---
title: 微生物学名-中文名称转换（可批量）
author: Peng Chen
date: '2024-11-20'
slug: latin_name
categories:
  - utils
tags:
  - latin_name
description: 对于微生物研究，虽然平时我们用的都是正式的拉丁学名，但有时我们还是需要查阅一些相关生物的正式中文名称（有时候还需要大批量的转换），方便做中文的展示或者写中文论文使用。
image: images/R-C.jpeg
math: ~
license: ~
hidden: no
comments: yes
---

## Introduction

对于微生物研究，虽然平时我们用的都是正式的拉丁学名，但有时我们还是需要查阅一些相关生物的正式中文名称（有时候还需要大批量的转换），方便做中文的展示或者写中文论文使用。

目前常用的方法有：

1. 直接谷歌查找，运气好的话可以找到知名物种的中文名称。
2. 参考中文文献中的译名，如知网、百度学术等。
3. 使用一些专业的菌种库检索，如CICC菌种平台。
4. 查找专业书籍，如《细菌名称双解及分类词典》

个人觉得比较好用的一个网站是中国典型培养物保藏中心的原核微生物名称翻译及分类查询网站(http://cctcc.whu.edu.cn/portal/dictionary/index)：

这个网站的描述是：
- 依据2011年化学工业出版社正式出版的《细菌名称双解及分类词典》以及由原主编组织翻译的2011-2020年间增加和修订的合格发表原核生物的学名。
- 在此网站不仅可以查询获得原核生物的中文名称，还包括了原核生物的分类地位、曾用名、变更信息、词源以及相关文献出处等信息。
- 原核生物的汉译名延用已有通用名称并充分尊重命名人的意愿根据发表的词源信息进行翻译。其中的地名参照《世界地名翻译大辞典》和《欧路词典》。
- 每年会更新一次，但是由于某些原核生物名称分类地位不断变化, 因此, 本网站中的信息仅供读者参考,欲了解准确信息,请及时査阅 “IJSB”或“IJSEM”杂志以及LPSN网站（https://lpsn.dsmz.de/）。

查询起来很方便：

1. 拉丁名翻译为中文

<img src="images/640.gif" title=""/>

2. 中文名翻译为拉丁名

<img src="images/641.gif" title=""/>


## 批量快速转换

如果需要大量的转换，一个一个查起来就比较费劲了，所以我也整理了一下数据库中的中文名-拉丁名对应关系，写了一个函数帮助批量的转换，放在`pctax`包里了。同样的，所有翻译结果仅供参考！

```r
# 下载更新一下最新版
# install.packages("devtools")
devtools::install_github("Asa12138/pctax")
```


```r
library(pctax)
convert_taxon_name(c("Escherichia coli", "Clostridioides difficile", "Chryseobacterium ureilyticum", "Mycolicibacterium hippocampi"))
```

```
##             Escherichia coli     Clostridioides difficile 
##               "大肠埃希氏菌"                 "艰难拟梭菌" 
## Chryseobacterium ureilyticum Mycolicibacterium hippocampi 
##               "解脲金黄杆菌"         "海马分枝菌酸小杆菌"
```

```r
# 支持中文搜索，可以打开模糊匹配
convert_taxon_name(c("白色盐湖杆菌","乳酸乳球菌","大肠弯曲杆菌","新月柄杆菌"),mode = "chinese_to_latin",fuzzy = TRUE)
```

```
##             白色盐湖杆菌               乳酸乳球菌             大肠弯曲杆菌 
##   "Salilacibacter albus"     "Lactococcus lactis"     "Campylobacter coli" 
##               新月柄杆菌 
## "Caulobacter crescentus"
```

## 微生物命名规则

顺便学习一下微生物相关的一些命名规则吧：

微生物学命名遵循国际生物命名规则，主要包括国际细菌命名法规（ICNP）和国际植物命名法规（ICN, 真菌属于此范畴）。

### 1. 基本命名原则
#### a. 双名法
- 微生物的学名一般由属名（genus）和种加词（specific epithet）组成。
- 属名首字母大写，种加词小写，均采用斜体书写。
  - 示例: *Escherichia coli*（大肠杆菌）。

#### b. 学名的唯一性
- 每一个物种的名称应在全球范围内唯一，避免歧义。
- 新物种的命名需要经过严格审查并正式发表。

#### c. 拉丁化
- 名称通常采用拉丁文或拉丁化的词汇，表示分类、特性、发现地或纪念发现者。
  - 示例: *Streptococcus*（链球菌），“strepto-”表示链状结构。

#### d. 语言通用性
- 学名以拉丁文为基础，不因语言或地区的变化而改变。

### 2. 微生物分类层级
微生物命名的层级结构从高到低依次为：
- 域（Domain）: 如 *Bacteria*（细菌域）、*Archaea*（古菌域）。
- 界（Kingdom）: 较少用于微生物。
- 门（Phylum）: 后缀通常为 -ota。
  - 示例: *Acidobacteriota*（酸杆菌门）。
- 纲（Class）: 后缀通常为 -ia。
  - 示例: *Gammaproteobacteria*（γ-变形菌纲）。
- 目（Order）: 后缀通常为 -ales。
  - 示例: *Enterobacterales*（肠杆菌目）。
- 科（Family）: 后缀通常为 -aceae。
  - 示例: *Enterobacteriaceae*（肠杆菌科）。
- 属（Genus）: 通常由一个单词构成，首字母大写。
  - 示例: *Escherichia*（埃希菌属）。
- 种（Species）: 由属名和种加词构成，具体描述物种。
  - 示例: *Escherichia coli*（大肠杆菌）。
- 亚种（Subspecies）: 必须附加在种名之后，用于表示下一级分类。

### 3. 命名规则细节
#### a. 正式描述
- 新物种必须在公认的学术期刊（《国际系统细菌学杂志》(IJSB)或《国际系统与进化微生物学杂志》(IJSEM)）上正式发表，发表在IJSB或IJSEM以外刊物的新名称和(或)新组合须在IJSB或IJSEM上合格化(validation)。
- 描述中应包括物种的特征、分类依据及模式标本。

#### b. 模式菌株
- 每个新命名的物种必须提供一个模式菌株（Type strain），作为该物种的标准参考。
- 模式菌株应保存在两个独立的公共菌种保藏机构中。

#### c. 同义名与名称修订
- 如果发现物种的分类或命名有误，可以提出修订。
- 原有的名称会作为同义名（Synonym）记录。

### 4. 特殊情况
#### a. 暂定名称
- 一些未能充分描述的物种会以“Candidatus”表示，表示该分类是候选状态。
  - 示例: *Candidatus Liberibacter asiaticus*。

#### b. 名称变更
- 随着分类学研究的进展，物种可能会被重新分类或更名，旧名会标注为“basionym”（基名）。

#### c. 不确定分类
- 在名称后加问号（?）表示分类不确定。
  - 示例: *Escherichia coli?*。
 
#### d. 其他写法
- 属名重复出现，可缩写如：*E.coli* （大肠杆菌）；
- 只确定属名，未确定种名的某一株细菌，如*Salmonella* sp.；
- 只确定属名，未确定种名的若干菌株，如*Salmonella* spp.；
- 亚种用subsp. 或者ssp.（subspecies）表示*Pasteurella multocida* subsp.

### 5. 中文命名规范
- 中文名称通常根据拉丁学名的含义翻译而来。
- 属名: 通常为一个字或短语，如“大肠杆菌”（*Escherichia coli*）。
- 种加词: 描述特性或发现地的词汇，如“金黄色葡萄球菌”（*Staphylococcus aureus*），“aureus”是形容词，意思是“金黄色的”。

通过遵守命名规则，微生物的分类体系能保持全球统一，也有助于科研成果的准确交流与传播。

## References

1. <http://cctcc.whu.edu.cn/portal/dictionary/mic_notice>
2. 国际细菌命名法规（ICNP）
3. LPSN: [https://lpsn.dsmz.de](https://lpsn.dsmz.de)
4. NCBI Taxonomy: [https://www.ncbi.nlm.nih.gov/taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy)
5. IJSEM: [https://www.microbiologyresearch.org/content/journal/ijsem](https://www.microbiologyresearch.org/content/journal/ijsem)
6. 微生物学命名的表示方法-《华侨大学学报（自然科学版）》
