---
title: 【ADF】04.画图相关
typora-root-url: 【ADF】04.画图相关
date: 2022-11-28
updated:
description: Engine ADF中画图相关
tags: [AMS, ADF, 画图]
mathjax: true
categories: [计算化学, 软件]
---



# 静电势

1. SCM LOGO → View → Add → Isosurface:colored
2. Density SCF，指电子云密度，0.001即该曲面为电子云密度值为0.001 a.u.的曲面
   - 范德华表面的定义，如果参考文献（J. Am. Chem. Soc. 1987, 109,7968-7979）的定义，则可以选为电子云密度等值面的值为0.001的曲面。
3. Culoumb potential SCF即静电势，后面两个方框内的值为值的范围，为程序自动计算得出，为了显示更对称，用户可以将数值改为±对称，这样白色的位置即静电势为0
4. 勾选最右侧的Bar，则显示色条
