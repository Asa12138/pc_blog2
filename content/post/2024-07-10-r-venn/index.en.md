---
title: R绘制Venn图及其变换
author: Peng Chen
date: '2024-07-12'
slug: r-venn
categories:
  - R
tags:
  - R
  - 可视化
description: 我将常用的各种函数整成了一个包：pcutils，包含各种绘图方法，这里介绍一下绘制Venn图及其变换，如花瓣图，Upset图，Venn网络图等。
image: index.en_files/figure-html/unnamed-chunk-6-1.png
math: ~
license: ~
hidden: no
comments: yes
---



我自己在用R做各种分析时有不少需要反复用到的基础功能，比如一些简单的统计呀，画一些简单的图等等，虽说具体实现的代码也不麻烦，但还是不太想每次用的时候去找之前的代码。

索性将常用的各种函数整成了一个包：[pcutils](https://github.com/Asa12138/pcutils)，
网址：https://github.com/Asa12138/pcutils 

从CRAN安装：


```r
install.packages("pcutils")
```

但目前还是建议从github安装，包含的功能会多一些:

```r
install.packages("devtools")
devtools::install_github('Asa12138/pcutils',dependencies=T)
```

## Introduction


在线网站：http://www.ehbio.com/test/venn/#/



```r
aa <- list(a = 1:3, b = 3:7, c = 2:4)
venn(aa, mode = "venn")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
venn(aa, mode = "network")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-2.png" width="672" />

```r
venn(aa, mode = "upset")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-3.png" width="672" />

```r
data(otutab)
venn(otutab, mode = "flower")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-4.png" width="672" />

```r
venn(otutab[sample(1:500,100),1:3], mode = "network")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-5.png" width="672" />

所有的可视化方法都是为展示数据服务的，
我整合这些函数也是希望可以更关注数据本身，花更少的精力在调节图形上，先快速对我们的数据有整体的把握。

`pcutils`的初衷还是迎合我自己的编程与数据分析习惯的，所以可能并不适合所有人，大家也可以直接fork并修改我的源码，欢迎大家提出建议与意见。
