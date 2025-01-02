---
title: 扩增子(Amplicon)数据分析流程
author: Peng Chen
date: '2024-12-23'
slug: amplicon-workflow
categories:
  - metagenomic
tags:
  - 16S
  - amplicon
description: ~
image: images/16s.webp
math: ~
license: ~
hidden: no
comments: yes
---




## Introduction

我学习微生物组分析的过程是从shot-gun 宏基因组数据分析开始的，反而没怎么做过相对更早更成熟的扩增子测序的上游分析😂，最近刚好有需求，还是自己学习并搭建一下自己用的比较舒服的流程吧。

扩增子（Amplicon）分析是研究微生物群落组成与功能的核心方法之一，特别是在生态学、医学和环境科学领域。通过对目标基因区域（如16S rRNA、18S rRNA、ITS）的特异性扩增与测序，扩增子分析能够高效揭示样本中微生物的多样性和群落结构。相比宏基因组测序，扩增子分析具有成本低、处理流程简化等优势，适用于大规模样本研究。

扩增子分析的核心原理是通过聚合酶链式反应 (PCR) 技术，对目标微生物基因片段进行特异性扩增和测序，以解析微生物群落组成及其多样性。通常选择的目标片段为具有保守区域和高变异区域的基因，如细菌的16S rRNA基因、真菌的ITS区等。保守区域用作引物设计的靶点，高变异区域用于区分不同物种。

具体步骤包括：
1. DNA 提取：从样本中提取总 DNA。
2. 目标基因扩增：使用特异性引物扩增目标区域。
3. 高通量测序：测序得到大量扩增子的序列数据。
4. 生物信息学分析：对序列进行过滤、聚类、注释，获得物种分类和功能信息。

这种方法的优势在于其高灵敏度和特异性，可以快速揭示微生物多样性并进行定量分析。

### 细菌  
细菌核糖体RNA (rRNA) 包括 5S rRNA (120bp)、16S rRNA (~1540bp) 和 23S rRNA (~2900bp)。  
- **5S rRNA**: 序列短，遗传信息量有限，无法用于分类鉴定。  
- **23S rRNA**: 序列过长，突变率高，不适用于远缘种类分析。  
- **16S rRNA**: 稳定性高、拷贝数多，约占细菌RNA总量的80%，基因中包含10个保守区和9个高变异区，适合细菌分类标准。V3-V4 区因特异性和数据库支持最佳，常用于多样性分析。  

<img src="images/16s.webp" title=""/>

### 真核生物  
真核微生物的 rRNA 包括 5.8S、18S 和 28S rRNA，其中 18S rRNA 常用于多样性分析。  
- **18S rRNA**: 基因序列包括保守区和可变区 (V1-V9, 无 V6)。可变区反映物种差异，V4 区因分类效果佳、数据库支持丰富，是分析和注释的最佳选择。  

### 真菌  
**ITS (内源转录间隔区)** 位于真菌 18S、5.8S 和 28S rRNA 基因之间，由 ITS1 和 ITS2 组成，分别长约 350 bp 和 400 bp。  
- **保守性**: 基因片段在种内稳定，种间差异显著，适用于细粒度分类。  
- **灵活性**: 容易分析和扩增，广泛用于真菌种属和菌株系统发育研究。  

### 古菌  
古菌生活于极端环境，是生命极限的代表。通过引物设计，16S rRNA 的 V4V5 区是古菌多样性研究的核心区域。  
- **Illumina MiSeq**: 519F/915R 适用于 V4V5 扩增。  
- **Roche 454**: 344F/915R 表现更佳。  
古菌研究揭示了其独特的生物特征，促进了极端生态学和生物系统学的发展。

## preprocess

一般把所有样本的测序双端文件放在一个data文件夹下，然后把所有样本名写入到一个`samplelist`文件中，方便后续各种软件的批量操作。

### 质控：fastp

测序文件质控是指在下游分析前对测序数据进行质量控制和清理，以确保数据的准确性和可靠性。

