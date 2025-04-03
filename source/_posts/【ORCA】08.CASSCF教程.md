---
title: 【ORCA】08.CASSCF教程
typora-root-url: 【ORCA】08.CASSCF教程
mathjax: true
date: 2023-10-07
updated:
tags: [ORCA, CASSCF, 多组态]
categories: [计算化学, 软件]
description: ORCA的CASSCF教程笔记
---



# CASSCF

## 初猜计算

好的起始轨道在开始时具有较小的 CASSCF 轨道梯度范数（在输出中表示为 ||g||）。然而，较小的初始梯度并不总是意味着较少数量的 CASSCF 迭代。重要的是与最终轨道的相似性。

- 直接计算
  - 默认是`Pmodel`初猜，可以针对重元素
  
    - 可以直接计算一个`!noiter`的结果来初猜
  
      ```
      ! SV def2/JK RI-JK Conv XYZFile noiter normalprint
      ```
  
  - 对于过渡金属，所需的金属 3d 轨道通常位于 HOMO-LUMO 能隙（或者对于由“离子”金属轨道组成的活性空间），可以使用`! PAtom`初猜（PAtom 猜测不适用于 ANO 基组。）对于更重的金属，不适用。
  
- 做ROHF/RKS计算，构造初始猜测轨道。

- DFT-QRO：做DFT计算，通过`UNO`关键词得到**qro轨道**。

   - 注意：猜测应该从高自旋重数开始，以避免 SCF 级别的收敛问题
   - HF-QRO的计算量更大，但是有时候它和CASSCF的结果更相似，初始梯度反而较小，也能较快收敛。但是对于离域性比较强的体系，HF很难识别反键轨道，结果反而不好。

- 通过小活性空间，再计算大活性空间

- 从阳离子轨道开始，比如要计算f3系统，可以先算f0。

- run a simple selected CEPA/2 calculation

- 对于有机化合物，通过简单的后HF计算，比如MP2或MRCI得到自然轨道*.mp2nat，和gbw文件一样。

   - 最昂贵的初猜，但是借助分数占据数可以简化“重要”轨道的选择。特别是，键合和反键合伙伴轨道，例如 π − π * 轨道，很容易识别。自然轨道是有机分子的绝佳选择。

   ```
   ! RI-MP2 SVP def2-SVP/C
   
   %mp2 
   	natorbs true
       density unrelaxed # or relaxed (更耗时)
   end
   ```

### orca_loc

ORCA 中有四种不同的定域方法可用：Pipek-Mezey 方法 (PM)、Foster-Boys 方法 (FB)、基于固有原子轨道 (IAO) 的 PM 方法和基于 IAO 的 FB 方法。

- 对于 Foster-Boys定域方法，存在三种不同的算法：
  - `FB`：传统方法
  - `NEWBOYS`：速度更快，并且可以用于定位大型系统的空轨道
  - `AHFB`：系统地收敛到局部最小值，而不是不同类型的驻点。

使用：

- 在输入文件中增加相应的块：

  ```
  %loc   
  LocMet      PM      # Localization method e.g. PIPEK-MEZEY 
              FB      # FOSTER-BOYS
              IAOIBO  # IAOIBO 
              IAOBOYS # IAOBOYS
              NEWBOYS # FOSTER-BOYS
              AHFB    # Augmented Hessian Foster-Boys
  Tol         1e-6    # absolute convergence tolerance for the localization sum
                      # default value is 1e-6
                      # In the case of AHFB, however, this is the gradient threshold!
  Random      0       # Always take the same seed for start for localization
                      # (For testing/debug purpose,optional)
              1       # Take a random seed for start of localization (default)
  PrintLevel  2       # Amount of printing 
  MaxIter     64      # Max number of iterations 
  T_Bond      0.85    # Thresh that classifies orbitals in bond-like at the printing 
  T_Strong    0.95    # Thresh that classifies orbitals into strongly-localized at
                      # the printing 
  OCC         true    # Localize the occupied space 
  T_CORE      -99.9   # The Energy window for the first OCC MO to be localized (in a.u.)
                      # Here, we localize all occupied MOs including core orbitals.
  VIRT        true    # Localize the virtual space 
  end
  ```

