---
title: NBO
typora-root-url: NBO
mathjax: true
date: 2020-11-27 22:13:28
updated:
tags: NBO
categories: 计算化学
description: NBO的一些使用方法
---



# 一般关键词

## MEMORY

按字、兆、兆字节或千兆字节分配动态内存，比如分配1G的内存可以用：

```
MEMORY=134217728
MEMORY=134mw
MEMORY=1024mb
MEMORY=1gb
```





# 自然共振理论分析NRT

## 输入

两种关键词指定

- 在.47文件中`$NBO`和`$END`之间写上`NRT`关键词即可
- `NRTSML`或`NRTSML=n`：把所有贡献大于1%或n%的共振结构式一起输出到FIlename-nrt.cml中,可以直接用MarvinView观看。
  - 注意，MarvinView中应选择View→Implicit→Hydrogens→Off，否则会自动显示一些不该存在的氢。

其他`$NBO`和`$END`之间的关键词：

- `NRTLST=n`：将权重大于`n`的结构输出在`$NRTSTR`部分。默认情况下仅打印参考结果。
- `NRT <atom-1 atom-2 ... atom-n>`：在NRT关键词后面的尖括号里写上共振分析要考虑的原子范围即可进行局部的NRT分析。

其他模块：

NBO轨道自动搜索结果随结构变化不是连续的，对于通过NRT考察化学过程电子结构的变化，为了满足分析数据的连贯性有意义，需要指定`NRTSTR`。

比如化学反应可以视为体系的电子结构是从反应物的Lewis结构平滑过渡到产物Lewis结构的。对过渡态结构，以及IRC路径上一系列点做NRT分析，应当在输入文件里通过$`NRTSTR`字段直接给出反应物和产物的Lewis结构定义作为参考结构，而不能让NBO自动判断，否则IRC上一系列点的NRT分析结果会突变（比如参考Lewis结构权重的变化曲线）。

- `$NRTSTR……$END`：在输入文件里指定了`$NRTSTR`字段，则NRT分析时会直接利用这些参考Lewis结构，而不会尝试自动搜索和判断。格式和`$CHOOSE`基本相同：

  - 第一行是`$NRTSTR`，最后一行是`$END`。注意开壳层要分别指定α和β电子，用`$NRTSTRA`和`$NRTSTRB`代替`$NRTSTR`

  - 中间是用`STRUCTURE`或者`STR`和`END`封装的，用`LONE`和`BOND`指定每个共振结构的所有价电子孤对和键的完整说明（注意忽略内层轨道），不像`$CHOOSE`支持`CBOND`

  - 最好放在`$NBO`、`$CORE`、`$CHOOSE`模块之后，`$DEL`模块之前NRTSTR，而且对于开壳层，不能同时存在`$CHOOSE`和`$NRTSTR`

  - eg.

    ![](image-20201130224813391.png)

  ```
  $NRTSTR
  	STR1 ! C1 anion center
  		LONE 1 1 END
  		BOND S 1 2 S 1 4 S 1 5 D 2 3 S 2 6 S 3 7 S 3 8 END
  	END
  	STR2 ! C3 anion center
  		LONE 3 1 END
  		BOND D 1 2 S 1 4 S 1 5 S 2 3 S 2 6 S 3 7 S 3 8 END
  	END
  $END
  ```

  

## 输出例子

### 烯丙基自由基开壳层计算出的alpha电子

<img src="image-20201130221142052.png" style="zoom:50%;" />

- 第3行和第4行表示最多允许的参考Lewis结构和全部Lewis结构的数目
- 第5行当前任务需要多少内存
- 第10~12行表示当前体系共发现3个参考Lewis结构（有一定的多中心离域性，因此一种结构无法描述）
- 第13~15行：
  - `rho*`表示主导的参考Lewis结构的non-Lewis电子为0.04795
  - `f(w)`表示基于这个参考Lewis结构再考虑其它二级Lewis结构后对体系的描述比起只考虑当前一种Lewis结构时的改进。越接近1改进越大（共振效应越显著），越接近0改进越小。
- 第17行中：
  - `D(W)`只考虑这三种参考Lewis结构并变分优化其系数后剩下的残值。越小说明靠这些参考Lewis结构就越已经足够描述实际电子结构了
  - `F(W)`：在参考Lewis结构基础上再考虑其它二级Lewis结构后对体系电子结构描述的改进程度

