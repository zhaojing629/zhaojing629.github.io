---
title: 【ORCA】08.CASSCF教程
typora-root-url: 【ORCA】08.CASSCF教程
mathjax: true
date: 2023-10-07
updated:
tags: [ORCA, CASSCF]
categories: [计算化学, 软件]
description: ORCA的CASSCF教程笔记
---







# CASPT2

- CASSCF收敛的结果是考虑动态相关多参考的起点，常用的MRCI和MRPT

- internally contracted N-Electron valence state perturbation theory
  N个电子价层微扰(NEVPT2) 是动态相关的首选，只需要一个关键词：

  ```
  %casscf
  ...
  PTMethod SC_NEVPT2 # for the strongly contracted NEVPT2
  # Other options: FIC-NEVPT2, DLPNO-NEVPT2, FIC CASPT2
  end
  ```

  - `NEVPT2`就是NEVPT2方法的strongly contracted” 版本
  - `PC-NEVPT2`是in the canonical and in the DLPNO methodology
  - `FIC-NEVPT2`是fully internally contracted (FIC)版
  - 
