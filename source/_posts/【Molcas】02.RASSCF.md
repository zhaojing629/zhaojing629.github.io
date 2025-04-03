---
title: 【Molcas】02.RASSCF
typora-root-url: 【Molcas】02.RASSCF
mathjax: true
date: 2024-09-24 15:13:41
updated:
tags: [molcas, CASSCF]
categories: [计算化学, 软件]
description: Molcas的RASSCF的计算
---





完整活动空间 (CASSCF) 和受限活动空间 (RASSCF) SCF 计算均可使用 RASSCF 程序模块执行

例子：

```
&RASSCF
Title= The CASSCF energy of water is calculated using C2v symmetry. 2 3B2 state.
nActEl= 8 0 0
Inactive= 1 0 0 0; Ras2= 3 2 0 1
Symmetry= 2; Spin= 3
CIRoot= 1 2; 2
LumOrb
```



# 输入

 RASSCF需要系统的轨道信息，可以通过两种方式获得。 LUMOrb 指示轨道应取自用户定义的轨道文件，该文件被复制到内部文件 INPORB。如果未给出此关键字，程序将按照优先顺序在运行文件中查找轨道：RASORB、SCFORB 和 GUESSORB



# 关键词

- `SYMMetry`：波函数的对称性（根据 GATEWAY）（1 到 8）

- `SPIN`：自旋多重度

- `CHARGE`:电荷

- `NACTel`：三个数字：Ras1 中的活性电子、空穴总数、Ras3 中的粒子总数

- `INACtive`：双占轨道，通过对称性指定

- `FROZen `：可用于重原子，以减少基集叠加误差 (BSSE)。相应的轨道将不会被优化。

- `RAS2 `：指定每个对称性中包含在允许所有可能占据的电子激发中的轨道数量。

- 使用关键字 `RAS1` 和/或 `RAS3` 指定轨道并指定非零数量的空穴/电子将产生 RASSCF 波函数。

  - 如果 RAS1 和 RAS3 空间为零，RASSCF 计算将产生 CASSCF 波函数。

  - 不同的RAS1和RAS3代表的计算类型：

    ![image-20240924154746777](/../【Molcas】02-RASSCF/image-20240924154746777.png)

- `LEVShift `：进行电平转换以提高计算的收敛性。

- `ITERations`：RASSCF迭代最大次数

- `ALTEr`：改变轨道

  ```
  ALTEr= 2; 1 4 5; 3 6 8
  ```

  表示2对MO将被交换：对称1中的4和5以及对称3中的6和8。

## 多组态

- `STAVerage`：态平均计算中包含的根数，是`CIroot`关键词的简化，比如：`STAverage = n`和`CIRoot = n n 1`是等同的。

- `CIROot`：第一行包含2或3个数字，分别代表NROOTS、LROOTS和IALL

  - `NROOTS`表示用几个态来进行计算
  - `LROOTS`表示Davidson过程中小CI矩阵的维数
  - `IALL`如果不等于1或者没有指定，那么就要给出第二行（指定选择的态的编号）和第三行（和第二行对应，他们所占的比例）

  ```
  #平均值分别在与根2、4和5相对应的三个状态下，分别为20％，20％和60％。
  CIRoot= 3 5; 2 4 5; 1 1 3
  ```



# 输出

