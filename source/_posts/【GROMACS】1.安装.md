---
title: 【GROMACS】1.安装
typora-root-url: 【GROMACS】1.安装
mathjax: true
date: 2026-08-6 12:49:19
updated:
tags: [Gromacs]
categories: [计算化学, 软件]
description: Gromacs的安装方法
---



# Windows版本

## 1. 通过VScode安装

- 参考[GROMACS的原生Windows版的编译和安装方法（支持GPU加速） - 思想家公社的门口：量子化学·分子模拟·二次元](http://sobereva.com/458)

# 2. 下载别人预编译好的

- 参考[GROMACS的原生Windows版的编译和安装方法（支持GPU加速） - 思想家公社的门口：量子化学·分子模拟·二次元](http://sobereva.com/458)
- 其他版本：
  - [Windows下原生Gromacs 2022.6 GPU 版 - 资源分享 - 计算化学公社](http://bbs.keinsci.com/thread-38865-1-1.html)
  - [经验分享：Windows Server 2016下Gromacs 2024.3 GPU版本编译经历 - 分子模拟 (Molecular Modeling) - 计算化学公社](http://bbs.keinsci.com/thread-48313-1-1.html)
- 直接下载下来解压即可，推荐放到根目录。

# 修改环境变量

- 使用前必须先设置环境变量，将程序的bin目录加入到Path环境变量里。
  - win11直接左下角搜索“环境变量”→系统属性→高级→环境变量→选择“PATH”→编辑→新建→输入GROMACS的bin文件夹的路径即可，保存后记得重启一下命令行才会生效。
- 可以参考：[GROMACS 2018.4原生Windows版的安装演示_哔哩哔哩_bilibili](https://www.bilibili.com/video/av39914815/)
- 命令行输入`gmx -version`出现版本号即说明安装成功。

# Linux版本

- 参考[GROMACS的安装方法（含全程视频演示） - 思想家公社的门口：量子化学·分子模拟·二次元](http://sobereva.com/457)
