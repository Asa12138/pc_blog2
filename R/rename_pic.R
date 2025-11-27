setwd("~/Desktop/")
fls=list.files(pattern = ".png")
for (i in seq_len(length(fls))) {
    file.rename(fls[i],paste0("fig",i,".png"))
}
