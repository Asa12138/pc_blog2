# 加载必要的包
library(httr)
library(stringr)

# 定义文件路径
file_path <- "content/post/un-2024-08-14-vcontact2/index.en.Rmd"
# 获取前面部分定义images目录路径
images_dir <- file.path(dirname(file_path),"images")

# 创建images目录
if (!dir.exists(images_dir)) {
    dir.create(images_dir)
}

# 读取index.md文件内容
file_content <- readLines(file_path, warn = FALSE)

# 正则表达式，匹配![](https://...)或![](http://...)格式的网络图片链接
pattern <- "!\\[.*?\\]\\((https?://[^)]+)\\)"

# 查找所有匹配的图片链接
matches <- str_extract_all(file_content, pattern)

# 初始化一个向量来存储所有匹配到的链接
all_matches <- unlist(matches)

# 打印匹配到的内容，方便调试
cat("匹配到的链接:\n", all_matches, "\n")

# 如果匹配到的项为空，给出提示
if (length(all_matches) == 0) {
    cat("未找到任何符合条件的图片链接。\n")
} else {
    # 对每个匹配的链接进行处理
    for (match in all_matches) {
        # 提取URL
        url <- str_match(match, "\\((https?://[^)]+)\\)")[,2]
        
        # 获取图片文件名
        file_name <- basename(url)
        
        # 下载图片到images目录
        img_path <- file.path(images_dir, file_name)
        GET(url, write_disk(img_path, overwrite = TRUE))
        
        # 替换文档中的链接为![](images/...)
        new_link <- paste0("![](images/", file_name, ")")
        file_content <- gsub(match, new_link, file_content, fixed = TRUE)
    }
    
    # 将替换后的内容写回index.md文件
    writeLines(file_content, file_path)
    
    # 完成提示
    cat("图片下载并替换完成。\n")
}
