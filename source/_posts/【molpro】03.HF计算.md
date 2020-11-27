---
title: 【molpro】03.HF计算
typora-root-url: 【molpro】03.HF计算
mathjax: true
date: 2019-11-16 22:10:02
updated: 
tags: HF
categories: [计算化学,molpro]
description: molpro的HF计算
---



# 调用方法

- `HF`或`RHF`，自旋限制Hartree-Fock程序，开壳层和比可曾都可以，或者用`HF-SCF`、`RHF-SCF`也可以。
- `UHF`或`UHF-SCF`，自旋非限制Hartree-Fock程序

# 选项

## 定义波函数

```
WF,elec,sym,spin
```

- `OCC`定义每个对称性的占据轨道数，轨道的总数必须等于(总电子数+spin)/2

- `CLOSED`定义闭壳层轨道，可用于开壳层计算，指定每个对称性中闭壳层轨道的数量。

- `OPEN`指定开壳层轨道，即指定单占据轨道，单占据轨道的数量必须等于spin，其对称性乘
  积必须等于sym，如果`orbi.sym`为负，这个轨道将用负自旋占据（仅允许在UHF中）。

  ```
  OPEN,orb1.sym1,orb.sym2,...orbn.symn
  ```

### 例子

O<sub>2</sub>

- 轨道占据为$1\sigma_g^21\sigma_u^22\sigma_g^22\sigma_u^23\sigma_g^21\pi_{u,x}^21\pi_{u,y}^21\pi_{g,x}^11\pi_{g,y}^1$

- $\sigma_g$，$\pi_{u,x}$，$\pi_{u,y}，$$\sigma_u$，$\pi_{g,x}$，$\pi_{g,y}$的对称性分别对应于$D_{2h}$的1，2，3，5，6，7，则`OCC`中为`3,1,1,,2,1,1`

- $\pi_{g,x}$，$\pi_{g,y}$相乘为4（$B_{2g}\times B_{3g}=B_{1g}$），`wf`的对称性是4

- $\pi_{u,x}$，$\pi_{u,y}$相乘也为4，所以需要用`OPEN`进一步明确开壳层的轨道

- 输入文件为：

  ```
  {hf
  wf,16,4,2
  occ,3,1,1,,2,1,1
  open,1.6,1.7} 
  ```

  