- 在shell中直接：

  ```
  orca_loc localization.input
  ```

  - input文件中按顺序准备以下：

    ```
    Myjob.gbw     # input orbitals 
    Myjob.loc.gbw # output orbitals 
    10            # orbital window: first orbital to be localized e.g. first active 
    15            # orbital window: last orbital to be localized e.g. last active 
    0             # localization method:
                  # 1=PIPEK-MEZEY,2=FOSTER-BOYS,3=IAO-IBO,4=IAO-BOYS,5=NEW-BOYS,6=AHFB
    #以下参数为可选参数
    # 但是，如果您想更改其中一个，则必须同时设置前面的所有参数。
    0             # operator: 0 for alpha, 1 for beta
    128           # maximum number of iterations 
    1e-6          # convergence tolerance of the localization functional value 
    0.0           # relative convergence tolerance of the localization functional value              
    0.95          # printing thresh to call an orbital strongly localized 
    0.85          # printing thresh to call an orbital bond-like
    2             # printlevel
    1             # use Cholesky Decomposition (0=false, 1=true)
    1             # randomize seed for localization (0=false, 1=true)
    ```

    - 比如

      ```
      PPD.gbw
      LOC.gbw
      0
      20
      1
      ```

### orca-mergefrag

- 对配位化合物（尤其是重金属）通过`orca_mergefrag`生成初猜

  - 首先计算DFT下配体的波函数L.gbw和纯金属CASSCF的波函数CAS.gbw

  - 合并两个gbw文件（第二个必须是CASSCF的结果）

    ```
    orca_mergefrag L.gbw CAS.gbw LCAS_merged.gbw
    ```

  - 然后将LCAS_merged.gbw作为初猜（注意坐标里面金属变为最后一行

## 旋转轨道

找出要选进活性空间及其编号，必要的时候进行旋转

例子：苯的CAS(6,6)计算的输入文件如下：（苯的π轨道为17,20-23,30，需要交换轨道）

```
!cc-pvtz UseSym pal8
!moread
%moinp "benzene-rhf.gbw"
%scf
	rotate {16,18,90} {23,29,90} end
	#或者直接rotate {16,18} {23,29} end
end
%casscf
	nel 6
	norb 6
	mult 1
	irrep 0
end
*xyzfile 0 1 benzene.xyz
```

## 对称性

使用对称性的好处是可以节约时间，另一方面可以指定特定的激发态，否则需要更多的roots去得到这个态。

- 要使用对称性，全过程的计算都应该增加对称性的关键词`! USESYM`。输出的结果与对称性有关的：

  ![image-20250120152608731](/image-20250120152608731.png)

  ![image-20250120153010260](/image-20250120153010260.png)

  

- IRREP 被计数为从零开始的整数，比如在Cs下是A’ (0) 和A’’ (1).

```
%casscf mult   1,3 # here: multiplicities singlet and triplet
        irrep  0,1 # here: irrep for each mult. block (mandatory!)
        nroots 4,2 # four singlets, two triplets
```





## 态平均

为了首先避免收敛问题，建议进行状态平均计算。

```
%casscf 
	nel 3 
	norb 5 
	mult 4,2 
	nroots 10,9 
end
```

注意，程序在默认情况下为多重块选择相等的权重。给定块中的根具有相等的权重。用户可以为多重块和根定义自定义加权方案：

```
%casscf mult 1,3   # here: multiplicities singlet and triplet
        nroots 4,2  # four singlets, two triplets
        bweight 2,1 # singlets and triplets weighted 2:1
        weights[0] = 0.5,0.2,0.2,0.2 # singlet weights
        weights[1] = 0.7,0.3         # triplet weights
        end
```



### 确定态的数目

对于最高多重度，直接使用公式$C_n^m$，即可，比如d3是$C_5^3=10$

#### Cr3+ d3系统

```
%casscf 
	nel 3
	norb 5
	mult 4,2 
	nroots 10,9
end
```

它的Tanabe-Sugano图是：

![image-20250115210600674](/image-20250115210600674.png)

最左边是自由离子的光谱项，会分裂成右边的光谱项（可以根据原子对称性在Oh下的分裂来推导）

![image-20250115210718195](/image-20250115210718195.png)

