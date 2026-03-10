setwd("~/Desktop/")
fls=list.files(pattern = ".png")
for (i in seq_len(length(fls))) {
    file.rename(fls[i],paste0("fig",i,".png"))
}

if(F){
    '
- Holmboe, C. M. H., Riis, T., Han, X., Frossard, A., Romaní, A. M., Kjær, J. B., et al. (2026). Spatial and temporal variability of microbial nitrogen cycling genes in Arctic streams. Global Biogeochemical Cycles, 40, e2025GB008569. https://doi.org/10.1029/2025GB008569
- 期刊：Global Biogeochemical Cycles （IF=5.5）
- 发表时间：2026年2月23日

Nature (IF 48.5)
Nature Communications (IF 15.7)
Nature Water (IF 24.1)
Nature Microbiology (IF 19.4)
Nature Reviews Microbiology （IF=103.3）
Nature Methods (IF=32.1)
    '
}