fastp是一个非常快速、多功能的测序数据质控工具，支持自动化的质控处理，包括去除低质量序列、剪切接头序列和生成质控报告。


```bash
#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --output=/share/home/jianglab/pengchen/work/asthma/log/%x_%A_%a.out
#SBATCH --error=/share/home/jianglab/pengchen/work/asthma/log/%x_%A_%a.err
#SBATCH --array=1
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
samplelist=/share/home/jianglab/pengchen/work/asthma/samplelist

echo start: `date +"%Y-%m-%d %T"`
start=`date +%s`

####################
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
START=$SLURM_ARRAY_TASK_ID

NUMLINES=40 #how many sample in one array

STOP=$((SLURM_ARRAY_TASK_ID*NUMLINES))
START="$(($STOP - $(($NUMLINES - 1))))"

echo "START=$START"
echo "STOP=$STOP"

####################
for (( N = $START; N <= $STOP; N++ ))
do
  sample=$(head -n "$N" $samplelist | tail -n 1)
  echo $sample
  mkdir -p data/fastp
  ~/miniconda3/envs/waste/bin/fastp -w 8 -i data/rawdata/${sample}_f1.fastq.gz -o data/fastp/${sample}_1.fq.gz \
    -I data/rawdata/${sample}_r2.fastq.gz -O data/fastp/${sample}_2.fq.gz -j data/fastp/${i}.json
done

##############
echo end: `date +"%Y-%m-%d %T"`
end=`date +%s`
echo TIME:`expr $end - $start`s
```

fastp的json文件中统计了测序数据的基本指标，我们可以将其整理为表格：
把所有的.json文件移到一个文件夹里report/下，使用我写的R包`pctax`读取json文件并整理成表格：


```r
pctax::pre_fastp("report/")
```

### 拼接：FLASH

FLASH的全称为Fast Length Adjustment of Short reads。如果两条reads的总长大于原始测序片段的长度就可以使用flash进行连接。



```bash
flash data/fastp/${sample}_1.fq.gz data/fastp/${sample}_1.fq.gz -o data/clean_data/${sample}

vsearch --fastq_mergepairs data/fastp/${sample}_1.fq.gz --reverse data/fastp/${sample}_2.fq.gz --fastqout data/clean_data/${sample}.merged.fq --relabel ${sample}
```



```bash

```


使用fastp[2]（https://github.com/OpenGene/fastp，version 0.19.6）软件对双端原始测序序列进行质控，使用FLASH[3]（http://www.cbcb.umd.edu/software/flash，version 1.2.11）软件进行拼接：
（1）过滤reads尾部质量值20以下的碱基，设置50bp的窗口，如果窗口内的平均质量值低于20，从窗口开始截去后端碱基，过滤质控后50bp以下的reads，去除含N碱基的reads；
（2）根据PE reads之间的overlap关系，将成对reads拼接(merge)成一条序列，最小overlap长度为10bp；
（3）拼接序列的overlap区允许的最大错配比率为0.2，筛选不符合序列；
（4）根据序列首尾两端的barcode和引物区分样品，并调整序列方向，barcode允许的错配数为0，最大引物错配数为2。

基于默认参数，使用Qiime2流程[10]中的DADA2[4]插件（或Deblur[5]插件）对质控拼接之后的优化序列进行降噪处理。DADA2（或Deblur）降噪处理之后的序列通常被称为ASVs（即扩增子序列变体）。去除所有样品中注释到叶绿体和线粒体序列。为了尽量减少测序深度对后续Alpha多样性和Beta多样性数据分析的影响，将所有样本序列数抽平至20,000，抽平后，每个样本的平均序列覆盖度（Good’s coverage）仍可达99.09%。基于Sliva 16S rRNA基因数据库（v 138），使用Qiime2中的Naive bayes(或Vsearch、或Blast)分类器对ASVs进行物种分类学分析。使用PICRUSt2[9](version 2.2.0)软件进行16S功能预测分析。


QIIME2，降噪方法是DADA2，注释方法是物种注释方法: classify-sklearn（Naive Bayes），数据库是unite9.0

