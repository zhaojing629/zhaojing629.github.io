---
title: 【molpro】04.多组态计算
typora-root-url: 【molpro】04.多组态计算
mathjax: true
date: 2019-11-17
updated:
tags: [molpro, 多组态,CASSCF,MCSCF]
categories: [计算化学, 软件]
description: CASSCF以及一般MCSCF计算
---





# 一般输入结构

1. 用命令`MULTI`或`MCSCF`调用程序。
2. 定义轨道空间分区的卡：`OCC`，`FROZEN`，`CLOSED`
3. 一般选项
4. `WF`卡，定义态的对称性
5. 与态对称性有关的选项：`WEIGHT`,`STATE`,`LQUANT`
6. 态对称性的组态定义：`SELECT`,`CON`,`RESTRICT`
7. 定义态对称性的主要组态：`PSPACE`
8. 更多的一般选项。

4~8可以重复几次，指定对于不同对称性的几个态的能量做平均。

## `MULTI`/`CASSCF`调用程序

全活性空间自洽场`CASSCF`，此命令的别名是`mcscf`或`multi`。这个命令后面可选地跟着定义波函数的进一步输入。

```
casscf
```

该命令行后面可以接：

- `MAXIT`：最大迭代数（默认10）
- `ENERGY`：能量收敛阈值
- `GRADIENT`：梯度收敛阈值
- `STEP`：步长收敛阈值
- `FAILSAFE`：（逻辑型）使用更稳定的收敛选项

## `OCC`，`FROZEN`，`CLOSED`轨道子空间的定义

在一个CASSCF波函数中，已占据轨道空间被划分为一组非活性或闭壳层轨道和一组活性轨道：

- 所有的非活性轨道在每个Slater行列式中都被双占据。
- 活性轨道有不同的占据，所有可能的Slater行列式(或conﬁguration state functions，CSFs)都被考虑在内，通过把N<sub>act</sub>（=N<sub>el</sub>-2m<sub>closed</sub>）个电子以各种可能的方式分布在活性轨道中。（在m<sub>closed</sub>是封闭外壳的数量(不活跃)轨道，N<sub>el</sub>是电子的总数）因此，它对应于活性空间中的一个完整CI。

具体定义方法

- `occ,m1,m2……m8;`定义每个对称性中的占据轨道：
  - 如果没有给定，默认来自最近的MCSCF计算。如果没有，则使用最小的价轨道集的轨道，即使用全部价轨道空间。
- `FROZEN,n1,n2,...,record.file;`定义每个对称性中的冻芯轨道，这些轨道在全部组态中都是双占据的，并且不会被优化。
  - `record.file`是冻芯轨道的记录名称；如果没有提供，来自`START`卡的`orb`。`record.file`可以在最后一个非零`ni`之后的任何位置指定。如果轨道初始猜测来自邻近的几何结构，它必须给出，接下来要定义在当前结构计算的SCF轨道。如果使用当前波函进行随后的梯度计算，那么record.file 是强制的，而且必须指定当前结构的闭壳层SCF轨道。注意，`record`必须大于2000。
  - 如果没有给定，默认来自最近的MCSCF计算。如果没有则不做轨道冻结。
  - 如果给定为`FROZEN,record.file`使用对应原子内壳层的轨道冻结，即Li-Ne是1s，Na-Ar是1s2s2p等
  - 没有任何说明的`FROZEN`卡把冻芯轨道数重新设置为0。

- `closed,n1,n2,……n8;`定义每个对称性中非活性的轨道，包含所有的`FROZEN`轨道，它们在所有的CSF中都是双占据的；但是与`FROZEN`轨道相反，这些轨道是完全优化的。
  - 如果忽略`CLOSED`卡，那么默认数据来自最近的MCSCF计算，如果没有则使用原子内壳层。
  - m<sub>i</sub>≥n<sub>i</sub>，每一个不可约表示中的**活性轨道数目为m<sub>i</sub>-n<sub>i</sub>**
- `FREEZE,orb.sym;`指定的轨道将不被优化，仍保持和初始猜测相同
  - `orb.sym` 应当是一个活性或闭壳层轨道，如果是`FROZEN`冻芯轨道，这个卡不起作用。

### 选择轨道的方法

一般有两种选法：

- 看原子的价层轨道
- 看分子的成键和反键轨道

可以先算个hf来看看`molden`文件中的轨道，注意输出的轨道`print,orbital`只输出占据轨道，通过`print,orbital=n`来控制输出的最低的空轨道数目。

## `WF`定义被优化的态

每个需要优化的态的对称性用一个WF卡定义：

```
WF,elec,sym,spin
```

- 之后可以选择接`STATE`，`WEIGHT`，`RESTRICT`，`SELECT`，`CON`，和/或`PSPACE`卡来定义这个WF卡 ，这些卡总是指前一个WF卡定义的态对称性，但是各个卡之间的顺序是任意的。

## 例子

如果全部选择默认，那么甲醛的CASSCF计算最简单的输入是：

