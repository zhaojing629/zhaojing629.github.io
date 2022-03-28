---
title: 【LmodeA】01.基础使用
typora-root-url: 【LmodeA】01.基础使用
mathjax: true
date: 2021-10-21 21:34:04
updated: 
tags: [LmodeA, 频率, 力常数]
categories: [计算化学, 软件]
description: 学习LmodeA的过程
---



# 安装

在Linux系统下：

```
tar -xzvf lmodea-200.tar
cd $LMODEA/src
make
```

需要有Fortran90编译器。

运行：

```
./lmodea.exe -b < input > output
```



# 输入

通过`$xxx ...  $END`控制，只有`$QCData`中数据的名字区分大小写。

## $Control

指定计算的类型，关键词有：

- `QCProg="XXXX"`：`XXXX`为量化软件名字，比如`Gaussian`、`GAMESS`、`ORCA`、`Molpro`……

- `IPrint=0`：默认为`0`，标准输出，可以改成`1`，也打印振动的简正模式，平动模式和旋转模式……等

- `ISymm=1`：

  - 默认为`1`，识别分子的点群和不可约表示，支持以下点群

  <img src="/image-20211021223040207.png" alt="image-20211021223040207" style="zoom: 67%;" />

  - 当软件无法识别点群，比如不支持的点群、Jahn-Teller效应、或者程序的bug时候，可以使用`-1`，然后再使用`$Irreps`模块指定。
  - `0`不使用对称性

- `IFSAVE=.False.`：默认不保存原子质量、笛卡尔坐标、Hessian矩阵、APT矩阵（Atomic Polar Tensors原子极化张量）等，如果为`.True.`则会保存到ALMODE纯文本文件中。

- `IFlocal=.True.`：默认计算计算局域模，需要指定`$LocMod`组，如果是`.False.`，则只计算简正模。

### 局域模分析

如果`IFlocal=.False.`，以下的选项都不起作用

- `KaFml=0`：定义力常数的计算方式，以下两种方式在完全优化的最小值和非常严格的收敛准则下是等价的，但在其他情况下，它们的结果可能有一点不同
  - 默认为`0`，计算的是局域力常数
  - `1`：计算的是柔性力常数。
- `IFProj=.False.`：仅适用于`KaFml=0`的情况，指在计算局部模态、力常数和频率时，是否投影出虚频。

  - 默认是`.False.`
  - 如果需要计算IRC或过渡态的时候，需要使用`IFProj=.True.`

## $QCData

指定用引号括起来的数据文件，其中获取数据(原子质量、坐标、APT和Hessian)，通常通过选项`FCHK`只需要一个数据文件。但是对于某些程序，多个数据文件应该用关键字HESS、DDIP和/或GEOM分别定义。

- GAUSSIAN：使用的是*.fchk文件，但是在计算时输入文件中要使用`FREQ(SaveNormalModes)`关键词去自动保存原子质量

- ORCA：使用的是*.hess文件

- MOLPRO：使用*.out文件，但是输入文件中要用`{frequencies,print=1;print,hessian}`打印Hessian和APT

- ADF：TAPE21或者TAPE13文件，但要通过`FCHK`选项

  - ADF将t21二进制文件转换成可用的文件

    ```
    source /home/scicons/ADF2017/adf2017.114/adfrc.sh
    dmpkf *.t21 > t21_ASCII
    ```

## $LocMod

指定局域模的参数

- `IFBnd=.Ture.`：通过程序生成所有键长，默认为`.False.`关闭
- `IFAng=.Ture.`：通过程序生成所有键角，默认为`.False.`关闭
- `IFDih=.Ture.`：通过程序生成所有二面角，默认为`.False.`关闭
- `IFRedun=.Ture.`：生成所有的冗余内坐标，即等同于IFBnd = IFAng = IFDih = `.True.`，默认为`.False.`关闭，对于大分子不要使用这个。

也可以通过自定义，格式为：

```
i j k l : ’name’
```

- `i`，`j`，`k`，`l`是原子的序号
  - 指定键长：`i`>0，`j`>0，`k`=`l`=0
  - 指定键角：`i`>0，`j`>0，`k`>0，`l`=0
    - 线型分子时，投影应该用0或者对于`l`指定一个负的值（-1代表α方向，-2代表β方向，α和β方向是垂直于化学键的两个正交的方向，比如分子在z轴方向上，那么α代表x轴方向，β代表y轴方向）。默认`l=0`代表α方向。
  - 指定二面角：`i`>0，`j`>0，`k`>0，`l`>0
- `:`和`name`可以省略，`name`的引号也可以省略
- `k`和`l`等于0时，也可以省略，但是如果有`name`，必须在两者之间有`:`
- 如果，`j`=`k`=`l`=0，那么可以在下一行指定特殊的局域模的参数（取决于`i`），

# 输出文件

## ALMODE文件

- NATM：原子数目，一个正整数
- AMASS：$NATM$个原子质量；如果没有会用NOMASS表示。
- ZA：$NATM$个核电荷数目
- XYZ：$NATM$个原子的笛卡尔桌标，一共$3 \times NATM$个数字，
  - 单位是a.u.，可以使用XYZANG换成以Å为单位
- FFX：Hessian矩阵，一共有$3NATM \times 3NATM $个元素
  - 可以使用FFXLT换成下三角的形式
- APT：原子极化张量，一共$3 \times 3 \times NATM $个元素；如果没有APT数据，会用NOAPT表示
- DPR：极化率，$6 \times 3NATM $个数字
  - 使用DPRSQ，表现为$9 \times 3NATM $个数字
  - 如果没有DPR数据，会用NODPR表示
- GRD：笛卡尔梯度，一共$3 \times NATM$个数字；如果没有GRD数据，会用NOGRD表示

目前只支持Gaussian生成的*.fchk文件中的DPR数据和Raman强度。