```
NATURAL RESONANCE THEORY ANALYSIS, alpha spin:

Maximum reference structures : 20
Maximum resonance structures : 5000
Memory requirements : 89064896 words of 99790766 available

7 candidate reference structure(s) calculated by SR LEWIS
0 candidate reference structure(s) added by SR HBRES
Initial loops searched 9 bonding pattern(s); 3 were retained
Delocalization list threshold set to 0.50 kcal/mol for reference 1
Delocalization list threshold set to 0.50 kcal/mol for reference 2
Delocalization list threshold set to 0.50 kcal/mol for reference 3
Reference   1:  rho*=0.17534, f(w)=0.96619 converged after  22 iterations
Reference   2:  rho*=0.17534, f(w)=0.96619 converged after  22 iterations
Reference   3:  rho*=0.31532, f(w)=0.98329 converged after  22 iterations
Multi-ref( 3):  D(W)=0.10221, F(W)=0.00000 converged after 117 iterations
1 reference structure has low weight (<35.0% of 41.1%); discarded
Multi-ref( 2):  D(W)=0.10221, F(W)=0.00000 converged after   1 iterations
```

- 对这三种参考Lewis式通过严格变分得到的权重

```
                                               fractional accuracy f(w)
                 non-Lewis             -------------------------------------
 Ref     Wgt      density      d(0)      all NBOs     val+core     valence
----------------------------------------------------------------------------
  1    0.50000    0.17534    0.02667     0.96619      0.97754      0.97754
  2    0.50000    0.17534    0.02667     0.96619      0.97754      0.97754
```

- 主导的参考Lewis结构对应的拓扑矩阵：
  - 非对角元是原子间形式键级
  - 对角元是原子上的孤对电子数

```
 TOPO matrix for the leading resonance structure:

     Atom  1   2   3   4   5   6   7   8
     ---- --- --- --- --- --- --- --- ---
   1.  C   1   1   0   1   1   0   0   0
   2.  C   1   0   2   0   0   1   0   0
   3.  C   0   2   0   0   0   0   1   1
   4.  H   1   0   0   0   0   0   0   0
   5.  H   1   0   0   0   0   0   0   0
   6.  H   0   1   0   0   0   0   0   0
   7.  H   0   0   1   0   0   0   0   0
   8.  H   0   0   1   0   0   0   0   0
```

- 第一列中有星号的是参考Lewis结构，权重非常小的Lewis结构直接合并显示其权重总和
- 第二列是各个Lewis结构的最终的权重
- 相对于主导的参考Lewis结构的拓扑关系的变化
  - 没加括号的是增加的项
  - 有括号的是程除的项
  - 单个原于的项是指给其增加一个或去掉一个电子

```
        Resonance
   RS   Weight(%)                  Added(Removed)
---------------------------------------------------------------------------
   1*     48.55
   2*     48.55    C  1- C  2, ( C  2- C  3), ( C  1),  C  3
   3       0.19    C  1- C  2, ( C  1- H  4), ( C  2- C  3),  C  3
   4       0.19   ( C  1- C  2),  C  2- C  3, ( C  3- H  8),  C  1
   5       0.19    C  1- C  2,  C  1- C  2, ( C  1- H  4), ( C  2- C  3),
                  ( C  2- C  3), ( C  1),  C  3,  C  3
   6       0.19   ( C  3- H  8),  C  3
   7       0.19    C  1- C  2, ( C  1- H  5), ( C  2- H  6),  H  5
   8       0.19    C  2- C  3, ( C  2- H  6), ( C  3- H  7),  H  7
   9       0.19    C  1- C  2,  C  1- C  2, ( C  1- H  5), ( C  2- C  3),
                  ( C  2- H  6), ( C  1),  C  3,  H  5
  10       0.19    C  1- C  2, ( C  2- H  6), ( C  3- H  7), ( C  1),
                   C  3,  H  7
  11       0.19    C  1- C  2, ( C  1- H  5), ( C  2- H  6),  H  6
  12       0.19    C  2- C  3, ( C  2- H  6), ( C  3- H  7),  H  6
  13       0.19    C  1- C  2,  C  1- C  2, ( C  1- H  5), ( C  2- C  3),
                  ( C  2- H  6), ( C  1),  C  3,  H  6
  14       0.19    C  1- C  2, ( C  2- H  6), ( C  3- H  7), ( C  1),
                   C  3,  H  6
  15       0.10   ( C  1- C  2),  C  2- C  3, ( C  3- H  8),  H  8
  16       0.10    C  1- C  2, ( C  1- H  4), ( C  2- C  3),  H  4
  17       0.10   ( C  3- H  8), ( C  1),  C  3,  H  8
  18       0.10    C  1- C  2,  C  1- C  2, ( C  1- H  4), ( C  2- C  3),
                  ( C  2- C  3), ( C  1),  C  3,  H  4
  19-26    0.22
---------------------------------------------------------------------------
         100.00   * Total *                [* = reference structure]
```

