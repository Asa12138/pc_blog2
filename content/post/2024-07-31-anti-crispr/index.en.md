---
title: Anti-CRISPR相关学习
author: Peng Chen
date: '2024-07-31'
slug: anti-crispr
categories:
  - microbial-ecology
tags:
  - crispr
  - Acr
description: 细菌和古菌等微生物与病毒(噬菌体)之间的生存之战是一场“军备竞赛”。噬菌体进化出特异性的anti-CRISPR来抵抗CRISPR-Cas系统的免疫。
image: ~
math: ~
license: ~
hidden: no
comments: yes
---

http://journals.im.ac.cn/html/wswxtbcn/2021/9/tb21093353.htm#rhhz

## Introduction

CRISPR-Cas系统是微生物为免受噬菌体和外来遗传元件入侵进化而来的获得性免疫系统，在约45%的细菌和87%的古细菌基因组中都发现了CRISPR-Cas系统的存在，具体可以看之前写的[CRISPR 相关学习](../crispr)。

在噬菌体与宿主共进化的过程中，通过在宿主CRISPR-Cas系统的Protospacer seed sequence区域引入突变，降低了RNP复合物与靶标核酸的结合亲和力，从而逃避宿主CRISPR-Cas系统介导的免疫。宿主CRISPR-Cas系统具有不断获取新Spacer的能力，因此噬菌体进化出积极的反防御系统，通过与核酸序列无关的机制使CRISPR-Cas效应复合物失活。

最初在铜绿假单胞菌的噬菌体中观察到了这种anti-CRISPR现象，尽管这些噬菌体携带与宿主Ⅰ-F型CRISPR-Cas系统Spacer序列匹配的靶标核酸，依然能成功侵染宿主并传播。Bondy-Denomy等研究者在这些噬菌体的基因组中发现了编码5个Acr蛋白（AcrⅠF1、AcrⅠF2、AcrⅠF3、AcrⅠF4和AcrⅠF5）的基因，这些蛋白能帮助噬菌体逃避Ⅰ-F型CRISPR-Cas系统的免疫。

自2013年发现第一个Acr蛋白以来，已确认多种来源于病毒和质粒等移动遗传元件的Acr蛋白可抵御CRISPR-Cas系统的免疫。由于Acr蛋白在序列上相似性较低，因此无法通过氨基酸序列同源比对来预测新的Acr蛋白。当前预测和挖掘Acr蛋白的策略主要有三种：(1) 在序列保守的anti-CRISPR相关蛋白Aca周围进行预测；(2) 在携带内源CRISPR-Cas系统自靶向的宿主菌基因组上筛选；(3) 在能够抵御宿主CRISPR-Cas免疫活性的噬菌体基因组上鉴定。此外，还有研究者通过高通量筛选平台，成功筛选到一个合成的抗SpCas9小分子，这提示我们可以通过类似筛选策略来发现天然和合成的CRISPR-Cas系统抑制分子，以便于开发利用。

## 分类


目前已经发现了至少82种Acr蛋白，它们分别能够抑制Ⅰ、Ⅱ、Ⅲ、Ⅴ和Ⅵ型CRISPR-Cas系统的免疫活性。表1展示了这些发现，注意到目前还没有报道针对Ⅳ型CRISPR-Cas系统的Acr蛋白。研究表明，这些Acr蛋白大多通过与CRISPR-Cas复合物或Cas蛋白相互作用来抑制其免疫活性。

<img src="images/acr.jpg" title=""/>

除了Acr蛋白外，还有两种不同的噬菌体反CRISPR策略被发现可以对抗宿主CRISPR-Cas系统的免疫干扰。一种策略是噬菌体形成拟核结构来规避Ⅰ型CRISPR-Cas系统的免疫，另一种是利用噬菌体衍生的肽来抑制CRISPR-Cas9的免疫活性（见上图）。

Mendoza等人发现，铜绿假单胞菌噬菌体ΦKZ能够通过在其基因组周围形成蛋白质拟核屏障，逃避宿主细胞内多种CRISPR-Cas系统，包括Cas3、Cas9和Cas12a的免疫活性。类似地，Malone等人发现，沙雷氏菌噬菌体PCH45感染宿主后，形成的蛋白质包裹的拟核结构使其基因组DNA免受Ⅰ型CRISPR-Cas系统的靶向攻击，尽管Ⅲ-A型CRISPR-Cas系统仍可通过靶向释放到细胞质中的噬菌体mRNA来抑制其大量增殖。

