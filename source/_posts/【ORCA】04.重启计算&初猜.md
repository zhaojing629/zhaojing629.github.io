---
title: 【ORCA】04.重启计算&初猜
typora-root-url: 【ORCA】04.重启计算&初猜
mathjax: true
date: 2020-09-04
updated:
tags: [ORCA, 初猜]
categories: [计算化学, 软件]
description: ORCA的SCF计算比较糟糕，因此通常最好使用初猜，能加快计算速度
---





# 初猜

`%scf`中有`Guess`、`MOInp`和`GuessMode`三个变量：

```c++
%scf 
    Guess HCore 
    MOInp "Name.gbw"
    GuessMode FMatrix 
    AutoStart true
end
```

## Guess

Guess可以用`HCore`、`Hueckel`、`PAtom`、`PModel` 【默认】、`MORead`：

- `HCore`：单电子矩阵
  - 非常简单但是几乎不用，因为产生的轨道太compact
- `MORead`：读取之前计算的轨道，与`moinp`一起使用

- `Hueckel`：扩展休克尔方法。
  - 执行最小基扩展的uckel计算和使用GuessMode两种方法之一将MOs从这个计算投影到实际的基组上进行。最小基是STO-3G，比较差，因此休克尔初猜可能不太好。
- `PAtom`：极化原子密度。
  - 原子密度的叠加是以一种很好的初步猜测，但是分子的实际形状没有被考虑进去，更难可靠地定义单个占据轨道的ROHF计算或合理的自旋密度的UHF计算。因此，ORCA在PAtom猜测时选择了不同的方法。在所有的电子在最小的原子SCF轨道进行Huckel计算，这些都是一次性确定的，并存储在程序中，这意味着原子周围的密度非常接近原子，一个中心上的所有轨道都是正交的，最初的电子分布已经反应了分子形状，对于ROHF的计算，有明确的单已占据轨道。
- `PModel` ：Model potential，或者直接用`!PModel`。
  - 它包括建立和对角化一个带有电子密度的Kohn-Sham矩阵，电子密度由球形中性原子密度的叠加构成，而这些密度是相对论和非相对论方法预先确定的。这一猜测对Hartree-Fock和DFT方法都有效，但对半经验模型无效。由于猜测的复杂性稍微耗时。对于元素周期表中的大多数原子来说，PModel 是可用的，因此PModel猜测通常是选择的方法(特别是对于含有重元素的分子)，除非有更精确的起始轨道可用。

## MOInp&AutoStart 重启SCF计算

每一圈SCF都会自动储存当前的轨道，覆盖前面的gbw文件（因此要注意初猜是否需要重命名以免被覆盖），因此可以通过当前gbw文件重启计算。只有HF和数值频率可以重启（不包括post HF、分子性质、光谱等）。

- `Autostart`默认是`true` ：从找是否存在存在的的同名.gbw文件，然后读取轨道和重启所需的所有其他信息，`Guess`也会被设置为`MORead`，并且该gbw文件会被重名为BaseName.ges，`Moinp`就会指向这个文件。如果不需要，则使用用`false`或者使用`!NoAutoStart`则关闭。

- 如果需要另外读取轨道，可以：

  ```c++
  ! moread
  % moinp "name.gbw"
  ```

  - 注意，另外读取的轨道名字不能和输入文件名字相同。否则该gbw会新计算的结果被覆盖。

  - 不同的gbw可以互相兼容，如果gbw文件比较旧，可以用以下方法来产生一个比较新版本的gbw：

    ```c++
    ! rescue moread noiter
    % moinp "name.gbw"
    ```

    - 当调用rescue关键字时，只从.gbw文件中读取轨道coeficients，从输入文件中读取其他所有内容。因此要确保旧gbw中的几何和基组和新的输入文件匹配。
    - 如果冗余成分从该基组上去除了，则`! moread noiter`一定不能用来从之前的计算中读取SCF轨道，因为这会导致错误的结果。如果不能一次性完成整个计算，可以尝试通过`! rescue moread`来重启。
    - 如果 在计算后ORCA在重叠矩阵中遗漏了非常低的特征值（默认为<1e-8），则在计算后重新启动SCF时， `Rescue`关键字也是必需的 。

- 在同一个ORCA版本中，几何图形和基组都没有存储在需要匹配当前的几何或基组的name.gbw中。程序只检查当前计算中发现的分子和name.gbw是相互一致的，然后执行一个可能的轨道投影。如果这两组基是相同的，程序默认只对输入轨道进行重新正交化和重整。但是可以通过在`% scf`块中指定`GuessMode`为`CMatrix`或`FMatrix`来改变。

- 如果使用了`SCFMode = Conventional`和`SCFMode = SemiDirect`需要重启时：

  - 该程序存储了大量的积分，这些积分在磁盘上计算可能很耗时。通常程序会在计算结束时删除这些积分。但是，如果要做一个紧密相关的计算需要相同的积分（比如几何结构，基组，threshold等都相同），使用之前生成的积分会更快，则需要设置：

    ```c++
    %scf
    	KeepInts true # Keep integrals on disk
    	ReadInts true # Read integrals from disk
    	IntName "MyInts" # 如果第二次与第一次计算的名称不同，则需要输入第一次程序积分文件的名称（不包含拓展名，去掉了输入文件的.inp）
    end
    ```

  - 如果重新使用积分用于`SCFMode = SemiDirect`，它禁止改变`%scf`中的`Tcost`和`Tsize`。程序不会检查这些，但是结果可能完全没有意义。一般来说，用旧的积分文件重新开始计算需要用户的意识和责任，如果使用得当，该特性可以节省大量时间。

### 改变初猜MO的轨道顺序或打破初猜的对称性

