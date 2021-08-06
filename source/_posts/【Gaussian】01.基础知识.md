---
title: 【Gaussian】01.基础知识
typora-root-url: 【Gaussian】01.基础知识
mathjax: true
date: 2019-09-03 14:47:37
updated:
tags: [基组]
categories: [计算化学,Gaussian]
description: Gaussian中关于基组的常见问题
---





# 输入文件基本格式





# 坐标的输入

- `geom=check`：输入结构从chk中读取，输入文件里此时不能写坐标
- `geom=allcheck`：标题段落、电荷、自旋多重度、坐标都从chk中读取。输入文件里此时不能写坐标多重度等，关键词后面空行直接跟指定的基组或者为空。