此外，噬菌体M13衣壳蛋白G8P的一个肽段G8PPD（G8P的外膜结构域）能够抑制链球菌CRISPR-Cas9系统的免疫活性。该外膜结构域的胞浆周结构能够与Cas9结合，阻止其装载sgRNA形成效应复合物，从而帮助噬菌体逃避CRISPR-Cas9的免疫反应。这种肽抑制CRISPR-Cas系统活性的机制类似于某些Acr蛋白。

## 作用机制

已报道的Acr蛋白，分别以阻止crRNA装载、阻止靶标DNA/RNA的识别与结合、阻止靶标核酸的切割以及通过降解信号分子等方式发挥抵御CRISPR-Cas系统免疫活性的功能：

<img src="images/acr_mechanism.jpg" title=""/>

### 阻止crRNA装载

AcrⅡC2是第一个报道的在核酸装载步骤抑制CRISPR-Cas系统免疫活性的anti-CRSIPR蛋白。AcrⅡC2通过与Cas9蛋白的BH结构域结合，阻止Cas9蛋白与crRNA结合形成效应复合体，进而保护靶标DNA不被降解。同样，有研究显示AcrⅡA16、17和19可能也是通过与ApoCas9蛋白的相互作用干扰了sgRNA的装载与稳定，从而抑制Ⅱ-A型CRISPR-Cas系统的活性。

### 阻止靶标DNA/RNA的识别与结合

目前发现的anti-CRSIPR蛋白中，阻止CRISPR-Cas效应复合体识别和结合靶标核酸是其抑制CRISPR-Cas系统免疫活性的常见方式。例如，Ⅰ-D型CRISPR-Cas系统的AcrⅠD1蛋白以二聚体形式约束Cas10d大亚基，阻止其与外源DNA的结合。在Ⅰ-F型CRISPR-Cas系统中，AcrⅠF1和AcrⅠF2分别与Csy3亚基多聚体和Csy1-Csy2异二聚体互作，阻断CRISPR-Cas效应复合体与靶标DNA的结合，进而抑制靶标核酸的降解。AcrⅢB1是首个直接抑制Ⅲ型CRISPR-Cas系统核酸干涉活性的Acr蛋白，能有效阻止Ⅲ-B型CRISPR-Cas系统对病毒中/晚期基因的靶向免疫。

### 阻止靶标核酸的切割

Acr蛋白抵御CRISPR-Cas系统免疫的第三种常见方式是直接抑制CRISPR-Cas效应复合体对外源靶标核酸的切割。其中，AcrⅠF3是第一个被发现能抑制CRISPR-Cas效应复合体核酸酶活性的Acr蛋白。AcrⅠF3以二聚体的形式结合到Cas3蛋白的关键结构域HD、Linker和CTD中，广泛的相互作用覆盖了Cas3蛋白的一个表面，并以ADP形式锁定Cas3，有效阻止了CRISPR-Cas效应复合体招募Cas3进行靶标DNA切割。此外，抑制Cas3靶向DNA降解也会阻碍新Spacer的获取。

另外，AcrⅡA11能够特异性地与Cas9蛋白的一个保守结构域结合，并通过改变Cas9蛋白的引导和自身构象来抑制其对双链DNA的切割活性。这种直接作用于Cas蛋白的保守结构域是细菌和噬菌体在长期“军备竞赛”中进化的结果，可以在一定程度上防止CRISPR-Cas系统通过修饰和突变克服Acr蛋白的抑制。

### 降解信号分子

AcrⅢ-1不直接改变Ⅲ型CRISPR-Cas效应复合体的结构和功能，而是通过降解靶向RNA后生成的环腺苷酸CA4信号分子来帮助病毒逃避Ⅲ型CRISPR-Cas系统的免疫干扰。这种策略表明AcrⅢ-1具有广泛的宿主适应性，在细菌和古菌中普遍存在。此外，Ⅵ-B型CRISPR-Cas系统中的Csx27是一种特殊的Cas蛋白，能减弱Cas13b-crRNA效应复合体对靶向干涉RNA的活性，这种负调节作用可能在微生物宿主的免疫防御中起重要作用。

## 生信鉴定方法

http://guolab.whu.edu.cn/anti-CRISPRdb/

直接跟现成的数据库比对。

https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-022-04986-3



## References