- 四重态的态选的是10个，主要根据的是较低的四重态$^4F$+$^4P$，分裂成A2u ⊕ T1u ⊕ T2u和T1u，加起来是1+3+3+3=10。也可以直接根据原子光谱项的数目，F代表7，P代表3，加起来是10
- 同理，双重态的选的是9个，则是最低的2G=9个
- 原子光谱的顺序也可以通过[NIST](https://physics.nist.gov/PhysRefData/ASD/levels_form.html)查询（查Cr3+输入Cr IV）

#### Co II d7系统

![image-20250115211320115](/image-20250115211320115.png)

则四重态是7+3=10个，双重态是9+3+11+5+7=35个

```
%casscf 
	nel 7 
	norb 5 
	nroots 10,35 
	mult 4,2
end
```











## 轨道优化方法

CASSCF迭代的输出部分会显示当前用的方法：

```
....
#||g||的值控制了收敛方法，比如这里||g||<0.02后用就改为NR方法，可以用SwitchConv控制这个值
||g|| = 2.971340e-02 Max(G)= -8.643429e-03 Rot=52,20
--- Orbital Update [SuperCI(PT)]
....
||g|| = 8.761362e-03 Max(G)= 4.388664e-03 Rot=43,19
--- Orbital Update [ NR]
```

关键词`Orbstep`和`Switchstep`的选择有：默认都是`SuperCI_PT`

```
SuperCI_PT  # perturbative SuperCI (first order) 
SuperCI     # SuperCI (first order)
DIIS        # DIIS (first order)
KDIIS       # KDIIS (first order)
SOSCF       # approx. Newton-Raphson (first order)
NR          # augmented Hessian Newton-Raphson
            # unfolded two-step procedure
            # - still not true second order
```

- 一阶方法成本低，但与二阶方法相比，通常需要更多的迭代。
- 当远离收敛限的时用`Orbstep`指定的方法，接近收敛时用`Switchstep`指定的方法
  - 用关键词`SwitchConv`和`SwitchIter`定义转变方法的条件

### SuperCI_PT

- 对于精确双占据或空轨道具有鲁棒性（即占据2或者0

- 可以使用关键字 `DThresh`（默认=1e-6）控制占据的阈值

- 在某些情况下，例如基集投影或PATOM猜测（固有基集投影），程序可能会选择太大的步长，通过关键字`MaxRot`（默认值=0.2）限制步长可能会有用。

  这两个关键词是特定于`SuperCI_PT`

  ```
  MaxRot 0.05  # cap stepsize for SuperCI_PT
  DThresh 1e-6 # thresh for critical occupation
  ```

- SuperCI_PT也可以使用能级移动（最好不要对其他收敛方法使用）或者`GradScaling`，其他收敛方法的关键词不适用于SuperCI_PT？？

  - Note, damping and level shifting techniques are not recommended for the default converger (SuperCI_PT).

- 相比起SuperCI_PT，<FONT COLOR=RED>DIIS、SuperCI和KDIIS不适用于占据正好是2.0或者0.0的活性空间</font>。后者允许更多的调整，例如可以使用关键字“FreezeGrad”禁用冻结核心旋转。

---

- 如果默认设置出现收敛问题，建议尝试 `orbstep SuperCI` 和 `switchstep DIIS` 的组合（使用SuperCI来收敛，达到一定收敛性后转变为DIIS），结合大能级移动 (2 Eh)，可能会立即成功

  - 但会需要更多迭代
  - SuperCI 和 DIIS (switchstep) 的组合特别适合保护活动空间成分。

  ```
  %casscf 
    OrbStep    SuperCI 
    SwitchStep DIIS    
    SwitchConv 0.03 
    SwitchIter 15   
    MaxIter     75  # Maximum number of macro-iterations
  end
  ```

#### 能级移动

```
%casscf
  	ShiftUp 2.0 # static up-shift the virtual orbitals
	ShiftDn 2.0 # static down-shift the internal orbitals
	MinShift 0.6 # minimum separation subspaces
end
```

- 理想情况下，内层和活性空间、活性空间和空轨道之间的能量差应为正且大于 0.2 Eh。当能量分离变为负值时，收敛器可能会失效或无法保留活动空间。
- 如果输入中未指定平移，ORCA 将选择能级平移以保证子空间之间的能量分离 (`MinShift`)。

### NR

在达到一定的收敛性后，使用Newton-Raphson方法去收敛

- 使用 Newton-Raphson 求解器进行轨道优化仅限于较小尺寸的分子，因为该程序会生成冗长的积分和 Hessian 文件
- 一开始就用昂贵的 NR 方法开始轨道优化是一种浪费，因为它的二次收敛半径非常小。
- 在困难的情况下，建议使用牛顿-拉夫森方法 (NR)，即使每次单独迭代的成本要高得多

```
%casscf
  	SwitchStep nr
end
```

成本较低的替代方法是准牛顿的SOSCF方法

## RI近似

- 默认是`Exact`，精确变换，使用RI近似（仅影响CASSCF计算中的积分变换）：

  ```
  %casscf
  	TrafoStep RI
  end
  ```

  - 需要对AuxC指定对应的辅助基组

    例：

    ```
    ! SV(P) def2-svp/C 			# smaller compared to def2/JK
    ! moread
    %moinp "Test-CASSCF-Benzene-2.mrci.nat"
                    
    # %basis 
    # auxC "def2-svp/C" 		# "AutoAux" or "def2/JK"
    # end
    
    %casscf  nel    6
             norb   6
             nroots 1
             mult   1         
             trafostep ri
             end
    ```

- 进一步加速整个计算，可以直接使用 （都需要设置相应的辅助基组）

  - `!RIJCOSX`：适合较大的系统

    ```
    ! SV(P) def2-svp/C RIJCOSX def2/J
    ! moread
    %moinp "Test-CASSCF-Benzene-2.mrci.nat"
    
    # %basis 
    # auxJ "def2/J"     # "AutoAux"
    # auxC "def2-svp/C" # "AutoAux", "def2/JK"
    # end
    
    %casscf  nel    6
      norb   6
      nroots 1
      mult   1
    end
    ```

  - `!RIJK`：更准确一些

    ```
    ! SV(P) RIJK  def2/JK
    
    # %basis 
    # auxJK "def2/JK" # or "AutoAux"
    # end
    ```

## 输出轨道

`IntOrbs`、`ExtOrbs`和`ActOrbs`选项都有

- `CanonOrbs`

- `LocOrbs`

- `unchanged`

- 除此之外的选项有

  ```
  IntOrbs PMOS      # based on orthogonalization tails.
          OSZ       # based on oszillator orbital      
          DOI       # based on differential overlap
  
  ExtOrbs PMOS      # based on orthogonalization tails.
          OSZ       # based on oszillator orbital
          DOI       # based on differential overlap
          DoubleShel
  
  ActOrb  dOrbs     # purify metal d-orbital and call the AILFT
          fOrbs     # purify metal f-orbital and call the AILFT
          SDO       # Single Determinant Orbitals: this is only possible if the
                    # active space has a single hole or a single electron.
                    # SDOs are then the unique choice of orbitals that simultaneously
                    # turns each CASSCF root into a single determinant.
  ```

- 比如在某些小活性空间下进一步扩大活性空间，有些内部的轨道可能比较离域，则可以使用`intorbs locorbs`。



### 内部

### 活性空间

可以在casscf 模块使用actorbs locorbs关键词，对活性轨道做局域化

- 在判断计算得到的是否为开壳层单重态时，不能只通过占据数来判断，要结合轨道图像一起判断。ORCA做CAS默认得到的是自然活性轨道，不一定能够直接通过组态信息确定所得到的电子态
- 因为CASSCF的能量对活性轨道的旋转是酉不变的，因此，如果要更直观地展现单电子，可以使用actorbs locorbs关键词得到局域化的活性轨道。使用局域活性轨道，易于通过组态信息确定电子态。

### 外部

- 如果希望包含第二壳层的轨道（比如计算二阶微扰，CASPT2或NEVPT2），比如已经计算包含了3d的活性轨道，希望继续包含4d轨道，可以基于前一次的计算使用`extorbs doubleshell `，但不能和对称性（`UseSym`）同时使用

  ```
  %casscf 
  	nel 7 
  	norb 7 
  	mult 4,2 
  	nroots 10,9  
  	extorbs doubleshell # produce the double-shell above the actives. 
  						# all other virtuals are canonicalized 
  end
  ```

## CIStep

```
%casscf
  CIStep CSFCI # CSF based CI (default)
  		 ACCCI  
  		 ICE   
  		 DMRGCI
end
```

- 对于较大的活动空间或许多根，使用accelerated CI (ACCCI)进行 CI 计算可以显着改善

  - 目前，ACCCI尚不提供属性（自旋轨道耦合、g-张量……）以及 NEVPT2 校正，但是可以作为下一部计算的初猜

- 更大的活动空间可以通过 DMRG 方法或迭代配置扩展 (ICE) 来处理。

  - 推荐不太严格的 CASSCF 收敛阈值（`etol 1e6`）。

  - 详细设置可以在子块中控制

    ```
    %casscf 
    	ci
    		MaxIter 64   # max. no. of CI iters.
    		MaxDim  10    # Davidson expansion space = MaxDim * NRoots
    		NGuessMat 512  # Initial guess matrix: 512x512
    		PrintLevel 3 # amount of output during CI iterations
    		ETol   1e-10    # default 0.1*ETol in CASSCF
    		RTol   1e-10    # default 0.1*ETol in CASSCF
    		TGen   1e-4     # ICE generator thresh
    		TVar   1e-11    # ICE selection thresh, default = TGen*1e-7
    	end
    
    ```

    ```
    %casscf
      nel  8
      norb 6
      mult 3
      CIStep DMRGCI
    
      # Detailed settings
      dmrg
        # more/refined options
        ...
      end
    end
    ```

    







## output

- 观察收敛情况：`grep Max\(G\) *log`、`grep "Eh DE=" *log`

### 监控活性空间

- 如果活动空间成分变化超过 50%，ORCA将在迭代过程中打印警告。

  - 混合量表示为OVL。
  - 此外，打印还包括更新前后活性轨道之间的重叠矩阵。
  - 该矩阵应该是对角占优的，其值接近于统一。请注意，在此打印中，活动 MO 的编号从零开始。

  ![image-20250121181834643](/image-20250121181834643.png)

  - 如果活动空间确实发生了变化，则可以使用重新旋转的轨道重新开始计算，或者使用不同的收敛设置（修改的 MaxRot、更大的能级偏移或不同的收敛器）从头开始计算。



```
ActConstraints  0 # no checks and no changes
                1 # maximize overlap of active orbitals and check sanity. (default for DIIS)
                2 # make natural orbitals in every iteration (default SuperCI)
                3 # make canonical orbitals in every iteration
                4 # localize orbitals
```

- 迭代过程中打印的占据数不一定是自然轨道占据。如果要强制设置（不推荐）则比如`ActConstraints 1`还检查活动空间的组成是否已更改，即轨道已旋转出活动空间。在这种情况下，ORCA 中止并存储最后一组有效的轨道。以下是错误消息示例：

  ```
  --- Orbital Update [      DIIS]
  	--- Failed to constrain active orbitals due to rotations:
  	Rot( 37, 35) with OVL=0.960986
  	Rot( 38, 34) with OVL=0.842114
  	Rot( 43,104) with OVL=0.031938
  ```



### 波函数打印

![image-20250114202528212](/image-20250114202528212.png)

- 基态的权重为0.96606，这意味着最低根被单一配置支配到96.6%，这个数值是通过CI系数的平方和得到的。

- 如果对CI系数或自旋行列式的表示感兴趣，可以通过关键字`PrintWF`实现

  ```
  PrintWF 0     # (default) prints only the CFGs
          csf   # Printing of the wavefunction in the basis of CSFs
          det   # Printing of the wavefunction in the basis of Determinants
  ```

  - 请注意，CSF 的打印仅对高自旋状态有意义，因为未解释 CSF 的寻址。

  打印阈值可以通过`TPrintWF`控制

  ```
  %casscf 
  	printwf det 
  	ci 
  		TPrintWF 0.1 # cutoff for printing 
  	end 
  end
  ```

  - `det`的结果如下：

    **![image-20250117173200422](/image-20250117173200422.png)**



### 激发能量

- 激发能量,例：<a id="SA-CASSCF">$d^3$的SA-CASSCF结果</a>

![image-20250114203201474](/image-20250114203201474.png)

- CASSCF 计算通常不能准确地再现激发能量。改善结果的最简单方法是使用 NEVPT2。





# CASPT2

- CASSCF收敛的结果是考虑动态相关多参考的起点，常用的MRCI和MRPT

- internally contracted N-Electron valence state perturbation theory
  N个电子价层微扰(NEVPT2) 是动态相关的首选，只需要一个关键词：

  ```
  %casscf
  ...
  PTMethod SC_NEVPT2 	# for the strongly contracted NEVPT2
  					# Other options: FIC-NEVPT2, DLPNO-NEVPT2, FIC CASPT2
  end
  ```

  - `NEVPT2`就是NEVPT2方法的strongly contracted” 版本
  - `FIC-NEVPT2`是fully internally contracted (FIC)版，又名PC-NEVPT2





- 使用RI近似的SC-NEVPT2

  ```
  ! RI-NEVPT2
  ```





例子：

```

%casscf
 nel          10
 norb        8
 irrep       0
 mult       1
 NRoots     6
 Maxiter    200
 PTMethod   FIC_CASPT2
 PTsettings 
  CASPT2_IPEAshift    0.25
  CASPT2_rshift       0.10
 end
end
```



## 输出

- 激发能量，例：$d^3$的结果（借助它们的简并性和d3 的 Tanabe-Sugano 图，可以很容易地分配状态）

  ![image-20250114203304205](/image-20250114203304205.png)

  - 可以和<a href="#SA-CASSCF">态平均的CASSCF的结果对比</a>



# 从头算配体场AILFT

在CASSCF计算中增加`actorbs forbs`或`actorbs dorbs`。



