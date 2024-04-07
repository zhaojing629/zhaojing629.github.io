---
title: 【molpro】03.HF计算
typora-root-url: 【molpro】03.HF计算
mathjax: true
date: 2019-11-16 22:10:02
updated: 
tags: [molpro, HF]
categories: [计算化学, 软件]
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
- 轨道占据为$$1\sigma_g^21\sigma_u^22\sigma_g^22\sigma_u^23\sigma_g^21\pi_{u,x}^21\pi_{u,y}^21\pi_{g,x}^11\pi_{g,y}^1$$
- $$\sigma_g$$，$$\pi_{u,x}$$，$$\pi_{u,y}$$，$$\sigma_u$$，$$\pi_{g,x}$$，$$\pi_{g,y}$$的对称性分别对应于$$D_{2h}$$的1，2，3，5，6，7，则`OCC`中为`3,1,1,,2,1,1`
- $$\pi_{g,x}$$，$$\pi_{g,y}$$相乘为4（$$B_{2g}\times B_{3g}=B_{1g}$$），`wf`的对称性是4
- $$\pi_{u,x}$$，$$\pi_{u,y}$$相乘也为4，所以需要用`OPEN`进一步明确开壳层的轨道
- 输入文件为：
  ```
  {hf
  wf,16,4,2
  occ,3,1,1,,2,1,1
  open,1.6,1.7} 
  ```

## 初始轨道

程序既可以产生初始轨道猜测，也可以从以前优化的轨道开始。还可以使用以前的密度矩阵构造第一个Fock算符。如果不指定START卡，程序会按照以下方式试着寻找合适的初始轨道：

1. 试着从`ORBITAL`或`SAVE`卡指定的record或它们相应的默认值（参见ORBITAL）中读取轨道。所有的文件都被搜索。
2. 试着从以前的SCF或MCSCF计算寻找轨道。所有的文件都被搜索。
3. 如果没有发现轨道，则初始轨道用近似原子密度或ℎ的本征矢产生（见下）。

由于这些默认值通常都是合适的，因此在大多数情况下不需要`START`卡。

定义方法：

```
START,[TYPE=]option
```

- option关键词可以是：
  - `H0`：用ℎ的本征矢作为初始猜测。
  - `ATDEN`：使用从原子占据数构造的对角密度矩阵的自然轨道。



# 其他指令

## 能级移动

- 对α和β电子分别使用`shifta`和`shiftb`的能级移动，可以改善收敛，对求解没有影响。
  - 闭壳层的默认值是shifta=`0`
  - 开壳层的默认值是`-0.3 0`

```
SHIFT,shifta,shiftb
```

## 迭代的最大数量

- 设置迭代的最大数量为maxit。默认为maxit= 60。

```
MAXIT,maxit
```

## 收敛阈值

- 收敛阈值设置为$$10^{-accu}$$。这用于密度矩阵元变化量的平方和。
- 默认值取决于全局能量阈值，并且阈值会在几何优化或频率计算中自动更小，除非给出了一个阈值。

```
ACCU,accu
```

## 能量的合理性检查

- 禁止能量的合理性检查，即使是能量值不合理时。否则，默认自动检查能量。

```
NOENEST
```

## 打印

- 打印虚轨道的数量，默认为print= 0。
- print= −1完全禁止打印轨道。test=1在每次迭代后打印轨道。

```
ORBPRINT,print,test
```



# SCF不收敛

- 看一下波函数的对称性

- 通过能级移动，导致更平滑但更慢的收敛

  ```
  {rhf; shift,-1.0,-0.5}
  ```

- 冻结占据，在迭代第N次的时候，冻结轨道占据。`rhf，nitord = 1}`会冻结最初的占据。

  ```
  {rhf，nitord = N}
  ```

- 极小基SCF猜：

- 增加DIIS：

  ```
  {rhf,maxdis=30,iptyp=DIIS,nitord=20; shift,-1.0,-0.5}
  ```

  ```
  {rhf,maxdis=10,iptyp=KAIN,nitord=10; shift,-1.0,-0.5}
  ```

  