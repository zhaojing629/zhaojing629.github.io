---
title: 【molpro】06.旋轨耦合计算
typora-root-url: 【molpro】06.旋轨耦合计算
mathjax: true
date: 2021-11-27
updated:
tags: [molpro, 旋轨耦合, SO]
categories: [计算化学, 软件]
description: 旋轨耦合计算
---



# 仅旋轨耦合计算

首先要通过casscf计算，再保存对应的波函数

```
{ci;...;save,record1.file}
```

- 如果是全电子计算中，继续计算SO的积分（BP哈密顿量的单、双电子自旋轨道积分可以预先计算并存储到硬盘上）：

  ```
  LSINT [,X] [,Y] [,Z][,ONECENTER] [;TWOINT,twoint;] [;PREFAC,prefac;]
  ```

  - `X`，`Y`，和`Z`定义计算的分量。如果没有给出，三个全部求解。预先计算积分的好处是它们可以用于后面的任何SO计算，但是这可能需要大量的硬盘空间（是在能量计算中积分的六倍）。如果没有给出`LSINT`卡，那么只要需要就会计算积分。
  - `ONECENTER`关键词激活单、双电子自旋轨道积分的单中心近似，对于大分子这会极大地减少计算时间。
  - `TWOINT`和`PREFAC` 可用于控制自旋轨道积分的精度。这些阈值类似于标准积分的`TWOINT`和`PREFAC`。`prefac`的默认值是`twoint`/100，`twoint`的默认值是$$10^{−7}$$。

生成和处理SO矩阵：

```
{ci;hlsmat,type,record1.file,..,recordn.file}
```

- 使用记录record1，record2， record3，. . .中所有的态，计算整个SO矩阵元并进行对角化。这些记录文件必须用MRCI程序的`SAVE`指令产生。如前。
- type是用于Breit-Pauli计算的`ls`或是用于ECP-LS计算的`ecp`用于全电子或 ECP 计算。
  - 如果`ls`给出（推荐），epcs 将用于所有持有 ecps 的原子，并且对剩余的原子进行全电子处理。
  - 如果`ecp`给出，自旋轨道仅包括 ecps 的贡献。
- 默认打印本征值以及基态与激发态之间的偶极跃迁矩阵元。

## 打印选项

```
PRINT,option1=value1, option2=value2, . . .
```

选项可以是：

- `HLS`
  - `=-1`：只打印SO能量以及基态和激发态之间的跃迁矩阵元（默认）。
  - ≥0，打印SO矩阵
  - ≥1，打印特性矩阵
  - ≥2，打印各个矩阵元（同`OPTION,MATEL`）。
  - ≥3，打印调试信息
- `VLS`
  - `=-1`：不打印本征矢（默认）。
  - ≥0，打印本征矢。

eg：

```
print,hls=1,vls=0
```

## 其他选项

使用OPTION指令设置（以任何次序）：

```
OPTIONS [,WIGNER=value] [,HLSTRANS=value] [,MATEL=value]
```

- 如果用`HLSMAT`计算整个SO矩阵，那么通常不显示各个矩阵元。当给定了选项MATEL=1时，会打印各个矩阵元以及内部和外部组态类的贡献。

## 例子


含有ECP的例子：

```
***,Br
geometry={br}
basis=vtz-pp
{rhf;wf,sym=5}
{multi;wf,sym=2;wf,sym=3;wf,sym=5}  !2P states, state averaged
{ci;wf,sym=2;save,5101.2}           !2Px state
{ci;wf,sym=3;save,5102.2}           !2Py state
{ci;wf,sym=5;save,5103.2}           !2Pz state
{ci;hlsmat,ls,5101.2,5102.2,5103.2} !compute and diagonalize SO matrix
```

全电子的例子：

```
***,Br
dkroll=1
geometry={br}
basis=vtz-dk
{rhf;wf,sym=5}
{multi;wf,sym=2;wf,sym=3;wf,sym=5}  !2P states, state averaged
{lsint}                             !Compute spin-orbit 2-electron integrals
{ci;wf,sym=2;save,6101.2}           !2Px state
{ci;wf,sym=3;save,6102.2}           !2Py state
{ci;wf,sym=5;save,6103.2}           !2Pz state
{ci;hlsmat,ls,6101.2,6102.2,6103.2} !compute and diagonalize SO matrix
```



S的例子：

```
***,SO calculation for the S-atom
geometry={s}
basis={spd,s,vtz}                                 !use uncontracted basis

{rhf;occ,3,2,2,,2;wf,16,4,2}                      !rhf for 3P state

{multi                                            !casscf
wf,16,4,2;wf,16,6,2;wf,16,7,2;                    !3P states
wf,16,1,0;state,3;wf,16,4,0;wf,16,6,0;wf,16,7,0}  !1D and 1S states

{ci;wf,16,1,0;save,3010.1;state,3;noexc}          !save casscf wavefunctions using mrci
{ci;wf,16,4,0;save,3040.1;noexc}
{ci;wf,16,6,0;save,3060.1;noexc}
{ci;wf,16,7,0;save,3070.1;noexc}
{ci;wf,16,4,2;save,3042.1;noexc}
{ci;wf,16,6,2;save,3062.1;noexc}
{ci;wf,16,7,2;save,3072.1;noexc}

{ci;wf,16,1,0;save,4010.1;state,3}                !mrci calculations for 1D, 1S states
ed=energy(1)                                      !save energy for 1D state in variable ed
es=energy(3)                                      !save energy for 1S state in variable es
{ci;wf,16,4,2;save,4042.1}                        !mrci calculations for 3P states
ep=energy                                         !save energy for 3P state in variable ep
{ci;wf,16,6,2;save,4062.1}                        !mrci calculations for 3P states
{ci;wf,16,7,2;save,4072.1}                        !mrci calculations for 3P states
text,only triplet states, casscf

lsint                                             !compute so integrals

text,3P states, casscf
{ci;hlsmat,ls,3042.1,3062.1,3072.1}               !Only triplet states, casscf

text,3P states, mrci
{ci;hlsmat,ls,4042.1,4062.1,4072.1}               !Only triplet states, mrci

text,3P, 1D, 1S states, casscf
{ci;hlsmat,ls,3010.1,3040.1,3060.1,3070.1,3042.1,3062.1,3072.1}       !All states, casscf

text,only triplet states, use mrci energies and casscf SO-matrix elements
hlsdiag=[ed,ed,es,ed,ed,ed,ep,ep,ep]             !set variable hlsdiag to mrci energies
{ci;hlsmat,ls,3010.1,3040.1,3060.1,3070.1,3042.1,3062.1,3072.1}
```

