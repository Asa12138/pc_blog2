---
title: 病毒相关内容学习
author: Peng Chen
date: '2024-08-13'
slug: learn-virus
categories:
  - microbial-ecology
tags:
  - virus
description: 学习病毒相关内容，包括病毒的分类、结构、功能等。
image: images/Virus_Baltimore_Classification.png
math: ~
license: ~
hidden: no
comments: yes
---

## 什么是病毒？

病毒是一种非常微小的、非细胞结构的病原体，它只能在宿主细胞内生长繁殖。与细菌不同，病毒本身没有完整的细胞结构，也无法进行独立的生命活动（如代谢、繁殖）。它们由遗传物质（DNA或RNA）和蛋白质外壳组成，少数病毒还带有脂质包膜。

- 病毒的基本特征：
1. **结构简单**：病毒的结构通常包括核酸（DNA或RNA）和蛋白质外壳（称为衣壳）。有些病毒外面还有一层由宿主细胞膜衍生来的包膜。
   
2. **寄生性**：病毒必须依赖宿主细胞才能复制。它们入侵宿主细胞后，将自身的遗传物质注入宿主细胞，并利用宿主的代谢系统进行复制。

3. **没有独立的生命活动**：病毒不能独立进行代谢、运动、繁殖等生命活动，必须在宿主细胞内进行复制和增殖。

4. **特异性**：病毒通常具有特异性，即它们只感染某些特定的宿主细胞。例如，某些病毒只感染植物，某些病毒只感染动物，还有些病毒专门感染细菌（称为噬菌体）。

- 病毒的传播：
病毒可以通过多种途径传播，包括空气传播（如流感病毒）、体液传播（如艾滋病毒）、接触传播（如疱疹病毒）、蚊虫叮咬传播（如登革热病毒）等。

- 病毒引发的疾病：
病毒可以引发多种疾病，包括感冒、流感、艾滋病、乙型肝炎、狂犬病、新冠肺炎等。治疗病毒感染通常需要抗病毒药物，而预防病毒感染常用疫苗。

## 分类系统

病毒的分类主要依据以下几个方面：
- **病毒颗粒的特性**：如病毒的形状、大小、是否有包膜等。
- **抗原特性**：指病毒表面蛋白的特性，这些蛋白决定了病毒与宿主细胞的相互作用。
- **生物特性**：包括病毒的基因组类型（DNA或RNA）、复制方式、宿主范围等。

当前，只有一小部分的病毒得到了详细研究。来自人体的病毒样品中，有约20%的序列是未曾发现过的，而从环境（如海水、大洋沉积物等）中采集的病毒样品中，大部分序列都是全新的。这表明我们对病毒世界的了解还非常有限，未来的研究可能会发现更多新病毒，进一步丰富和复杂化现有的病毒分类系统。

### ICTV病毒分类

ICTV于1966年建立了病毒分类的通用系统和统一的命名法则。这个系统是目前唯一一个被广泛接受的病毒分类标准。ICTV是国际微生物学联合会（International Union of Microbiological Societies, IUMS）下属的机构，负责发展、改进和维护这个病毒分类系统。

官方网站：<https://ictv.global/>

- 病毒分类的层次
ICTV的分类系统从最广泛的域（Realm）开始，逐步细化到种（Species）这个最低的分类单元。以下是各个层级及其对应的分类后缀：

1. **域（Realm）**：-viria
2. **亚域（Subrealm）**：-vira
3. **界（Kingdom）**：-viriae
4. **亚界（Subkingdom）**：-virites
5. **门（Phylum）**：-viricota
6. **亚门（Subphylum）**：-viricotina
7. **纲（Class）**：-viricetes
8. **亚纲（Subclass）**：-viricetidae
9. **目（Order）**：-virales
10. **亚目（Suborder）**：-virineae
11. **科（Family）**：-viridae
12. **亚科（Subfamily）**：-virinae
13. **属（Genus）**：-virus
14. **亚属（Subgenus）**：-virus
15. **种（Species）**：通常以[疾病]病毒的形式出现。

我们可以去官网下载文件后看看主要的门类，目前（2024.8.12）共有14,690种有命名的病毒：


```r
library(dplyr)
ICTV=readxl::read_excel("~/database/ICTV_Master_Species_List_2023_MSL39.v3.xlsx",sheet = 2)
ICTV=ICTV[,c("Realm","Kingdom","Phylum", "Class", "Order", "Family", "Genus", "Species","Genome Composition")]

count(ICTV,Realm,Kingdom,Phylum)%>%arrange(-n)%>%na.omit()%>%my_sankey()
```
<img src="images/Pasted image 20240812125208.png" title="" width="40%"/>

以下是主要病毒域及其门类的介绍：

以下是各个病毒域及其主要门类的详细介绍：

- A型DNA病毒域 (Adnaviria)
    - **特征**：包含环状或线状双链DNA病毒，常感染古细菌，具有独特的DNA包装和复制机制。
    - **齐利希病毒界 (Zilligvirae)** 
      - **杆状病毒门 (Taleaviricota)** 

- 双链DNA病毒域 (Duplodnaviria)
    - **特征**: 包含双链DNA病毒，具有独特的DNA包装和复制机制。
    - **香港病毒界 (Heunggongvirae)**：
      - **衣壳病毒门 (Peploviricota)**：具有二十面体衣壳和外膜，附有糖蛋白。
      - **尾噬菌体门 (Uroviricota)**：通过尾状结构将DNA注入宿主。

