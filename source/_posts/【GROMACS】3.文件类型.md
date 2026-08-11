---
title: 【GROMACS】3.文件类型
typora-root-url: 【GROMACS】3.文件类型
mathjax: true
date: 2026-08-11 10:14:28
updated:
tags: [GROMACS, 文件]
categories: [计算化学, 软件]
description: Gromacs的文件介绍
---



# 文件总览

- <u>下划线为二进制数据</u>
- **加粗为mdrun计算产生的文件**

## 参数文件

- `.mdp`：运行参数，用于 GMX、Grompp 和 GMX Convert 工具的处理

## 结构文件

当执行 `gmx pdb2gmx` 来生成分子结构时，该程序会将结构文件（`.pdb`文件）转换为 GROMOS 结构文件（`.gro`文件）。`.pdb`文件和 gromos 文件的主要区别在于它们的格式，而且`.gro`文件还可以包含速度信息。

- [`.gro`](#gro文件)： GROMOS格式的结构文件
- [`.pdb`](#PDB文件)：蛋白质结构格式

## 拓扑文件

- `.top`：主拓扑文件
  - 由 `gmx pdb2gmx` 程序生成的。`gmx pdb2gmx` 能够将任何肽或蛋白质的 pdb 结构文件转换为分子拓扑文件。该拓扑文件包含了你所研究的肽或蛋白质中所有相互作用的详细信息。
- `.itp`：被引用的拓扑文件

## 运行输入文件 

- <u>`.tpr`：系统拓扑结构、参数、坐标以及速度（二进制表示，可移植）</u>
  - 由`grompp`汇总结构+拓扑+参数生成
  - `mdrun`的输入文件

## 轨迹文件

- **<u>`.trr`：全精度轨迹文件，含模拟时间和原子坐标。 并可以包含原子速度、受力信息</u>**
  - **x（坐标）、v（速度） 和 f（受力）（二进制数，全精度，可移植）**
- **<u>`.xtc`：压缩的轨迹文件。体积比`.trr`小，记录精可调，且可以只记录指定的group</u>**
  - **仅 x 类型（压缩格式，可移植，任意精度）**

## 能量文件 

- **<u>`.edr`：能量文仵，记录了模拟过程中的各种信息（能量、体积、压力、温度等）**</u>

## 其他文件

- **`.log`：日志文件**
- **<u>`.cpt`：可移植的 checkpoint 文件。用于续算，延长计算</u>**
- `.ndx`：索引文件，设定各个组里包含哪些原子
- `.xvg`：被grace程序读取来对其中的数据绘图



# 一般流程

## 例子

```
gmx grompp-f md1.mdp -o md1.tpr -c eq2.gro -t eq2.cpt -p memwat.top -maxwarn 10
```

## 流程图

![这是模拟蛋白质在水中的行为的典型 GROMACS 分子动力学运行的流程图。过程中可能需要多次进行能量最小化操作，这些步骤包括以下几个循环：gmx grompp -> gmx mdrun。](/image-20260811102611572.png)

1. 前处理：
   - 建立体系结构文件(`.gro`)和生成拓扑文件 ( `.top`) 主要涉及的命令: `editconf`、 `solvate` 、 `insert-molecules`、 `genion` 、 `pdb2gmx` 、 `x2top` 。另涉及make_ndx 、 `genrestr`等
   - 对于蛋白质：
     1. 首先可以使用 `gmx editconf` 程序来定义围绕分子的一个适当大小的盒子。
     2. `gmx solvate` 可以将溶质分子（即肽分子）溶解在任何溶剂中。`gmx solvate` 的输出结果是一个包含在水中溶解后的肽分子的结构文件。此外，`gmx solvate` 还会修改由 `gmx pdb2gmx` 生成的分子结构文件，以在结构中添加溶剂信息。
2. 计算：
   1. 手写模拟参数文件`.mdp`
   2. `grompp`：`.mdp`、`.gro`、 `.top`一起产生`mdrun`的运行文件`.tpr`
   3. `mdrun`：运行`.tpr`开始能量极小化、动力学等计算，期间可以监控`.log`输出信息。
3. 后处理：
   - 对`mdrun`产生的轨迹文件（`.trr`或`.xtc`)、结构文件（`.gro`)及能量文件(`.edr`)通过各种命令进行分析处理和提取有用的信息，或对轨迹进行合并/分割/转换等操作。
   - 涉及的命令:`energy`、`trjconv`、`trjcat`、`analyze`、`spatial`、`cluster`、`clustersize`、`traj`、`mindist`、`rdf`、`gyrate`,`msd`、`order`、`hbond`、`angle`、`density`、`densmap`、`distance`、`pairdist`、`velacc`、`chi`、`do_dssp`、`rama`、`sasa`、`anaeig`、`order`、`rms`、`rmsf`、`dipole`、`helix`、`freevolume`、`h2order`、`mdmat`等等数十种



