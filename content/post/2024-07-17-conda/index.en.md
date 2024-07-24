---
title: 更新一下你的Conda吧
author: Peng Chen
date: '2024-07-17'
slug: conda
categories:
  - utils
tags:
  - utils
  - conda
description: conda从23.10.0 版本开始默认求解器更改为 `conda-libmamba-solver`，速度快了很多。
image: images/conda.png
math: ~
license: ~
hidden: no
comments: yes
---

做生信分析时有时候要安装很多软件，软件之间的版本依赖关系复杂，这时候就需要用到Conda来安装软件。我一年前下载的conda，最近感觉安装软件越来越慢了，有试过一段时间的mamba（一个快速、强大、跨平台的包管理器），但是某个版本开始不兼容我已有的conda，会报错，我也没有仔细去解决。就一直在忍受着conda的慢。。。

终于在前几天，在安装测试几个大型pipeline时受不了了，准备整理一下自己的环境，想试试最新的mamba。结果发现conda在去年十月份有一个重大更新，在这个 23.10.0 版本中，将 conda 的默认求解器更改为 `conda-libmamba-solver`！
以前的“经典”求解器基于 pycosat/Picosat，并且在可预见的将来仍将是 conda 的一部分，并且可以使用后备方案。

conda 更新日志：<https://docs.conda.io/projects/conda/en/stable/release-notes.html>

conda慢就慢在计算环境中包之间的依赖关系，那换成mamba求解器，岂不是快很多而且不破坏原有的环境？（我不喜欢有个conda目录又一个mamba目录，两者的config也不太一样），赶紧试试：

```bash
conda -V #看看你的conda版本，是不是在23.10.0以前
conda clean -a #注意，我的环境积压了太多东西，conda更新几个小时都没成功，于是清理了一下
conda update conda
conda -V #再看看你的conda版本
```

亲身体验，更新后的conda在solve environment这一步快了非常多，几分钟左右（之前可能花上几个小时😭，因为我的一些环境已经安装了不少软件）。

下面是conda的一些相关介绍：

## Introduction

<img src="images/conda.png" title=""/>

Conda是一个开源的包管理和环境管理工具，主要用于数据科学和机器学习领域。它允许轻松地创建、安装、管理和切换不同版本的软件包和依赖项，以及创建和管理不同的虚拟环境。Conda最常用于Python环境，但也可用于其他编程语言的环境管理。(conda, mamba, python 都是蛇🐍的名字)

以下是一些与Conda相关的基本概念和用法：

1. **环境（Environment）：** 在Conda中，环境是一个独立的工作区，其中包含特定版本的软件包和其依赖项。可以创建多个环境，每个环境可以有不同的软件包配置，以满足不同项目的需求。

2. **软件包（Package）：** 软件包是在Conda环境中安装的软件组件，可以包括Python库、工具和其他程序。Conda具有大量的预构建软件包，也支持创建自定义软件包。

3. **频道（Channel）：** Conda软件包通常存储在称为"频道"的仓库中。默认情况下，Conda会从Anaconda仓库下载软件包，但也可以添加其他频道（镜像源，保证网络通畅），以获取更多软件包。

### 基础使用：

1. **安装Conda：** 首先，需要安装Conda。可以选择安装Anaconda或Miniconda，它们是Conda的不同发行版。Anaconda包含大量的预安装软件包，而Miniconda只包含Conda本身和一些基本工具，允许自定义环境，服务器上的话上从miniconda上手就行。
    ```bash
    # 使用Miniconda安装
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh
    ```

2. **创建环境：** 使用Conda可以轻松地创建新环境，例如：
   ```bash
   conda create --name myenv python=3.8
   ```
   这将创建一个名为`myenv`的新环境，并在其中安装Python 3.8。

3. **激活环境：** 要进入或激活一个环境，可以使用以下命令：
   ```bash
   conda activate myenv
   ```
   激活环境后，将在其中运行软件包和Python。

