---
title: 【AMS】01.基本输入结构
typora-root-url: 【AMS】01.基本输入结构
date: 2021-05-11
updated:
description: AMS2020的主要结构
tags: 输入
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

# System

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
   Symmetry
   
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

## 几何结构的指定：

- `header`：单位默认都是 `Angstrom`，如果需要更改，可以在将`header`部分更改为`[Bohr]`
- **`Atoms`：指定原子类型和坐标**
  - 如果需要给坐标分区，可以在每个原子坐标最后面添加` region=name1`，` region=name2`……，一个原子可以在多个区域中，此时命名用`,`分隔` region=name1，name2`
  - 可以更改原子的质量成为同位素(in Dalton) ，在每个原子坐标最后面添加`mass=number`即可
- `Lattice`：指定最多三个晶格向量
- `GeometryFile`：从.xyz文件中读取几何，不需要再指定`atoms`和`lattice`块。
- `FractionalCoords`：原子块中的原子坐标是否以晶格向量的分数坐标给出，默认为`No`。

## 对称性的指定

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

# Task

- Task的可选参数有：

  ```
  Task [SinglePoint | GeometryOptimization | TransitionStateSearch | IRC | PESScan | NEB | VibrationalAnalysis | MolecularDynamics | GCMC]
  ```

# Engine

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

# Properties

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



