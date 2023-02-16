---
title: 【AMS】02.几何优化
typora-root-url: 【AMS】02.几何优化
date: 2019-09-23
updated:
description: 几何优化是在AMS块中指定
tags: [AMS, 几何优化]
mathjax: true
categories: [计算化学, 软件]
---





# `GeometryOptimization`

配置几何优化和过渡状态搜索的详细信息。

```
Task GeometryOptimization

GeometryOptimization
   Convergence
      Energy float
      Gradients float
      Step float
      StressEnergyPerAtom float
   End
   MaxIterations integer
   CalcPropertiesOnlyIfConverged Yes/No
   OptimizeLattice Yes/No
   KeepIntermediateResults Yes/No
   PretendConverged Yes/No
End
```

> 20版以前的为：
>
> ```
> GEOMETRY
> 	Converge {E=TolE} {Grad=TolG} {Rad=TolR} {Angle=TolA}
> 	Iterations Niter
> 	Inithess inithessian.file
> 	Hessupd HessUpdate
> 	Optim {Delocal / Cartesian / Internal} {All / Selected}
> 	GEigenvalueThreshold threshold
> 	Branch {New / Old}
> 	Step {Rad=MaxRadStep} {Angle=MaxAngleStep} {TrustRadius=MaxRadius}
> 	DIIS {N=NVect} {CYC=Ncyc}
> 	Externprogram externprog.exe coord=coords.inp energy=energy.out grad=grads.out
> End
> ```

## `Convergence`

收敛部分的设置：

- `Energy`：能量变化，默认是`1e-05`Hartree。
- `Gradients`：核梯度的阈值，默认是`0.001`Hartree/Angstrom
- `Step`：收敛几何允许的最大笛卡尔步长，默认是`0.01`Angstrom
- `StressEnergyPerAtom`：优化晶格向量时使用的阈值，默认是`0.0005`Hartree

收敛判定（如果最大梯度和均方根梯度比收敛准则小10倍，则忽略最后两条）

- 当前几何结构和上一个几何步骤的键能之间的差异小于`Energy`
- 最大笛卡尔核梯度小于`Gradients`
- 笛卡尔核梯度的均方根(RMS)小于2/3`Gradients`
- 最大笛卡尔步长小于`Step`
- 笛卡尔阶跃的均方根(RMS)小于2/3`Step`

优化过程会不断地计算不同的分子结构，直到找到最低能量的结构为止。收敛标准得到5个T表示五个收敛标准都达到。其中第二个标准最重要，一般也是最后一个达到的，第二个标准是势能面的梯度最大值。这个标准非常严格，对于大量过渡金属参与的化学反应，过渡态搜索，有可能达不到这样严格的标准，一般到0.003左右也可以认为收敛了，可以将对应的分子结构拿来使用。

> 2020版以前为总能量、梯度，笛卡尔步长，键角，默认为：
>
> ```
> GEOMETRY
> Converge 1e-3 1e-3 1e-2 0.5
> end
> ```

## 其他

- `MaxIterations`：允许收敛到所需结构的最大几何迭代次数。默认是max(30，$$2 \times N_{free}$$)，$$N_{free}$$是指自由度的数目，接近于3*原子数。
- `CalcPropertiesOnlyIfConverged`：默认为`Yes`，当几何优化（过渡态搜索）收敛时，才计算相应的性质，比如频率，声子等，若为`False`，不收敛也可以计算。
- `PretendConverged`：默认为`No`，当几何优化不收敛会报错。如果改成`True`，只会出现一个警告，并且表明几何优化是收敛的，在一些脚本编写中有用。

## 优化方法`Method`

- `Method`：默认为`auto`，根据系统大小和支持的优化选项自动选择合适的方法。选项有
  - `Quasi-Newton`
  - `SCMGO`
  - `FIRE`
  - `L-BFGS`
  - `ConjugateGradients`

- `CoordinateType`：默认是`auto`，自动为给定的方法选择最合适的方法。准牛顿法和SCMGO方法将使用`Delocalized`，所有其他方法将使用`Cartesian`。

