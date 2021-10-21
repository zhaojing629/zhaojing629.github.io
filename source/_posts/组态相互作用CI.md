---
title: 组态相互作用CI
typora-root-url: 组态相互作用CI
mathjax: true
date: 2020-11-20 14:16:33
updated:
tags: [CI]
categories: [计算化学, 原理]
description: 组态相互作用CI的一些原理
---



# 分子的电子组态

Configuration State Functions (CSF)

# 分子波函数的组态展开

在从头算中，基组态$$\Phi_o$$用作基态分子的状态波函数,这是最粗略的描述方式。欲求更精确的表达,应把波函数写成相同自旋本征值的组态函数的线性组合：
$$
\begin{aligned}
\Psi^{\mathrm{CI}} &=\sum_{P} C_{P} \Phi_{P} \\
&=C_{0} \Phi_{0}+\sum_{i}^{o c c} \sum_{a}^{v i t t} C_{i}^{a} \Phi_{i}^{a}+\sum_{i j}^{o c c} \sum_{a b}^{v i r t} C_{i j}^{a b} \Phi_{i j}^{a b}+\sum_{i j k}^{o c c} \sum_{a b c}^{v i j t} C_{i j k}^{a b c} \Phi_{i j k}^{a b c}+\cdots
\end{aligned}
$$

- i，j，k代表占据轨道；a，b，c代表空轨道；Φ为行列式。依次为基态波函数、单激发行列式、双激发行列式、三激发
- 组态相互作用：每一个行列式都可以叫做组态。CI即各种各样的组态做一个线性组合来描述，一组合就表示产生了相互作用

# CI的自洽场计算

CI方法是将实际的多电子波函数用HF波函数及各种激发行列式作为多电子基函数来线性展开，通过变分方法求解展开系数，并得到对应的能量。

## 变分法

$$
\Psi^{C I}=\sum_{P} C_{P} \Phi_{P}
$$

分子体系的总电子能量：$$E^{\mathrm{CI}}=\frac{\left\langle\Psi^{\mathrm{CI}}|\hat{H}| \Psi^{\mathrm{CI}}\right\rangle}{\left\langle\Psi^{\mathrm{CI}} \mid \Psi^{\mathrm{CI}}\right\rangle}$$，其中$$\hat{H}=\sum_{i} \hat{h}_{i}+\sum_{i<j} \frac{1}{r_{i j}}$$

定义CI矩阵元：$$H_{P Q}=\left\langle\Phi_{P}|\hat{H}|\Phi_{Q}\right\rangle
\quad S_{P Q}=\left\langle\Phi_{P} \mid \Phi_{Q}\right\rangle$$
$$
\begin{aligned}
E^{\mathrm{CI}} &=\frac{\left\langle\Psi^{\mathrm{CI}}|\hat{H}| \Psi^{\mathrm{CI}}\right\rangle}{\left\langle\Psi^{\mathrm{CI}} \mid \Psi^{\mathrm{CI}}\right\rangle}=\frac{\left\langle\sum_{p=1}^{n} c_{p} \Phi_{p}|\hat{H}| \sum_{q=1}^{n} c_{q} \Phi_{q}\right\rangle}{\left\langle\sum_{p=1}^{n} c_{p} \Phi_{p} \mid \sum_{q=1}^{n} c_{q} \Phi_{q}\right\rangle} \\
&= \frac{\sum_{p=1}^{n} \sum_{q=1}^{n} c_{p} c_{q}\left\langle\Phi_{p}|\hat{H}| \Phi_{q}\right\rangle}{\sum_{p=1}^{n} \sum_{q=1}^{n} c_{p} c_{q}\left\langle\Phi_{p} \mid \Phi_{q}\right\rangle}=\frac{\sum_{p=1}^{n} \sum_{q=1}^{n} c_{p} c_{q} \mathrm{H}_{p q}}{\sum_{p=1}^{n} \sum_{q=1}^{n} c_{p} c_{q} S_{p q}}
\end{aligned}
$$

最小的$$E^{CI}$$对应的$${C_P}$$可以通过在$$\{\Phi_P\}$$定义的组态空间中（轨道空间是$$\{\psi_k\}$$）使用变分法（$$\delta E^{CI}$$）得到。

