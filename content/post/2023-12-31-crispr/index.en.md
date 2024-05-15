---
title: CRISPR 相关学习
author: Peng Chen
date: '2023-12-31'
slug: crispr
categories:
  - microbial-ecology
tags:
  - crispr
description: CRISPR-Cas 系统的一些基础知识和最新研究进展
image: images/stress.png
math: null
license: null
hidden: no
comments: yes
bibliography: [../../bib/My Library.bib]
link-citations: yes
csl: ../../bib/science.csl
editor_options: 
  markdown: 
    wrap: 72
---

## Introduction

CRISPR规律成簇间隔短回文重复：clustered regularly interspaced short
palindromic repeats

CRISPR是存在于细菌基因组中的一种元件，其中含有曾经攻击过该细菌的病毒的基因片段。细菌透过这些基因片段来侦测并抵抗相同病毒的攻击，并摧毁其DNA，这类基因组是细菌（和古菌）免疫系统的关键组成部分。CRISPR-Cas 系统存在于大约 40% 的细菌和 85% 的古细菌基因组中，但不存在于真核生物基因组中。

### Work mechanism

CRISPR整体工作流程基本如下 ([*1*](#ref-carterSnapShotCRISPRRNAGuidedAdaptive2015))：

<img src="images/crispr_overall.png" title=""/>

阶段1. 外源DNA采集

外来核酸被Cas蛋白识别，入侵DNA的短片段（30-50个碱基对）（称为原型间隔子）被插入宿主的CRISPR基因座作为间隔序列，由重复序列分隔。在I型和II型系统中，原型间隔子选自侧翼有2-5称为PAM（protospacer
adjacent
motif）的核苷酸(nt)基序。原型间隔子通常结合在CRISPR基因座的一端，称为领导者，通过涉及Cas1、Cas2和原型间隔子上的游离3’羟基的机制。Protospacer整合伴随着重复前导末端重复序列，可能涉及宿主聚合酶和DNA修复机制。

阶段2. crRNA生物合成

CRISPR
RNA生物合成始于转录，然后将初级转录本（pre-crRNA）核解加工成短的CRISPR衍生RNA文库(crRNAs)，每个都包含与先前遇到的外来DNA互补的序列。crRNA指导序列的两侧是相邻重复区域。在I型和III型系统中，初级CRISPR转录物由在重复序列内切割的CRISPR特异性内切核糖核酸酶（Cas6或Cas5d）处理。在许多I型系统中，重复序列是回文序列，并且Cas6与crRNA3’端的茎环稳定相关。在III型系统中，Cas6与CRISPR
RNA瞬时结合，crRNA的3’端被未知核酸酶进一步修剪。CRISPR
RNA加工类型II系统依赖于反式作用crRNA(tracrRNA)，它包含与重复序列互补的序列。这些双链区域在Cas9存在的情况下由RNase
III处理。在II型系统中，tracrRNA和crRNA都是目标干扰所需的。该系统的两个RNA已融合成一个单向导RNA(sgRNA)，Cas9已成为一个强大的工具用于在多种细胞类型和多细胞生物中进行靶向基因组工程。

阶段3. 目标干扰

成熟的crRNA将Cas蛋白引导至互补目标。目标序列被专用Cas核酸酶降解，但目标降解的机制多种多样。I型和II型系统均以包含PAM和互补原型间隔子的dsDNA底物为目标顺序。II型系统中的目标切割由单个蛋白质(Cas9)和两个RNA执行，而I型系统依赖于多亚基监视复合物结合dsDNA底物然后募集Cas3，这是一种反式作用核酸酶，通常与ATP依赖性解旋酶融合。像I型系统，III型系统还依赖多亚基复合物进行目标检测，但与I型系统不同，这些复合物表现出内源性核酸酶活性，以转录依赖性方式降解互补RNA和靶DNA。III型系统不依赖PAM进行目标识别；相反，碱基配对延伸超出指导序列并进入crRNA信号”自身”的5’句柄（CRISPR基因座包含与指导和5’互补的序列handle)并防止目标切割。

### PAM

使用CRISPR/Cas9系统进行基因编辑时需要考虑PAM，PAM的含义和重要性：

1.  Protospacer adjacent motif（PAM）原间隔序列邻近模块序列。

2.  CRISPR/Cas9 (或 gRNA)所靶向的 DNA 序列称为 protospacer，PAM
    是与之紧邻的一小段 DNA 序列(常用的 SpCas9 识别的 PAM 为 NGG)。

3.  Cas9/sgRNA 不能结合、切割没有 PAM 的靶向序列。

4.  PAM 是细菌区分自身 DNA 与外源 DNA 的重要标志。

5.  改变 PAM 或与其相邻的 protospacer/target DNA
    序列会严重影响核酸酶(Cas9, Cpf1 等) 对 DNA 的切割效率。

6.  某些基因编辑操作(如敲入点突变)可能需要人为将 PAM 或与其相邻的 DNA
    序列进行突变，以避免核酸酶对该位点的反复切割，从而提高编辑效率。

### Class, Type, Subtype

|                            |                            |
|----------------------------|----------------------------|
| <img src="images/class1.png" title=""/> 1类 | <img src="images/class2.png" title=""/> 2类 |

原核生物的CRISPR-Cas适应性免疫系统根据效应子模块组织分为两个不同的类别。
1类CRISPR-Cas系统利用**多蛋白效应复合物**
([*2*](#ref-makarovaSnapShotClassCRISPRCas2017))，而2类CRISPR-Cas系统利用**单一蛋白效应器**
([*3*](#ref-makarovaSnapShotClassCRISPRCas2017a))。

基于不同的效应蛋白家族，1类系统分为3种类型和12种亚型。1类系统代表CRISPR-Cas基因座的约90％，并且存在于不同的细菌和古菌门中;嗜热菌富含III型系统。除效应子基因之外，大部分1类基因座编码适应模块蛋白质Cas1和Cas2，以及多种辅助蛋白质，例如Cas4，逆转录酶，CARF（CRISPR相关的Rossmann折叠）结构域蛋白质等。
III型和IV型系统在其各自的基因座中经常缺少适应性模块基因和/或CRISPR阵列。所有I型系统也编码DNA解旋酶Cas3，其通常与HD家族核酸酶结构域融合。在I型系统中，PAM在不同亚型之间变化，位于（原型）间隔区的5’或3’，对于适应和干扰都是必需的。

基于不同的效应蛋白家族，第2类系统可分为3种类型和9个亚型。第十亚型（V-U）包括许多假定的系统，其免疫（或可能是调节）功能仍有待证明。
2类系统占CRISPR-Cas基因座的约10％，在不同的细菌被发现，但在古细菌中几乎不存在。除了效应器蛋白质，大部分2类基因组编码适应性模块蛋白质，Cas1和Cas2以及辅助蛋白质，例如Cas4。
II型和V-B型基因座还包括tracrRNA（反式激活CRISPR
RNA），其与重复部分互补并涉及CRISPR（cr）RNA加工和干扰。然而，某些2类系统，特别是类型6的系统仅由CRISPR阵列和效应蛋白组成。

## beyond adaptive immunity

一篇比较新的综述总结讨论了 CRISPR-Cas 系统的一些众所周知的和一些最近建立的非规范功能及其在其他生物过程中的快速扩展应用 ([*4*](#ref-deviCRISPRCasSystemsRole2022))。它们在基因调控、细菌病理生理学、毒力和进化中的替代作用已经开始揭示。

#### Pathogenicity and virulence

#### Bacterial physiology

#### Response to stress

有人提出，在大肠杆菌中，诱导的 Cas 水平和 CRISPR 阵列中 ssTorA 靶向间隔子（部分匹配）的出现的联合作用导致膜蛋白水平降低，从而影响跨细胞的运输通道。

<img src="images/stress.png" style="width:90.0%" />

#### Endogenous gene regulation

#### Bacterial genome remodeling

为了避免由于自我靶向间隔子导致的细胞死亡，生物体被证明可以通过移除原型间隔子或删除整个目标区域来重塑目标区域。

#### Association with DNA repair system

### application

#### Inhibition of horizontal gene transfer

最近，CRISPR-Cas 还被用作抑制抗生素抗性基因从一种生物体转移到另一种生物体的工具。

#### Typing tool

CRISPR-Cas 系统用于分型细菌物种的多样性

#### Genome editing

## Pangenomes

大部分的CRISPR array中的spacer尚未与它们识别的病毒相关联，被命名为
**CRISPR 暗物质**。

### membranome and CRISPR-Cas systems

最新的这篇文章分析了被称为 ESKAPE 的细菌组的数千个基因组,
看有crispr系统的基因组比没有的基因组多的特殊功能 ([*5*](#ref-rubioAnalysisBacterialPangenomes2023))

1.  总体crispr概况

cirspr type 分布，spacer到plasmid/phage的比例。。。

在肠沙门氏菌中，已表明这些系统可以调节鞭毛基因的表达，最终与生物膜形成有关。

平均而言，具有 CRISPR-Cas 系统的基因组呈现出较少数量的抗性和毒力基因。

2.  crispr phylogeny

CRISPR-Cas 系统似乎遍布整个系统发育树

CRISPR-Cas 系统不会出现在具有固定辅助基因集合的基因组中

具有 CRISPR-Cas
系统的基因组是否以比没有这些系统的基因组更高的频率呈现特定基因？（进一步看这个）

3.  CRISPR-Cas 相关基因富集膜蛋白

4.  具有 CRISPR-Cas I 型系统和特定膜蛋白的基因组显示出独特的spacer和噬菌体基因

## hCRISPR or repeat?

CRISPR-Cas 系统存在于大约 40% 的细菌和 85% 的古细菌基因组中，但不存在于真核生物基因组中。最近，Communications Biology 上发表的一篇文章报道了在人类基因组中鉴定出 12,572 个推定的 CRISPR，他们称之为“hCRISPR” ([*6*](#ref-vanrietCRISPRsHumanGenome2022))。

觉得有点搞笑，人类怎么会有这么多CRISPR系统，所以又看到一篇文章怼他的： ([*7*](#ref-buyukyorukClarifyingCRISPRWhy2023))。

## Reference

<div id="refs" class="references csl-bib-body">

<div id="ref-carterSnapShotCRISPRRNAGuidedAdaptive2015" class="csl-entry">

<span class="csl-left-margin">1. </span><span class="csl-right-inline">J. Carter, B. Wiedenheft, [SnapShot: CRISPR-RNA-Guided Adaptive Immune Systems](https://doi.org/10.1016/j.cell.2015.09.011). *Cell*. **163**, 260–260.e1 (2015).</span>

</div>

<div id="ref-makarovaSnapShotClassCRISPRCas2017" class="csl-entry">

<span class="csl-left-margin">2. </span><span class="csl-right-inline">K. S. Makarova, F. Zhang, E. V. Koonin, [SnapShot: Class 1 CRISPR-Cas Systems](https://doi.org/10.1016/j.cell.2017.02.018). *Cell*. **168**, 946–946.e1 (2017).</span>

</div>

<div id="ref-makarovaSnapShotClassCRISPRCas2017a" class="csl-entry">

<span class="csl-left-margin">3. </span><span class="csl-right-inline">K. S. Makarova, F. Zhang, E. V. Koonin, [SnapShot: Class 2 CRISPR-Cas Systems](https://doi.org/10.1016/j.cell.2016.12.038). *Cell*. **168**, 328–328.e1 (2017).</span>

</div>

<div id="ref-deviCRISPRCasSystemsRole2022" class="csl-entry">

<span class="csl-left-margin">4. </span><span class="csl-right-inline">V. Devi, K. Harjai, S. Chhibber, [CRISPR-Cas systems: Role in cellular processes beyond adaptive immunity](https://doi.org/10.1007/s12223-022-00993-2). *Folia Microbiologica*. **67**, 837–850 (2022).</span>

</div>

<div id="ref-rubioAnalysisBacterialPangenomes2023" class="csl-entry">

<span class="csl-left-margin">5. </span><span class="csl-right-inline">A. Rubio, M. Sprang, A. Garzón, A. Moreno-Rodriguez, *et al.*, [Analysis of bacterial pangenomes reduces CRISPR dark matter and reveals strong association between membranome and CRISPR-Cas systems](https://doi.org/10.1126/sciadv.add8911). *Science Advances*. **9**, eadd8911 (2023).</span>

</div>

<div id="ref-vanrietCRISPRsHumanGenome2022" class="csl-entry">

<span class="csl-left-margin">6. </span><span class="csl-right-inline">J. van Riet, C. Saha, N. Strepis, R. W. W. Brouwer, *et al.*, [CRISPRs in the human genome are differentially expressed between malignant and normal adjacent to tumor tissue](https://doi.org/10.1038/s42003-022-03249-4). *Communications Biology*. **5**, 1–13 (2022).</span>

</div>

<div id="ref-buyukyorukClarifyingCRISPRWhy2023" class="csl-entry">

<span class="csl-left-margin">7. </span><span class="csl-right-inline">M. Buyukyoruk, W. S. Henriques, B. Wiedenheft, Clarifying CRISPR: Why Repeats Identified in the Human Genome Should Not Be Considered CRISPRs. *The CRISPR Journal* (2023), doi:[10.1089/crispr.2022.0106](https://doi.org/10.1089/crispr.2022.0106).</span>

</div>

</div>