```
***,formaldehyde
print,orbitals,civector   ! 打印轨道和CI矢量
                          
angstrom
geometry={   
C
O  , C , rco
H1 , C , rch , O , hco
H2 , C , rch , O , hco , H1 , 180
}
rco=1.182 Ang
rch=1.102 Ang
hco=122.1789 Degree

basis=vdz
hf                     !执行HF计算
casscf                 !实行CASSCF计算，用HF轨道作为初猜
```

- 默认下碳和氧的1s轨道是非活性的，而碳和氧的2s、2p和氢的1s轨道是活性的，因此和以下定义相同：

  ```
  {casscf
  closed,2               !2 inactive orbitals in Symmetry 1 (a1)
  occ,7,2,3              !7a1, 2b1, 3b2 occupied orbitals
  wf,16,1,0}             !16 electrons, Symmetry 1 (A1), singlet
  ```

  - 有5个a<sub>1</sub>，2个b<sub>1</sub>，3个b<sub>2</sub>活性轨道。这产生了3644个CSFs或11148个Slater行列式。注意，wf指令必须在`occ`和`closed`指令之后给出。

- 如果使氧的2s轨道变成非活性，其膨胀时间就会缩短，只生成了1408个CSFs或4036个Slater行列式。

  ```
  {casscf
  closed,3               !3 inactive orbitals in Symmetry 1 (a1)
  occ,7,2,3              !7a1, 2b1, 3b2 occupied orbitals
  wf,16,1,0}             !16 electrons, Symmetry 1 (A1), singlet
  ```



# 态平均MCSCF

为了计算激发态，通常最好对所考虑的所有状态的平均能量进行优化。这避免了优化过程中的根本问题，并为所有状态生成一组折衷轨道。

- 通过`STATE,nstate;`定义当前对称性中态的数量，默认所有的态都用权重1来优化，它必须直接跟随在wf指令之后

  ```
  wf,16,1,0;state,2 !optimize two states of symmetry 1
  ```

- 可以优化不同对称性的状态。在这种情况下，几个wf /state指令可以相互遵循：

  ```
  wf,16,1,0;state,2 !optimize two states of symmetry 1 
  wf,16,2,0;state,1 !optimize one states of symmetry 2
  ```

- `WEIGHT,w(1),w(2),...,w(nstate);`定义态平均计算中的权重，`w(i)`是当前对称性第i个态的权重。所有的权重默认都是1.0。

  - <font color=red>**如果只想优化特定态对称性的第二个态，可以指定:**</font>

    ```
    STATE,2;WEIGHT,0,1;
    ```

    但是注意，这可能会导致根的跳跃问题。

  - 优化对称性1的两个态，第一个权重0.2，第二个0.8

    ```
    wf,16,1,0;state,2;weight,0.2,0.8
    ```

- 例子：对O<sub>2</sub>的状态平均计算，其中将$^1\Sigma^+_g$，$^3\Sigma_g^-$，$^1\Delta_g$放在一起处理：（在本例中，对具有不同自旋多重性的状态进行平均只对CASSCF可行，而对限制更严格的RASSCF或MCSCF波函数则不可行。）

  ```
  ***,O2
  print,basis,orbitals
  geometry={                 
  o1
  o2,o1,r
  }
  r=2.2 bohr                 
  basis=vtz
  {hf
  wf,16,4,2
  occ,3,1,1,,2,1,1
  open,1.6,1.7}
  
  {casscf                    !invoke CASSCF program
  wf,16,4,2                  !triplet Sigma-
  wf,16,4,0                  !singlet delta (xy)
  wf,16,1,0}                 !singlet delta (xx - yy)
  ```



# `restrict`占据限制

由于CSFs或Slater行列式的数量以及计算成本会随着活动轨道的数量而迅速增加，所以最好使用更小的CSFs集合。选择的一种方法是限制某些子空间中的电子数，得到受限活性空间自洽场RASSCF。例如，可以只允许某些活跃轨道的强占据部分的单激发态和双激发态，或者将另一个活跃轨道的电子数限制在最多2个。通常，可以使用`restrict`指令来定义这些限制：

```
restrict,nmin,nmax,orb1，orb2，....，orbn;
```

- 只有在指定轨道orb1，orb2，....，orbn中包含电子数在`nmin`和`nmax` 之间的组态，才能包含在波函中。。轨道按照`number.sym`的形式定义。

- 如果`nmin`和`nmax`为负，那么指定轨道中有`abs(nmin)`和`abs(nmax)`个电子的组态将被删除。比如用来忽略单激发组态。

- 可以连续用几个`RESTRICT`卡

- 在第一个`WF`卡之前给出的`RESTRICT`卡是全局的，用于所有的态对称性。

