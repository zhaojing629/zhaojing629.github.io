---
title: 【ORCA】DLPNO-CCSD(T)
date: 2020-05-29 16:20:02
typora-root-url: 【ORCA】DLPNO-CCSD(T)
mathjax: true
updated:
tags: [ORCA, DLPNO]
categories: [计算化学, 软件]
description: ORCA DLPNO-CCSD(T)计算
---





- DLPNO-CCSD(T)是一种基于局域轨道的近似CCSD(T)方法，其所得相关能与标准CCSD(T)的相关能比值可达99.9%以上，误差可控制在1 kcal/mol。在平时的计算中，需要用高精度方法的电子能量时，如果体系较大，无法做标准CCSD(T)计算，可以考虑使用ORCA的DLPNO-CCSD(T)方法。

输入文件例子：

```c++
%pal nprocs 16 end
%maxcore 28000
! def2-TZVP def2-TZVP/C DLPNO-CCSD(T) TightSCF tightPNO
* xyz 0 1
体系xyz坐标
*
```

# 内存

- 一般使用的核数比较小，因为DLPNO-CCSD(T)比较消耗内存
- `%maxcore`×` %pal`要小于总内存（大约是orca.sub中指定的节点数*4）
- 对硬盘的空间大小要求不是很高，但是对硬盘的读写性能要求很高，如果用SSD就会提升很多计算速度

# 基组

- LPNO必须使用RI近似，因此必须提供**相关拟合**的基组。比如：def2-SVP/C, def2-TZVP/C, def2-TZVPP/C, def2-QZVPP/C, cc-pVnZ/C, aug-cc-pVnZ/C (n=D,T,Q,5,6) 

- DLPNO-CCSD(T)的HF计算部分可以用RIJK或者RIJCOSX方法来加速，并指定辅助基组

  ```c++
  RIJK def2/JK
  ```

  ```c++
  RIJCOSX def2/J
  ```

# 精度控制选项

## tightpno

`tightPNO`为控制CCSD(T)精度的参数，对应的可选值有`LoosePNO`、`NormalPNO`（默认）、`TightPNO`，一般来说LoosePNO精度不高，尽量选择后两个：

- 用NormalPNO的时候精度就已经显著超过PWPB95-D3(BJ)了，相对于CCSD(T)的误差通常在1kcal/mol以内。
- DLPNO-CCSD(T)结合tightPNO的时候，根据J. Chem. Theory Comput., 11, 4054 (2015)的测试（注意此文里有很多在耗时方面的严重误导性说法），与CCSD(T)的误差在1 kJ/mol的程度，几乎可认为没有差别。tightPNO的耗时比NormalPNO通常高几倍。在笔者的Intel 36核机子上，用当前级别计算66个原子的有机体系耗时约8小时，耗硬盘最多时候为120GB。如果你还想要更好的精度，建议将基组提升至cc-pVQZ，但也会贵非常多。如果不用RIJK，即去掉RIJK cc-pVTZ/JK关键词，精度会有所改进，但对较大的体系，SCF部分的耗时会增加许多。

## ccsd(t1)

- 在ORCA 4.2版中，需要注意直接在关键词中写DLPNO-CCSD(T)实际做的是`DLPNO-CCSD(T0)`计算。所谓T0是指在进行(T)计算时使用semi-canonical (SC) 近似。在局域轨道表象下，分子轨道基的Fock矩阵的非对角元不为0，此时(T)的计算需要迭代求解。**在SC近似下，忽略Fock矩阵的非对角元，不进行迭代求解。**
- **而不使用SC近似，对(T)部分进行迭代求解**，这部分功能在ORCA中应该写为`DLPNO-CCSD(T1)`，这样结果与标准CCSD(T)更为接近。在J. Chem. Phys. 148, 011101 (2018)一文中，作者提到，一般在研究相对能量的问题时，使用T0便可以得到很好的结果，而对gap比较小的体系，可能需要T1才能得到准确的结果。

## tcutpno

- 如果还需要更准，可以修改`TCutPNO`的具体值。(`TCutPNO 3.33e-7` 默认)

  ```c++
  %mdci
  	TCutPNO 0.0
  end
  ```

- 更高精度的话，比如追求CCSD(T)的精度，可以把cutoff都设置为0：

  ```c++
  %mdci
  	TCutPNO 0.0
  	TCutDo 0.0
  	TCutTNO 0.0
  	TCutPairs 0.0
  end
  ```
  - 在此基础上还需要用比较大的辅助基组，否则RI对 四个virtual的积分会有比较大的误差。比如用DLPNO-CCSD（T1）/cc-pvdz 希望得到和标准CCSD(T) 一模一样的结果（小数点后第六位一样，单位hartree），除了把cutoff设置为0，还要用cc-pv5z/c作为cc-pvdz的辅助基组

20210130 8核 cc-pvtz 测试B<sub>9</sub><sup>-</sup>结果

![](image-20210205164601861.png)



# 优化

- 通常只拿来算单点
- ccsd(t)没有解析梯度，因此要加上

```
!opt numgrad
```













![](clipboard.png)

- 计算开壳层时，最好使用UCO

  ```c++
  ! UCO
  #是用于绘制UHF波函数的自然轨道，同UNO。
  ```

  