- 使用拟牛顿法或 SCMGO 方法优化系统时<span id="初始Hessian">初始模型 Hessian </span>的选项`InitialHessian`：

  ```
  GeometryOptimization
     InitialHessian
        File string
        Type [Auto | UnitMatrix | Swart | FromFile | Calculate | CalculateWithFastEngine]
     End
  End
  ```

  - `File`：包含初始Hessian（或包含它的结果目录）的KF文件。这可用于加载先前使用[Properties％Hessian]关键字计算出的Hessian。

  - `Type`：默认为`auto`，让程序选择初始模型Hessian。
    - `UnitMatrix`：最简单的初始模型Hessian，只是优化坐标中的一个单位矩阵
    - `Swart`： model Hessian from M. Swart.
    - `FromFile`：从先前计算的结果加载Hessian。配合`File`使用
    - `Calculate`：计算初始的Hessian，计算比较昂贵，大多数建议用于TransitionStateSearch计算
    - `CalculateWithFastEngine`：使用更快的方法计算初始的Hessian

### `Quasi-Newton`

准牛顿几何优化：

```
GeometryOptimization
   Quasi-Newton
      MaxGDIISVectors integer
      Step
         TrustRadius float
         VaryTrustRadius Yes/No
      End
      UpdateTSVectorEveryStep Yes/No
   End
End
```

- `MaxGDIISVectors`：设置GDIIS向量的最大数量。默认为`0`，如果> 0将启用GDIIS方法。
- `Step%TrustRadius`：信任半径的初始值。
- `Step%VaryTrustRadius`：是否允许信任半径在优化过程中改变。默认情况下，在能量最小化期间为 True，在过渡状态搜索期间为 False。（2021才支持）
- `UpdateTSVectorEveryStep`：是否在每个步骤用当前特征向量更新TS反应坐标。默认为`Yes`。