# 结构文件

## PDB文件

```
HEADER    EXTRACELLULAR MATRIX                    22-JAN-98   1A3I
TITLE     X-RAY CRYSTALLOGRAPHIC DETERMINATION OF A COLLAGEN-LIKE
TITLE    2 PEPTIDE WITH THE REPEATING SEQUENCE (PRO-PRO-GLY)
...
EXPDTA    X-RAY DIFFRACTION
AUTHOR    R.Z.KRAMER,L.VITAGLIANO,J.BELLA,R.BERISIO,L.MAZZARELLA,
AUTHOR   2 B.BRODSKY,A.ZAGARI,H.M.BERMAN
...
REMARK 350 BIOMOLECULE: 1
REMARK 350 APPLY THE FOLLOWING TO CHAINS: A, B, C
REMARK 350   BIOMT1   1  1.000000  0.000000  0.000000        0.00000
REMARK 350   BIOMT2   1  0.000000  1.000000  0.000000        0.00000
...
SEQRES   1 A    9  PRO PRO GLY PRO PRO GLY PRO PRO GLY
SEQRES   1 B    6  PRO PRO GLY PRO PRO GLY
SEQRES   1 C    6  PRO PRO GLY PRO PRO GLY
...
ATOM      1  N   PRO A   1       8.316  21.206  21.530  1.00 17.44           N
ATOM      2  CA  PRO A   1       7.608  20.729  20.336  1.00 17.44           C
ATOM      3  C   PRO A   1       8.487  20.707  19.092  1.00 17.44           C
ATOM      4  O   PRO A   1       9.466  21.457  19.005  1.00 17.44           O
ATOM      5  CB  PRO A   1       6.460  21.723  20.211  1.00 22.26           C
...
HETATM  130  C   ACY   401       3.682  22.541  11.236  1.00 21.19           C
HETATM  131  O   ACY   401       2.807  23.097  10.553  1.00 21.19           O
HETATM  132  OXT ACY   401       4.306  23.101  12.291  1.00 21.19           O
...
```

- 第一列：
  - `ATOM`：描述构成蛋白质的各个原子的坐标。
  - `TER` ：记录标识了多肽链的结束
  - `HETATM`：描述杂原子的坐标，即那些不属于蛋白质分子的原子。
- 第二列：原子序号
- 第三列：原子名
- 第四列：残基名
- 第五列：链名
- 第六列：残基号
- 第5-7列：原子xyz坐标（埃）
- 第七列：占有率，代表这个原子在当前三维坐标位置的出现概率。1.00 意味着 100%，即在所有被解析的分子颗粒中，这个原子完全存在于这个位置。
- 第八列：温度因子。反映了该原子在空间中的“动态柔性”或“位置不确定度”。数值越大，代表这个原子晃动得越厉害，或者在实验图谱中越模糊。
- 第九列：元素

## gro文件

不需要记录速度时，gro文件可等价地用pdb格式代替。

```
MD of 2 waters, t= 0.0
    6
    1WATER  OW1    1   0.126   1.624   1.679  0.1227 -0.0580  0.0434
    1WATER  HW2    2   0.190   1.661   1.747  0.8085  0.3191 -0.7791
    1WATER  HW3    3   0.177   1.568   1.613 -0.9045 -2.6469  1.3180
    2WATER  OW1    4   1.275   0.053   0.622  0.2519  0.3140 -0.1734
    2WATER  HW2    5   1.337   0.002   0.680 -1.0641 -1.1349  0.0257
    2WATER  HW3    6   1.326   0.120   0.568  1.9427 -0.8216 -0.0244
   1.82060   1.82060   1.82060
```

- 标题：标题字符串（自由格式的字符串，可选，在“ t= ”之后加上时间格式）

- 原子数量（以自由格式的整数表示）

- 每个原子对应一行字符

  - 残基编号和名称
  - 原子名称
  - 原子编号
  - 原子坐标（单位是nm）
  - 原子速度（单位是nm/ps=km/s，不是必须有）
  - 原子部分以固定格式记录：`(i5,2a5,i5,3f8.3,3f8.4)`
    - `i`是整数，`a`是字符串，`f`是小数
    - **`i5`**：占**5列**的**整数**。→ 对应**残基编号**（如 `30`）。
    - **`2a5`**：连续两个**占5列的字符串**。→ 第一个对应**残基名称**（如 `GLU`），第二个对应**原子名称**（如 `CA`）。
    - **`i5`**：占**5列**的**整数**。→ 对应**原子编号**（如 `2`）。
    - **`3f8.3`**：连续三个**占8列**的**浮点数**，小数点后保留**3位**。→ 对应**X、Y、Z坐标**（单位nm）。例如 `106.568`。
    - **`3f8.4`**：连续三个**占8列**的**浮点数**，小数点后保留**4位**。→ 对应**速度VX、VY、VZ**（单位nm/ps），如果没有速度这3个格子可以空着。

