---
title: 【AMS】01.基本输入结构
typora-root-url: 【AMS】01.基本输入结构
date: 2021-05-11
updated:
description: AMS2020的主要结构
tags: [输入, 对称性]
mathjax: true
categories: [计算化学, AMS]
---



- `System`，`Task`和`Engine`是必须的，其他的块比如`Properties`等是可选的

```
$AMSBIN/ams -n 8 << eor 1>${0/run/out} 2>${0/run/err}

System
	Atoms
		F         0.000000    0.000000    0.760010
		F         0.000000    0.000000   -0.760010
End
charge 0 
End

Task GeometryOptimization

Engine ADF
	TITLE UueFn
	basis
		type TZ2P
		core None
		CreateOutput Yes
	end
	xc
		gga PBE 
	end
	relativity
		level spin-orbit
		formalism ZORA
	end
EndEngine
```

# `System`

```
System header
   Atoms header
      ...
   End
   Lattice header
      ...
   End
   GeometryFile string   
   FractionalCoords Yes/No
   
   Symmetrize Yes/No
   Symmetry [...]
   
   LatticeStrain float_list
   SuperCell integer_list
   AllowCloseAtoms Yes/No
   
   Charge float
   
   BondOrders
      ...
   End
   ...
End
```

## 几何结构的指定

- `header`：单位默认都是 `Angstrom`，如果需要更改，可以在将`header`部分更改为`[Bohr]`
- **`Atoms`：指定原子类型和坐标**
  - 如果需要给坐标**分区**，可以在每个原子坐标最后面添加` region=name1`，` region=name2`……，一个原子可以在多个区域中，此时命名用`,`分隔` region=name1，name2`
  - 可以更改原子的质量成为同位素(以Dalton为单位) ，在每个原子坐标最后面添加`mass=数字`即可
- `Lattice`：指定最多三个晶格向量
- `GeometryFile`：从.xyz文件中读取几何，不需要再指定`atoms`和`lattice`块。
- `FractionalCoords`：原子块中的原子坐标是否以晶格向量的分数坐标给出，默认为`No`。
- **`Charge`**：默认为`0.0`，**系统总电荷**（仅适用于非周期系统）。
- `BondOrders`：定义键级，目前仅由`ForceField`引擎使用。

## 对称性的指定

对称性也可以在[AMS中的块](#`Symmetry`)和ADF中的块指定，`System`中：

- `Symmetrize`：是否使输入结构对称，这也会将结构旋转转换为标准方向。默认为`No`。
- `Symmetry`：默认为`auto`，可以通过`nosym`、`C(LIN)`……等来指定对称性

## 其他

- **`Charge`：指定非周期体系的电荷，默认为`0.0`**
- `BondOrders`：指定原子和原子之间的键级，一般不需要。

除了通过`System`指定系统，还可以用`Load System`读取`.rkf`文件中的之前的系统：

```
LoadSystem header
   File string
   Section string
End
```

- `Section`：默认是`Molecule`

# `LoadSystem`

除了`System`在输入块中指定要模拟的系统之外，还可以从`.rkf`AMS的二进制结果文件中读取先前计算中使用的系统。`LoadSystem`块与`System`块是互斥的，系统要么需要在输入中指定，要么从先前的结果文件中加载。

```
LoadSystem header
   File string
   Section string
End
```

- `File`：从中加载系统的 KF 文件的路径。它也可能是包含它的结果目录。
- `Section`：KF 文件中用于加载系统的部分。默认为`Molecule`

# `Task`

- Task的可选参数有：

  ```
  Task [SinglePoint | GeometryOptimization | TransitionStateSearch | IRC | PESScan | NEB | VibrationalAnalysis | MolecularDynamics | GCMC]
  ```

# `Engine`

```
Engine header
...
EndEngine
```

- 在`header`中可以指定的有：
  - `ADF`
  - `BAND`
  - `DFTB`
  - `ReaxFF`
  - `MLPotential`
  - `ForceField`
  - `Hybrid`
  - `MOPAC`
  - `External`
  - `LennardJones`

# `Properties`

```
Properties
   BondOrders Yes/No
   Charges Yes/No
   DipoleGradients Yes/No
   DipoleMoment Yes/No
   ElasticTensor Yes/No
   Gradients Yes/No
   Hessian Yes/No
   Molecules Yes/No
   NormalModes Yes/No
   Other Yes/No
   PESPointCharacter Yes/No
   Phonons Yes/No
   Polarizability Yes/No
   Raman Yes/No
   SelectedRegionForHessian string
   StressTensor Yes/No
   VCD Yes/No
   VROA Yes/No
End
```

# `Symmetry`

指定关于对称检测和使用的细节。

```
Symmetry
   SymmetrizeTolerance float
   Tolerance float
End
```

- `SymmetrizeTolerance`：默认为`0.05`，在要求对称化的情况下，用于检测对称性的容差。
- `Tolerance`：默认为`1e-07`，用于检测系统对称性的容差。

另外，`UseSymmetry`可以指定是否在 AMS 中使用系统的对称性。对称性会在上述`Symmetry` 块中给出的容差内被识别。

```
UseSymmetry Yes/No
```

为了让 AMS 识别分子的（亚）对称性，分子必须在空间中具有特定的取向：

- 原点是对称群的一个不动点
- z轴是主旋转轴
- xy平面是 σ<sub>h</sub>面（轴群，C(s)）
- x轴是C<sub>2</sub>轴（D对称）
- xz平面是一个 σ<sub>v</sub>平面（C<sub>nv</sub> 对称性）
- 在T<sub>d</sub> 和O<sub>h</sub> 中，z轴是四重轴（分别为S<sub>4</sub>和C 4）并且（111）方向是三重轴。

## 检测对称性失败

- 通过软件对称后再导入坐标计算
- 让坐标更对称一些，可以降低程序检测的难度。比如将一个原子移动到原点，主轴设置为z轴等：
  - ADFinput > 选中原子 > Edit > Set Origin
  - ADFinput > 选定两个原子确定方向 > Edit > Align > With Z-Axes
