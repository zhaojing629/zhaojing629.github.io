---
title: 【ORCA】02.几何坐标输入
typora-root-url: 【ORCA】02.几何坐标输入
mathjax: true
date: 2020-05-28
updated:
tags: [输入,内存]
categories: [计算化学,ORCA]
description: ORCA输入文件
---



- 可以是笛卡尔坐标（x，y，z）或内坐标（键，角度，二面角），也可以是xyz文件形式。
- 可用`%coords`标记的block来表示，也可用两个`*`来封装，包含体系的电荷、多重度和原子坐标。

# *下的三种坐标形式

```c++
* CType Charge Multiplicity
...
coordinate specifications
...
*
```

- `ctype`中可以是`xyz`，`int`或`internal`，`gzmt`

## 笛卡尔坐标形式

- 默认是Ångström为单位，如果需要用`Bohrs`，需要在关键词中或者`%coords`中指定 `Bohrs`，或者直接`! Bohrs`

- eg：

  ```c++
  * xyz 1 2
  C 0.0 0.0 0.0
  O 0.0 0.0 1.1105
  *
  ```

## 内坐标

```C++
*int charge multiplicity
Atom1 0 0 0		0.0 0.0 0.0
Atom2 1 0 0 	R1  0.0 0.0
Atom3 1 2 0 	R2  A1  0.0
Atom4 1 2 3 	R3  A2  D1
. . .
AtomN NA NB NC RN AN DN
(R = actual distance (Angström or Bohr)
(A = Angle in degrees)
(D = dihedral angle in degree)
*
```

- 角度单位是`degree`
- NA= atom for distance NA-NB
- NB= atom for angle- this atom-NA-NB
- NC= dihedral angle- this atom-NA-NB-NC
- **orca原子序数是从1开始计数的**
- eg：

  ```C++
  * int 0 1
  C 0 0 0 0.0000 0.000 0.00
  O 1 0 0 1.2500 0.000 0.00
  H 1 2 0 1.1075 122.016 0.00
  H 1 2 3 1.1075 122.016 180.00
  *
  ```

### 笛卡尔坐标和内坐标混合使用

- 对原子使用`0 0 0`来代表是笛卡尔坐标，但是由于内坐标的第一个原子也是`0 0 0`，因此第一个原子如果是笛卡尔坐标，需要使用`1 1 1`
- 内坐标和笛卡尔坐标可以以任意顺序，但是最好先用笛卡尔坐标固定前三个原子的位置，这样才有唯一的框架。

```
UKS B3LYP SV(P) TightSCF Opt SlowConv
%geom scan B 4 0 = 2.0, 1.0, 15 end end
* int 0 2
	# First atom - reference atoms 1,1,1 mean Cartesian coordinates
	C 1 1 1 -0.865590 1.240463 -2.026957
	# Next atoms - reference atoms 0,0,0 mean Cartesian coordinates
	H 0 0 0 -1.141534 2.296757 -1.931942
	H 0 0 0 -1.135059 0.703085 -2.943344
	H 0 0 0 -0.607842 0.670110 -1.127819
	# Actual internal coordinates
	H 1 2 3 1.999962 100.445 96.050
	O 5 1 2 0.984205 164.404 27.073
	H 6 5 1 0.972562 103.807 10.843
*
```



## Gaussian Z-matrix format

- eg：

  ```c++
  * gzmt 0 1
  C
  O 1 4.454280
  Si 2 1.612138 1 56.446186
  O 3 1.652560 2 114.631525 1 -73.696925
  C 4 1.367361 3 123.895399 2 -110.635060
  ...
  *
  ```

# 用block `%coords`表示

```c++
%coords
	CTyp xyz # the type of coordinates = xyz or internal
	Charge 0 # the total charge of the molecule
	Mult 2 # the multiplicity = 2S+1
	Units Angs # the unit of length = angs or bohrs
	# the subblock coords is for the actual coordinates
	# for CTyp=xyz
	coords
		Atom1 x1 y1 z1
		Atom2 x2 y2 z2
	end
	# for CTyp=internal
	coords
		Atom1 0 0 0 0.0 0.0 0.0
		Atom2 1 0 0 R1 0.0 0.0
		Atom3 1 2 0 R2 A1 0.0
		Atom4 1 2 3 R3 A2 D1
		. . .
		AtomN NA NB NC RN AN DN
	end
end
```

# 文件形式输入

- .xyz坐标为埃，文件中第一行是原子数量，第二行是描述行，接着是坐标

  ```
  *xyzfile charge multiplicity myCoordinateFile.xyz
  ```
  - file.xyz是XMol格式的xyz文件，坐标为Ångström，两行标题包含原子数和描述行：

    ```
    4 
    description line
    C        0.000000000      0.000000000      0.000000000
    O        2.362157486      0.000000000      0.000000000
    H       -1.109548835      1.774545300      0.000000000
    H       -1.109548835     -1.774545300      0.000000000
    ```