- 初猜可能会产生错误的占据，或者需要使用之前计算的轨道收敛到其他的电子态，则可以使用`ROTATE`重排MOs等。但是仅在通过`MOread`在先前收敛的解决方案中交换轨道时，此方法才适用（如果在开始时使用常规的默认猜测轨道交换了轨道，则不适用）。

```c++
%scf
    Rotate
        {MO1, MO2, Angle} 
        {MO1, MO2, Angle, Operator1, Operator2}
        {MO1, MO2}
    end
end
```

- MO1和MO2是两个轨道的序号。**注意ORCA的轨道序号是从0开始的。**
- Angle是旋转的角度。`90`度是翻转两个轨道，`45`是1:1混合两个轨道，180度导致相变。
- `Operator1` and `Operator2`是轨道设置。对于UHF来说，alpha是`0`，beta是`1`。但是RHF和ROHF只有一个轨道设置，即`0`

`Rotate`可以用来在过渡金属二聚体中产生对称性破缺的解。首先做一个高自旋的计算，然后找到相互对称和反对称组合的MOs对，让这些轨道作为初猜，然后对每一对用45的旋转。

## GuessMode 

其余的猜测(可能)需要将最初的猜测轨道投影到实际的基组上，有两种方法：

- `FMatrix` ：FMatrix projection
- `CMatrix` ：Corresponding orbital projection

结果一般很相似，某些情况`CMatrix`更好，`FMatrix`会更简单更快：

- FMatrix projection定义了一个有效的单电子算符，$$f=\sum_{i} \varepsilon_{i} a_{i}^{\dagger} a_{i}$$
  - 这个和是初猜轨道集中的所有轨道，$$a_{i}^{\dagger}$$是一个猜测MO_i的电子生成算符，$$a_{i}$$是相应的湮灭算符，$$ε_i$$是轨道能量。这个有效的单电子算符在实际基组中被对角化，特征向量是在目标基础上的初始猜测轨道。对于大多数波函数，这产生了一个相当合理的猜测。

- CMatrix更加复杂，它用了Corresponding orbital去分别拟合每个MO的子空间（占据、部分占据、alpha、beta占据）。拟合已占据轨道后，在已占据轨道的正交补中选择虚起始轨道。在某些情况下，特别是重新启动ROHF计算时，这可能是一个优势。

# 用Gaussian的输出转换为初猜文件gbw

- 先用高斯进行计算：
  - 确保Gaussian里用的基组和ORCA里精确一致。
    - Gaussian里用6-31G系列基组时，默认是用笛卡尔型d基函数，而ORCA总是用球谐型基函数，因此Gaussian计算时要写`5d`关键词
    
  - Gaussian计算时候加上`nosymm`关键词避免摆到标准朝向下
  
  - `int=NoBasisTransform`关键词避免去掉任何primitive GTF，即基组原始怎么定义的就怎么用。
  
    ```
    # 5d nosymm int=NoBasisTransform 
    ```
  
- 用formchk将chk转换为fch，载入Multiwfn后依次输入

```shell
100  //其它功能 Part 1
2   //导出文件
9   //导出mkl文件
y   //表明产生的mkl文件是给ORCA当初猜用，程序会做特殊处理
XXX.mkl
```

- 将mkl转换成gbw作为orca的初猜

  ```
  orca_2mkl xxx -gbw
  ```

- 如果传递给orca后，没有1圈就结束迭代，需要仔细对比二者的基函数是否有区别，高斯中可以使用`GFPrint`打印基函数，orca用`printbasis`打印基函数。

## 利用MOkit

- Gaussian计算完后，直接用mokit转换chk文件为gbw文件。

```
chk2gbw *chk 
```

- 还可以直接利用mokit转换算出来的chk文件为inp文件，基本完全一致

  ```
  %fchk *chk
  fch2mkl *fchk 	#会得到*_o.inp和*_o.mkl文件
  				#然后再用上诉转换得到的*.gbw文件进行计算
  				#如果直接修改*.gbw为*_o.gbw则不用在orca中写入% moinp "*.gbw"
  ```

  

```




inp文件关键词部分如下
! UKS PBE0 defgrid3 TightSCF noTRAH noRI SOSCF
%scf
 Thresh 1e-12
 Tcut 1e-14
 CNVDamp False
 CNVShift False
 DirectResetFreq 1
end


我后面会考虑把
 CNVDamp False
 CNVShift False
 DirectResetFreq 1
这三行作为fch2mkl的默认选项，产生inp文件时默认就写在里面
这三行是给一个比较普通的SCF初始（即程序默认初始轨道和密度矩阵）用的。若用户提供接近收敛的初始轨道，这三行的默认设置反倒是累赘，所以我全给它关了。
```

- 或者先转换chk文件为fchk文件，`fch2mkl`会得到自动生成的*_o.inp文件



检验稳定性

```
读取收敛的轨道，在%scf中加入以下5行
STABPerform true
STABRestartUHFifUnstable true
STABMaxIter 500
STABDTol 1e-5
STABRTol 1e-5
```



# 几何优化的重启

- 迭代圈数耗尽或者意外崩溃，最简单的办法是最后一组坐标并从那里开始新的计算
- 从底部搜“`CARTESIAN COORDINATES`”或者直接从 jobname.xyz中读取
- 几何优化不会自动读取gbw文件。因此如果需要读取old orbitals（几何优化中通常没有必要），可以用MOREAD 和 %moinp 指定。

# 频率的重启

- 解析频率不能重启
- 数值频率计算确保.hess文件存在，如果在集群上使用作业提交脚本，确保将.hess文件复制到执行计算的节点上的本地scratch目录中。

```c++
!
%freq 
restart truec
end
```

