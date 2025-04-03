---
title: 【molpro】07.相关分析
typora-root-url: 【molpro】07.相关分析
mathjax: true
date: 2024-11-14 16:10:57
updated:
tags: [molpro, 电荷]
categories: [计算化学, 软件]
description: 电荷分析
---



# `PROPERTY`

例子：

```
***,h2o properties
geometry={o;h1,o,r;h2,o,r,h1,theta}   !Z-matrix geometry input
r=1 ang                               !bond length
theta=104                             !bond angle
hf                                    !do scf calculation
property                              !call property program
orbital                               !read scf orbitals
density                               !read scf density matrix
dm                                    !compute dipole moments and print orbital contributions
qm                                    !compute quadrupole moments and print orbital contributions
{multi;wf;state,2;dm                  !do full-valence CASSCF
natorb,state=1.1                      !compute natural orbitals for state 1.1
natorb,state=2.1}                     !compute natural orbitals for state 2.1

{property                             !call property program
orbital,state=1.1                     !read casscf natural orbitals for state 1.1
density,state=1.1                     !read casscf density matrix for state 1.1
dm                                    !compute dipole moments and print orbital contributions
qm}                                    !compute quadrupole moments and print orbital contributions

{property                             !call property program
orbital,state=2.1                     !read casscf natural orbitals for state 2.1
density,state=2.1                     !read casscf density matrix for state 2.1
dm                                    !compute dipole moments and print orbital contributions
qm}                                   !compute quadrupole moments and print orbital contributions
```



# Mulliken电荷分析

```
POP;
```

- 调用Mulliken分析程序，用于把任何密度矩阵分解为每个原子s,p,d,f...基函数的贡献。密度矩阵来自最后一个转存记录，除非使用DENSITY卡覆盖。

  ```
  DENSITY,record.file[,specifications]
  ```

  - 从文件file的记录record获取用于分析的密度矩阵。
  - 特定态的密度矩阵可以用specifications选择

  ```
  INDIVIDUAL;
  ```

  - 如果指定，则打印每个基函数的Mulliken布居。

- 例子：

  ```
  ***,h2o population analysis
  geometry={o;h1,o,r;h2,o,r,h1,theta}   !Z-matrix geometry input
  r=1 ang                               !bond length
  theta=104                             !bond angle
  basis=6-311g**
  hf                                    !do scf calculation
  pop;                                  !Mulliken population analysis using mcscf density
  individual                            !give occupations of individual basis functions
  ```

  



# NBO分析

```
NBO,[WITH_CORE=core_option],[LEVEL=level],[KEEP_WBI=wbi_option];
SAVE,record.file;
```

- 默认使用完全轨道空间，但是如果定义了coreoption=0，那么芯轨道可以放到流程外。
- 用LEVEL关键词可以截选转换的轨道序列（例如，只计算NAO轨道）。如果LEVEL=1，
  则只执行NAO转换。对于LEVEL=2，执行NBO转换，=3为NLMO（默认）。
- 有时由于双中心键搜索顺序的错误，NBO流程可能不收敛。第一次运行基于Wiberg键级，但是在随后的运行中，算法调整到原子顺序。这可以用KEEPWBI选项避免。如果wbioption=1，那么在所有的迭代中使用Wiberg键级。