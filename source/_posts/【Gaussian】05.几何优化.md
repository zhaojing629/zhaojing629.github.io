---
title: 【Gaussian】05.几何优化.md
typora-root-url: 【Gaussian】05.几何优化.md
mathjax: true
date: 2025-09-04 20:52:39
updated: 
tags: [Gaussian, 几何优化]
categories: [计算化学, 软件]
description: 几何优化
---



# 消除虚频

- 几何优化时用更严的收敛限：`tight`或者`vtight`

  ```
  opt=tight freq		#freq最后也会用tight标准来判断是否收敛
  ```

- 提升DFT积分格点精度（Gaussian 16`int=ultrafine`是默认设置）

  ```
  int=superfine
  ```

- 使用精确的Hessian矩阵：

  ```
  #几何优化过程中每一步都会精确计算Hessian，优化任务结束后会自动做振动分析
  opt=calcall
  
  #只在优化第一步的时候精确计算Hessian，而之后还是近似估计Hessian
  opt=calfc
  
  #第一步精确计算一次Hessian矩阵，之后每n步重新计算一次Hessian矩阵。
  opt=recalc=n
  ```

  
