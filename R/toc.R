all_post=list.files("~/Documents/R/pc_blog2/content/post/", pattern = "index.*\\.md", recursive  = TRUE,full.names = TRUE)
all_post2=all_post[-c(1:2)]

yaml_data=list()
for (i in all_post2) {
    # 读取Markdown文件
    md_text <- readLines(i)
    
    # 提取YAML信息
    start_line <- grep("^---$", md_text)
    yaml_text <- paste(md_text[(start_line[1]+1):(start_line[2]-1)], collapse = "\n")
    
    # 解析YAML信息
    yaml_data[[i]] <- yaml::yaml.load(yaml_text)
}

lapply(yaml_data, \(i){
    data.frame(
        title=i$title,
        author=i$author,
        date=i$date,
        slug=paste0(i$slug,collapse = ", "),
        categories=paste0(i$categories,collapse = ", "),
        tags=paste0(i$tags,collapse = ", "),
        description=paste0(i$description,collapse = ", ")
    )
})%>%do.call(rbind,.)%>%data.frame(row.names = NULL,.)->all_post_yaml_data
