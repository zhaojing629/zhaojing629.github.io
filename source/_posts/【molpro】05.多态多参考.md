---
title: 【molpro】05.多态多参考
typora-root-url: 【molpro】05.多态多参考
mathjax: true
date: 2021-11-27
updated:
tags: [molpro, CASPT2, 微扰理论]
categories: [计算化学, 软件]
description: 多态多参考CASPT2等计算
---



- CASSCF主要是考虑静态相关，CI，微扰理论等考虑动态相关。MRCI和CASPT2都考虑了。

- 多参考微扰计算作为MRCI程序的特例执行。对于RS2（CASPT2，RASPT2），只需要对单电子算符计算矩阵元，因此计算量远远小于相应的MRCI。对于RS3（CASPT3），必须计算一阶波函的能量期待值，计算量几乎与一次MRCI迭代相同。RS2 和RS3程序使用与MRCI相同的组态空间，即，只对双激发的外组态进行内收缩。

# 多参考微扰理论

- 如果没有进一步的输入卡，波函的定义（芯轨道，闭壳层及活性轨道空间和对称性）对应最近的SCF或MCSCF计算所用的定义。轨道来自相应的SCF或MCSCF 计算，除非给出了`ORBITAL`指令。
- 对于CASPT2计算，如果使用了（赝）正则轨道，零阶哈密顿量将会成为分块对角化的形式。这会加速收敛。因此在此前的MULTI计算中，推荐用`CANONICAL` 指令保存轨道（默认是`NATORB`）。

执行二阶或三阶微扰计算：

```
RS2,options
RS2C,options
RS3,options
```

- RS3总是包含RS2作为第一步计算。
- 对于rs2和rs3，使用与MRCI完全相同的组态空间。在这种情况下，外层轨道空间中有两个电子的激发态在内部收缩。对于32位系统，相关轨道的总数限制为16，对于64位系统，相关轨道的总数限制为32。对于闭壳层单参考的情况，这等价于MP2或MP3。
- 在rs2c情况下，单激发外部和内部组态空间的子空间也都是内收缩的。这种方法比RS2效率更高，特别是对具有多个闭壳层（非活性）轨道的大分子。特别地，在这种情况下，只有活性轨道的数量被限制为16个或32个，分别在32位和64位机器上，并且可以使用任何数量的封闭壳层（非活性的）轨道（根据程序参数定义的最大值）。RS2C调用新的更高效的二阶程序，如果不计算三阶项的话，一般使用这个。
  - 注意，RS2和RS2c方法产生的结果略有不同。在这两种情况下，结果也与在MOLCAS中实现的使用Roos等人的方法得到的结果略有不同，因为后一种情况下，所有组态空间都在内部收缩。这就引入了MOLPRO中不存在的一些瓶颈。
- 可以使用restrict和/或select指令来执行限制活性空间RASPT2或常规MRPT2计算，如MCSCF和CASSCF部分所述。

## Options

- MRPT2和CASPT2的计算经常遇到激发态计算的入侵态问题，导致波函数爆炸而不收敛。可以使用以下方法来避免。

  - `Gn`：使用修改的零阶哈密顿量

  - `SHIFT=value`：能级移动（(Chem. Phys. Lett. 245, 215 (1995)).）典型的移动是0.1 − 0.3。在小数点之后只考虑两位数字。打印的能量以及ENERGY 变量包含了Roos和Andersson对能级移动建议的能量修正。收敛后还打印未修正的能量用于比较。

  - `IPEA=value`：IPEA 能级移动。（G. Ghigo, B. O. Roos, and P.A. Malmqvist, Chem. Phys. Lett. 396, 142 (2004）） A value of 0.20-0.25 is recommended. 
  - 可以同时使用`SHIFT`和`IPEA`，但`Gn`选项不能和`IPEA`一起使用。

- `MIX=nstates`：调用nstates个态的多态（MS-CASPT2）处理。
- `ROOT=ioptroot`：在次梯度计算（比如几何优化）中需要优化的根数（只有在随后进行梯度计算时才需要）。和MS-CASPT2中的`nstates`有关。
- `SAVEH=record`：在MS-CASPT2计算中，保存有效哈密顿量的记录。如果没有给出，则使用默认的记录（推荐）。
- `INIT`：（逻辑型）用单个态的参考函数初始化MS-CASPT2。
- `IGNORE`：（逻辑型）不使用CP-CASPT2的近似梯度计算标记。

## 例子

```
***,mscaspt2 for h2o 3B2 states
basis=vdz
geometry={O
          H1,O,R;
          H2,O,R,H1,THETA}
R=2.4
Theta=98
hf
{multi;closed,2
wf,10,1,2;state,3         !three 3A1 states included in sa-casscf
wf,10,2,2;state,2         !two 3B1 states included in sa-casscf
wf,10,3,2;state,3         !three 3B2 states included in sa-casscf
canonical,2140.2}         !save pseudo canonical orbitals

{rs2,xms=2,mix=3,root=2;  !include three B2 states,
                          !select the second state for gradients
wf,10,3,2}                !Triplet B2 state symmetry

optg                      !optimize the geometry
```

## 计算激发态

### 分别计算每个态

```
STATE,1,root
```

- `root`是所需要的根（即，2对应第一激发态）。在这种情况下，用于零阶哈密顿量的Fock算符用给定态的密度进行计算。

### 同时计算两个或更多的态

```
STATE, n [,root1, root2, . . . , rootn]
```

- `n`是计算的态的个数。
- 默认计算最低的n个根。默认设置也可以通过指定所需要的根`rooti`来修改。
