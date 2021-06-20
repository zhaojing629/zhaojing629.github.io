---
title: 基组
typora-root-url: 基组
date: 2021-06-18 19:33:37
updated: 
tags: 基组
mathjax: true
categories: 计算化学
description: 关于基组的基础知识
---




- 从头算中，采取了LCAO-MO近似，即通过对原子轨道进行线性叠加来构造分子轨道：$$\left|\psi_{\mu}\right\rangle=\sum_{i=1}^{n}\left|\varphi_{i}\right\rangle a_{i \mu} $$
- 由原子的Hatree-Fock方程得到的原子轨道AO为数值解析的函数，因此需要通过解析函数来拟合：$$\left|\varphi_{i}\right\rangle=\sum_{k=1}^{m}\left|\chi_{k}\right\rangle b_{k i} $$
- 以基函数为基的Roothaan方程：$$\left|\psi_{\mu}\right\rangle=\sum_{=1}^{n} \sum_{k=1}^{m}\left|\chi_{k}\right\rangle b_{k i} a_{i \mu}=\sum_{k=1}^{m}\left|\chi_{k}\right\rangle\left[\sum_{i=1}^{n} b_{k} a_{i \mu}\right]=\sum_{i=1}^{m}\left|\chi_{k}\right\rangle c_{k \mu}$$

- 基函数集基本要求：
  - 分子积分容易计算，且速度快；
  - 在较小的基组维界下即可逼近数学完备集的理论极限精度（MO的展开具有高的收敛性）

# $$Y_{l m}$$部分

## 中心势场型AO基组

- 对单电子原子的薛定谔方程进行求解，通过球坐标的变换和使用变量分离法，得到$$\varphi(r, \theta, \phi)=R_{n l}(r) Y_{l m}(\theta, \phi)$$，其中球谐部分$$ Y_{l m}(\theta, \phi)$$与势能无关。
- 对于多电子体系，其他电子对第i个电子的排斥看为对核电荷的屏蔽，即引入屏蔽常数σ。与势能的径向部分写为$$R_{n l}(r, \sigma)$$，即得到$$\varphi(r, \theta, \phi)=R_{n l}(r, \sigma) Y_{l m}(\theta, \phi)$$
  - n主量子数：1, 2, ...
  - l角量子数：0, 1, 2, ..., n-1（s、p、d、f……）
  - m磁量子数：0,±1, ...,±l

## 复AO和实AO

$$Y_{l m}(\theta, \phi)$$分为复型（连属Legendre多项式）和实型

例子：