- 单链DNA病毒域 (Monodnaviria)
    - **特征**：包含单链DNA病毒，通常感染真核生物。
    - **洛布病毒界 (Loebvirae)**：
      - **霍夫奈病毒门 (Hofneiviricota)**
    - **桑格病毒界 (Sangervirae)**：
      - **菲克斯病毒门 (Phixviricota)**
    - **称徳病毒界 (Shotokuvirae)**：
      - **科萨特病毒门 (Cossaviricota)**
      - **单环编码病毒门 (Cressdnaviricota)**：编码复制相关蛋白的环状单链DNA病毒。
    - **特拉帕尼病毒界 (Trapavirae)**：
      - **嗜盐病毒门 (Saleviricota)**

- 核糖病毒域 (Riboviria)
    - **特征**：包含所有RNA病毒，具有单链正负链RNA基因组。
    - **正RNA病毒界 (Orthornavirae)**：
      - **双链RNA病毒门 (Duplornaviricota)**
      - **光滑裸露病毒门 (Lenarviricota)**
      - **黄色病毒门 (Kitrinoviricota)**
      - **负核糖病毒门 (Negarnaviricota)**
      - **小RNA病毒超群门 (Pisuviricota)**
    - **副RNA病毒界 (Pararnavirae)**：
      - **酶录转逆病毒门 (Artverviricota)**

- 核酶病毒域 (Ribozyviria)
    - **特征**：包含单一属的病毒，具有环状RNA，类似核酶的功能。
    - **主要门类**：未列出具体门类。

- 多变DNA病毒域 (Varidnaviria)
    - **特征**：包含多种DNA病毒，具有衣壳基因的广泛变化。
    - **班福病毒界 (Bamfordvirae)**：
      - **核质病毒门 (Nucleocytoviricota)**
      - **质粒前体病毒门 (Preplasmiviricota)**
    - **海尔维蒂病毒界 (Helvetiavirae)**：
      - **分隔病毒门 (Dividoviricota)**

### 巴尔的摩分类法

<img src="images/Virus_Baltimore_Classification.png" title="" width="60%"/>

巴尔的摩分类法（Baltimore classification）是由美国生物学家戴维·巴尔的摩（David Baltimore）于1971年提出的一种病毒分类方法。与ICTV分类法基于病毒的结构和其他生物特性不同，巴尔的摩分类法主要依据病毒的基因组类型和病毒复制过程中的信使RNA（mRNA）合成方式进行分类。这个分类方法将病毒分为七大类，每一类对应一种特定的基因组类型和复制机制。

- 巴尔的摩分类法的七大类：

1. **I类：双链DNA病毒（dsDNA）**
   - **基因组**：双链DNA。
   - **mRNA合成**：宿主细胞的RNA聚合酶直接转录mRNA。
   - **代表病毒**：腺病毒、疱疹病毒、痘病毒等。

2. **II类：单链DNA病毒（ssDNA）**
   - **基因组**：单链DNA。
   - **mRNA合成**：单链DNA在宿主细胞中形成双链DNA，然后由宿主细胞的RNA聚合酶转录mRNA。
   - **代表病毒**：细小病毒等。

3. **III类：双链RNA病毒（dsRNA）**
   - **基因组**：双链RNA。
   - **mRNA合成**：病毒自带的RNA依赖性RNA聚合酶将双链RNA中的一条链直接转录为mRNA。
   - **代表病毒**：轮状病毒等。

4. **IV类：正义单链RNA病毒（(+)-ssRNA）**
   - **基因组**：正义单链RNA，即直接作为mRNA使用。
   - **mRNA合成**：基因组RNA本身就是mRNA，可以直接被翻译成蛋白质。
   - **代表病毒**：冠状病毒、脊髓灰质炎病毒、黄病毒等。

5. **V类：负义单链RNA病毒（(-)-ssRNA）**
   - **基因组**：负义单链RNA。
   - **mRNA合成**：病毒自带的RNA依赖性RNA聚合酶将负义RNA转录为正义mRNA。
   - **代表病毒**：流感病毒、狂犬病毒、麻疹病毒等。

6. **VI类：反转录RNA病毒（Retroviruses）**
   - **基因组**：正义单链RNA。
   - **mRNA合成**：病毒自带的逆转录酶将RNA逆转录为双链DNA，双链DNA整合到宿主基因组中，宿主细胞的RNA聚合酶再转录mRNA。
   - **代表病毒**：人类免疫缺陷病毒（HIV）等。

7. **VII类：反转录DNA病毒（Pararetroviruses）**
   - **基因组**：部分双链DNA，带有缺口。
   - **mRNA合成**：缺口的双链DNA在宿主细胞内修复成为完整的双链DNA，由宿主的RNA聚合酶转录mRNA。部分mRNA通过逆转录形成DNA，并整合到宿主基因组中。
   - **代表病毒**：乙型肝炎病毒（HBV）等。

### 亚病毒因子

亚病毒因子是指比病毒更简单的病原体，包括类病毒、卫星病毒和朊病毒等。它们通常没有完整的病毒结构，缺乏自身复制所需的酶或结构蛋白，依赖宿主或协助病毒的机制进行繁殖。

- **类病毒**：由单一的环状RNA分子组成，感染植物。
- **卫星病毒**：依赖辅助病毒进行复制。
- **朊病毒**：异常折叠的蛋白质，能导致神经退行性疾病。

这些因子尽管简单，却可能导致严重的疾病。

