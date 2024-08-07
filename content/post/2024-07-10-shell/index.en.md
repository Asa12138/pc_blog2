---
title: 一些实用的shell脚本
author: Peng Chen
date: '2024-07-15'
slug: shell
categories:
  - utils
tags:
  - shell
description: ~
image: ~
math: ~
license: ~
hidden: no
comments: yes
---

记录分享一些自己在linux下常用的shell脚本。

建议使用方式：新建一个储存脚本的目录如~/script，把脚本复制为相应文件，chmod +x 使脚本可执行，然后添加到PATH中方便使用。

```bash
mkdir ~/script

# add scripts
chmod +x ~/script/*

# add to PATH
echo 'export PATH=$PATH:~/script' >> ~/.bashrc
source ~/.bashrc
```

### 无root权限使用yum安装包

参考： <https://blog.csdn.net/GreenHandCGL/article/details/83055151>

现在很多服务器都是centos系统，可以用yum（ Yellow dog Updater, Modified）作为Shell 前端软件包管理器。

而我们使用服务器的时候通常无法获得root权限，也就无法使用sudo提升权限直接用yum安装软件。
但是其实在linux中，安装软件需要权限通常是因为我们对安装位置没有权限，所以只要把软件安装到我们有权限的位置就行了。

脚本，保存为`yum_i`：
```bash
#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 [-y] package_name"
    exit 1
}

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    show_usage
fi

# Parse options
DOWNLOAD_AND_INSTALL=false
while getopts ":y" opt; do
    case ${opt} in
        y )
            DOWNLOAD_AND_INSTALL=true
            ;;
        \? )
            show_usage
            ;;
    esac
done
shift $((OPTIND -1))

# Get the package name
PACKAGE_NAME=$1

# If no package name is provided, show usage
if [ -z "$PACKAGE_NAME" ]; then
    show_usage
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if yum and yumdownloader are available
if ! command_exists yum || ! command_exists yumdownloader; then
    echo "yum or yumdownloader command not found. Please make sure they are installed."
    exit 1
fi

# Extract the base package name
BASE_NAME=$(echo "$PACKAGE_NAME" | cut -d. -f1)

# If -y option is provided, download and install the package
if [ "$DOWNLOAD_AND_INSTALL" = true ]; then
    echo "Downloading and installing package: $PACKAGE_NAME"
    cd ~ || exit 1
    yumdownloader "$PACKAGE_NAME"
    RPM_FILE=$(ls "${BASE_NAME}"*.rpm 2>/dev/null)
    if [ -f "$RPM_FILE" ]; then
        rpm2cpio "$RPM_FILE" | cpio -idvm
        rm -f "$RPM_FILE"
        echo "Package $PACKAGE_NAME installed successfully."
    else
        echo "Failed to download package $PACKAGE_NAME."
        exit 1
    fi
else
    # Otherwise, list the package
    yum list "$PACKAGE_NAME"
fi
```

使用方法：

1. 查询能装的包：`yum_i package_name`
```bash
$ yum_i graphviz
Loaded plugins: fastestmirror, langpacks, product-id, search-disabled-repos, subscription-manager
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
Available Packages
graphviz.i686                                                        2.30.1-22.el7                                                      base
graphviz.x86_64                                                      2.30.1-22.el7                                                      base
```

2. 正式下载安装包：`yum_i -y package_name`
```bash
# 注意用上面查找到的包名替换
yum_i -y graphviz.x86_64
```

3. 添加环境变量
这种方法默认安装位置是`~/usr/bin/`，我们把它添加到PATH中：

```bash
echo 'export PATH=$PATH:~/usr/bin/' >> ~/.bashrc
source ~/.bashrc
```

这样就可以正常调用该软件包了。

### 
