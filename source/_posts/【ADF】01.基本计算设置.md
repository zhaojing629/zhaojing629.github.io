---
title: 【ADF】01.基本计算设置
typora-root-url: 【ADF】01.基本计算设置
date: 2019-09-23
updated:
description: Engine ADF中的的基本输入结构，SCF选项以及不收敛的处理方法
tags: [AMS, ADF, SCF, 基组, 对称性, 占据, 相对论]
mathjax: true
categories: [计算化学, 软件]
---





# 基组`basis`

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

## `PerAtomType`

为一类原子指定基组

- `Symbol`：哪一类原子
- `File`：指定基组的位置，可以是相对于`$AMSRESOURCES/ADF`的相对位置，也可以是绝对位置。应该在相对论计算的路径中包含 ZORA，例如`ZORA/QZ4P/Au`。通过 `Type` 和 `Core` 明确指定基组会覆盖自动基组文件选择。

- `Core`、`type`等：同上

这一部分也可以简写为：

```
PerAtomType Core=None File=string Symbol=tring type=XXX
```

## `PerRegion`

为一个区域的原子指定基组，基本设置同上。

- `Region`：指定基组的区域，可以用逻辑运算符，比如`R1+R2`



> ADF19中，为同元素的不同原子设置基组
>
> ```
> ATOMS
> O.F1 x y z
> O.F2 x y z
> End
> basis
> O.F1 TZ2P
> O.F2 DZP
> END
> ```
>
> 

# 泛函`XC`

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



# 相对论`Relativity`

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
  - `CollinearX`，`CollinearY`，`CollinearZ`：使用x，y或z分量作为XC函数的自旋极化。默认为z。
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

# SCF选项

```
SCF
 Iterations Niter
 Converge SCFcnv { sconv2 }
 
 AccelerationMethod { ADIIS | LISTi | LISTb | fDIIS | LISTf | MESA | SDIIS }
 MESA [NoFDIIS] [NoLISTb] [NoLISTf] [NoLISTi] [NoSDIIS] [NoADIIS]
 ADIIS
   {THRESH1 a1}
   {THRESH2 a2}
 End
 NoADIIS
 DIIS
   {N n}
   {OK ok}
   {cyc cyc}
 End
 Mixing mix
 Mixing1 mix1

 OldSCF
End
```

- `Iterations`SCF迭代的最大次数，`Niter`默认是`300`
- `Converge` 
  - `SCFcnv`表示停止迭代的收敛限，默认是`1e-6`。
  - `sconv2`表示SCF过程难以收敛时起作用的第二个标准，默认是`1e-3`，如果达到了，仅发出警告，但是继续计算。仍无法达到的时候SCF不收敛，只能用`ALLOW`来继续
- `oldSCF`：禁用默认 SCF 算法并使用旧的 SCF 算法。
  - 默认 SCF 提高了大型机器上大型系统的性能（当计算使用许多任务时）。也推荐用于磁盘 I/O 速度较慢的机器，因为它向磁盘写入的数据较少。支持的默认收敛方法是 A-DIIS，但也支持 LISTi。在使用`Occupations Steep`、`Lshift`，`ARH`，`EDIIS`，`RESTOCC`时，会自动启用`oldSCF`。

## `DIIS`

允许的最大 SCF 迭代数相关设置。

- `BFac`：默认为`0.0`，即DIIS算法不支持最新的向量。一个合理的值是 0.2。

- `CX`：当出现非常大的 DIIS 系数时，DIIS 空间会减少。该值是阈值，默认是`5.0`

- `CXX`：当出现非常大的 DIIS 系数时，切换到传统阻尼。该值是阈值，默认为`25.0`

- `Cyc`：禁用A-DIIS时，无论`DIIS OK`值如何，SDIIS都会在此迭代下启动，默认值为`5`

- `N`：用于加速SCF的扩展向量的数量，默认为`10`，小于2后会禁用DIIS。此数字不仅适用于Pulay DIIS方案，还适用于其他类似DIIS的方法，例如A-DIIS和LIST方法。

  > LIST家族的方法对使用的扩展向量的数量非常敏感，接近收敛时，LIST中的向量数量会增加，但始终受`DIIS N`的限制，当难以收敛时，可以将`DIIS N`设置为大于10的值，比如12~20。

- `Ok`：禁用A-DIIS时，SDIIS起始条件。默认为`0.5` a.u.。

## 加速方法

