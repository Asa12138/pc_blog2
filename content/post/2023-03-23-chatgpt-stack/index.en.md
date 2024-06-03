---
title: ChatGPT帮我调整stack主题
author: Peng Chen
date: '2023-03-23'
slug: Chatgpt-stack
categories:
  - utils
tags:
  - ChatGPT
description: 刚开始搭建博客，看中了stack主题，但是还有一些需求无法满足，于是让ChatGPT辅助我调整stack主题。
image: ChatGPT.jpg
math: null
license: null
hidden: no
comments: yes
editor_options: 
  markdown: 
    wrap: 72
---



在[Rblogdown](https://github.com/rstudio/blogdown)使用[stack-theme](https://github.com/CaiJimmy/hugo-theme-stack)遇到了几个问题，应该是Rblogdown与原生hugo间的不太兼容。

我很快发现了问题是Rmd产生的md文件可能跟stack主题不太匹配，一开始想看看yaml文件能不能修改解决，但找了不少地方都没找到😭。

因为问题还比较确定，可以试试自己写脚本转换Rmd产生的md文件。

## 公式问题

rblogdown 渲染Rmd成md会把我写的公式语法改变：

例如： `$a=sum_i^2$`变成$a=sum_i^2$

但是stack主题识别不了后面那种语法，这个比较简单：


```python
import re

# 定义一个正则表达式，匹配LaTeX数学公式中的起始和结束行内数学模式符号
pattern = r'\\\((.*?)\\\)'  

# 定义一个字符串，包含要处理的LaTeX字符串
latex_string = r'For the equation$\sum_{i=1}^n i^2$'

# 使用sub()函数替换匹配到的文本
processed_string = re.sub(pattern, r'$\1$', latex_string)

# 输出处理后的字符串
print(processed_string)

a=re.sub(r'`\\\((.*?)\\\)`',r'$\1$',$a=sum_i^2$jjjh$a=sum_i^2$")
```

## 图片大小调整

因为`![from data to viz website](images/data2viz.png){width=60%}`这种语法是stack主题不支持的，
但是

```         
'<p style="text-align: center;">
    <img src="images/data2viz.png" width="60%" title="from data to viz website"/>
</p>'
```

这种语法是支持的，所以想写一个小脚本转换一下

自己不太熟悉正则（上面那个公式转换的也是他帮我写的，哈哈），所以试试问了ChatGPT
：

可以帮我写一个将插入图片的markdown语法转换为html语法的小脚本吗？
比如：`![A](B.png){width=60%}`转换为`<img src="B.png" width="60%" title="A"/>`

它立马用python帮我写了：


```python
import re

def convert_markdown_to_html(markdown_text):
    # 将插入图片的Markdown语法转换为HTML语法
    pattern = r"!\[(.*?)\]\((.*?)\){(.*?)}"
    matches = re.findall(pattern, markdown_text)
    for match in matches:
        title = match[0]
        src = match[1]
        attributes = match[2].split(",")
        attr_dict = dict([tuple(attribute.split("=")) for attribute in attributes])
        html_tag = f'<img src="{src}" title="{title}"'
        for key, value in attr_dict.items():
            html_tag += f' {key}="{value}"'
        html_tag += "/>"
        markdown_text = markdown_text.replace(f"![{title}]({src}){{{match[2]}}}", html_tag)
    return markdown_text

def convert_latex_to_md(markdown_text):
    html_text=re.sub(r'`\\\((.*?)\\\)`',r'$\1$',markdown_text)
    return html_text

def convert_markdown_file_to_html(file_path):
    # 读取Markdown文件
    with open(file_path, "r", encoding="utf-8") as f:
        markdown_text = f.read()
    # 将Markdown语法转换为HTML语法
    html_text = convert_markdown_to_html(markdown_text)
    html_text = convert_latex_to_md(html_text)
    # 将HTML文本写入文件
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(html_text)

if __name__ == "__main__":
    file_path = "index.md"
    convert_markdown_file_to_html(file_path)
```

牛牛牛！ 再问一下，可以用R语言写一下吗？


```r
convert_markdown_to_html <- function(markdown_text) {
  # 通过正则表达式匹配图片语法
  matches <- gregexpr("!\\[(.*?)\\]\\((.*?)\\){(.*?)}", markdown_text, perl = TRUE)
  
  # 遍历匹配结果，将Markdown语法替换为HTML语法
  for (i in seq_along(matches[[1]])) {
    # 判断匹配结果是否为空列表
    if (length(matches[[1]][i]) == 0) {
      next
    }
    
    match <- regmatches(markdown_text, matches[[1]][i])
    title <- match[[2]]
    src <- match[[3]]
    attributes <- strsplit(match[[4]], ",")[[1]]
    attr_dict <- setNames(sapply(strsplit(attributes, "="), "[", 2), sapply(strsplit(attributes, "="), "[", 1))
    
    # 构造HTML标签
    html_tag <- sprintf('<img src="%s" title="%s"', src, title)
    for (key in names(attr_dict)) {
      value <- attr_dict[[key]]
      html_tag <- paste(html_tag, sprintf('%s="%s"', key, value), sep = " ")
    }
    html_tag <- paste(html_tag, "/>", sep = "")
    
    # 将Markdown语法替换为HTML语法
    markdown_text <- sub("!\\[(.*?)\\]\\((.*?)\\){(.*?)}", html_tag, markdown_text, fixed = TRUE)
  }
  
  return(markdown_text)
}
markdown_text <- "![A](B.png){width=60%}"
html_text <- convert_markdown_to_html(markdown_text)
print(html_text)
```

唉，实际上这个代码没有用，我也不知道bug怎么搞，R的正则表达式一直感觉没有python好用。

还是用写好的python脚本吧。

## 修改新的md文件

我们还需要找到最新render出来的md文件按上述规则进行修改（否则一口气改全部的话，害怕会越来越慢，甚至损坏以前的md文件）：


```python
import os
import datetime

# 定义要查找的目录
directory = './content/post/'

# 存储所有的md文件
md_files = []

# 递归查找目录下的所有文件
for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith('.md'):
            file_path = os.path.join(root, file)
            md_files.append((file_path, os.path.getmtime(file_path)))

# 找到最新修改的文件
latest_file = max(md_files, key=lambda x: x[1])[0]

print("最新保存的.md文件是：", latest_file)
```

再问问，可以找到目录下所有新保存的.md文件吗，就是修改时间与上次不一致的？


```python
import os
import datetime

# 定义要查找的目录
directory = './content/'

# 存储所有新保存的md文件
new_md_files = []

# 读取上一次检查的时间戳
if os.path.isfile('last_check_time.txt'):
    with open('last_check_time.txt', 'r') as f:
        last_check_time = datetime.datetime.strptime(f.read(), '%Y-%m-%d %H:%M:%S.%f')
else:
    last_check_time = datetime.datetime.now()

# 递归查找目录下的所有文件
for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith('.md'):
            file_path = os.path.join(root, file)
            mod_time = datetime.datetime.fromtimestamp(os.path.getmtime(file_path))
            if mod_time > last_check_time:
                new_md_files.append(file_path)

# 更新上一次检查的时间戳
last_check_time = datetime.datetime.now()

# 将上一次检查的时间戳保存到文件中
with open('last_check_time.txt', 'w') as f:
    f.write(last_check_time.strftime('%Y-%m-%d %H:%M:%S.%f'))

# 打印所有新保存的md文件
for file_path in new_md_files:
    print("新保存的.md文件：", file_path)
#更新所有新保存的md文件
for file_path in new_md_files:
    convert_markdown_file_to_html(latest_file)
```

这个思路真不错，哈哈

## 解决方法

调教了一下ChatGPT后，就得到了整个更新问题的方法了：
首先整理一个[refresh_md_to_fit_stack.py](https://github.com/Asa12138/pc_blog2/R/refresh_md_to_fit_stack.py)放在网站根目录下，
然后在R文件夹的（如果你是用Rblogdown生成的网站，那就会有这个文件夹）的build2.R中加入一行：

`system("python refresh_md_to_fit_stack.py")`

即可。
因为Rblogdown会在每次实时渲染我们的网站后运行build2.R文件，相当于运行了refresh_md_to_fit_stack.py文件，而refresh_md_to_fit_stack.py文件将搜索所有更新的md文件并修改以上两个问题，这样hugo建立的网站就能够契合stack-theme。

看看结果： 如果调试成功的话，下面显示的即是正常的latex公式:

\$y=\frac{1}{2} \$

如果不是使用的Rblogdown生成的网站，这种思路的方法也可以帮助改变stack-theme。

此外，如果是Rblogdown生成的其他主题的网站有类似问题，也可以这样修改。

最后，ChatGPT真不错！再来一个[攻略](https://k5ms77k0o1.feishu.cn/wiki/wikcnJyI9wsyjyBc8xiDgv0cY8b)

## 其他调整参考

- [Hugo主题stack的使用与优化](https://jinli.io/p/%E4%B8%AA%E4%BA%BA%E7%BD%91%E7%AB%99%E7%9A%84%E5%BB%BA%E7%AB%8B%E8%BF%87%E7%A8%8B%E4%B8%89hugo%E4%B8%BB%E9%A2%98stack%E7%9A%84%E4%BD%BF%E7%94%A8%E4%B8%8E%E4%BC%98%E5%8C%96/)
- [Stack主题的自定义](https://blog.linsnow.cn/p/modify-hugo/)
- [使用 Hugo+Stack 简单搭建一个博客](https://blog.reincarnatey.net/2023/build-hugo-blog-with-stack-mod)
- [Hugo Stack主题更新小记](https://xrg.fj.cn/p/hugo-stack%E4%B8%BB%E9%A2%98%E6%9B%B4%E6%96%B0%E5%B0%8F%E8%AE%B0/)
- [使用 Hugo 对博客的重建与 Stack 主题优化记录](https://oxidane-uni.github.io/p/%E4%BD%BF%E7%94%A8-hugo-%E5%AF%B9%E5%8D%9A%E5%AE%A2%E7%9A%84%E9%87%8D%E5%BB%BA%E4%B8%8E-stack-%E4%B8%BB%E9%A2%98%E4%BC%98%E5%8C%96%E8%AE%B0%E5%BD%95/)