- .gzmt通常在Gabedit，molden or Jmol中使用

  ```
  * gzmtfile 1 2 mycoords.gzmt
  ```

- 注意，如果在同一个输入文件中指定了多个作业，那么新作业可以从以前的作业读取坐标。如果第四个参数没有提供文件名，则自动使用实际作业的名称。这样，优化和单点作业就可以非常方便地组合在一个简单的输入文件中。

  ```
  .. specification for the first job
  $new_job
  ! keywords
  * xyzfile 1 2
  ```

# 特殊指定

## Dummy atoms

- 使用“DA”作为符号并给适当的坐标。虚拟原子不是真正的原子，它们没有电子、原子核或基函数。它们通常用于定义约束。

```
*xyz 0 1
C        0.000000000      0.000000000      0.000000000
O        2.362157486      0.000000000      0.000000000
H       -1.109548835      1.774545300      0.000000000
DA        1.000000000      0.000000000      0.000000000 
*
```

## ghost atoms

- 在一个原子的元素符号后面加上"："使其成为ghost atoms，ghost atoms没有电子或原子核，但有指定的基函数。ghost atoms通常用于校正基集叠加误差(BSSE)。

```
*xyz 0 1
C        0.000000000      0.000000000      0.000000000
O        2.362157486      0.000000000      0.000000000
H       -1.109548835      1.774545300      0.000000000
H:       -1.109548835     -1.774545300      0.000000000  
*
```

## 点电荷

- 可以通过指定电荷和坐标以及使用符号`Q`添加。

  - 点电荷没有基函数，但有一个固定的电荷，可以是负的或正的，点电荷基本上与核电荷处理相同。
  - 注意，当添加点电荷作为`Q`原子时，点电荷之间的自相互作用**被计算并包含在最终能量中**。

  ```
  *xyz 0 1
  O        0.000000000     -0.005910000      0.000000000
  H        0.765973000      0.587955000      0.000000000
  H       -0.765973000      0.587955000      0.000000000
  Q    -0.834      1.374158484     -2.145897424      0.000000000  
  Q     0.417       2.328008170     -1.973964147      0.000000000 
  Q     0.417       0.980357969     -1.270385486      0.000000000 
  *
  ```

- 当存在许多点电荷时，例如在QM/MM计算中，从文件中读取点电荷通常更方便

  - 注意，当通过点电荷文件读取点电荷来添加点电荷时，**不会计算点电荷之间的自相互作用**。

  ```
  %pointcharges "pointcharges.pc"
  *xyz 0 1
  O        0.000000000     -0.005910000      0.000000000
  H        0.765973000      0.587955000      0.000000000
  H       -0.765973000      0.587955000      0.000000000
  *
  ```

  - pc文件格式：第一行是点电荷数目，后面是电荷和坐标（）Å

    ```
    3
    -0.834      1.374158484     -2.145897424      0.000000000
    0.417       2.328008170     -1.973964147      0.000000000
    0.417       0.980357969     -1.270385486      0.000000000
    ```

  - 如果需要将外部电荷的自相互作用加进去，可以用`! DoEQ`关键词或者在`%method`部分指定  

    ```
    % pointcharges "pointcharges.pc"
    %method
    	DoEQ true
    end
    ```

## Embedding potential

计算簇模型有时候需要Embedding potential来解释边界处被忽略的排斥项

- 因为Embedding ECP被当作一个点电荷，所以要给定电荷。
- 也需要指定坐标，可选择给定ECP
- 一般来说应该执行的是单点计算，如果需要几何优化，需要coreless ECP中心设置明确的笛卡尔约束

```
* ...
# atom> charge x y z optional ECP declaration
Zr> 4.0 0.0 0.0 0.0 NewECP "SDD" end
...
*
```

这样一个没有核心的ECP中心的声明是在坐标部分通过在元素符号后面附加一个括号`>`来实现的。注意，嵌入ECPs在ORCA中被视为点电荷。所以接下来要给出电荷。没有芯的ECP中心的坐标必须像往常一样指定，然后可能会有一个可选的ECP分配。一般来说，采用ECP嵌入程序的计算应该是单点计算。然而，如果需要执行几何优化，请确保为无芯ECP中心设置明确的笛卡尔约束。

## None-standard 非标准同位素

在后面加M= Z=

## Fragments

- 片段可以通过在元素符号后面的括号`(n)`中声明一个给定原子所属的片段号来方便地定义。片段的序号是从1开始的

- 例子：利用片段将分子分成金属和配体的片段，打印每个MOs中金属和配体的占据

