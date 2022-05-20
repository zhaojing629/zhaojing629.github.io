---
title: 【Gaussian】01.基础知识
typora-root-url: 【Gaussian】01.基础知识
mathjax: true
date: 2019-09-03 14:47:37
updated:
tags: [Gaussian, 基组]
categories: [计算化学, 软件]
description: Gaussian中的常见问题
---





# 输入文件基本格式





# 坐标的输入

- `geom=check`：输入结构从chk中读取，输入文件里此时不能写坐标
- `geom=allcheck`：标题段落、电荷、自旋多重度、坐标都从chk中读取。输入文件里此时不能写坐标多重度等，关键词后面空行直接跟指定的基组或者为空。





# chk文件

- 在哪个操作系统下得到的chk文件就要在哪个操作系统下转换：

  - Windows下点击Gaussian图形界面的Utilities-FormChk，选择chk文件

  - Linux使用格式：（直接formchk的前提是已经将formchk添加到环境变量中，否则可以是：相应的路径/formchk）

    ```
    formchk xxx.chk xxx.fchk
    formchk xxx.chk #y
    ```

    