4. **安装软件包：** 使用Conda可以安装所需的软件包，例如：
   ```bash
   conda install numpy
   ```

   这将在当前激活的环境中安装NumPy。

5. **管理环境：** 可以列出已创建的环境、复制环境、删除环境等，以管理的工作环境。
   ```bash
	$ conda info -e
	
	#导出环境
	conda env export > environment.yml
	#删除环境
	conda remove --name myenv --all
   ```
   
6. **卸载软件包：** 如果不再需要某个软件包，可以使用以下命令卸载：
    ```bash
    conda remove numpy
    ```
    pip安装的包最好用pip来卸载，conda卸载也需要处理依赖关系，好慢的。
    
    
**我的浅薄理解**：conda关键在把不同的软件放在不同文件夹下，切换环境时更新环境变量，让某些版本优先使用。

所以有些不太依赖环境的软件可以直接用绝对路径使用，不需要激活环境：

```bash
~/miniconda3/envs/waste/bin/bowtie2 -h
```

有时候也可以通过软链接给某个环境“安装”软件。注意首先要清楚自己的环境以及该软件的性质，有的软件会有相对路径的依赖，简单的把bin文件移过去是不行的：

```bash
ln -s ~/miniconda3/envs/waste/bin/bowtie2 ~/miniconda3/envs/new_env/bin/
```

我觉得不能太过于依赖conda，自己必须也要有一定的安装软件和管理环境能力，才可以更好地面对未来各种环境问题😂。

现在好多软件都要求新建一个环境安装，做着做着就有好多个环境了，但可能大部分通用包是冗余的，硬盘占用也大。有时候自己观察某个软件的本体和依赖项，说不定大部分依赖项我们已经装过了（我喜欢把目标类似的软件放一起，一般他们的依赖项也比较一致），我们可以手动处理。

这里有一个简单的python脚本，用于将所有Conda环境中安装的包整理成表格，方便查看：

```python
import subprocess
import pandas as pd
import os

# 获取所有conda环境的名称
def get_conda_envs():
    result = subprocess.run(['conda', 'env', 'list'], stdout=subprocess.PIPE, text=True)
    envs = [line.split()[0] for line in result.stdout.split('\n') if line and not line.startswith('#') and 'envs' in line]
    envs.append('base')
    return envs

# 获取指定环境中的包
def get_packages(env):
    result = subprocess.run(['conda', 'list', '-n', env], stdout=subprocess.PIPE, text=True)
    packages = []
    for line in result.stdout.split('\n')[3:]:  # 跳过头几行
        if line:
            parts = line.split()
            if len(parts) >= 4:
                packages.append((parts[0], parts[1], parts[2], parts[3], env))
    return packages

# 获取所有环境的包信息
all_packages = []
envs = get_conda_envs()
for env in envs:
    all_packages.extend(get_packages(env))

# 转换为DataFrame并保存为CSV
df = pd.DataFrame(all_packages, columns=['Package', 'Version', 'Build', 'Channel', 'Environment'])
df.to_csv('conda_packages.csv', index=False)
print("Packages list saved to conda_packages.csv")
```

### 一些问题

1. shell脚本中切换环境

常用的`conda activate`切换conda环境的方法只能在命令行中使用，放在脚本中会报错，该如何解决呢？

必须要先在脚本里`source ~/conda.sh`，shell脚本里source一次就行，就可以切换多次了
```bash
source ~/miniconda3/etc/profile.d/conda.sh
conda activate waste
```

2. 安装速度慢怎么办？

可以使用国内镜像源：
```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
```

3. 为什么不建议将所有内容安装到base环境中？

随着时间的推移，Python 打包系统很容易出现不兼容性；在一个 conda 环境中安装的包越多，依赖关系图就越复杂，这使得默认的基本环境在每次安装另一个包时容易出现问题和损坏。

因此，强烈建议为每个项目/目的使用单独的 conda 环境，以减轻 Python 打包系统的依赖关系管理问题，并使项目依赖关系尽可能独立和简单。

