---
title: 【ADF】01.SCF相关
typora-root-url: 【ADF】01.SCF相关
date: 2019-09-23 
updated:
description: ADF的SCF选项以及不收敛的处理方法
tags: SCF
mathjax: true
categories: [计算化学,ADF]
---

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

## Iterations

`Iterations`SCF迭代的最大次数，`Niter`默认是`300`

##  Converge

`Converge` ：
- `SCFcnv`表示停止迭代的收敛限，默认是`1e-6`。
- `sconv2`表示SCF过程难以收敛时起作用的第二个标准，默认是`1e-3`，如果达到了，仅发出警告，但是继续计算。仍无法达到的时候SCF不收敛，只能用`ALLOW`来继续

## AccelerationMethod

`AccelerationMethod`调用的SCF加速方法，默认情况下为`ADIIS`，还可以用`LISTi` | `LISTb` | `fDIIS` | `LISTf` | `MESA` | `SDIIS`

### MESA

`AccelerationMethod MESA`是ADIIS, fDIIS, LISTb, LISTf, LISTi和 SDIIS方法的组合
`MESA NoSDIIS`代表从其中删掉某一种方法，也可以直接使用该关键词调用MESA，优先级大于`AccelerationMethod`指定的方法。

### ADIIS

使用ADIIS + SDIIS方法，根据 [F,P] 交换子矩阵中的最大元素`ErrMax`来确定具体方法：
- 当ErrMax≥`a1`，只使用A-DIIS系数
- 当ErrMax≤ `a2`，只使用SDIIS系数
- 当`a2`≤ ErrMax≤ `a1`，根据ErrMax的值按一定的权重来计算
`a1`和`a2`的默认值是`0.01`和`0.0001`，收敛比较困难的时候，可以降低阈值，只使用A-DIIS系数

### SDIIS

`AccelerationMethod SDIIS`与在没有指定`oldscf`的情况下使用`NoADIIS`意思相同，采用的是阻尼+SDIIS方法。从简单阻尼（Mixing）开始，持续到`ErrMax`降低到`DIIS OK`参数以下，但是不超过`DIIS Cyc`次迭代。之后使用纯的SDIIS方法。
> 在指定`oldscf`的情况下使用`NoADIIS`会禁用在SCF收敛困难的时候自动切换到ADIIS + SDIIS方法

- 指定`NoADIIS`时才可以设置 `DIIS`模块：
  - `N`用于加速SCF的扩展向量的数量，默认为`10`，小于2后会禁用DIIS。此数字不仅适用于Pulay DIIS方案，还适用于其他类似DIIS的方法，例如A-DIIS和LIST方法。
    
    > LIST家族的方法对使用的扩展向量的数量非常敏感，接近收敛时，LIST中的向量数量会增加，但始终受`DIIS N`的限制，当难以收敛时，可以将`DIIS N`设置为大于10的值，比如12~20。
  - `OK`禁用A-DIIS时，SDIIS起始条件。默认为`0.5` a.u.。
  - `Cyc`禁用A-DIIS时，无论上面的`DIIS OK`值如何，SDIIS都会在此迭代下启动，默认值为`5`
- `Mixing`中，指将下一个Fock矩阵确定为$$F = mix F_{n} + (1-mix) F_{n-1}$$，`mix`默认为`0.2`
- `Mixing1`中指第一个SCF循环的混合参数值不同，默认为`0.2`

## oldSCF

在使用`Occupations Steep`、`Lshift`，`ARH`，`EDIIS`，`RESTOCC`时，会自动启用`oldSCF`

### Lshift

能级移动方法，在前一次迭代的轨道表示中，Fock矩阵的对角元素提高虚轨道的`vshift`hartree。旋轨耦合不支持这种方法。

```
Lshift vshift
Lshift_err Shift_err
Lshift_cyc Shift_cyc
```

- `Lshift_err`指定一旦SCF error降至阈值以下，程序将关闭能级移动，`Shift_err`默认值为`0`。
- `Lshift_cyc`指定在第几个SCF 迭代次数的时候再启动能级移动， `Shift_cyc`默认为`1`。

### ARH

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

# SCF不收敛

1. 更换SCF加速收敛的方法
2. 使用ARH方法
3. 修改DIIS算法的参数
   - `Mixing`高于默认值`0.2`会有更高的加速度，更低会更稳定的迭代
   - `N`默认为`10`，越大用于加速SCF的扩展向量的数量越多，SCF迭代更稳定，最多到25
   - `Cyc`是SDIIS启动的初始SCF迭代步数，默认值为`5`，更高计算越稳定   
   比如使用如下参数：
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