- `AccelerationMethod`调用的SCF加速方法，默认情况下为`ADIIS`，还可以用`LISTi` | `LISTb` | `fDIIS` | `LISTf` | `MESA` | `SDIIS`。MESA采用的是ADIIS, fDIIS, LISTb, LISTf, LISTi和 SDIIS方法的组合。
- `MESA`：代表从其中删掉某一种方法，可以直接使用该关键词调用MESA（也可以用`AccelerationMethod MESA`调用），优先级大于`AccelerationMethod`指定的方法。
- `NoADIIS`：指定`NoADIIS`时才可以设置 [`DIIS`模块](#DIIS)的`cycle`和`OK`。
  - 如果<span id="NOADIIS">没有设置`oldSCF`，则指定 `NoADIIS` </span>与[将 AccelerationMethod 设置为 SDIIS](#SDIIS) 的效果相同。
  - 在指定`oldscf`的情况下使用`NoADIIS`会禁用在SCF收敛困难的时候自动切换到ADIIS + SDIIS方法

### 简单阻尼部分

- `Mixing`：没有激活加速方法时，指将下一个Fock矩阵确定为$$F = mix F_{n} + (1-mix) F_{n-1}$$，$$mix$$默认为`0.2`
- `Mixing1`中指第一个SCF循环的混合参数值不同，默认为`0.2`

### ADIIS部分

使用ADIIS + SDIIS方法。根据 [F,P] 交换子矩阵中的最大元素`ErrMax`来确定具体方法：

- 当ErrMax≥`a1`，只使用A-DIIS系数
- 当ErrMax≤ `a2`，只使用SDIIS系数
- 当`a2`≤ ErrMax≤ `a1`，根据ErrMax的值按一定的权重来计算
`a1`和`a2`的默认值是`0.01`和`0.0001`，收敛比较困难的时候，可以降低阈值，只使用A-DIIS系数

### SDIIS部分

[SDIIS](#NOADIIS) 代表原始的Pulay DIIS方法。禁用 A-DIIS 并将 SCF 切换为阻尼+SDIIS方法：从简单阻尼（Mixing）开始，持续到`ErrMax`降低到[`DIIS OK`](#DIIS)参数以下，但是不超过`DIIS Cyc`次迭代。之后使用纯的SDIIS方法。

## 能级移动

- `Lshift`：能级移动方法，在前一次迭代的轨道表示中，Fock矩阵的对角元素提高虚轨道的`vshift`hartree。旋轨耦合不支持这种方法。

- `Lshift_err`指定一旦SCF error降至阈值以下，程序将关闭能级移动，`Shift_err`默认值为`0`。

- `Lshift_cyc`指定在第几个SCF 迭代次数的时候再启动能级移动， `Shift_cyc`默认为`1`。

  ```
  Lshift vshift
  Lshift_err Shift_err
  Lshift_cyc Shift_cyc 
  ```

## `ARH`

```
SCF
  ARH
    {CONV conv}
    {ITER iter}
    {NSAVED nsaved}
    {START start}
    {FINAL} ...
  End
  ...
End
```

- `CONV`：当RMS梯度及其最大分量均低于` conv`，ARH收敛，` conv`默认是1e-4
- `ITER`：最大ARH迭代次数，`iter`默认为500
- `FINAL`：确定ARH完成后是否继续SCF。如果设置了此选项，将执行一次Fock矩阵对角化以获得轨道，并且将停止SCF过程。默认选项为`OFF`。
- `START`：开始调用ARH的SCF迭代次数，`start`默认为2。使用较大的值可以为ARH提供更好的初猜
- `NSAVED`：保存密度和Fock矩阵的数量。 `nsaved`默认为8。在非常接近费米能级的轨道数很大的收敛困难时，应使用较大的`nsaved`值。
- 默认的最小化方法是“Untransformed Pre-conditioned Conjugate Gradient”，可以使用以下两个关键词更改：
  - `NOPRECOND`：禁用Untransformed Pre-conditioned CG最小化，不能在第二周期后的元素里使用
  - `TRANSPCG`：启用Transformed Pre-conditioned CG 方法，SCF可能会更好的收敛。
- 在每一步SCF中，先执行常规CG最小化，跟踪总步长，如果在某个微迭代中步长超过了信任半径，则过程将在缩小的空间中切换到信任半径优化，在能级移动参数mu收敛后立即中止。在CG最小化期间生成的所有试验矢量的缩小空间中，将最终步骤计算为牛顿步骤。可以通过以下关键词修改参数：
  - `NOSWITCHING`：关闭从普通CG到缩小的空间中的信任半径最小化的切换。在某些情况下，使用此选项有助于减少SCF循环的总数。
  - `SHIFTED`：设置此选项将在第一次微迭代中打开信任半径优化。
  - `CGITER=cgiter`：设置微迭代的最大数量。
  - 确定置信半径：
    - `TRUSTR=trustr`：信任半径的初始值。默认为`0.5`
    - `MAXTRUSTR=maxtrustr`：最大信任半径值。默认为`0.5`，并且不会改变。
- 缺点：
  - 该方法仅适用于NOSYM计算
  - 在每一步都要计算总能量，计算非常昂贵，而且使用总能量，需要更高的积分精度才能获得稳定的SCF收敛，该方法可能不适用于所有情况，??使用`ADDDIFFUSEFIT`关键字或更高的`ZlmFit`质量设置来提高总能量的准确性，从而提高收敛性。??

## SCF不收敛

1. 更换SCF加速收敛的方法
2. 使用ARH方法
3. 修改DIIS算法的参数
   - `Mixing`高于默认值`0.2`会有更高的加速度，更低会更稳定的迭代
   - `N`默认为`10`，越大用于加速SCF的扩展向量的数量越多，SCF迭代更稳定，最多到25
   - `Cyc`是SDIIS启动的初始SCF迭代步数，默认值为`5`，更高计算越稳定，比如使用如下参数：
   ```
    SCF
        DIIS
          N 25
          Cyc 30
        End
        Mixing 0.015
        Mixing1 0.09
    End
   ```
4. HOMO-LUMO较为接近的情况（0.02Hatree以内），可能造成HOMO-LUMO的震荡。可以使用`Lshift vshift`方法，比如0.01，不能太大，不适于激发态的计算、**解析频率**、旋轨耦合的计算。
5. 使用Electron smearing设定在允许的能量范围内分数占据。
6. 其他：[费米维基](https://www.fermitech.com.cn/wiki/doku.php?id=adf:scfnonconvergence)的2、3、5。



# 对称性的设置

除了在AMS中或`System`块中指定，`Engine ADF`中也可以设置对称性：

- `Symmetry`：默认是`AUTO`，默认为`auto`，可以通过`nosym`、`C(LIN)`……等来指定对称性
- `SymmetryTolerance`：用于检测系统对称性的容差。默认是`1e-07`

> 即使在`System`中设置了 `Symmetry nosym`，ADF中也可能会检测出对称性。因此要在ADF中也设置`nosym`。

# 指定占据`IrrepOccupations`

```
IrrepOccupations
  irrep orbitalnumbers
  irrep orbitalnumbers
  ...
End
```

- `irrep`是不可约表示

- `orbitalnumbers`：

  - 可以是一个或者一系列数字，会按能量顺序排序，高于这些数字的占据都是0、

  - 对于简并的对称性，要给出电子的总数。

  - 在unrestricted的计算中【在使用（非）共线近似的无限制自旋轨道耦合计算中没有意义，在这种情况下，应该为每个不可约的占用数使用一个序列】，要用两个数字序列，通过`//`分隔开。前一组是α电子，后一组是β电子。如：

    ```
    IrrepOccupations
       A 28 // 26
    End
    SpinPolarization 2
    Symmetry NOSYM
    ```

注意事项：

- 电子总数不包括冻芯里的电子。
- 如果数字序列比较长，可以组合内层的电子数，程序会自动拆分，比如对于单个原子，`P 17 3`会自动变成`P 6 6 5 3`
- 可以用分数占据
- 在数值频率计算中，程序内部默认使用nosym，因此只能识别不可约表示A。

# 红外光谱

所需的 Hessian 可以通过数值计算或解析计算。这可以在输入的 AMS 部分设置。

## 解析频率

对于相同的积分精度，解析 Hessian 与数值 Hessian 一样准确，但计算速度最多可提高 3 到 5 倍，具体取决于分子、积分网格参数和基组选择。但是解析Hessian目前只支持（包括 PW91 和 Hartree-Fock都不支持）：

- **LDA:** XONLY, VWN, STOLL, PW92
- **Exchange GGA:** Becke88, OPTx, PBEx, rPBEx, revPBEx, S12g
- **Correlation GGA:** LYP, Perdew86, PBEc
- **XC GGA shortcuts:** BP86, PBE, RPBE, revPBE, BLYP, OLYP, OPBE

```
AnalyticalFreq
   B1Size float
   B1Thresh float
   Check_CPKS_From_Iteration integer
   Debug string
   Hessian [reflect | average]
   Max_CPKS_Iterations integer
   Print string
   PrintNormalModeAnalysis Yes/No
   U1_Accuracy float
End
```

- `Max_CPKS_Iterations`：解析频率的计算需要求解Coupled Perturbed Kohn-Sham (CPKS)  (CPKS)方程，这是一个迭代过程。如果没有实现收敛（输出中会打印警告" CPKS failed to converge. Frequencies may be wrong")，可以增加迭代次数（收敛不能保证）。默认为`20`

