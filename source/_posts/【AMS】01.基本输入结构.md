---
title: 【AMS】01.基本输入结构
typora-root-url: 【AMS】01.基本输入结构
date: 2021-05-11
updated: 
description: ADF2020版本后的输入文件结构大改
tags: 输入
mathjax: true
categories: [计算化学, 软件]
---





# 主要结构

- `System`，`Task`和`Engine`是必须的，其他比如`Properties`是可选的

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

## System

- 单位默认都是 `Angstrom`，如果需要更改，可以在将`header`部分更改为`[Bohr]`

```
System header
   Atoms header
      ...
   End
   Lattice header
      ...
   End
   FractionalCoords Yes/No
   AllowCloseAtoms Yes/No
   GeometryFile string
   Symmetrize Yes/No
   LatticeStrain float_list
   SuperCell integer_list
   Charge float
   BondOrders
      ...
   End
   ...
End
```

- **`Atoms`：指定原子类型和坐标**
  - 如果需要给坐标分区，可以在每个原子坐标最后面添加` region=name1`，` region=name2`……，一个原子可以在多个区域中，此时命名用`,`分隔` region=name1，name2`
  - 可以更改原子的质量成为同位素(in Dalton) ，在每个原子坐标最后面添加`mass=number`即可
- `Lattice`：指定最多三个晶格向量
- `FractionalCoords`：原子块中的原子坐标是否以晶格向量的分数坐标给出，默认为`No`。
- `GeometryFile`：从.xyz文件中读取几何
- `Symmetrize`：是否使输入结构对称，这也会将结构旋转转换为标准方向。默认为`No`。
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

### 指定均匀电场或多极电荷

- 均匀电场

  ```
  System
     ElectrostaticEmbedding
        ElectricField ex ey ez
     End
  End
  ```

- 点电荷和多极电荷：

  ```
  System
     ElectrostaticEmbedding
        MultipolePotential
           ChargeModel Point
           Coordinates
              x y z   q   py pz px
              x y z   q   py pz px
              ...
           End
        End
     End
  End
  ```

  - `ChargeModel`：多极子可以由一个点（在其位置具有奇异势能）或球形高斯分布``Gaussian`来表示。默认是`Point`。
  - `ChargeWidth`：默认是`-1.0`a.u.。高斯电荷模型的宽度。
  - `Coordinates`：格式为`x y z q`或者`x y z q µx µy µz`。x、y、z 是以 Å 为单位的坐标，q 是电荷（以电荷的原子单位表示），μx、μy、μz 是（可选）偶极矩分量（以原子单位表示，即 e*Bohr）。



## Task

- Task的可选参数有：

  ```
  Task [SinglePoint | GeometryOptimization | TransitionStateSearch | IRC | PESScan | NEB | VibrationalAnalysis | MolecularDynamics | GCMC]
  ```

## Properties

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



