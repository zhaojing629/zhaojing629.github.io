---
title: 【Gaussian】对称性破缺
typora-root-url: 【Gaussian】对称性破缺
mathjax: true
date: 2022-11-07 14:47:37
updated:
tags: [Gaussian, 对称性破缺]
categories: [计算化学, 软件]
description: 片段组合波函数、自旋极化单重态
---



- 自旋极化单重态也经常叫对称破缺态，这是因为对称破缺态是指波函数对称性低于当前分子结构的对称性，自旋极化单重态总伴随对称破缺的出现，而出现对称破缺又必然存在自旋极化，所以除了个例，二者指的是同一种态。



# 方法1 stable=opt

- 可以在限制性方法计算后进行波函数优化，程序会寻找能量更低的态，包括尝试破坏对称性
  - 如果找到了（称存在RHF->UHF不稳定性），说明自旋极化态才是基态
  - 如果没找到，也不能说非自旋极化态一定就是基态，波函数优化并不能保证获得参数空间最小点，有可能通过调整初猜后能得到能量比非自旋极化态更低的自旋极化态。



# 方法2 guess=mix

- `guess=mix`只在自旋极化单重态（即使用UHF方法在单重态下做计算，发现有严重自旋污染）时需要考虑加，其他情况（如二重态、三重态）等无需考虑这个问题；

- always表示在结构优化的每一步中都执行guess=mix。顾名思义，这只在结构优化中可能有用，而在单点计算中无需加、加了也没用。

  ```
  # guess=(mix,always)
  ```


- 通常使用：

  ```
  # UB3LYP/6-31G* guess=mix nosymm stable=opt
  ```

  

## mix具体的含义

- 可以是只混合alpha列的HOMO与LUMO轨道，也可以是alpha、beta两列的HOMO与LUMO轨道各自混合、但混合方式不一样。比如Gaussian采用后者中对1.5Å的H2计算（http://sobereva.com/82）是（注意还要乘归一化系数）：

  $ψα_{HOMO}=ψ_{HOMO}+ψ_{LUMO}$
  $ψα_{LUMO}=ψ_{LUMO}-ψ_{HOMO}$
  $ψβ_{HOMO}=-(ψ_{LUMO}-ψ_{HOMO})$
  $ψβ_{LUMO}=-(ψ_{HOMO}+ψ_{LUMO})$

- 还可以手动修改比例（https://mp.weixin.qq.com/s/ZB6gkRtfZQ8yuh3u0FNbOw）

# 方法3 片段组合波函数

## 例子：N2的解离

普通计算：

```
%chk=N2_cc-pVDZ_2.0.chk
%mem=4GB
%nprocshared=4
#p UHF/cc-pVDZ nosymm guess=mix stable=opt

title

0 1
N   0.0   0.0   0.0
N   0.0   0.0   2.0
```

得到的结果：

```
 SCF Done:  E(UHF) =  -108.616833307     A.U. after   16 cycles
 SCF Done:  E(UHF) =  -108.659688488     a.u. after    6 cycles
……
……
Mulliken charges and spin densities:
               1          2
     1  N    0.000000  -0.861075
     2  N   -0.000000   0.861075
```

可以看到每个N原子只有接近1个电子的净自旋，这不太符合基本知识和化学直觉。因为N2平衡结构是N≡N三键，而解离时左右各自都应该像孤立N原子，所以无论是看平衡结构还是看解离极限，每个原子应各提供3个单电子。

```
%chk=N2_cc-pVDZ_2.0_frag.chk
%mem=4GB
%nprocshared=4
#p UHF/cc-pVDZ nosymm guess(fragment=2)

title

0 1 0 4 0 -4
N(fragment=1)   0.0   0.0   0.0
N(fragment=2)   0.0   0.0   2.0

--Link1--
%chk=N2_cc-pVDZ_2.0_frag.chk
%mem=4GB
%nprocshared=4
#p UHF chkbasis nosymm guess=read geom=allcheck stable=opt
```

得到：

```
Mulliken charges and spin densities:
               1          2
     1  N   -0.000000   2.901523
     2  N   -0.000000  -2.901523
```