- 盒子三个方向的尺寸（nm）

  - 实际是：`v1(x) v2(y) v3(z) v1(y) v1(z) v2(x) v2(z) v3(x) v3(y)`
    - `v3(y)`代表第 3个盒子矢量的y分量。
  - 最后六个数值可以省略（默认值为零），即记录正交盒子时后6个可省。
  - GROMACS 仅支持满足 `v1(y)=v1(z)=v2(z)=0` 的盒式向量。即盒子第一个矢量必须平行于X方向，第二个矢量必须在XY平面上。盒子以(0,0,0)为原点开始，往正方向定义盒子矢量以及原子坐标，所以不会有负原子坐标。若出现负原子坐标，原子会被认为是在负方向的镜像盒子里，做模拟时会根据周期性自动平移成正值。
  - 盒子信息部分是自由格式的。

  

# 拓扑文件

其他：

- [GROMACS中文手册：第五章　拓扑文件|Jerkwin](https://jerkwin.github.io/GMX/GMXman-5/#571-拓扑文件)

- 拓扑文件包含体系中原子类型、原子电荷、成键和非键项及参数、各种分子数目等信息。`.top`和`.itp`都叫拓扑(topology)文件

    - top：作为体系的主拓扑文件，是grompp的输入文件之一

    - itp：included topology，`.top`通过`#include`方式引用，储存力场参数和定义分子信息。itp文件不是必须的，也可以直接把itp文件里的内容直接写到top的合适位置里

    - **拓扑文件里可以开头用`;`进行注释。每个字段用`[]`标识。**

    - 拓扑文件里`#`开头的叫做预处理指令(preprocessor directive)。grompp先根据预处理指令对拓扑文件内容进行事先处理后，再对拓扑文件的内容进行处理。

    - 例子

        ```
        #include "gromos54a7.ff/forcefield.itp"				54A7力场的主文件
        #include "gromos54a7.ff/spce.itp"					SPC/E水模型的定义
        #include "gromos54a7.ff/ions.itp"					54A7力场对离子的定义
        #include "itp/a_A.itp"								分别定义两种分子信息的itp文件		
        #include "itp/a_B.itp"
        
        [ system ]
        Protein in water		体系名称，随意取
        [ molecules ]
        Protein_A	1
        Protein_B	1
        SOL			4199		体系里分子的出现顺序和数目
        NA			12			GROMACS里自带的力场中的各种水模型的名字都统叫SOL，离子的名字都统一是大写，如NA、CL、MG
        ```

    - 所有被include的文件(以及被include文件所include的文件)在grompp做预处理时会被完整展开，grompp实际处理的是所有被include的文件展开之后的内容。因此不要管include了什么文件，而只需要关心最终全展开之后都有什么内容。


- `[ defaults ]`：全局非键设置

  - `nbfunc` = 1：采用 Lennard-Jones 型非键势函数。
  - `comb-rule` = 1：异种原子的 LJ 参数按组合规则生成。 
  - `gen-pairs` = yes：自动生成 1–4 pair 相互作用。 
  - `fudgeLJ` / `fudgeQQ` = 1：1–4 LJ 与静电相互作用不缩放。

- `[ atomtypes ]`：  原子类型参数

  ```
  [ atomtypes ]
  ; 	type	mass	charge	ptype	sigma(nm)	epsilon(kJ/mol)
  	0W	15.99940	0.0000	A		3.16655E-01	8.903586E-01
  	HW	 1.00800	0.0000	A 		0.00000E+00	0.00000E+00
  ```

  - type：原子类型名,后续 `[ atoms ]` 会引用。
  - mass / charge:类型层面的默认质量和电荷
  - ptype = A：普通原子类型。
  -  sigma、epsilon：LJ 参数；OW 有 LJ，HW 设置为 0。
    - OW 表示水氧，承担主要范德华相互作用。sigma = 0.316655 nm，epsilon = 0.8903586 kJ/mol  是水氧 LJ 参数。
    - HW 表示水氢,通常不设置 LJ,只参与静电与约束几何。

- `[ nonbond_params ]`  特定非键相互作用。用于覆盖或指定某些原子类型对之间的非键参数。

  ```
  [ nonbond_params ] 
  ; i j func C A 
  OW OW 1 0.5 0.5 
  OW HW 1 0.0 0.0 
  HW HW 1 0.0 0.0
  ```

  -  i、j：相互作用的两个原子类型；
  - func = 1 表示 LJ 形式。 
  - C、A:该文件写法下的势函数参数；OW–HW 与 HW–HW 为 0
  - `[ nonbond_params ]` 会改变特定 pair 的非键相互作用,  需与力场格式保持一致。 水模型拓扑应与主力场文件和 mdp 设置配套使用。 修改该段参数会直接影响水–水及水–其他物质的相互作用。

- `[ moleculetype ]` ：分子与排除规则。表示开始定义一个新的分子类型，置于文件开头，下面紧接着定义分子名和`nrexcl`（nrexcl=*n*表示不计算≤*n*个键相连的原子间非键作用，一般为3)。

  - 例子：

    ```
    [ moleculetype ]
    ; name  nrexcl
    Urea         3			忽略 1-2 、 1-3 、 1-4 间的非键作用
    ```

  - 第1列name：定义一个名为 SPCE 的分子类型。 

  - 第2列nrexcl：同一分子内相隔不超过 3 个键的非键相互作用将被排除。 对小分子水而言，这是避免分子内部非键相互作用重复计入的重要设置。

  - 虽然可以将多个不相互成键的分子定义在一个`[ moleculetype ]` 里，但最好还是把每个分子作为单独的一个`[ moleculetype ]` 来定义，这样易于管理

  - 对于一批相同的分子，一起作为一个`[ moleculetype ]` 来定义对计算资源的消耗量明显高于共用同一个`[ moleculetype ]` 

    ```
    两种定义方式：
    
    500个A分子放一起：
        .itp中：
            [ moleculetype ]
            all_A
            [ atoms ]
            A分子1的各原子
            A分子2的各原子
            ...
            A分子500的各原子
            [bonds,angles等项]
            ...
    	.top中:
            [ molecules ]
            all_A 1
    
    500个A分子单独：
    	.itp中：
    		[ moleculetype ]
    		all_A
    		[ atoms ]
    		A分子
    		[bonds,angles等项]
    		A分子参数
    	.top中:
    		[ molecules ]
    		A 500
    
    ```

    - `moleculetype`中的不同函数类型：[File formats - GROMACS 2026.3 documentation](https://manual.gromacs.org/current/reference-manual/topologies/topology-file-formats.html#id38)

- `[ atoms ]` ： 定义分子中各个原子的名字、原子类型、所属残基、原子电荷、原子质量、所属电荷组

  ```
  [ atoms ]
  ;   nr    type   resnr  residu    atom    cgnr  charge
       1       C       1    UREA      C1       1   0.683
       2       O       1    UREA      O2       1  -0.683
       3      NT       1    UREA      N3       2  -0.622
       4       H       1    UREA      H4       2   0.346
       5       H       1    UREA      H5       2   0.276
       6      NT       1    UREA      N6       3  -0.622
       7       H       1    UREA      H7       3   0.346
       8       H       1    UREA      H8       3   0.276
  ```

  - 第1列nr：原子序号
  - 第2列type：引用 `[ atomtypes ]` 中的原子类型。
  - 第3-4列resnr/ residu：残基编号与残基名。
  - 第5列atom：原子名
  - 第6列cgnr：电荷组编号。
  - 第7列charge：原子电荷
  - 第8列mass：原子质量
    - 质量用于积分运动方程,与时间步长稳定性有关。 质量在 [ atoms ] 中明确列出，优先用于该分 子。实际模拟中分子数量由 .top 文件的 [ molecules ] 指 定。

- **以下字段可以定义多次，效果累加：**

  - `[ bonds ]`：定义键伸缩项的信息

    ```
    [ bonds ]
    ;  ai    aj funct           c0           c1
        3     4     1 1.000000e-01 3.744680e+05
        3     5     1 1.000000e-01 3.744680e+05
        ....
    ```

    - 第1-2列：成键原子在**当前**分子类型中的序号
    - 第3列：函数类型
    - 第4-5列c0和c1：可以合并为一列，用在力场文件中的参数名字代替

  - `[ pairs ]`：定义要计算的范德华和静电1-4作用

    ```
    [ pairs ]
    ;  ai    aj funct           c0           c1
        2     4     1 0.000000e+00 0.000000e+00
        2     5     1 0.000000e+00 0.000000e+00
        ....
    ```

    - 由千nrexcl=3，常规的1-4间的非键作用不被计算。但由于定义了`[ pairs ]`，故会以特殊方式计算此处罗列出的1-4作用项
    - c0和c1好像可以省略

  - `[ angles ]`：定义键角弯曲项的信息

    ```
    [ angles ]
    ;  ai    aj    ak funct           c0           c1
        1     3     4     1 1.200000e+02 2.928800e+02
        1     3     5     1 1.200000e+02 2.928800e+02
        4     3     5     1 1.200000e+02 3.347200e+02
        ....
    ```

  - `[ dihedrals ]`： 定义二面角项的信息 

    ```
    [ dihedrals ]
    ;  ai    aj    ak    al funct           c0           c1           c2
        2     1     3     4     1 1.800000e+02 3.347200e+01 2.000000e+00
        6     1     3     4     1 1.800000e+02 3.347200e+01 2.000000e+00
        2     1     3     5     1 1.800000e+02 3.347200e+01 2.000000e+00
        ....
    [ dihedrals ]		第二次定义二面角项，和上一批定义的效果累加
    ;  ai    aj    ak    al funct           c0           c1
        3     4     5     1     2 0.000000e+00 1.673600e+02
        6     7     8     1     2 0.000000e+00 1.673600e+02
        ...
    ```

    - 通常将普通二面角项和 improper项用不同的 `[ dihedrals]` 分开定义以便区分和易于修改.

  - `[ settles/bonds/angles ]`  刚性或柔性水

    ```
    #ifndef FLEXIBLE					表示默认使用刚性水
    [ settles ]							用解析算法保持水分子几何
    ;	i	funct	doh		dhh			doh O–H 键长;dhh H–H 距离。
    	1	1		0.1		0.16330	
    #else								柔性水：若定义 FLEXIBLE，则改用键伸缩和角弯曲势。
    [ bonds ] 0-H: r0=0.1000 nm, k=3.45E+05
    [ angles ] H-0-H: a0=109.47", k=3.83E+02
    #endif
    [ exclusions ]
    1 2 3/ 2 1 3 / 3 1 2
    ```
    - 柔性模型计算更重,时间步长通常更保守
  
  - `[ exclusions ]`：定义哪些原子间的非键作用被忽略掉
  
    - 明确排除同一水分子内部 OW 与两个 HW 之间的非键相互作用。 
    - 避免分子内静电或 LJ 相互作用与约束/键角项重复计入。 
    - 对刚性小分子水模型,这是保持拓扑一致性的关键段落。


## 例子

- gromos54a7.ff下的spc.itp

  ```
  [ moleculetype ]
  ; molname	nrexcl
  SOL		2
  
  [ atoms ]
  ;   nr   type  resnr residue  atom   cgnr     charge       mass
  #ifndef HEAVY_H			默认情况 (在mdp里没设define =-DHEAVY H时用的)
       1     OW      1    SOL     OW      1      -0.82   15.99940
       2      H      1    SOL    HW1      1       0.41    1.00800
       3      H      1    SOL    HW2      1       0.41    1.00800
  #else					在mdp文件设定了define=-DHEAVY_H时用的，可减缓氢的运动
       1     OW      1    SOL     OW      1      -0.82    9.95140
       2      H      1    SOL    HW1      1       0.41    4.03200
       3      H      1    SOL    HW2      1       0.41    4.03200
  #endif
  
  #ifndef FLEXIBLE				默认情况，对应刚性水
  [ settles ]
  ; OW	funct	doh	dhh			使用SETTLE算法约束水的结构为刚性
  1	1	0.1	0.16330
  
  [ exclusions ]					忽略掉1与2/3，2与1/3、3与1/2原子间的非键相互作用
  1	2	3
  2	1	3
  3	1	2
  #else							mdp里设了deine=-DFLEXiBLE时的情况，对应柔性水
  [ bonds ]
  ; i	j	funct	length	force.c.
  1	2	1	0.1	345000	0.1     345000
  1	3	1	0.1	345000	0.1     345000
  	
  [ angles ]
  ; i	j	k	funct	angle	force.c.
  2	1	3	1	109.47	383	109.47	383
  #endif
  ```

- gromos54a7.ff下的 ions.itp 的一部分

  ```
  ...
  [ moleculetype ]
  ; molname	nrexcl
  CA		1		除个例外，所有力场中离子的“分子名”“残基名”、“原子名”相同且都是元素符号大写，但原子类型名视力场而定
  
  [ atoms ]
  ; id	at type	res nr 	residu name	at name  cg nr	charge   mass
  1	CA2+	1	CA		CA	 1	2	 40.08000
  
  [ moleculetype ]
  ; molname	nrexcl
  NA		1
  
  [ atoms ]
  ; id	at type	res nr 	residu name	at name  cg nr	charge   mass
  1	NA+	1	NA		NA	 1	1	 22.9898
  ...
  ```

  - 一个itp文件里可以有多个`[moleculetype]`字段分别定义多个分子类型的信息。在下一个`[moleculetype]`字段之前出现的各种字段都是对上一个`[moleculetype]`定义的分子来定义的。

## 注意事项

拓扑文件与结构文件的对应关系问题：

- 只有拓扑文件对应的原子顺序与结构文件(一般为gro、pdb)的原子顺序完全一致时计算才有意义，否则参数会匹配错乱，导致结果离谱或者崩溃。为此，必须满足:

  - top文件里[molecules ]中分子出现顺序必须和结构文件里严格一致。如

    ```
    [ molecules ]
    SOL 100
    MOL 8
    SOL 20
    ```

    则结构文件里必须按顺序依次出现100个SOL、8个MOL、20个SOL

  - 结构文件里每个分子的原子顺序必须和`[ molecules ]`里出现的分子的相应的`[ moleculetype ]`里的`[ atoms ]`里的原子顺序相一致。例如：

    ```
    [ molecules ]
    MOL 4
    SOL 4199
    NA	12
    ```

    若`include`了GROMACS自带力场目录下的spce.itp，由于此itp里的`[atoms]`中原子出现顺序是O、H、H，因此结构文件里每个水的原子顺序也必须是O、H、H。如果不符，应当在使用packmol或insert-molecules等工具将水加入体系前将被插入的水的结构文件里的原子顺序手动调整成O、H、H。

# mdp文件

- mdp参数一般不区分大小写，顺序无所谓，但如果输入两次相同的内容，则使用最后一次输入的内容（ `gmx grompp` 会在值被覆盖时发出提示）。左侧的破折号和下划线将被忽略。

- 例：蛋白质在水箱中进行 1 纳秒 MD 模拟的值

  ```
  integrator               = md
  dt                       = 0.002
  nsteps                   = 500000
  
  nstlog                   = 5000
  nstenergy                = 5000
  nstxout-compressed       = 5000
  
  continuation             = yes
  constraints              = all-bonds
  constraint-algorithm     = lincs
  
  cutoff-scheme            = Verlet
  
  coulombtype              = PME
  rcoulomb                 = 1.0
  
  vdwtype                  = Cut-off
  rvdw                     = 1.0
  DispCorr                 = EnerPres
  
  tcoupl                   = V-rescale
  tc-grps                  = Protein  SOL
  tau-t                    = 0.1      0.1
  ref-t                    = 300      300
  
  pcoupl                   = Parrinello-Rahman
  tau-p                    = 2.0
  compressibility          = 4.5e-5
  ref-p                    = 1.0
  ```

- `gmx grompp` 将生成一个带有默认名称的注释文件 该文件将包含上述选项以及所有其他未明确设置的选项，并显示其默认值。

- [mdpeditor · PyPI](https://pypi.org/project/mdpeditor/)：该工具可以根据简单的指令，帮助用户按照最佳实践生成 mdp 文件。

常用的mdp选项：[Molecular dynamics parameters (.mdp options) - GROMACS 2026.3 documentation](https://manual.gromacs.org/current/user-guide/mdp-options.html)

## 预处理控制（区分大小写）

- `define`：传递给`.top`的预处理器的设定。
  - `-DFLEXIBLE` 将在您的拓扑中使用柔性水而不是刚性水，这对于正态模式分析非常有用。
  - `-DPOSRES` 将触发将 `posre.itp` 包含到您的拓扑中，用于实现位置约束。

## 运行控制 

- `integrator`: 决定当前任务干什么
  - `md`(默认):leap-frog方式做动力学
  - `md-wv`:用Velocity-Verlet方式做动力学，在功能上有一些限制
  - `sd`:做随机动力学(Langevin动力学)
  - `bd`:做布朗动力学
  - `steep`:用最陡下降法做能量极小化
  - `cg`:用共轭梯度法做能量极小化(不支持约束)
  - `l-bfgs`:用L-BFGS准牛顿法做能量极小化，比较准确、收敛性好但耗时高
  - `nm`:做正则振动分析(必须双精度版)
- `tinit`:动力学开始的时间(ps)。默认0
- `dt`:动力学步长(ps)。默认0.001(即1fs)
- `nsteps`：动力学或能量极小化的步数上限
  - 总模拟时长=dt*nsteps
- `comm-mode`:设定消除整体运动的方式
  - `Linear`(默认):消除质心平动速度
  - `Angular`:消除质心平动速度与绕着质心的转动速度
  - `Linear-acceleration-correction`:同Linear,但还假定体系存在质心常加速度并消除之
  - `None`:不消除(通常加外力时应当用none)
- `nstcomm`：每多少步消除一次整体运动，默认100步
- `comm-grps`:对哪个组消除整体运动，默认是system

## 能量极小化参数

- `emtol`:能量极小化时最大受力小于多少就认为己收敛(kJ/mol/nm)。默认为
  10.0
- `emstep`:最陡下降法最大步长(nm)，默认0.01
- `nstcgsteep`：每做多少步共轭梯度极小化时做一次最陡下降法极小化，默认为1000。这种组合使用比单独用共轭梯度法效果往往更好

## 输出控制

- `nstxout`:每多少步输出一次坐标到trr文件
- `nstvout`:每多少步输出一次速度到trr文件
- `nstfout`:每多少步输出一次受力到tr文件
- `nstxout-compressed`:每多少步输出一次坐标到xtc文件

以上4个默认为0，即不输出

- `compressed-x-grps`:选择输出到xtc文件的group,默认为system
- `nstlog`:每多少步输出一次各种能量、属性信息到log文件，默认为1000
- `nstenergy`:每多少步输出一次能量信息到.edr文件，默认为1000。应是计算能量频率(由`nstcalcenergy`设定，默认100)的倍数
- `energygrps`:将哪个group的短程非键作用能输出到.edr文件中。例如设AB则.edr里会包含A、B组自身的以及它们之问的短程非键作用能信息。GPU加速时不支持
- xtc/edr/trr第一帧对应初始时刻信息。初始时刻和最终时刻信息总会被输出到log和edr中

## 邻居列表生成方式

有verlet和基于charge group两种方式构建邻居列表

- `cutof-schemevedet`：

  - `verlet`：默认。只能用于PBC下的计算。对于水不占体系主要部分的情况效率比group方式更高，且GPU加速时只能用此方法。

    邻居列表距离(rlist)会依据指定的差限(verlet-bufer-tolerance)自动设定来确保留出足够大的缓冲区。邻居列表最小更新频率虽可通过nstlist设定，但mdrun可能自发增加nstist以达到最佳效率。因此此时rist和nstlist没必要自己设

  - `group`：是GROMACS 4.6版之前唯一支持的方法，如今一般不用，此时也不支持OpenMP并行和GPU加速。但对于非PBC下的模拟、GB模型下的模拟等情况只能用这个。用nstlis定义更新邻居列表的频率(默认为10)，用rlist定义邻居列表距离(默认为1nm)。从2020版开始不再支持

- `nstlist`：默认每 5 步更新一次邻域表；对应 10 fs。

- `rlist`：邻域表搜索半径。默认1.0 nm

### 周期性设定

- `pbc`
  - `xyz`(默认):在xly/z方向都用周期性
  - `xy`:只在xy方向上用周期性
  - `no`:不用周期性，此时通常应当将所有`cutoff`设0，即每一步都计算所有粒子间非键作用，且将`nstlist`也设0，即只在第一步构建一次邻居列表
- `periodic-molecules`:说明模拟体系是否有首尾相接的周期性分子(如无限长纳米管)
  - `no`(默认):不是周期性分子
  - `yes`:是周期性分子



## 静电作用的计算设定

- `coulombtype`：设静电作用的计算方式
  - `cut-off`（默认）：简单截断方法
  - `Ewald`:Ewald方法
  - `PME`:SPME方法
  - `P3M-AD`:带解析导数的PPPME方法，精度比PME略微高一点
  - `Reaction-Field`:反应场方法，圆球外介电常数用epsilon-rf设定
  - `User`:使用用户在table.xvg中定义的静电作用的列表势(从2020版开始不再支持。）

- `rcoulomb`:对截断方法义cutoff值:对Ewald/PME/P3M-AD定义实空间中计算短程静电作用的距离值;对反应场方法定义圆球半径。默认为1nm
- `epsilon-r`:相对介电常数，默认为1。如果设0代表无穷大(等价于忽略体系中静电相互作用，但不能由此达到省时间目的。此时必须用`coulombtype=cut-off`否则会报错

## 范德华作用的计算设定

- `vdwtype`:设定范德华作用的计算方式

  - `Cut-off`:截断方式计算
  - `PME`:PME方式计算
  - `User`:使用用户在table.xvg中定义的范德华作用的列表势(从2020版开始不再支持)

- `rvdw`:范德华作用距离(nm)，默认为1nm

  - 一 般令 rcoulomb=rvdw 。原理上数值越大色散 作用精度越高,越小计算速度越快。建议根 据所用力场参数化时的参数恰当设定数值.

- `vdw-modifier`:设定如何修改范德华势

  - `Potential-shift-Verlet`(默认):对范德华势进行shif使得cutoff处数值为0，不会增加耗时
  - `None`:不对范德华势做任何修改
  - `Force-switch`, `Potential-switch`: 用switchingfunction分别使得范德华力、势从rvdw-switchrvdw范围间平滑切换到0，会增加耗时

- `DispCorr`:对色散作用的长程校正

  - `no`(默认):不做校正

  - `EnerPres`:对能量和压力都做校正

  - `Ener`:只对能量做校正

    盒子被原子填满的情况一般建议用`EnerPres`,其它情况用`no`


≥2018 版的非键作用通常情况下的推荐设定

```
cutoff-scheme=verlet
coulombtype=PME
rcoulomb=1.0
vdwtype=cut-off
rvdw=1.0
DispCorr=EnerPres
```



## 与键有关的设定

- `constraints`:设定约束方式。约束的参考值是拓扑文件里定义的平衡坐标
  - `none`（默认)：不做约束
  - `h-bonds`:约束与氢相连的键。如果还要约束与之相关的键角用`h-angles`
  - `all-bonds`：约束所有的键
  - `all-angles`:约束所有键、键角
  - **主流力场普遍是对h-bonds约束做的参数化，对重原子之间都是特意给定了力常数的。**
- `constraint-algorithm`：设定约束算法
  - `LINCS`(默认)：使用LINCS方法约束，但不能约束键角
  - `SHAKE`:使用SHAKE方法约束，没LINCS稳健，且不能用于能量极小化
- continuation：是否对初始结构做约束。
  - 默认的no代表对初始结构做约束。
  - yes代表对初始结构不做约束，对于续跑、rerun的目的应当设此值（但用默认的no一般也没什么不良影响）
- `lincs-iter`：LINCS 校正迭代次数;数值越高越严格但更耗时。默认1。
- `lincs-order`：LINCS 展开阶数;影响约束精度和稳定性。默认4。





控压只影响MD过程，在能量极小化过程中叩便用了压浴，盒子尺寸也不会发生变化

## 压浴设定

- `pcoupl`:选择压浴
  - `no`(默认):不使用压浴
  - `Berendsen`: 使用Berendsen压浴。常用于预平衡,不严格产生 NPT 系综。
  - `Parrinello-Rahman`: 用Parrinello-Rahman浴
  - `C-rescale`:stochastic cell rescaling压浴 (2021版入)
- `pcoupltype`:选择控压方式
  - `isotropic`:各方向等比例缩放盒子,适合各向同性液体或溶液。
  - `semiisotropic`:半各项同性控压，即xy方向上和z方向上分别控压。相关参数(compressibility、ref-p)因此需要设定两套。对于界面体系、膜体系有用
  - `anisotropic`:各问异性控压，相关参数需要对xx,Wy,zz,xy/yx;xz/zx,yz/zy分别输入。若非对角元值都设为0则矩形盒子会一直保持矩形而不会歪斜
  - `surface-tension`:对xly方向按照指定的表面张力值对盒子进行调节，而z方向还是用普通控压

- `nstpcouple`：每多少步做一次控压。通常用默认的-1即可，含义对于不同版本有所不同。对于2018版默认值相当于nstpcouple=10，而从2023版开始为了降低耗时面将默认值对应的控压步数间隔设得较大（极个别
  时候可能导致控压不稳定)

- `tau-p`：控压的时间常数(ps)，数值较大时体积调节更平缓。

- `compressibility`:可压缩系数（bar）通常用水在1atm、298.5K下的值4.5E-5bar，0代表不可压缩

- `ref-p`:控压的参考压力(bar)。通常设1或1.01325

- `refcoord-scaling`:设置使用控压调节盒子尺寸时怎么处理位置限制对应的参考坐标

  - no:不修改参考坐标

  - all：所有参考坐标以盒子为比例调节

  - com:只按照盒子比例调节被限制的部分的质心，

    而原子的参考坐标相对于质心的坐标不变。通常使用这个以避免被限制的分子的结构变形



## 热浴设定

- `tcoupl`:选择热浴
  - `no`(默认):不用热浴
  - `berendsen`: Berendsen热浴
  - `nose-hoover`: Nose-Hoover热浴，适合产生正则系综。
  - `v-rescale`:Velocity-rescale热浴

- `nsttcouple`:每多少步做一次控温。默认为-1，即使用`nstlist`的值，通常是合适的
- `tc-grps`:控温组，默认为system。可以设定对多个组单独控温，如Protein SOL
- `tau-t`:控温的时间常数(ps)，需要对每个控温组都设定。-1代表不做控温
- `ref-t`:参考温度(K)，需要对每个控温组都设定
  使用热浴时，每个原子都必须属于一个控温组。但可以把某个组的tau-t设为-1代表对之不控温，由此可以研究诸如热传导问题。

## 退火设定

- `annealing`
  - `no`(默认):不做退火
  - `single`:单次退火。如果模拟时间超过最后退火点则会一直维持此温度
  - `periodic`:每次达到最后退火点时从最初退火点温度重新开始，反复周期性循环直到模拟结束
- `annealing-npoints`:对每个控温组设定退火点数目
- `annealing-time`:对每个控温组设定每个退火点的时间(ps)
- `annealing-temp`:对每个控温组设定每个退火点的温度(K)

## 初始速度生成设定

- `gen-vel`

  - `no`(默认):如果输入文件里有速度信息则使用其作为初速度，里面没有速度信息则初速度为0
  - `yes`:令grompp按照Maxwell分布产生随机的初速度

- `gen-temp`:产生的初速度对应的温度(K)，默认为300

- gen-seed:随机数的种子。默认为-1，对应赝随机数注:用gen-vel= yes时不宜结合较高的gen-temp,否则有可能有些原子初速度过大，导致一开始动力学出现不稳定、崩溃。应当用较低的gen-temp(如100K)，然后通过控温的自发过程，或者指定退火方式，使温度最终达到期望值。

  注:用`gen-vel= yes`时不宜结合较高的`gen-temp`,否则有可能有些原子初速度过大，导致一开始动力学出现不稳定、崩溃。应当用较低的gen-temp(如100K)，然后通过控温的自发过程，或者指定退火方式，使温度最终达到期望值。





`ns_type`：`grid`：采用网格法进行邻域搜索,提高非键相互作用搜索效率。

pme_order：PME 插值阶数为 4;常见且稳定的默认选择。

fourierspacing：PME 傅里叶网格间距;越小通常越精确但更耗时。

gen_vel no 不重新生成初速度;通常从输入结构/重启文件读取速度。
