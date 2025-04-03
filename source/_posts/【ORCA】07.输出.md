---
title: 【ORCA】07.输出
typora-root-url: 【ORCA】07.输出
mathjax: true
date: 2020-09-04
updated:
tags: [ORCA, 轨道]
categories: [计算化学, 软件]
description: ORCA的可视化等
---



# 控制输出

```
%output
  PrintLevel     Normal
  Print[ Flag ]  0  # turn print off
                 1  # turn print on
                 n  # some flags are more sophisticated
end
```

- `Printlevel`可选的范围是 `Nothing`、`Mini`、`Small`、`Normal`、`Maxi`、`Large`、`Huge`、`Debug`
- 输出的Flag可选的有：
  - `P_ReducedOrbPopMO_L`：打印Mulliken reduced orbital population
  - `P_MOs`：打印MO收敛系数，和`! PrintMOs`相同





# Chemcraft 或 Avogadro

- 这两个软件可以直接读取ORCA的输出文件并绘制轨道，但是要加入如下关键词（或者直接`! PrintMOs Printbasis`）：

  ```
  !Printbasis # prints the basis 
  %print 
  	print[p_mos] 1 	#prints MO Coefficients
  end 
  ```

  



# 修改gbw文件

比如在计算CASSCF中，得到一个gbw文件后，可以使用 orca_2mkl 模块将文件转换为人可读的 ASCII 文件：

```
orca_2mkl bpguess –mkl -u
```

- 就会生成一个`bpguess.mkl`文件





# 导出molden

```
orca_2mkl basename -molden
```





# 自然轨道

- 在`%scf`里写上`UHFNO true`，或者直接`! UNO`。

  ```
  %scf 
  	UHFNO true 
  end
  ```

  - 结果在`.uno`文件中，这实际上也是一个`gbw`文件，可以重命名为`.gbw`后缀后再通过ORCA自带的`orca_2mkl`小程序生成`mkl`和`molden`文件。
  - 其他文件：

> UNO: unrestricted HF/DFT natural orbitals，这是总密度产生的自然轨道，只有1列，总密度=alpha密度+beta密度
> UNSO: unrestricted HF/DFT natural spin orbitals，这个轨道有2列，是分别用alpha/beta密度产生的自然轨道
> UCO: unrestricted HF/DFT corresponding orbitals，这个轨道有2列
> QRO: quasi-restricted orbitals，这个轨道只有1列



- 使用`! UCO`可以输出中打印 UCO 重叠，这可以提供有关系统中自旋耦合的非常清晰的信息。

  - 重叠对应的值通常小于 0.85，表示自旋耦合对。而接近 1.00 和 0.00 的值分别指双占据和单占据轨道。

  - 例如：

    ```
    ***UHF Corresponding Orbitals were saved in MyJob.uco***
    
    ----------------------
    Orbital    Overlap(*)
    ----------------------
    .
    .
    .
    96:       0.99968
    97:       0.99955
    98:       0.99947
    99:       0.99910
    100:      0.99873
    101:      0.99563
    102:      0.74329
    103:      0.00000
    ```

  
