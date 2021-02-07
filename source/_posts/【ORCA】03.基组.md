---
title: 【ORCA】03.基组
typora-root-url: 【ORCA】03.基组
mathjax: true
date: 2020-09-05
updated:
tags: [输入,基组,辅助基组,RI近似,赝势,相对论基组]
categories: [计算化学,ORCA]
description: ORCA基组相关
---

# 概述

- orca中的标准基组列于**6.3.1 Standard basis set library**中的**Table 6.3**，可以直接作为关键词输入，没有的也可以在输入中用多种方法指定。
- 辅助基组用于RI-J RI-MP2的列于**6.3.1 Standard basis set library**中的**Table 6.4**，也可以直接作为关键词输入。
- 在**9.4.1 Built-in Basis Sets**的**Table 9.8: Basis sets availability**中也列出了所有的基组和适用的元素。



- 大多数HF/DFT计算推荐 Karlsruhe group的def2系列。能量和几何通常在DFT水平上用a balanced polarized triple-zeta basis set (such as def2-TZVP) 相当收敛，但是MP2和其他post-HF波函数理论方法收敛速度较慢。
- 对于某些分子性质，可能需要特殊的基组和/或uncontracted basis sets ：化学位移，自旋-自旋耦合，电场梯度，超精细耦合等。
- 坚持使用一个族中并适用于系统中所有元素的基组。来自不同族的混合和匹配基组可能会导致问题。推荐涵盖大部分元素周期表的 [Ahlrichs def2 basis set family](http://dx.doi.org/10.1039/B508541A) 进行DFT计算。该基组在DFT计算中比旧的Ahlrichs系列（文献中称为XVP或def-XVP，其中X可以是S，TZ，QZ）或分裂价Pople基组（6-31G，6-311G）更可靠。优点还在于，可以容易地获得针对该基组系列（与RI-J，RI-JK和RIJCOSX近似值一起使用）进行适当设计和测试的辅助基组。

- ORCA始终**使用纯d和f函数（5d函数和7f函数**，而不是6d函数和10r函数）。与与其他程序（默认值为6d函数和10f函数）的结果进行比较时很重要。

通常建议：

![](image-20210130180255629.png)

- 自己指定的时候应使用`Printbasis`关键字来确检查分子的最终基组是否正确。orca接受不规范的基组格式并规范，可以用`!printbasis`来输出，也可以用

  ```c++
  %output print[p basis] 2 end
  ```


# 指定方法

## 通过`!关键词`指定

关键词比如：

- def2-SVP, def2-TZVP, def2-TZVPP, def2-QZVPP,
- ma-def2-SVP, ma-def2-TZVP, ma-def2-TZVPP, ma-def2-QZVPP,
- cc-pVnZ, aug-cc-pVnZ, cc-pCVnZ, aug-cc-pCVnZ (n= D,T,Q,5,6)

## 通过`%basis`

- 注意有双引号


```c++
%basis
    Basis  "Def2-TZVP"
    AuxJ   "Def2/]"
    AuxJK  "Def2/〕K"
    AuxC   "Def2-TZVP/C"
    CABS    "cc-pVDZ-F12-OptRI" #for F12 calculations
end
```

### ~~基组decontract~~

- ORCA will delete duplicate primitives if the basis set comes from a general contraction scheme：if your basis set arises from general contraction it will contain duplicate primitives in several contractions and these will be removed such that only unique primitives remain and there is no problem with redundancy.

  ```c++
  %basis
  	DecontractBas false # if chosen "true" the program will decontract the orbital basis set
  	DecontractAuxJ false # if "true" - decontract the AuxJ basis set
  	DecontractAuxJK false # if "true" - decontract the AuxJK basis set
  	DecontractAuxC false # if "true" - decontract the AuxC basis set
  	DecontractCABS true # if "false" - do not decontract the CABS
  	Decontract false # if "true" - decontract all basis sets
  end
  ```

### 为不同元素指定不同基组

- `newgto`和`addgto`关键字需要单独的`end`语句

- `newgto`中的元素符号也可以用元素序号，比如`C`用`6` 
  
  ```c++
  ! BP86 def2-SVP def2/J TIGHTSCF printbasis
  %basis
  	newgto C "def2-TZVP" end
  end
  ```

- 如果要在`％basis`块中手动指定基组，基组输入文件的格式基本上是来自Gamess-US的EMSL库的格式
  - 第一行是第一角动量（s、p、d、f、g、h、i、j）和原始基函数的数目，接着每个原始基函数为一行
    - 第一列（1，2……）是原始基函数的序号，第二列是原始基函数的指数，第三列是没有归一化的收缩系数
    - ORCA总是使用球谐高斯函数。<a href="#LShell">L壳层(不要与角动量等于9混淆)是具有相同指数的s壳层和p壳层</a>
  - 还有可能在第一行的原始基函数的数目之后包含一个`SCALE X`语句，以指示基函数指数应该被收缩 
  
  ```c++
  ! BP86 def2-SVP def2/J TIGHTSCF printbasis
  %basis
  newgto C
  S   6
    1  13575.3496820              0.22245814352E-03      
    2   2035.2333680              0.17232738252E-02      
    3    463.22562359             0.89255715314E-02      
    4    131.20019598             0.35727984502E-01      
    5     42.853015891            0.11076259931    
    6     15.584185766            0.24295627626    
  S   2
    1      6.2067138508           0.41440263448    
    2      2.5764896527           0.23744968655    
  S   1
    1      0.57696339419          1.0000000
  ...etc...
  end
  end #Don't forget the two "end" keywords!
  ```


- 还可以使用`AddGTO`关键字添加基函数，比如不想使用标准极化函数
  - 例子：向所有碳原子添加指数为0.101的d极化函数
    ```c++
    ! BP86 def2-SVP def2/J TIGHTSCF printbasis
    %basis
    	addgto C 
    		D   1
      		1      0.1010000              1.0000000
    	end
    end
    ```
  
  - 也可以用基组的名称：
    ```c++
    #给O指定6-31G，然后再加入一个指数为0.4的极化函数
    %basis
        NewGTO 8 # new basis for oxygen
        	"6-31G"
        	D 1
        	1 0.4 1.0
    	end
    end
    ```
  
- 使用`NewGTO`不会改变元素的`ECP`，需要使用`NewECP`或者`DelECP`，  
- 辅助基组`NewAuxJGTO`的用法类似，关键词还有：`NewAuxCGTO`**, **`AddAuxCGTO`, `NewAuxJKGTO`**, **`AddAuxJKGTO`, `NewCABSGTO`**, **`AddCABSGTO`
  - `NewAuxGTO`和`AddAuxGTO`与`NewAuxJGTO`和`AddAuxJGTO`一样，只影响库伦辅助基组（/J）

  ```c++
  %basis
      NewAuxJGTO 8 # new auxiliary basis for oxygen
          s 1
          1 350 1.0
          ... etc
      end
      AddAuxJGTO 8 # add a shell to the auxiliary basis for oxygen
          D 1
          1 0.8 1.0
      end
  end
  ```

## 通过坐标部分为不同原子指定

- 如果要在特定原子（而不是元素）上放置不同的基组，则可以通过将`newgto`关键字添加到坐标部分来做到这一点
  ```c++
  ! BP86 ZORA ZORA-def2-SVP SARC/J TIGHTSCF printbasis
  *xyz 0 1
  H 0.0 0.0 0.0
  H 0.0 0.0 1.0 newgto "ZORA-def2-TZVP" end 
  *
  ```
- 类似的方式使用`AddGTO`关键字，向特定原子添加额外的基函数

  ```c++
  ! BP86 ZORA def2-SVP SARC/J TIGHTSCF printbasis
  *xyz 0 1
  H 0.0 0.0 0.0
  H 0.0 0.0 1.0 
  addgto
  P   1
    1      0.0356900              1.0000000
  end
  *
  ```
- 也可以在`%coords`中指定：
  ```c++
  #为C增加指数为1的d层，为O新指定6-311G基组并增加指数为1.2的d层
  %coords
      CTyp = Internal; 
      Units = Angs;
      Charge = 0; 
      Mult = 1;
      Coords # start coordinate assignments
          C(1) 0 0 0 0.00 0.0 0.00
              AddGTO
              D 1
              1 1.0 1.0
         end;
          O(2) 1 0 0 1.13 0.0 0.00
              NewGTO
                 "6-311G"
                 D 1
                  1 1.2 1.0
               end;
       end;
  end
  ```
- 类似的辅助基组`NewAuxJGTO`,`AddAuxJGTO`,`NewAuxCGTO`, `AddAuxCGTO`, `NewAuxJKGTO`, `AddAuxJKGTO`, `NewCABSGTO`, `AddCABSGTO`也是相同用法：
- 如果给一个指定原子改变了基组，并且想自动AutoAux，即使AutoAux已经在`%basis`中指定了，也必须重新在`%coords`部分重新指定。
  - eg，O指定了Def2-SVP和Def2/JK，第一个H指定了Def2-SVP和自动的"AutoAux"，第二个H指定了Def2-SVP和两个增加的极化函数，和一个更大的对所有这些函数自动辅助基组。

  ```c++
  ! Def2-SVP Def2/JK
  %basis
      NewAuxJKGTO H "AutoAux" end
  end
  %coords
      Coords
      	O 0.00 0.00 0.00
      	H -0.25 0.93 0.00
      	H 0.96 0.00 0.00
      	AddGTO
          	P 1
          	1 1.6 1.0
          	D 1
          	1 1.0 1.0
          end
     		NewAuxJKGTO 
      		"AutoAux" 
      	end
      end
  end
  ```
## 从文件中读取基组

- 缺点是不能给同一元素的不同原子分配不同的基组
- 通过复制和粘贴使用`printbasis`关键字打印的基组输出，可以方便地创建基组文件。

- 可以用`GTOName`, `GTOAuxJName`（=`GTOAuxName`）, `GTOAuxJKName`，`GTOAuxCName`：

  ```c++
  %basis
      GTOName = "MyBasis.bas"
      GTOAuxJName = "MyAuxJBasis.bas"
      GTOAuxJKName = "MyAuxJKBasis.bas"
      GTOAuxCName = "MyAuxCBasis.bas"
      STOName = "MySTOBasis.bas"
  end
  ```

- 文件格式是”GAMESS-US“ in the EMSL library，也可以自己编辑基组，辅助基组的格式也相同。

  - 比如Buenker的3-21GSP：<a id="LShell"></a>

    ```c++
    3-21GSP
    ! !开头的都是注释
    ! BASIS="3-21GSP"
    !Elements References
    !-------- ----------
    ! H - Ne: A.V. Mitin, G. Hirsch, R. J. Buenker, Chem. Phys. Lett. 259, 151 (1996)
    ! Na - Ar: A.V. Mitin, G. Hirsch, R. J. Buenker, J. Comp. Chem. 18, 1200 (1997).
    !
    HYDROGEN ! (3s) -> [2s]
    	S 2
    		1 4.50036231 0.15631167
    		2 0.68128924 0.90466909
    	S 1
    		1 0.15137639 1.00000000
    CARBON ! (6s,3p) -> [3s,2p]
    	S 3
    		1 499.24042249 0.03330322
    		2 75.25419194 0.23617745
    		3 16.86538669 0.81336259
    	L 2 （L是一个具有相同指数的s和p壳层）
    		1 0.89739483 0.24008573 0.46214684
    		2 0.21746772 0.81603757 0.66529098
    	L 1
    		1 4.52660451 1.00000000 1.00000000
    STOP
    ```

## 弥散基组









# 辅助基组

- ORCA包含许多近似，这些近似旨在显着加快计算速度，同时由于这些近似值而在计算中引入非常小的误差（通常小于基本集误差，并且小于电子结构方法误差）。这些近似通常近似各种积分，例如库仑，HF交换，MP2积分等。大多数近似都是基于 Resolution of Identity（RI）近似值（也称为密度拟合）。使用这些近似值将大大加快ORCA计算速度，因此通常建议使用。通常可以在有或没有这些近似值的情况下执行计算。
- RI近似的使用总是需要一个辅助基组，它的选择取决于被近似的积分和被使用的基组。
- 如果不想使用RI近似，可以先计算一个RI-J近似计算，再使用该轨道作为初猜去计算精确的库伦项，SCF也会很快收敛，比直接精确计算库伦项耗时会更短。

## 只存在库仑积分的RI-J近似

- RI-J近似用于近似库仑积分（J）。因为在所有计算中都存在库仑积分时，通常可以始终使用RI-J近似。纯泛函应该用RI加速而不是RIJCOSX。GGA-DFT计算默认情况下启用RI-J近似，因此不需要再指定。`NORI`关键字可用于关闭近似。
- Split-RI-J算法是RI-J算法的改进版本，通常更快，对内存的需求仅稍微多一点。仅用于SCF过程（不用于梯度，耦合的扰动方程式和TD-DFT）。要关闭`!NoSplit-RI-J`。

- 指定辅助基组：
  - def2/J：通用辅助基组by Weigend

  - SARC/J：用于ZORA/DKH中

    ```c++
    ! BP86 def2-TZVP def2/J
    ```

## 同时存在库仑和交换积分的HF和杂化泛函方法（以及post-HF中的HF步）

- HF和杂化泛函方法（例如B3LYP）的默认值为：`NORI`，即对库仑或交换积分均不近似。

### RIJONX库仑近似（对交换无近似）

- 使用`RIJONX`用于库伦积分近似，对HF交换不使用。加快库仑积分的速度，但仍保留昂贵的HF交换积分。如今通常不常用。

- 基组：

  - def2/J
  - 对于ZORA/DKH计算：使用 `SARC/J` 关键字代替decontracted 辅助基组

  ```c++
  ! B3LYP  def2-QZVP def2/J RIJONX
  ```

### RI-JK近似（对库伦和交换近似）

- `!RIJK`可以用于库仑和HF交换积分，从而比`RIJONX`更快，可用于用SCF能量和梯度（即几何优化）。
- 对于中小型分子，`RIJK`比`RIJCOSX`近似更快，但是随着分子变大，`RIJCOSX`的效率更高。 但是与`RIJCOSX`相比，误差更小，更平滑（通常低于1 mEh）。缺点是非限制（UHF / UKS）RIJK比限制（RHF / RKS）RIJK的贵两倍，而RIJCOSX则不。

- 需要一个较大的辅助基组（def2/J太小），仅使用旨在与RIJK近似配合使用的辅助基组（否则将获得相当大的RIJK误差）：

  - `def2/JK`, `cc-pVnZ/JK`, `aug-cc-pVnZ/JK` (n=T,Q,5)

  ```c++
  ! B3LYP  def2-QZVP def2/JK RIJK
  ```

### RIJCOSX近似（库伦用RI-J近似，交换用COSX数值积分）

- `！RIJCOSX`对HF交换用numerical chain-of-sphere integration（COSX），大大加快速度。用于COSX数值积分默认的COSX网格可以通过`!GridXn`更改。

- 通常推荐（但对于小分子，RIJK可能更好）。

- 需要`RI-J` 的辅助基组：

  ```c++
  ! B3LYP  def2-QZVP def2/J RIJCOSX
  ```

## RI-MP2近似（对MP2积分）相关C

- 传统的MP2计算可能非常昂贵，一般不推荐使用。对于MP2积分使用RI近似`!RI-MP2`可以大大加快计算速度

- 需要RI-C辅助基组（/C）用于**相关拟合**（MP2和耦合簇），注意，不同于一般的def2/J和def2/JK辅助基组，有多个RI-C辅助基组可用，应该根据所使用的轨道基组(或可能使用更大的/C辅助基组)来选择：

  ![](image-20210205163145343.png)

- 注意，因为一个MP2计算(post-HF方法)是以HF开始的（含有库伦和HF交换积分），因此前述(RIJONX / RIJK / RIJCOSX)也可以使用进行加速，这就需要指定多个关键字：

  ```c++
  #常规MP2
  ! MP2 def2-TZVP
  
  #对HF没有近似
  ! RI-MP2 def2-TZVP def2-TZVP/C
  
  #对HF使用RIJK近似
  ! RI-MP2 def2-TZVP def2-TZVP/C RIJK def2/JK
  
  #对HF使用RIJCOSX近似
  ! RI-MP2 def2-TZVP def2-TZVP/C RIJCOSX def2/J
  ```

## 积分变换中的RI

- RI近似被用于ORCA的积分变换，特别是在波函数理论方法中，例如DLPNO耦合簇。需要使用用户提供的辅助基组。一般建议使用/C辅助基组。

```c++
! DLPNO-CCSD(T) def2-TZVP def2-TZVP/C
```

## 误差和准确性

- 会引入RI error ，受限于辅助基组的大小。

- 由于始终存在一些RI error，因此RI和NORI计算得出的绝对能量可能会有所不同。

- RI 误差是系统ing的，在计算相对能量会抵消。但是有些分子性质可能是绝对值，对RI误差很敏感。

- RIJCOSX不仅有RI误差，还有COSX误差，这取决于COSX的格点大小、

- 测试RI类型错误是否为提供了不可忽略的错误的最简单方法是进行测试计算，有或没有近似值来计算。删除所有RI类型的关键字和所有辅助基组（对于GGA DFT计算，要使用 `NORI`关键字，其中RI为默认值），还可以选择更大的辅助基组或解压缩辅助基组（**DecontractAux**），这将减少RI误差，特别是对于核性质。

  ```c++
  ! BP86 def2-TZVP def2/J DecontractAux
  ```

- 通常，RI近似值在以最小误差加速计算方面做得很好。注意，比较有RI近似和没有RI近似的绝对总能量有时会告诉你很少的东西(总能量中总会有相当大的RI误差)。通常最好比较直接的能量差(如:反应能量)，几何或分子性质，来看看近似的效果有多好。

## 自动生成辅助基组

-  AutoAux会根据您选择的轨道基组创建一个大型辅助基组，它旨在为没有优化辅助基组的情况提供准确的辅助基组。不确定或非标准轨道基的安全选择。

- 自动构造一种通用辅助基组，可同时进行库仑拟合、交换和相关计算，和优化后的辅助基组精度相同，但是花费会是优化后的两倍。

- AutoAux的辅助基组通常比优化后的基组大，所以AutoAux最好是在优化后的辅助基组不可用的情况下使用(例如，一个特殊的外来元素)，或者可能用于检查辅助基组的依赖性。

- 可以直接使用关键词，也可以在`%basis`中指定

  ```c++
  ! AutoAux
  ```

- AutoAux的一些附加设置及其默认值：

  -  `AutoAuxSize`中：
    -  1：默认，增加低角动量壳层的最大指数
    -  2：增加所有壳层的最大指数
    -  3：直接使用原始产生最大的拟合基组

```c++
%basis
    Aux "AutoAux" #使用自动生成辅助基组
    AutoAuxSize 1 
    AutoAuxLmax false #True则将拟合基组的最大角动量增加到ORCA和轨道基组允许的最大值。
    OldAutoAux false  #Ture则选择orca3.1的生成过程
	
    # Only change the defaults below if you know what you are doing
    
    AutoAuxF[0] 20.0  # 增加最大s指数的因子
    AutoAuxF[1] 7.0   # Same for the p-shell
    AutoAuxF[2] 4.0   # d-shell
    AutoAuxF[3] 4.0  # f-shell
    AutoAuxF[4] 3.5  # g-shell
    AutoAuxF[5] 2.5  # h-shell
    AutoAuxF[6] 2.0  # i-shell
    AutoAuxF[7] 2.0  # j-shell
    
    AutoAuxB[0] 1.8 # s壳层的均匀膨胀系数
    AutoAuxB[1] 2.0 # Same for the p-shell
    AutoAuxB[2] 2.2 # d-shell
    AutoAuxB[3] 2.2 # f-shell
    AutoAuxB[4] 2.2 # g-shell
    AutoAuxB[5] 2.3 # h-shell
    AutoAuxB[6] 3.0 # i-shell
    AutoAuxB[7] 3.0 # j-shell
    
    AutoAuxTightB true # 对于高l的壳只使用B[l]，对于其余壳只使用B[0]
end
```

## 弥散轨道基组的基组

- 如果要结合RI-J，RI-JK或RIJCOSX近似使用弥散基组，诸如def2 / J或def2 / JK之类的非增强辅助基组将不再适用。这将取决于系统（阴离子最有可能出现问题）。为了安全起见，前面提到的`!AutoAux`通常会提供准确但昂贵的辅助基基组。或者可以向辅助基组添加弥散功能，但AutoAux应该是一种更安全，更轻松的选择。
- 但是有时AutoAux过程会生成一个与线性相关的辅助基组，这将导致ORCA崩溃（'Error in Cholesky Decomposition of V Matrix'）。在这种情况下，可以尝试使用可能足够大的常规辅助基组def2 / J或def2 / JK（可以通过与NORI计算进行比较来进行检查），将弥散手动添加到def2 / J或def2 / JK或修改辅助基组的AutoAux创建，例如像下面这样可以减少线性依赖性：

  ```c++
  %basis
  AutoAuxB[0] 2.0
  end
  ```

- 同样重要的是如果使用的是RIJCOSX近似值，那么使用扩散基组时默认的COSX格点有时可能不够用。
- 对于ma-def2系列，由于没有标配的辅助基组，所以会自动用autoaux关键词来自动构建。仅B97-3c和CCSD(T)-F12/cc-pVDZ with RI没法加弥散函数。

# ECP

- 如果涉及重元素，是标量相对论全电子计算的一个很好的替代方法。但是ECP并不是计算重元素的最准确方法，更精确的是标量相对论全电子方法。如果想要对重元素进行全电子描述，则建议使用标量相对论近似（ZORA或DKH）。对ECP进行参数化以隐式地考虑相对论效应不一定很准确，只有小核ECP较准。
- 化学上不相关的核电子不是电子问题的明确组成部分，可以由ECP代替。主要用于几何优化和能量计算，在性质计算中可能会出错。

## 原理

- 为了减少计算量，通常高度收缩和化学惰性的核基组可以使用ECP，ECP计算只包含价层，因此符合冻核近似。核轨道的贡献被一个单电子算符$$U^{core}$$所解释，它取代了核和价电子之间的相互作用，并解释了电子的不可区分性。其径向部分$$U_l(r)$$一般表示为高斯函数的线性组合，而角动量算符$$\left|S_{m}^{l}\right\rangle$$则包含了角依赖关系。

$$
\begin{array}{c}
U^{\text {core }}=U_{L}(r)+\sum_{l=0}^{L-1} \sum_{m=-l}^{l}\left|S_{m}^{l}\right\rangle\left[U_{l}(r)-U_{L}(r)\right]\left\langle S_{m}^{l}\right| \\
U_{l}=\sum_{k} d_{k l} r^{n_{k l}} \exp \left(-\alpha_{k l} r^{2}\right)
\end{array}
$$

- 最大角动量$$L$$通常被定义为$$l^{atom}_{max}+1$$，评估ECP积分所必需的参数$$n_{kl}$$、$$\alpha_{kl}$$和$$d_{kl}$$参数有许多作者发表，其中著名的Los Alamos (LANL)和Stuttgart-Dresden (SD)参数集。依赖于ECP的具体参数化，相对论效应可以包括在半经验的方式，否则是非相对论计算。将$$U^{core}$$引入电子哈密顿量可以得到两种类型的ECP积分，一种是由最大角动量势$$U_L$$产生的局部积分，另一种是由投影势项产生的半局部积分。

## 适用范围

- 如果分子不包含重于Kr的元素，那么通常不应该使用ECP，应该使用全电子方法。对元素H-Kr使用def2-XVP或cc-pVnZ基本集，不会自动分配任何ECP。
- 不建议对第一个TM行原子使用LANL2DZ和SDD基组ECP组合，因为它们的准确性较差，非相对论/相对论全电子计算要好得多。

- 如果分子中含有一种重元素(比Kr重)，例如在典型的过渡金属配合物中，使用ECP可能没有太大的优势。使用全电子相对论近似可以获得更准确的结果，并且几乎一样快。
- 如果分子中含有很多重元素(比Kr重)，那么ECPs就有最大的优势(尽管梯度会变得昂贵)。使用全电子标量相对论方法的单点计算对于更精确的能量或性质计算更好。
- 在某些情况下要处理很重的元素以至于在使用全电子标量相对论方法（ZORA，DKH）时会遇到数值问题。使用ECP更好，特别是对于几何优化步骤。
- 对不同ECP的评估发现，一些流行的ECP不太准确。通常推荐the Stuttgart ECPs (e.g. the ones called ECPXXMWB in the [Stuttgart library](http://www.theochem.uni-stuttgart.de/pseudopotentials/clickpse.en.html), also called SDD or def2-SD)以及def2基组一起使用。另外，应该始终使用推荐的基组ECP组合，不要混合使用。
- 注意:Ahlrichs等人在def2基组论文中描述的def2-ECPs是Stuttgart ECPXXMWB potentials，只是跳过了ECPs的g-和更高的投影(因为此类投影在Turbomole中不可用)。而orca没有这个限制，所以全部的Stuttgart ECPs都被实现了。在比较相对能量时，这应该不会产生明显的差异，但是不同代码之间的绝对能量可能会不同。

## 指定方式

- **各种指定方式 只包含了核，不包含价层，价层基组不要漏**

### 关键词

- 用关键词指定ECP，orca中可用的ECP关键词列于**6.3.3 Eective Core Potentials**的**Table 6.5**

  ```c++
  ! def2-TZVP def2-SD
  ```

- 对于`def2-X`基组，`def2-ECP`会自动用于重于Kr的元素，自动用的是Stuttgart-Dresden effective core potentials for elements Rb-Rn。上例中如果没有`def2-SD`，会自动分配`Def2-ECP`

- cc-pvnz-pp中也会自动分配ECP

  ```c++
  ! B3LYP def2-SVP printbasis
  * xyz 0 1
  Mo 0 0 0
  F  0 0 1
  C  0 0 2
  H 0 0 3
  *
  ```

- `printbasis`关键字对于检查是否向每个元素添加了正确的基组和ECP非常有用。ORCA输出显示ECP被分配是：

  ```c++
  Your calculation utilizes the basis: def2-SVP
     F. Weigend and R. Ahlrichs, Phys. Chem. Chem. Phys. 7, 3297 (2005).
  
  cite the ECPs for Mo [Def2-ECP] as follows:
  Ce-Yb(ecp-28): M. Dolg, H. Stoll, H.Preuss, J. Chem. Phys., 1989, 90, 1730-1734.
  Y-Cd(ecp-28), Hf-Hg(ecp-46): D. Andrae,U. Haeussermann, M. Dolg, H. Stoll, H. Preuss, Theor. Chim. Acta, 1990, 77, 123-141.
  In-Sb(ecp-28), Tl-Bi(ecp-46): B. Metz, H. Stoll, M. Dolg, J. Chem. Phys., 2000, 113, 2563-2569.
  Te-Xe(ecp-28), Po-Rn(ecp-46): K. A. Peterson, D. Figgen, E. Goll, H. Stoll, M. Dolg, J. Chem. Phys., 2003, 119, 11113-11123.
  Rb(ecp-28), Cs(ecp-46): T. Leininger, A. Nicklass, W. Kuechle, H. Stoll, M. Dolg, A. Bergner, Chem. Phys. Lett., 1996, 255, 274-280.
  Sr(ecp-28), Ba(ecp-46): M. Kaupp, P. V. Schleyer, H. Stoll and H. Preuss, J. Chem. Phys., 1991, 94, 1360-1366.
  La(ecp-46): M. Dolg, H. Stoll, A. Savin, H. Preuss, Theor. Chim. Acta, 1989, 75, 173-194.
  Lu(ecp-28): X. Cao, M. Dolg, J. Chem. Phys., 2001, 115, 7348-7355.
  
  ECP parameters for Mo [Def2-ECP] have been obtained from:
  TURBOMOLE (7.0.2)
  
  ...
  -------------------------
  ECP PARAMETER INFORMATION
  -------------------------
  
   Group 1, Type Mo ECP Def2-ECP (replacing 28 core electrons, lmax=3)
  
  Atom   0Mo   ECP group =>   1
  ```

### %basis

- 例子：在轻原子上指定较小的def2-SVP，在重元素上指定更大的基组和ECP：

  ```c++
  ! BP def2-SVP def2/J  printbasis
  
  %basis
  	newgto Mo "def2-TZVP" end
  end
      
  * xyz 0 1
  Mo 0 0 0
  F  0 0 1
  C  0 0 2
  H 0 0 3
  *
  ```

- 通过在`%basis`中通过`ECP`和`newECP`指定，只作用于ECP而不作用于价层上。

  ```c++
  %basis
      ECP "def2-ECP" # All elements (for which the ECP is defined)
      NewECP Pt "def2-SD" end # Different ECP for Pt
  end
  ```

- 也可以为单个原子指定

  ```c++
  * xyz ...
      ...
      S 0.0 0.0 0.0 NewECP "SDD" end
      ...
  *
  ```

- 为单个原子用`NewGTO`的时候，可能需要用`DelECP`移除ECP再添加新的：

  ```c++
  ! LANL2DZ # Uses HayWadt ECPs by default, starting from Na
  %basis
      NewGTO S "Def2-TZVP" end # All-electron up to Kr
      DelECP S # Remove HayWadt ECP
  end
  * xyz ...
      ...
      Cu 0.0 0.0 0.0
      DelECP # Remove HayWadt ECP
      NewGTO "Def2-QZVPP" end # All-electron up to Kr
  ...
  *
  ```

### 手动输入ECP参数

- 首先用`NewECP`，然后再跟上要指定的元素，核电子数，最大的角动量

  ```c++
  %basis
      NewECP element
          N_core (number of core electrons)
          lmax (max. angular momentum)
          [shells]
      end
  end
  ```

- ECP的指定通过给出构成依赖于角度的电势$$U_l$$的各个壳的定义来完成。

  - 首先要给出角动量，然后跟着原始基函数的数目
  - 原始基函数通过一个序号和指数$$a_{kl}$$l、扩展系数dkl$$d_{kl}$$和径向指数$$n_{kl}$$来指定

  ```c++
  # ECP shell
      l (number of primitives)
      1 a1l d1l n1l
      2 a2l d2l n3l
  ...
  ```

- 例子：V的SD(10,MDF)

  - 名称表明一个Stuttgart-Dresden型ECP，取代10核心电子和派生自中性原子的相对论计算.它由角动量s p d f的4个壳层组成。注意f壳层的扩展系数为0.0，因此对有效核势没有任何贡献。

```c++
# ECP SD(10,MDF) for V
# M. Dolg, U. Wedig, H. Stoll, H. Preuss,
# J. Chem. Phys. 86, 866 (1987).
NewECP V
    N_core 10
    lmax f
    s 2
        1 14.4900000000 178.4479710000 2
        2 6.5240000000 19.8313750000 2
    p 2
        1 14.3000000000 109.5297630000 2
        2 6.0210000000 12.5703100000 2
    d 2
        1 17.4800000000 -19.2196570000 2
        2 5.7090000000 -0.6427750000 2
    f 1
        1 1.0000000000 0.0000000000 2
end
```

# 相对论基组

- 使用Ahlrichs def2基组时，ORCA默认会为定义了def2-ECP（元素> Kr）的重元素查找ECP。但是，如果要求进行全电子相对论计算（ZORA或DKH），则需要选择正确的相对论基组。

- 如果使用推荐的基组，在ORCA的DFT计算中使用标量相对论方法很容易
- Ahlrichs def2基组系列已重新收缩来用于ZORA或DKH2计算，应选择def2-XVP基的相对论性收缩。
- 对于相对论WFT计算，可以使用相对论Douglas-Kroll相关一致基组cc-pVnZ-DK基组。
- 对于仅使用ECP（第三行过渡金属行等）才能使用标准def2-XVP基组的元素，应该使用分段的全电子相对论收缩（SARC）基组

- 随着元素变得越来越重，对于DFT中的交换相关项，ZORA或DKH2方法需要甚至更密的格点。
  - 对于非常重的元素（第三行及以下）的计算，有时需要指定最大的角度格点（Grid7），然后大幅增加径向格点（甚至是IntAcc 10-20）。因此可能需要对新分子系统的格点依赖性进行手动探索

## DFT中的单点ZORA/DKH2计算和Ahlrichs & SARC基组

### H-Kr

- 使用**ZORA或DKH2方法**：
  - 基组ZORA-def2-TZVP是全电子def2-TZVP Ahlrichs基组的相对论版，直接在前面加入`DKH-`或者`ZORA-`
  - 注意，对于其他非相对论基组(例如Pople-style基础)没有执行重缩，因此计算会不一致

```c++
! B3LYP ZORA ZORA-TZVP ...
```

- 如果需要使用辅助基组，建议使用解压缩的def2/J辅基组，通过`! SARC/J`定义，对于相对论ZORA / DKH计算更准确

```c++
! BP86 ZORA ZORA-def2-SVP SARC/J
```

```c++
! BP86 DKH2 DKH-def2-SVP SARC/J

*xyz 0 1
H 0 0 0
F 0 0 1
*
```

### Rb-I

- 周期表中的这一行def2-XVP仅仅是价基组+core的def2-ECP
- 在ORCA 4.0中没有有效的`ZORA-def2-TZVP`或  `DKH-def2-TZVP`关键字。为了大致再现旧的ORCA行为，可以使用关键字 `old-ZORA-TZVP`和`old-DKH-TZVP`。

```c++
! BP86 ZORA ZORA-def2-TZVP SARC/J  
%basis 
NewGTO Mo "old-ZORA-TZVP" end
end

*xyz 0 1
H 0 0 0 
F 0 0 1
Mo 0 0 2
*
```

```c++
! BP86 DKH DKH-def2-TZVP SARC/J  
%basis 
NewGTO Mo "old-DKH-TZVP" end
end

*xyz 0 1
H 0 0 0 
F 0 0 1
Mo 0 0 2
*
```

### Xe-Rn、Ac-Lr

- 如果包含重元素，例如第三过渡金属行原子、镧系、锕系和6p元素，必须明确定义**SARC基组**和`SARC/J`
- 例子：为所有内容定义`ZORA-def2-TZVP`（对于H和F，由于Pt没有可用的`ZORA-def2-TZVP`，因此将忽略Pt）；然后使用`％basis`块定义Pt的`SARC-ZORA-TZVP`基组

```c++
! BP86 ZORA ZORA-def2-TZVP SARC/J  
%basis 
NewGTO Pt "SARC-ZORA-TZVP" end
end

*xyz 0 1
H 0 0 0 
F 0 0 1
Pt 0 0 2
*
```

```c++
! BP86 DKH DKH-def2-TZVP SARC/J  
%basis 
NewGTO Pt "SARC-DKH-TZVP" end
end

*xyz 0 1
H 0 0 0 
F 0 0 1
Pt 0 0 2
*
```

## 用弥散函数和ZORA、DKH

如果ZORA / DKH2 DFT计算中需要弥散函数，则建议使用最小扩展的def2 ZORA / DKH基组：

```
ma-ZORA-def2-SV（P）（H-Rn）
ma-ZORA-def2-SVP （H-Rn）
ma-ZORA-def2-TZVP （H-Rn）
ma-ZORA-def2-TZVP（-f） （H-Rn）
ma-ZORA-def2-TZVPP （H-Rn）
ma-ZORA-def2-QZVP （H-Rn）
ma-ZORA-def2-QZVPP （H-Rn）
```

```
ma-DKH-def2-SV（P） （H-Rn）
ma- DKH -def2-SVP （H-Rn）
ma- DKH -def2-TZVP （H-Rn）
ma- DKH -def2-TZVP（-f） （H-Rn）
ma- DKH -def2-TZVPP （H-Rn）
ma- DKH -def2-QZVP （H-Rn）
ma- DKH -def2-QZVPP （H-Rn）
```

**对于WFT计算**，aug-cc-VnZ-DK系列更好：

```
aug-cc-pVDZ-DK（H-Ar，Sc-Kr）
aug-cc-pVTZ-DK （H-Ar，Sc-Kr，Y-Xe，Hf-Rn） 
aug-cc-pVQZ-DK （H-Ar，Sc-Kr，In-Xe，Tl-Rn） 
aug-cc-pV5Z-DK （H-Ar，Sc-Kr）
```

## 几何优化with ZORA/DKH

- 由于在几何优化中使用了单中心近似，因此ZORA / DKH2几何优化产生的能量与单点计算产生的能量不同。注意不要混淆优化和单点相对论工作的能量。

- 请注意，重元素分子的几何优化通常使用ZORA比使用DKH更稳定。这似乎是由于ZORA的格点灵敏度降低所致。因此通常建议使用ZORA。

  ```
  ! BP86 def2-TZVP SARC/J ZORA Opt
  ```

  ```
  ! BP86 def2-TZVP SARC/J DKH2 Opt
  ```

## 相对论分子性质

- 由于所谓的 picturechange效应，使用标量相对论哈密顿量计算的分子特性可能会变得复杂

- - ZORA中， 磁性不需要picture change

  - ZORA中，电性质原则上需要picture change，但是由于ZORA缺乏gauge invariance，结果不好。一种解决方法是使用van Lenthe定义的所谓的ZORA-4密度。这是在ORCA中将**picturechange**设置为**true**时得到的。但是，这似乎并没有通过完全相对论的四分量计算来改善一致性。

  - DKH中，电性质的picture change相对容易，应该包括

  - DKH中，变换依赖于矢量电视，因此picture change对磁的影响很复杂，orca也实现了picture change的效果

    ```
    %rel picturechange  true end
    ```

- 如果基组接近完整，则所有相对论计算都将变为奇异，因为相对论轨道会随着点原子核发散。解决方法是使用有限核。有限核模型：

  ```
  %rel FiniteNuc true/false end
  ```

  