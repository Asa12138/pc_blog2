library(optparse)
library(magick)

# 定义命令行选项
option_list <- list(
    make_option("-i", "--input", dest = "input", type = "character",
                help = "输入文件路径"),
    make_option("-o", "--output", dest = "output", type = "character",
                help = "输出文件路径"),
    make_option("-w", "--watermark", dest = "watermark", type = "character",
                help = "水印文件路径"),
    make_option("-x", "--xoffset", dest = "xoffset", type = "integer",
                default = 10, help = "水印的X偏移量"),
    make_option("-y", "--yoffset", dest = "yoffset", type = "integer",
                default = 10, help = "水印的Y偏移量"),
    make_option("-a", "--alpha", dest = "alpha", type = "numeric",
                default = 0.5, help = "水印的透明度")
)

# 解析命令行参数
opt <- parse_args(OptionParser(option_list = option_list))

library(showtext)
font_add("simley","/Users/asa/Library/Fonts/SmileySans-Oblique.ttf")
font_add("song","/System/Library/Fonts/Supplemental/Songti.ttc")
font_families()
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point() +
    ggtitle("Fuel Efficiency of 32 Cars",
            subtitle = "32种汽车的燃油效率")+
    theme(text=element_text(size = 15, family="song"))


library(extrafont)
font_import("/Users/asa/Library/Fonts/")
fonts()
truetype_path <- paste0("@", subset(fonttable(), FullName=="", fontfile)[1,])


# 读取原始图像和水印图像
image <- image_read(opt$input)
image_annotate(image, "qunqing", gravity = "southeast", location = "+10+10", size =50, color = "#FFFFFF66",font = "mono")

# 保存结果
image_write(result, opt$output)