- 例：甲醛，假设只有单激发和双激发可以进入波函数中未占据的轨道6.1、7.1、2.2、3.3。

  ```
  {casscf
  closed,2                        !2个对称性为1（A1）的活性轨道
  occ,7,2,3                       !7个a1, 2个b1, 3个b2占据轨道
  wf,16,1,0                       !16个电子，对称性1，单线态
  restrict,0,2,6.1,7.1,2.2,3.3}   !在给定的轨道列表中最多2个电子
  ```

  可以进一步只允许3.1和4.1轨道的两次激发态，但这种情况下，这没有影响，因为没有其他激发态是可能的。为了证明这种情况，将对称性1的已占据轨道数增加到8，并取消了6.1轨道的限制：

  ```
  {casscf
  closed,2                        
  occ,8,2,3                       
  wf,16,1,0                       
  restrict,0,2,7.1,8.1,2.2,3.3   
  restrict,2,4,3.1,4.1}          !2~4个电子在给定的轨道中
  ```

  结果表明，这种计算不收敛。原因是有些轨道旋转在单激发态下几乎是多余的，即强占位空间和弱占位空间之间的轨道变换效应可以用单激发态和双激发态来表示。这使得优化问题非常病态。这个问题可以通过以下方法来消除来自/进入受限轨道空间的单个激发来解决，结果可以收敛。

  ```
  {casscf
  closed,2                        
  occ,8,2,3                       
  wf,16,1,0           
  restrict,0,2, 7.1,8.1,2.2,3.3  
  restrict,-1,0 7.1,8.1,2.2,3.3   !不允许单个电子在给定的轨道空间
  restrict,2,4, 3.1,4.1           
  restrict,-3,0,3.1,4.1}          !3个电子不允许在给定的轨道空间
  ```

- 收敛的MCSCF计算有时是棘手和困难的。一般来说，CASSCF计算比受限计算更容易收敛，但即使在CASSCF计算中也可能出现问题。缓慢或没有收敛的原因可能有以下一种或多种。
  - 轨道和CI系数之间的近冗余变化。
    - 消除单个激发态
  - 两个或两个以上的弱占据轨道对能量的影响几乎相同，但活动空间只允许包含一个激发态
    - 增加或减少活动空间(occ卡)。
  - 一个活性轨道的占位数非常接近2。程序可能很难决定哪个轨道是不活跃的。
    - 增加不活跃的空间
  - 一个活性轨道的相关比一个非活性轨道的相关得到的能量降低要小。程序试图交换活动轨道和非活动轨道。
    - 减少(或可能增加)活动空间。
  - 同样对称的另一种状态在能量上非常接近(近似简并)。程序可能在状态之间振荡(根翻转)。
    - 将所有接近简并的状态纳入计算，优化它们的平均能量。

## 指定轨道组态

还可以使用任意选择的组态空间执行MCSCF。唯一的限制是包含同一个占据轨道中所有不同自旋耦合的csf。从`select`指令开始，有两种选择组态的方法：

- 从先前带有阈值的计算中选择：

  ```
  SELECT,ref1,ref2,refthr,refstat,mxshrf;
  ```

- 在输入中明确定义，以关键字`con`开头的一行给出每个轨道组态：

  ```
  SELECT
  CON,n1,n2,n3,n4,…
  ```

  - n1，n2等是活性轨道的占据数（0，1，或2），比如对于`OCC,5,2,2;CLOSED,2,1,1;`，n1是轨道3.1的占据数，n2是轨道4.1的占据数，n3，n4，n5是轨道5.1，2.2，2.3的占据数。

  - 例：BH分子

    ```
    OCC,4,1,1;             ! 四个σ，一个π
    FROZEN,1;              ! 第一个σ双占且冻结
    WF,6,1;                ! 6个电子，单重态
    SELECT                 ! 触发组态输入
    CON,2,2                ! 2sigma**2, 3sigma**2
    CON,2,1,1              ! 2sigma**2, 3sigma, 4sigma
    CON,2,0,2              ! 2sigma**2, 4sigma**2
    CON,2,0,0,2            ! 2sigma**2, 1pi_x**2
    CON,2,0,0,0,2          ! 2sigma**2, 1pi_y**2
    ```





# 其他选项

## `rotate`

将`sym`对称性中的初始轨道`orb1`和`orb2`做`angle`度的2×2 转动：

```
ROTATE,orb1.sym,orb2.sym,angle
```

- angle=`0`表示交换轨道（等价于angle=90）。**只能针对相同对称性的交换**
- `ROTATE`只在`START`卡之后才有意义。

## `natorb`自然轨道

计算最终的自然轨道，并写到记录record中。（默认的record是2140.2，或者在ORBITAL卡指定）

```
NATORB,[record,] [options]
```

options的可以是：

- `CI`：以计算的自然轨道为基，把哈密顿量对角化，并打印组态及其有关的因子。与全局打印中的`CIVECTOR`等同。
- `PRINT(=n)`：打印每个对称性的n个虚轨道。与全局打印中的`ORBITAL(=n)`等同。

## `CANORB`赝正则轨道

正则化最终的轨道，等同于`CANONICAL`。options与自然轨道中的一样。

```
CANORB,[record,] [options]
```

