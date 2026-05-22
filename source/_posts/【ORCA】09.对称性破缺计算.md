---
title: 【ORCA】09.对称性破缺计算
typora-root-url: 【ORCA】09.对称性破缺计算
mathjax: true
date: 2024-08-04 16:54:26
updated:
tags: [ORCA, 对称性破缺]
categories: [计算化学, 软件]
description: ORCA中对称性破缺的计算
---

> 参考文献：
>
> 1. [双金属中心化合物的磁交换耦合常数的计算 (qq.com)](https://mp.weixin.qq.com/s?__biz=MzU5NjMxNjkzMw==&mid=2247486753&idx=1&sn=f72b07524a8e7e3a4e1abdaf64416dd6&chksm=fe65cb4bc912425d12a3eb0ba263ee36908dbafb6b7660a25464ff16e9a4479d888e66c68748&scene=21#wechat_redirect)
>2. [ORCA Input Library - Broken-symmetry DFT (google.com)](https://sites.google.com/site/orcainputlibrary/dft-calculations/broken-symmetry-dft)
> 3. 《ORCA 6.0.0手册》
>
> 

# Broken Symmetry

```
%scf 
BrokenSym NA,NB 
end
```

- 要保证A点位的未成对电子数更大
- 会自动打印UCO

例子：对于两个Fe<sup>3+</sup>，S=5/2 (d<sup>5</sup>)

```
! BP def2-SVP def2/J UKS
%scf
Brokensym 5,5 # A和B两个点位未成对电子
end
*xyz 6 11  # 高自旋态的自选多重度，10个单电子，S=5，11重态
Fe 0.0 0.0 0.0
Fe 0.0 0.0 3.0
*
```



## 磁交换耦合常数的计算

ORCA在计算完Broken Symmetry之后会自动输出，比如：

```
------------------------------------------
BROKEN SYMMETRY MAGNETIC COUPLING ANALYSIS
------------------------------------------
 
S(High-Spin)      =   1.0
<S**2>(High-Spin) =   2.0058
<S**2>(BrokenSym) =   0.9816
E(High-Spin)      = -4542.777216 Eh
E(BrokenSym)      = -4542.778211 Eh
E(High-Spin)-E(BrokenSym)= 0.0271 eV    218.386 cm**-1 (ANTIFERROMAGNETIC coupling)
 
          ---------------------------------------------------------
          | Spin-Hamiltonian Analysis based on H(HDvV)= -2J*SA*SB |
    -------                                                       -----------
    | J(1) =    -218.39 cm**-1    (from -(E[HS]-E[BS])/Smax**2)             |
    | J(2) =    -109.19 cm**-1    (from -(E[HS]-E[BS])/(Smax*(Smax+1))      |
    | J(3) =    -213.21 cm**-1    (from -(E[HS]-E[BS])/(<S**2>HS-<S**2>BS)) |
    -------------------------------------------------------------------------
```

这三个公式分别为：
$$
J_{\mathrm{AB}}=-\frac{\left(E_{\mathrm{HS}}-E_{\mathrm{BS}}\right)}{\left(S_{\mathrm{A}}+S_{\mathrm{B}}\right)^{2}} \\

J_{\mathrm{AB}}=-\frac{\left(E_{\mathrm{HS}}-E_{\mathrm{BS}}\right)}{\left(S_{\mathrm{A}}+S_{\mathrm{B}}\right)\left(S_{\mathrm{A}}+S_{\mathrm{B}}+1\right)} \\

J=-\frac{E_{\mathrm{HS}}-E_{\mathrm{BS}}}{\left\langle\hat{S}^{2}\right\rangle_{\mathrm{HS}}-\left\langle\hat{S}^{2}\right\rangle_{\mathrm{BS}}}
$$

- 更加推荐最后一个定义，因为它在整个耦合强度范围内近似有效，而第一个方程意味着弱耦合极限，第二个方程意味着强耦合极限。
  - 上式中，HS表示高自旋态（high-spin），BS表示对称破缺态（broken-symmetry）
  - 对应UDFT计算中的低自旋状态。由于$$\left\langle\hat{S}^{2}\right\rangle_{\mathrm{HS}}$$大于$$\left\langle\hat{S}^{2}\right\rangle_{\mathrm{BS}}$$，因此，若$$J$$为正值，则高自旋态的能量低，称为铁磁耦合；反之，低自旋态的能量更低，称为反铁磁耦合。由上式可知，要计算磁交换耦合常数，需要计算体系的高自旋态和对称破缺态。
  - 也可以通过高斯分别计算两个态的能量和$$\left\langle\hat{S}^{2}\right\rangle$$，手动计算




# Spin flip

还可以先计算高自旋态，然后通过`Flipspin`来计算：

```
! BP def2-SVP def2/J 
%scf
Flipspin 0 # 原子0被翻转
FinalMs 0.0 # 最终的对称性破缺收敛的自旋量子数的值 即(Nα-Nβ)/2
end

*xyz 6 11  # 高自旋态的自选多重度，10个单电子，S=5，11重态
Fe 0.0 0.0 0.0
Fe 0.0 0.0 3.0
*
```

