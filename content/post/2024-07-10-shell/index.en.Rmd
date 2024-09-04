---
title: 一些实用的shell脚本
author: Peng Chen
date: '2024-07-15'
slug: shell
categories:
  - utils
tags:
  - shell
description: 记录分享一些自己在linux下常用的shell脚本和小软件。
image: ~
math: ~
license: ~
hidden: no
comments: yes
---

记录分享一些自己在linux下常用的shell脚本和小软件。

脚本建议使用方式：新建一个储存脚本的目录如~/script，把脚本复制为相应文件，chmod +x 使脚本可执行，然后添加到PATH中方便使用。

```bash
mkdir ~/script

# add scripts
chmod +x ~/script/*

# add to PATH
echo 'export PATH=$PATH:~/script' >> ~/.bashrc
source ~/.bashrc
```

## 脚本

### 无root使用yum安装包

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

### autojump

官网：<https://github.com/wting/autojump>

Autjump 是一个非常实用的命令行工具，帮助用户快速跳转到常用的目录，尤其适合经常在命令行中导航的用户。以下是一些常见的用法示例：

1. 快速跳转到包含特定关键字的目录

如果你想跳转到包含关键字 `foo` 的目录，可以使用：

```bash
j foo
```

2. 跳转到子目录

有时候你可能只想跳转到当前目录的某个子目录，而不想输入完整的路径名称。这时可以使用：

```bash
jc bar
```

其中 `bar` 是子目录的名称。

3. 使用文件管理器打开目录

你还可以通过 `jo` 命令来使用系统的文件管理器（如 Mac Finder、Windows Explorer、GNOME Nautilus 等）打开目录，而不是直接跳转：

```bash
jo music
```

如果你想打开子目录，也可以使用类似的命令：

```bash
jco images
```

4. 使用多个参数来跳转

假设你的数据库中有以下两个目录：

```
30   /home/user/mail/inbox
10   /home/user/work/inbox
```

默认情况下，使用 `j in` 会跳转到 `/home/user/mail/inbox`，因为它的权重更高。但是，如果你想跳转到另一个目录，可以通过传递多个参数来实现：

```bash
j w in
```

这会跳转到 `/home/user/work/inbox`。

5. 获取更多选项

如果你想了解更多使用选项，可以查看帮助文档：

```bash
autojump --help
```

通过这些命令可以更高效地在系统目录中导航，节省大量时间。

### 查找差集

使用awk查找file1中存在但file2中不存在的行，并将结果打印到标准输出，有时候在做文件名对比之类时很有用：

脚本，保存为`diff_rows`：
```bash
#!/bin/bash

# 初始化变量
file1=""
file2=""

# 使用getopts解析命令行参数
while getopts ":f:s:" opt; do
  case "$opt" in
    f)
      file1="$OPTARG"
      ;;
    s)
      file2="$OPTARG"
      ;;
    \?)
      echo "无效的选项： -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "选项 -$OPTARG 需要一个参数" >&2
      exit 1
      ;;
  esac
done

# 检查必需的参数是否提供
if [ -z "$file1" ] || [ -z "$file2" ]; then
  echo "用法: $0 -f <file1> -s <file2>"
  exit 1
fi

awk 'NR==FNR{seen[$0]=1; next} !seen[$0]' "$file2" "$file1"
```

### 文件夹软链接

方便创建多个软链接，将源目录中的所有文件链接到目标目录中：

脚本，保存为`link_dir`：

```bash
#!/bin/bash

# 检查是否提供了源目录和目标目录
if [ $# -ne 2 ]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

SOURCE_DIR=$1
DEST_DIR=$2

# 检查源目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory does not exist."
  exit 1
fi

# 检查目标目录是否存在，不存在则创建
if [ ! -d "$DEST_DIR" ]; then
  echo "Destination directory does not exist. Creating it now."
  mkdir -p "$DEST_DIR"
fi

# 创建软链接
for file in "$SOURCE_DIR"/*; do
  ln -s "$file" "$DEST_DIR"
done

echo "Soft links created for all files in $SOURCE_DIR to $DEST_DIR"
```