```
%coords
	CTyp xyz
	Charge -2
	Mult 2 
	coords
		Cu(1) 0 0 0
		Cl(2) 2.25 0 0
		Cl(2) -2.25 0 0
		Cl(2) 0 2.25 0
		Cl(2) 0 -2.25 0
	end
end
```

- 或者通过`%geom`部分指定：
  - `%geom`部分必须写在坐标之后

```
*xyz -2 2
	Cu 0 0 0
	Cl 2.25 0 0
	Cl -2.25 0 0
	Cl 0 2.25 0
	Cl 0 -2.25 0
*
%geom
	Fragments
		1 f0g end # atom 0 for fragment 1
		2 f1:4g end # atoms 1 to 4 for fragment 2
	end
end
```

- 几何和碎片也可以通过外部文件指定，另外，如果没有指定，所有的原子都是fragment 1。

# 对称性和取向

- 需要将分子摆成某个取向计算，可以先在其他软件中摆好了再计算。但是几何优化中这个取向会发生变化（因为笛卡尔坐标到内坐标信息会丢失），因此最好是几何优化完后导出结构，摆成某个朝向再算单点。

- ORCA对分子对称性的利用有限，主要用于SCF/CASSCF中的轨道和状态分析，以及MRCI代码中的计算优势。使用`UseSym`关键字，可以让ORCA检测点群，对坐标进行对称化，改变原点，并产生适合于对称的轨道，用于SCF/CASSCF计算。目前只支持D2h和较低点群。

- 为了使自动点群检测工作，分子需要被正确地对称，也可以更改点组检测的`treshold`，但是阈值过高可能会出现问题

  ```
  ! Usesym
  %method SymThresh 5.0e-2 end
  ```

- 有时候希望得到基态，但是初猜比较糟糕，计算会收敛到激发态，此时可以用：

  - 当且仅当空轨道的能量低于已占据轨道时，每一个不可约表示中的占据数就会发生变化。

  ```
  %method SymRelax True
  end
  ```

例子：计算水分子阳离子

- 输入：

  ```
  !SVP UseSym
  
  * xyz 1 2
  O 0.000000 0.000000 0.068897
  H 0.000000 0.788011 -0.546765
  H 0.000000 -0.788011 -0.546765
  *
  ```

- 程序将识别出C<sub>2v</sub>：

  ```
  ------------------------------------------------------------------------------
                              SYMMETRY HANDLING SETUP
  ------------------------------------------------------------------------------
  
  ------------------
  SYMMETRY DETECTION
  ------------------
  Preparing Data                    ... done
  Detection Threshold:    SymThresh ... 1.0000e-04
  
  Point Group will now be determined:
  Moving molecule to center of mass ... done
  
  POINT GROUP                       ... C2v
  
  The coordinates will now be cleaned:
  Moving to standard coord frame    ... done
  (Changed main axis to z and one of the symmetry planes to xz plane)
  Structure cleanup requested       ... yes
  Selected point group              ... C2v
  Cleaning Tolerance      SymThresh ... 1.0000e-04
  
  Some missing point group data is constructed:
  Constructing symmetry operations  ... done
  Creating atom transfer table      ... done
  Creating asymmetric unit          ... done
  
  Cleaning coordinates              ... done
  
  -----------------------------------------------
  SYMMETRY-PERFECTED CARTESIAN COORDINATES (A.U.)
  -----------------------------------------------
     0 O     0.00000000   0.00000000   0.13019595 
     1 H     0.00000000   1.48912498  -1.03323662 
     2 H     0.00000000  -1.48912498  -1.03323662 
  
  ------------------
  SYMMETRY REDUCTION
  ------------------
  ORCA supports only abelian point groups.
  It is now checked, if the determined point group is supported:
  Point Group ( C2v   ) is          ... supported
  
  (Re)building abelian point group:
  Creating Character Table          ... done
  Making direct product table       ... done
  
  ----------------------
  ASYMMETRIC UNIT IN C2v
  ----------------------
    #  AT     MASS              COORDS (A.U.)             BAS
     0 O   15.9990   0.00000000   0.00000000   0.13019595   0
     1 H    1.0080   0.00000000   1.48912498  -1.03323662   0
  
  ----------------------
  SYMMETRY ADAPTED BASIS
  ----------------------
  The coefficients for the symmetry adapted linear combinations (SALCS)
  of basis functions will now be computed:
  Number of basis functions         ...    24
  Preparing memory                  ... done
  Constructing Gamma(red)           ... done
  Reducing Gamma(red)               ... done
  Constructing SALCs                ... done
  Checking SALC integrity           ... nothing suspicious
  Normalizing SALCs                 ... done
  
  Storing the symmetry object:
  Symmetry file                     ... /tmp/tmp.Hph6rKnPOv/test-sym-h2o+.sym.tmp
  Writing symmetry information      ... done
  ```

