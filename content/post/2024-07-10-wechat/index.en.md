---
title: 公众号长期数据统计（笨方法）
author: Peng Chen
date: '2024-07-11'
slug: wechat
categories:
  - utils
tags:
  - 公众号
description: ~
image: images/wechat.png
math: ~
license: ~
hidden: no
comments: yes
---



## Introduction


### 下载

```r
#第一次运行的话，设置一下自己公众号创建时间：
ori_begin_date=as.Date("2023-03-30", "%Y-%m-%d")

rm(wechat_user_analysis,wechat_article_analysis)
if(file.exists("wechat_user_analysis.csv")){
  wechat_user_analysis=read.csv("wechat_user_analysis.csv",header=TRUE,row.names = 1)
  wechat_user_analysis$Date=as.Date(wechat_user_analysis$Date,format="%Y-%m-%d")
  ori_begin_date=as.Date(max(wechat_user_analysis$Date),"%Y-%m-%d")+1
  message("Last update date:",format(ori_begin_date,"%Y-%m-%d"))
  wechat_article_analysis=read.csv("wechat_article_analysis.csv",header=TRUE,row.names = 1)
  wechat_article_analysis$发表时间=as.Date(wechat_article_analysis$发表时间,format="%Y-%m-%d")
}

library(dplyr)
begin_date=ori_begin_date
end_date=begin_date+90 # 微信一次只能下载90天的数据
today=Sys.Date()

# 写一个for循环，从start开始到今天，每90天为begin_date到end_date，调用utils::browseURL函数，打开微信的用户分析页面，并将begin_date和end_date参数传入。
file_list=c()
stat_file_list=c()
while (begin_date<=today) {
  if(end_date>today){
    end_date=today
  }
  cat("Downloading data from ",format(begin_date,"%Y-%m-%d")," to ",format(end_date,"%Y-%m-%d"))
  #粉丝数据
  if(TRUE){
    old_file=list.files("~/Downloads/",full.names = TRUE)
    url=paste("https://mp.weixin.qq.com/misc/useranalysis?=&download=1&begin_date=",format(begin_date,"%Y-%m-%d"),"&end_date=",format(end_date,"%Y-%m-%d"),"&source=99999999&token=41126005&lang=zh_CN",sep="")
    utils::browseURL(url)
    Sys.sleep(3)
    file_list=append(file_list,setdiff(list.files("~/Downloads/",full.names = TRUE),old_file))
  }
  
  #文章数据
  if(TRUE){
    old_file=list.files("~/Downloads/",full.names = TRUE)
    url2=paste("https://mp.weixin.qq.com/misc/datacubequery?action=query_download&busi=3&tmpl=19&args={%22begin_date%22:",format(begin_date,"%Y%m%d"),",%22end_date%22:",format(end_date,"%Y%m%d"),"}&token=41126005&lang=zh_CN",sep="")
    utils::browseURL(url2)
    Sys.sleep(3)
    stat_file_list=append(stat_file_list,setdiff(list.files("~/Downloads/",full.names = TRUE),old_file))
  }
  
  begin_date=end_date+1
  end_date=begin_date+90
}
```

### 合并数据

```r
# 合并文章数据
if(length(stat_file_list)>0){
  dflist=list()
  for (i in stat_file_list){
    dflist[[i]]=readxl::read_excel(i)
  }
  all_df=data.frame(do.call(rbind,dflist),row.names = NULL)
  all_df$发表时间=as.Date(all_df$发表时间,format="%Y%m%d")
  all_df=mutate_at(all_df,vars(总阅读人数:阅读完成率),as.numeric)
  all_article_df=arrange(all_df,desc(发表时间))
  if(exists("wechat_article_analysis")){
    all_article_df=rbind(wechat_article_analysis,all_article_df)
  }
  all_article_df=arrange(all_article_df,desc(发表时间))
  write.csv(all_article_df,paste0("wechat_article_analysis.csv"))
  file.remove(stat_file_list)
}

# 合并粉丝数据
if(length(file_list)>0){
  dflist=list()
  for (i in file_list){
    dflist[[i]]=XML::readHTMLTable(i)[[1]][-c(1:2),]
  }
  
  all_df=data.frame(do.call(rbind,dflist),row.names = NULL)
  colnames(all_df)=c("Date","New_followers","Cancel_user","Increase_followers","Cumulative_followers")
  all_df$Date=as.Date(all_df$Date,format="%Y-%m-%d")
  all_df=mutate_at(all_df,vars(New_followers:Cumulative_followers),as.numeric)
  all_df=na.omit(all_df)
  all_user_df=arrange(all_df,desc(Date))
  if(exists("wechat_user_analysis")){
    all_user_df=rbind(wechat_user_analysis,all_user_df)
  }
  all_user_df=arrange(all_user_df,desc(Date))
  write.csv(all_user_df,paste0("wechat_user_analysis.csv"))
  file.remove(file_list)
}
```


### 画图

```r
library(ggplot2)
p=ggplot(all_user_df,aes(x=Date,y=Cumulative_followers))+
  geom_line()+geom_point(aes(colour = Increase_followers))+
  labs(title="Wechat User Analysis",x="Date",y="Cumulative Followers")+
  # viridis::scale_color_viridis(direction = -1)+
  scale_color_gradientn(colours = get_cols(pal = "bluered")[7:11],name = "Increase \nFollowers")+
  theme_bw()+theme(legend.position = c(0.1,0.7))

#在净增最多的五天画个箭头
max_increase=top_n(all_user_df,10,Increase_followers)%>%filter(Increase_followers>20)
#找到最近的一篇推文

max_increase$内容标题=rep("",nrow(max_increase))
for (i in 1:nrow(max_increase)){
  max_date=max_increase$Date[i]
  max_increase$内容标题[i]=all_article_df[which.min(abs(all_article_df$发表时间-max_date)),"内容标题"]
}
max_increase=distinct(max_increase,内容标题,.keep_all = TRUE)

max_increase$内容标题=stringr::str_wrap(max_increase$内容标题,16,whitespace_only = F)

showtext::showtext_auto()
p2=p+
  ggrepel::geom_label_repel(data = max_increase,
                           mapping = aes(x = Date, y = Cumulative_followers, label = 内容标题),
                           size = 3, min.segment.length =0.1, fill=NA)
 
  # geom_segment(data = max_increase, 
  #              aes(x = Date-8, xend = Date, y = Cumulative_followers+50, yend = Cumulative_followers), 
  #              arrow = arrow(length = unit(0.2, "cm"), type = "closed"))

ggsave("wechat_user_analysis.pdf",p2,width=7,height=5)
ggsave("wechat_user_analysis_secret.pdf",
       p2+theme(axis.text.y = element_blank(),legend.text = element_blank()),
       width=7,height=5)
```

<img src="images/wechat.png" title=""/>