准牛顿优化器使用Hessian计算几何优化步骤。Hessian通常在开始时近似，然后在优化过程中进行更新。因此，非常好的[初始Hessian](#初始Hessian)可以提高优化器的性能，并导致更快，更稳定的收敛。

### `FIRE`

```
GeometryOptimization
   FIRE
      AllowOverallRotation Yes/No
      AllowOverallTranslation Yes/No
      MapAtomsToUnitCell Yes/No
      NMin integer
      alphaStart float
      dtMax float
      dtStart float
      fAlpha float
      fDec float
      fInc float
      strainMass float
   End
End
```

### `SCMGO`

```
GeometryOptimization
   SCMGO
      ContractPrimitives Yes/No
      NumericalBMatrix Yes/No
      Step
         TrustRadius float
         VariableTrustRadius Yes/No
      End
      logSCMGO Yes/No
      testSCMGO Yes/No
   End
End
```

### `HessianFree`

有限内存BFGS方法

```
GeometryOptimization
   HessianFree
      Step
         MaxCartesianStep float
         MinRadius float
         TrialStep float
         TrustRadius float
      End
   End
End
```

# 重新开始几何优化

参见AMS的`LoadSystem`关键词，指定之前优化的ams.rkf文件作为File。可以使用相对路径。

# 几何不收敛

- 修改`CoordinateType`

- 修改优化方法：

  ```
  GeometryOptimization
      Method Quasi-Newton
      Quasi-Newton
        Step
           TrustRadius 0.02
        End
        UpdateTSVectorEveryStep True
      End
  End
  ```

- 提高`Engine ADF`中`NumericalQuality`的精度





# 限制性几何优化`Constraints`

## ADF19

- `RESTRAINT `：在约束条件下，为了满足约束条件，势能中加入了一个势能，这意味着约束条件不一定要完全满足。例如，我们可以从几何优化运行中的一个几何体开始，其中的约束不被满足。

- `Constraints`：在几何优化的每一步，受限坐标的值应该与预定的固定值完全匹配。

  - ATOM、COORD、DIST、ANGLE和DIHED约束不需要在几何优化开始时满足。ATOM和COORD约束只能在直角坐标优化中使用，而所有其他约束只能用于离域坐标。

    ```
    GEOMETRY
     OPTIM CARTESIAN
    END
    ```

### RESTRAINT 

```
RESTRAINT
  DIST Ia1 Ia2 Ra {[Aa] [Ba]}
  ANGLE Ib1 Ib2 Ib3 Rb {[Ab] [Bb]}
  DIHED Ic1 Ic2 Ic3 Ic4 Rc {[Ac] [Bc]}
  DD Id1 Id2 Id3 Id4 R0 [{Ad} {Bd}]
end
```

### Constraints

```
CONSTRAINTS
  ATOM Ia1 {Xa1 Ya1 Za1}
  COORD Ia1 Icoord {valcoord}
  DIST Ia1 Ia2 Ra
  ANGLE Ib1 Ib2 Ib3 Rb
  DIHED Ic1 Ic2 Ic3 Ic4 Rc
  SUMDIST Ic1 Ic2 Ic3 Ic4 Rc
  DIFDIST Ic1 Ic2 Ic3 Ic4 Rc
  BLOCK bname
end
```

- block用法：

  ```
  ATOMS
    1.C        -0.004115   -0.000021    0.000023 b=b1
    2.C         1.535711    0.000022    0.000008 b=b2
    3.H        -0.399693    1.027812   -0.000082 b=b1
    4.H        -0.399745   -0.513934    0.890139 b=b1
    5.H        -0.399612   -0.513952   -0.890156 b=b1
    6.H         1.931188    0.514066    0.890140 b=b2
    7.H         1.931432    0.513819   -0.890121 b=b2
    8.H         1.931281   -1.027824    0.000244 b=b2
  END
  
  CONSTRAINTS
    BLOCK b1
    BLOCK b2
  END
  ```

## AMS

- 在计算开始时，不需要满足约束条件。

```
Constraints
   Atom integer
   AtomList integer_list
   FixedRegion string
   Coordinate integer [x|y|z] float?
   Distance (integer){2} float
   All ... [Bonds|Triangles] ...
   Angle (integer){3} float
   Dihedral (integer){4} float
   SumDist (integer){4} float
   DifDist (integer){4} float
   BlockAtoms integer_list
   Block string
   FreezeStrain [xx] [xy] [xz] [yy] [yz] [zz]
   EqualStrain  [xx] [xy] [xz] [yy] [yz] [zz]
End
```

### 固定原子

- `Atom atomIdx`：用`System%Atoms`块中给出的索引`atomIdx`将原子固定在初始位置，如那样
- `AtomList [atomIdx1 .. atomIdxN]`：固定列表中所有原子的初始位置
- `FixedRegion regionName`：通过region的方法来指定固定原子块
- `Coordinate atomIdx [x|y|z] coordValue`：用原子序号固定原子使其具有`coordValue`的笛卡尔坐标，如果`coordValue`缺失，就固定为初始值。

### 内自由度

- `Distance atomIdx1 atomIdx2 distValue`：键长
- `Angle atomIdx1 atomIdx2 atomIdx3 angleValue`：键角
- `Dihedral atomIdx1 atomIdx2 atomIdx3 atomIdx4 dihedValue`：二面角
- `SumDist atomIdx1 atomIdx2 atomIdx3 atomIdx4 sumDistValue`：限制R(1,2)+R(3,4) 两个键长之和为固定值
- `DifDist atomIdx1 atomIdx2 atomIdx3 atomIdx4 difDistValue`：限制R(1,2)-R(3,4) 两个键长之差为固定值

### `All`

- `Distance`为特定原子对来设定约束，如果想固定某种键或者键角：

  ```
  All [bondOrder] bonds at1 at2 [to distance]
  All triangles at1 at2 at3
  ```

  - `bondOrder`可以是 `single`，`double`， `triple` 或者`aromatic`，如果省略了它，那么任何特定原子之间的键都会受到约束。
  - 原子名是区分大小写的，它们必须和它们在原子块中的位置一样，或者用星号`*`表示任何原子。
  - 如果忽略`distance`，则使用从初始几何结构开始的键长。

- eg：将所有碳-碳单键的距离限制在1.4埃，所有氢原子键的距离限制在初始距离

```
Constraints
   All single bonds C C to 1.4
   All bonds H *
End
```

### 区域约束

- `BlockAtoms [atomIdx1 ... atomIdxN]`：冻结这个原子块的所有内部自由度

- `Block regionName`：为Sy`stem% atoms`块中定义的区域中的所有原子创建一个块约束，如：

  ```
  System
     Atoms
        C  0.0  0.0  0.0    region=myblock
        C  0.0  0.0  1.0    region=myblock
        C  0.0  1.0  0.0
     End
  End
  Constraints
     Block myblock
  End
  ```

  
