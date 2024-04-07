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



# Engine ADF

## 基组

```
Basis
   Type [...]
   Core [None | Small | Large]
   CreateOutput Yes/No
   Path string
   PerAtomType
      Core [None | Small | Large]
      File stringS
      Symbol string
      Type [...]
   End
   PerRegion
      Core [None | Small | Large]
      Region string
      Type [...]
   End
   FitType [...]
End
```

- `Type`：默认`DZ`，还有一系列：[SZ, DZ, DZP, TZP, TZ2P, QZ4P, TZ2P-J, QZ4P-J, AUG/ASZ, AUG/ADZ, AUG/ADZP, AUG/ATZP, AUG/ATZ2P, ET/ET-pVQZ, ET/ET-QZ3P, ET/ET-QZ3P-1DIFFUSE, ET/ET-QZ3P-2DIFFUSE, ET/ET-QZ3P-3DIFFUSE, POLTDDFT/DZ, POLTDDFT/DZP, POLTDDFT/TZP, POLTDDFT/TZ2P]
- `Core`：默认`Large`，还可以选择`None`, `Small`, `Large`
- `CreateOutput`：默认为`No`。如果为`true`，原子创建运行的输出将打印到标准输出。如果为`false`，它将被保存到CreateAtoms.out文件中。
- `Path`：默认为`$AMSRESOURCES/ADF`，ADF只在该文件夹中寻找合适的基组
- `PerAtomType`：为一类原子指定基组
  - `File`：指定基组的位置，可以是相对于`$AMSRESOURCES/ADF`的相对位置，也可以是绝对位置
  - `Symbol`：定义基组的符号

- `PerRegion`：为一个区域的原子指定基组
  - `Region`：指定基组的区域，可以用逻辑运算符，比如`R1+R2`

## 泛函

```
XC
  {LDA LDA {Stoll}}
  {GGA GGA}
  {MetaGGA metagga}
  {Model MODELPOT [IP]}
  {HartreeFock}
  {OEP fitmethod {approximation}}
  {HYBRID hybrid {HF=HFpart}}
  {MetaHYBRID metahybrid}
  {DOUBLEHYBRID doublehybrid}
  {RPA}
  {XCFUN}
  {RANGESEP {GAMMA=X} {ALPHA=a} {BETA=b}}
  (LibXC functional}
  {DISPERSION [s6scaling] [RSCALE=r0scaling] [Grimme3] [BJDAMP] [PAR1=par1]  [PAR2=par2]  [PAR3=par3]  [PAR4=par4] }
  {Dispersion Grimme4 {s6=...} {s8=...} {a1=...} {a2=...}}
  {DISPERSION dDsC}
  {DISPERSION UFF}
end
```

## 相对论

2020版本开始默认使用标量相对论效应：

```
Relativity
   Formalism [Pauli | ZORA | X2C | RA-X2C]
   Level [None | Scalar | Spin-Orbit]
   Potential [MAPA | SAPA]
   SpinOrbitMagnetization [NonCollinear | Collinear | CollinearX | CollinearY | CollinearZ]
End
```

- `Formalism`：如果`level`里是`None`，则不需要考虑所选择的形式。
  - `Pauli`：泡利哈密顿函数
  - `ZORA`：零阶正则近似哈密顿量。默认。
  - ` X2C `：四分量狄拉克方程到二分量狄拉克方程的精确变换，是Dyall修正的Dirac方程。
  - `RA-X2C`：四分量狄拉克方程到二分量狄拉克方程的精确变换，是修正狄拉克方程的正规方法。
- `Level`：
  - `None`：非相对论。哈密顿量也就是Kohn-Sham方程的形式。
  - `Scalar`：标量相对论，成本较低。默认。
  - `Spin-Orbit`：旋轨耦合，最好的理论水平，比普通计算昂贵（4-8倍）
- `Potential`：
  - `MAPA`：默认。the Minumium of neutral Atomical potential Approximation 中性原子势近似值的最小值。MAPA优于SAPA的优点是可以降低ZORA的规格依赖性。 除了电子密度非常接近重核外，几乎所有特性的ZORA规范依赖性都很小。 非常接近重核的电子密度可用于解释Mossbauer光谱中的异构体位移。
  - `SAPA`：the Sum of neutral Atomical potential Approximation 中性原子势近似值之和。
- `SpinOrbitMagnetization`：只与自旋轨道耦合相关，而且在`unrestricted`下使用。在不受限制的计算中，大多数XC泛函都有自旋极化作为一种成分。通常，自旋量子化轴的方向是任意的，可以方便地选择为z轴。然而，在自旋轨道计算中，方向很重要，将磁化矢量的z分量放入XC函数中是任意的。
  - `NonCollinear`：可以将磁化矢量的大小插入XC函数中。 这称为非共线方法。
  -  `CollinearX`，`CollinearY`，`CollinearZ`：使用x，y或z分量作为XC函数的自旋极化。默认为z。
  - ：`Collinear`：同`CollinearZ`



> 2019版及之前的输入格式为：
>
> ```
> RELATIVISTIC {level} {formalism} {potential}
> ```
>
> - > Scalar级别为：`RELATIVISTIC Scalar ZORA`
>
> - SpinOrbit级别为：`RELATIVISTIC spinorbit ZORA`
>
>   - 注意此时：unrestricted不再适用，解决办法删掉unrestricted或加上collinear/nocollinear，以及nosym关键词
>   - 并且不能同时计算解析freq