构成组态空间$$\{\Phi_P\}$$的轨道空间MO波函数是正交归一的：$$\left\langle\psi_{\mu} \mid \psi_{\nu}\right\rangle=\delta_{\mu \nu}$$，

组态空间$$\{\Phi_P\}$$ 也是正交归一的：$$\left\langle\Phi_{P} \mid \Phi_{Q}\right\rangle=\delta_{P Q}$$
$$
\sum_{p=1}^{n} \sum_{q=1}^{n} c_{p} c_{q}\left(H_{p q}-E^{C I} S_{p q}\right)=0\\
\frac{\partial E^{C I}}{\partial c_{r}}=0 \quad \rightarrow \quad \sum_{p=1}^{n}\left(H_{p q}-E^{C I} \delta_{p q}\right) c_{p}=0
$$
线性变分所得出的$$\{C_P\}$$列向量满足久期方程：$$\boldsymbol{H} \boldsymbol{C}=E^{CI} \boldsymbol{C}$$

解此本征值方程即可求出Cl波函数和能量。

## SCF-CI处理步骤

1. HF-SCF MO计算（简单从头算）

2. 在组态空间$$\{\Phi_P\}$$形成电子总哈密顿矩阵$$\mathbf{H}=\{H_{pq}\}$$

3. 对角化$$\boldsymbol{H}$$矩阵求得CI能级和波函数：$$\mathbf{C}^{+} \mathbf{H C}=\mathbf{E}^{\mathrm{CI}}$$

   产生：
   $$
   \begin{array}{l}
   E_{0}^{C I} \leq E_{1}^{C I} \leq E_{2}^{C I} \leq \cdots \\
   \Psi_{0}^{C I}, \Psi_{1}^{C I}, \Psi_{2}^{C I}, \cdots
   \end{array}
   $$
   其中$$\Psi_{0}^{C I}$$对应基态，$$\{\Psi_{k}^{CI},k=1,2,\cdots\}$$对应第$$k$$个激发态



- 矩阵在正交变换前后阵迹不变：$$\sum_{\mu} E_{\mu}^{C I}=\operatorname{Tr} \mathbf{H}$$

- 变分结果使低能量组态能级降低,高能量组态能级升高：

  <img src="image-20201120152427635.png" style="zoom:50%;" />

- 因此CISD处理可改善分子基态和低激发态的能量和波函数,但对高激发态效果不佳(需要T,Q,P,...等激发组态)

# CI处理的分类

纳入越高阶激发行列式，由于可以越准确地展开实际体系多电子波函数，CI的结果也就越准确。考虑所有可能的激发行列式时称为Full CI（有n个电子就考虑到n重激发态就考虑到最高阶），是理论方法的完美极限。但由于Full CI计算量极大，实际CI计算用的都是截断的CI(Truncated CI)，越高阶精度越高耗时也越高：

- CIS：仅考虑全部单电子激发组态的CI处理。对基态能量无修正作用，只能算激发态，可修正若干低激发态。常用于激发态分子的几何优化计算和光化学反应及其反应途径的计算
- CID：考虑HF波函数及二重激发行列式
- CISD：考虑HF波函数及单重、 二重激发行列式。可修正基态相关能~90%（基组须足够大，下同）
- CISDT：考虑HF波函数及单重、 二重、三重激发行列式。可修正基态相关能~95%（<20个电子）
- CISD (T)：CISD+部分贡献大的三电子激发组态，精度与CISDT接近。（30-40个电子）
- CISD(TQ)：CISD (T)+部分四重激发组态，可校正相关能 98 %%，计算量很大，（<10 的体系）



# 评价

计算量太大、包含了很多没有贡献的构型，效率低。同样计算量下，CI的结果不如微扰、耦合簇，因此很不划算，很少被直接使用计算基态性质。

- Size consistency：碎片的计算误差与结合后的整体的计算误差可以抵消
- Size extensivity：多电子与少电子的误差要一致。

大小一致性很重要，若计算方法不具备大小一致性，结合能、电离能等无法比较，无法准确计算。HF、MBPT、CC和FCI具有大小一致性，而截断的CI不具有，可以通过Davisaon校正，即CISD+Q。