- 对角元代表平均携带的孤对电子数
- 非对角元代表两个原子之间的NRT键级、共价和离子的贡献。（由于只有一个自旋的结果，大约是期望值的一半）

```
Natural Bond Order:  (total/covalent/ionic)

    Atom       1      2      3      4      5      6      7      8
    ----   ------ ------ ------ ------ ------ ------ ------ ------
  1.  C  t 0.2523 0.7529 0.0000 0.4970 0.4962 0.0000 0.0000 0.0000
         c   ---  0.5616 0.0000 0.3795 0.3817 0.0000 0.0000 0.0000
         i   ---  0.1912 0.0000 0.1176 0.1145 0.0000 0.0000 0.0000

  2.  C  t 0.7529 0.0011 0.7529 0.0000 0.0000 0.4921 0.0000 0.0000
         c 0.5616   ---  0.5616 0.0000 0.0000 0.3986 0.0000 0.0000
         i 0.1912   ---  0.1912 0.0000 0.0000 0.0935 0.0000 0.0000

  3.  C  t 0.0000 0.7529 0.2523 0.0000 0.0000 0.0000 0.4962 0.4970
         c 0.0000 0.5616   ---  0.0000 0.0000 0.0000 0.3817 0.3795
         i 0.0000 0.1912   ---  0.0000 0.0000 0.0000 0.1145 0.1176

  4.  H  t 0.4970 0.0000 0.0000 0.0010 0.0000 0.0000 0.0000 0.0000
         c 0.3795 0.0000 0.0000   ---  0.0000 0.0000 0.0000 0.0000
         i 0.1176 0.0000 0.0000   ---  0.0000 0.0000 0.0000 0.0000

  5.  H  t 0.4962 0.0000 0.0000 0.0000 0.0019 0.0000 0.0000 0.0000
         c 0.3817 0.0000 0.0000 0.0000   ---  0.0000 0.0000 0.0000
         i 0.1145 0.0000 0.0000 0.0000   ---  0.0000 0.0000 0.0000

  6.  H  t 0.0000 0.4921 0.0000 0.0000 0.0000 0.0041 0.0000 0.0000
         c 0.0000 0.3986 0.0000 0.0000 0.0000   ---  0.0000 0.0000
         i 0.0000 0.0935 0.0000 0.0000 0.0000   ---  0.0000 0.0000

  7.  H  t 0.0000 0.0000 0.4962 0.0000 0.0000 0.0000 0.0019 0.0000
         c 0.0000 0.0000 0.3817 0.0000 0.0000 0.0000   ---  0.0000
         i 0.0000 0.0000 0.1145 0.0000 0.0000 0.0000   ---  0.0000

  8.  H  t 0.0000 0.0000 0.4970 0.0000 0.0000 0.0000 0.0000 0.0010
         c 0.0000 0.0000 0.3795 0.0000 0.0000 0.0000 0.0000   ---
         i 0.0000 0.0000 0.1176 0.0000 0.0000 0.0000 0.0000   ---
```

- 每个原子的自然原子价（体现成键的数目），以及共价和离子的贡献量

```
Natural Atomic Valencies:

                     Co-    Electro-
    Atom  Valency  Valency  Valency
    ----  -------  -------  -------
  1.  C    1.7461   1.3228   0.4233
  2.  C    1.9978   1.5218   0.4760
  3.  C    1.7461   1.3228   0.4233
  4.  H    0.4970   0.3795   0.1176
  5.  H    0.4962   0.3817   0.1145
  6.  H    0.4921   0.3986   0.0935
  7.  H    0.4962   0.3817   0.1145
  8.  H    0.4970   0.3795   0.1176
```

- 最后以SNRTSTR字段的格式输出各个参考Lewis结构的表示。

```
$NRTSTRA
  STR        ! Wgt = 48.55%
    LONE 1 1 END
    BOND S 1 2 S 1 4 S 1 5 D 2 3 S 2 6 S 3 7 S 3 8 END
  END
  STR        ! Wgt = 48.55%
    LONE 3 1 END
    BOND D 1 2 S 1 4 S 1 5 S 2 3 S 2 6 S 3 7 S 3 8 END
  END
$END
```