- $$\text { Complex }\left\{\begin{array}{l}
  Y_{11}=\sqrt{\frac{3}{8 \pi}} \sin \theta e^{i \varphi} \\
  Y_{10}=\sqrt{\frac{3}{4 \pi}} \cos \theta \\
  Y_{1 \overline{1}}=\sqrt{\frac{3}{8 \pi}} \sin \theta e^{-i \varphi}
  \end{array}\right.$$，具有球对称性$$K_h$$，无方向性，物理学家更关心。
- $$\text { Real }\left\{\begin{array}{l}
  Y_{p x}=\sqrt{\frac{3}{4 \pi}} \sin \theta \cos \varphi=\sqrt{\frac{3}{4 \pi}} \frac{x}{r} \\
  Y_{p y}=\sqrt{\frac{3}{4 \pi}} \sin \theta \sin \varphi=\sqrt{\frac{3}{4 \pi}} \frac{y}{r} \\
  Y_{p z}=\sqrt{\frac{3}{4 \pi}} \cos \theta=\sqrt{\frac{3}{4 \pi}} \frac{z}{r}
  \end{array}\right.$$，具有立方对称性$$O_h$$，化学家更关心化学键中原子的位置和方向，所以降低其对称性，引入了x，y，z方向。

![p型复AO和实AO的角度分布比较](p型复AO和实AO的角度分布比较.png)

特点：

- 复AO无方向性；AO与共价键方向性相联系
- 原子计算用复AO基，分子计算用实AO基
- 复AO基与实AO基可以通过欧拉公式$$e^{i x}=\cos x+i \sin x$$，线性组合相互转换：$$Y_{p x}=\frac{1}{\sqrt{2}}\left(Y_{11}+Y_{1 \overline{1}}\right) ; \quad Y_{p y}=\frac{1}{\sqrt{2} i}\left(Y_{11}-Y_{1 \overline{1}}\right)$$
- 不同AO基的角度部分$$Y_{l m}$$均固定不变，基函数的选择实际上是选取$$R_{n l}$$合适的形式

# $$R_{n l}$$部分

类氢原子轨道的径向函数为连属Laguerre多项式的形式：$$R_{n l}(r)=N_{n} e^{-\rho / 2} \rho^{l} L_{n+l}^{2 l+1}(\rho) ; \quad \rho=\frac{2 Z}{n} \frac{r}{a_{0}}$$，展开为：
$$
R_{n l}(r)=\sum_{k=0}^{n-l-1} c_{k}\left(\frac{r}{a_{0}}\right)^{k}\left(\frac{r}{a_{0}}\right)^{l} e^{-\frac{Z r}{n a_{0}}}=\left[c_{0}+c_{1} \frac{r}{a_{0}}+\cdots+c_{n-l-1}\left(\frac{r}{a_{0}}\right)^{n-l-1}\right]\left(\frac{r}{a_{0}}\right)^{l} e^{-\frac{Z r}{n a_{0}}}
$$

- 最高次项取到n-l-1，这样符合解薛定谔方程的量子数。
- 函数中，n-l-1次多项式有n-l个极值点和n-l-1个节点，积分非常困难（时正时负），不便用于分子积分计算。

例子：氢原子的2s和sp连属Laguerre多项式

$$R_{2 s}(r)=\left[c_{0}+c_{1} \frac{r}{a_{0}}\right] e^{-\frac{Z r}{n a_{0}}}$$$$\quad R_{2 p}(r)=\left[c_{0}\right]\left(\frac{r}{a_{0}}\right) e^{-\frac{Z r}{n a_{0}}}$$

径向分布函数：$$D(r)=r^{2} R(r)^{2}$$

<img src="/image-20210618172635946.png" alt="image-20210618172635946" style="zoom: 40%;" />



# Slater-Type Orbital（STO）

Slater提出一种无节点型的简化径向函数
$$
R_{n}(r ; \zeta)=N_{n, \zeta} r^{n-1} e^{-\varsigma r},\zeta=(Z-\sigma) / n
$$

- 实际上是截取了类氢AO的最高次项，$$\left(\cdots r^{n-l-1}\right) r^{l} e^{\cdots} \Rightarrow \cdots r^{n-1} e^{. \cdots}$$
- 数值仅仅与$$n$$和$$\sigma$$（Slater screening constant）有关，即$$\zeta$$，而与$$l$$无关。
- $$R_n$$无节点，因此函数集归一化但相互不正交：$$\left\langle R_{n} \mid R_{n^{\prime}}\right\rangle=\int R_{n}^{*}(r ; \varsigma) R_{n^{\prime}}(r ; \varsigma) r^{2} d \tau \neq \delta_{n n^{\prime}}$$
- $$R_{n}(r ; \zeta)$$和$$Y_{l m}$$组合构成的基函数集通称“Slater型轨道”（STO），属于非正交的AO基集。但是其实严格来说不是一个轨道，只是一个函数拟合的轨道，严格的简称STF。

## $$\zeta$$的优化

- 这一方法取决于$$\zeta$$的精度。但是与分子有关，即随体系变化。
- 先通过对个元素原子的SCF计算，对$$\zeta$$初步优化，再在分子环境下进行$$\zeta$$的再优化。
- 对大量的中、小分子的“最优$$\zeta$$“进行平均，定义出“标准$$\zeta$$”，Gaussain和大多数软件的默认值都是标准$$\zeta$$

![image-20210618190026149](/image-20210618190026149.png)

## AO基组的大小等级

### 极小基Minimal basis sets（MBS）

- 原子的每个AO只对应一个基函数。也称为“单$$\zeta$$基组”，即SZ。
- $$\left\{\phi_{i}\right\}=\text { Core AO's }+\text { Valence AO's }$$，包含芯基组和价基组
- 精度比较低。

### 价基组Valence basis sets

- 去除极小基中的“芯基组”，只留下价基组
- 用于半经验和低级的价电子从头算

### 扩展基组

- 向极小基中增加基函数，进一步逼近完备集。$$\left\{\phi_{i}\right\}=\text { Minimal BS }+\text {Additional BS }$$
- 增大变分空间，计算精度得以改善

## 常见的STO扩展基组形式

### nζ基组

- 双ζ基组，DZ：每个AO对应2个n相同，但ζ不同的STO（ζ'<ζ'）
- 也有TZ，QZ等。

### 含极化函数的基组

$$\left\{\phi_{i}\right\}=\text { DZ }+\text { Polarization function }$$

- 向DZ基加速比价AO角量子数l更高的基函数以利于描述原子成键后的电子云极化变形。（ADF中描述位nZ2P，2P表示两个极化函数。）
- 例子：比如为了描述H原子1s轨道成键的方向性，加入2p型极化函数。2p轨道就加入3d轨道，3d加入f轨道。

<img src="/image-20210618194650821.png" alt="image-20210618194650821" style="zoom:50%;" />

### 含弥散函数的基组

- 分子的负离子因电子过量使电子云弥散度增加，向极化基组中添加**小的ζ**弥散函数使物理图像能正确反映。比如分子间弱相互作用（范德华力、氢键）体系或过渡态、激发态的计算通常也需要添加弥散函数。
- ζ越小，r增大时，$$R_{n}(r ; \zeta)=N_{n, \zeta} r^{n-1} e^{-\varsigma r}$$衰减的速度越慢，因此加入小ζ的STO有利于对原子核区域的电子运动的描述。

<img src="/image-20210618200107486.png" alt="image-20210618200107486" style="zoom:50%;" />

## STO基组的优缺点和用途

- 优点：与真实原子分子轨道的径向电子分布特性确实比较靠近，因为是从类氢原子推出来的。
- 缺点：计算三、四中心双电子积分困难。
  - 因为再球坐标下$$\frac{1}{r_{12}}$$的展开为$$\frac{1}{r_{12}}=\sum_{l=0}^{\infty} \frac{r_{<}^{l}}{r_{>}^{l+1}} P_{l}(\cos \theta)$$，是收敛很慢的无穷级数。（$$P_{l}(\cos \theta)$$为l阶Legendre多项式）
- 用途：
  - 主要用于半经验 MO 计算，因为把很多积分都忽略了。
  - 在从头计算中可用于原子和双原子分子的计算，很少用于比 CH4 更大的分子。
  - 近年来在密度泛函理论（DFT）中使用逐渐增多。DFT 中很多矩阵元都无法用解析函数表达，只能用数值积分，所以就不需要更复杂的基函数，直接用 Slater 基函数。比如ADF程序。

# 高斯型基函数（GTO）

- Boys于1950年提出用归一化 Gaussian 函数作为径向函数：

$$
R_{n}(r, \alpha)=c_{n} r^{n-1} e^{-\alpha r^{2}}，
{c_{n}=2^{n+1}[(2 n-1) ! !]^{-1 / 2} 2 \pi^{-1 / 4}}
$$

- $$R_n$$与$$Y_{lm}$$组合称为Gaussian-type atomic orbitals，简称GTO。
  - 球极坐标：$$\chi_{n l m}(\alpha ; r, \theta, \varphi)=c_{n} r^{n-1} e^{-\alpha r^{2}} Y_{l m}(\theta, \varphi)$$
  - 直角坐标/笛卡尔型：$$\chi_{L M N}(\alpha ; x, y, z)=N_{\alpha} x^{L} y^{M} z^{N} e^{-\alpha r^{2}}$$，
    - $$N_{\alpha}$$：归一化系数
    - α：高斯函数指数（决定收敛快慢，越大收敛越快）
    - r：距离原子核的距离，x，y，z也是r的笛卡尔分量
    - L、M、N：决定了GTO的类型，$$L+M+N=l$$是AO的角量子数。

## GTO的标记

<img src="/image-20210618234317761.png" alt="image-20210618234317761" style="zoom:50%;" />

- O是远点，A、B为原子，原子A的坐标为：$$\vec{R}_{A}=\vec{i} A_{x}+\vec{j} A_{y}+\vec{k} A_{z}$$
- 电子的坐标为$$e(x,y,z)$$，$$\vec{r}=\vec{i} x+\vec{j} y+\vec{k} z$$
- 原子A上的GTO为：$$\chi(A, \alpha, L, M, N)=N x_{A}^{L} y_{A}^{M} z_{A}^{N} e^{-r_{A}^{2}}$$
  - $$r_{A}=\mid \vec{r}-\vec{R}_{A} \mid$$
  - $$x_{A}=x-A_{x}, y_{A}=y-A_{y}, \quad z_{A}=z-A_{z}$$
  - $$r_{A}=\sqrt{x_{A}^{2}+y_{A}^{2}+z_{A}^{2}}, \quad L+M+N=l$$

## GTO的特点

- 径向无节点
- 函数值的指数衰减比STO快得多，两者的指数上面分别是$$-\alpha r^2$$和$$-\zeta r$$
- 变量可分离：$$x^{L} y^{M} z^{N} e^{-\alpha r^{2}}=x^{L} e^{-c x^{2}} \cdot y^{M} e^{-\alpha y^{2}} \cdot z^{N} e^{-\alpha z^{2}}$$
- 位于 A、B 两中心上的两个 GTO 乘积可向广义质心作单中心展开：
$$
\chi\left(A, \alpha_{1}, L_{1}, M_{1}, N_{1}\right) \cdot \chi\left(B, \alpha_{2}, L_{2}, M_{2}, N_{2}\right)=\sum_{L=0}^{L_{1}+L_{2}} \sum_{M=0}^{M_{1}+M_{2}} \sum_{n=0}^{N_{1}+N_{2}} C_{L M N} \chi(P, \alpha, L, M, N)
$$
> <img src="/image-20210618235810647.png" alt="image-20210618235810647" style="zoom:50%;" />
>
> 其中$$|\overrightarrow{A P}|=\frac{\alpha_{2}}{\alpha_{1}+\alpha_{2}}|\overrightarrow{A B}| ;|\overrightarrow{B P}|=\frac{\alpha_{1}}{\alpha_{1}+\alpha_{2}}|\overrightarrow{A B}|$$，即杠杆定理。而各种积分都是两个函数的乘积的形式，从而大大简化各种积分运算。

- GTO径向函数相比于STO，除了指数上的变化以外，$$r^{n-l}$$变成了$$r^l$$。**则GTO不含主量子数n。**n对各壳层的影响仅体现在α的大小上，即n越大，α越小。

> 由$$L+M+N=l$$，则：
> $$
> \begin{aligned}\chi_{L M N} &=N x^{L} y^{M} z^{N} e^{-\alpha r^{2}}=N r^{l}\left(\frac{x}{r}\right)^{L}\left(\frac{y}{r}\right)^{M}\left(\frac{z}{r}\right)^{N} e^{-\alpha r^{2}} \\&=N r^{l} e^{-\alpha r^{2}} \cos ^{L} \theta \sin ^{L+M} \phi \sin ^{M} \theta \cos ^{N} \phi \\&=N r^l e^{-\alpha r^{2}} \cdot \tilde{Y}_{L M N}(\theta, \phi)\end{aligned}
> $$

## 从头算中使用的高斯型函数

因为没有主量子数n，直接分为：

- s型基函数：$$e^{-\alpha r^{2}}$$
- p型基函数：$$xe^{-\alpha r^{2}}$$，$$ye^{-\alpha r^{2}}$$，$$ze^{-\alpha r^{2}}$$
- d型基函数：$$x^2e^{-\alpha r^{2}}$$，$$y^2 e^{-\alpha r^{2}}$$，$$z^2e^{-\alpha r^{2}}$$，$$xye^{-\alpha r^{2}}$$，$$xze^{-\alpha r^{2}}$$，$$yze^{-\alpha r^{2}}$$
  - 但是这6个并不是完全独立的，前三个可以写成为：$$(3z^2-r^2)e^{-\alpha r^{2}}$$，$$(x^2-y^2)e^{-\alpha r^{2}}$$，$$(x^2+y^2+z^2)e^{-\alpha r^{2}}$$。而其中最后一项是s型基函数。因此前两项和剩下的三项构成了5个d型球谐基函数。

|  l   | Type |  L   |  M   |  N   |  l   | Type |  L   |  M   |  N   |
| :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
| 0(S) |  S   |  0   |  0   |  0   | 3(F) | XXX  |  3   |  0   |  0   |
| 1(P) |  X   |  1   |  0   |  0   | 3(F) | YYY  |  0   |  3   |  0   |
| 1(P) |  Y   |  0   |  1   |  0   | 3(F) | ZZZ  |  0   |  0   |  3   |
| 1(P) |  Z   |  0   |  0   |  1   | 3(F) | XXY  |  2   |  1   |  0   |
| 2(D) |  XX  |  2   |  0   |  0   | 3(F) | XXZ  |  2   |  0   |  1   |
| 2(D) |  YY  |  0   |  2   |  0   | 3(F) | YYZ  |  0   |  2   |  1   |
| 2(D) |  ZZ  |  0   |  0   |  2   | 3(F) | XYY  |  1   |  2   |  0   |
| 2(D) |  XY  |  1   |  1   |  0   | 3(F) | XZZ  |  1   |  0   |  2   |
| 2(D) |  XZ  |  1   |  0   |  1   | 3(F) | YZZ  |  0   |  1   |  2   |
| 2(D) |  YZ  |  0   |  1   |  1   | 3(F) | XYZ  |  1   |  1   |  1   |

实际计算时，对于角动量高于D的笛卡尔型基函数，一般把它们转化成球谐型高斯基函数再用，这可以节约耗时和避免数值问题。并且与原子轨道特点相同。

## GTO和STO的比较

- 电子运动图像描述，STO更好。分子积分计算处理，GTO更好。为了弥补GTO物理图像的缺陷，可以增大基函数的数目。

- 例子：10s6p-GTO用于B~Ne的计算，与双ζ-STO精度相似。
  - 而GTO中的基函数总数为：10+6×3=28。STO中的基函数总数为：2+(1+3)×2=10
  - (ij|kl)积分∝n<sup>4</sup>，因此采用GTO使得积分总数增大了2.8<sup>4</sup>=62倍，但是计算一个GTO积分比STO快3-4个数量级。

# 高斯基组的分类