- SCF程序中的初猜将识别并冻结C2v点群的每个不可约表示中的占据数：

  ```
  The symmetry of the initial guess is 2-B1
  Irrep occupations for operator 0
      A1 -    3
      A2 -    0
      B1 -    1
      B2 -    1
  Irrep occupations for operator 1
      A1 -    3
      A2 -    0
      B1 -    0
      B2 -    1
  ```

- 计算收敛得到：

  ```
  Total Energy       :          -75.56349635 Eh           -2056.18727 eV
  ```

- 轨道：

  ```
  ----------------
  ORBITAL ENERGIES
  ----------------
                   SPIN UP ORBITALS
    NO   OCC          E(Eh)            E(eV)    Irrep
     0   1.0000     -21.127828      -574.9174    1-A1
     1   1.0000      -1.867577       -50.8194    2-A1
     2   1.0000      -1.192140       -32.4398    1-B2
     3   1.0000      -1.124658       -30.6035    1-B1
     4   1.0000      -1.085063       -29.5261    3-A1
     5   0.0000      -0.153303        -4.1716    4-A1
     6   0.0000      -0.071325        -1.9408    2-B2
  ...
                   SPIN DOWN ORBITALS
    NO   OCC          E(Eh)            E(eV)    Irrep
     0   1.0000     -21.081197      -573.6485    1-A1
     1   1.0000      -1.710192       -46.5367    2-A1
     2   1.0000      -1.152853       -31.3707    1-B2
     3   1.0000      -1.032555       -28.0972    3-A1
     4   0.0000      -0.306683        -8.3453    1-B1
     5   0.0000      -0.139418        -3.7937    4-A1
     6   0.0000      -0.062261        -1.6942    2-B2
     7   0.0000       0.374726        10.1968    3-B2
  ...
  ```

  







# 定义几何参数和扫描势能面

- 可以将坐标定义为参数或者一系列的值（此时会做势能面扫描）。在这种情况下，变量`RunTyp`被自动更改为`Scan`。格式如下：

  ```
  %coords
  	CTyp internal
  	Charge 0
  	Mult 1
  	pardef
      	rCH = 1.09; 
      	ACOH = 120.0; 
      	rCO = 1.35, 1.10, 26; # a C-O distance that will be scanned
  	end
  	coords
      	C 0 0 0 0 0 0
      	O 1 0 0 {rCO} 0 0
      	H 1 2 0 {rCH} {ACOH} 0
      	H 1 2 3 {rCH} {ACOH} 180
  	end
  end
  ```

  - 参数也可以在笛卡尔坐标中实现

  - 每个几何参数都可以通过封装函数大括号作为几何参数的函数来赋值，比如$$\{0.5×cos(Theta)×rML+R\}$$（注意orca的三角函数中是度数不是弧度）。几何参数的长度默认是Å，角度是°

  - 在上面的例子中，变量`rCO`被定义为一个“扫描参数”。它的值将在从1.3到1.1的26步中改变，并且在每个点上进行单点计算。在运行结束时，程序将汇总每个点的总能量。就可以绘制出势能表面。如果不想用均匀的点，而是用自定义的，则可以：这样可以在接近最大值或最小值多设一些点，其他地方少一些

    ```
    rCO [1.3 1.25 1.22 1.20 1.18 1.15 1.10]; # a C-O distance that will be scanned
    ```

  - 扫描参数最多可以有三个，可以构造三维势能面扫描

- orca中参数也可以参数的参数，比如：

  ```
  %coords
  	CTyp internal
  	Charge 0
  	Mult 1
  	pardef
      	rCOHalf= 0.6;
      	rCO = { 2.0*rCOHalf };
  	end
  	coords
      	C 0 0 0 0 0 0
      	O 1 0 0 {rCO} 0 0
      	O 1 0 0 {rCO} 180 0
  	end
  end
  ```

- orca的一些关于势能面扫描的设置：

  ```
  %method
  	SwitchToSOSCF true
  	ReducePrint true
  	ScanGuess MORead
  end
  ```

  - `SwitchToSOSCF true表示`在第一个点后，换成SOSCF，如果起始轨道正确，`SOSCF`可能比`DIIS`收敛得更好。默认是`false`
  - `ReducePrint true`表示减少第一个点后的输出，默认是`true`
  - 第一点后可以改变初猜方法，默认是`MOread`，一般来说前一个点是下一个点的初猜，但是有些情况，可以使用更一般的初猜
    - `OneElec` 单电子矩阵
    - `Hueckel` 
    - `PAtom`
    - `PModel`
    - `MORead`





