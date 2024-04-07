---
title: 【【草稿】】Hatree-Forck方法
typora-root-url: Hatree-Forck方法
date: 2023-7-7 19:33:37
updated: 
tags: [薛定谔方程, Hatree-Fock]
mathjax: true
categories: [计算化学, 原理]
description: 量子化学基本常识
---





# 光的波粒二象性

光：$$\lambda \nu = c$$（$\nu$是光的频率，$\lambda$波长，$c$既是光的传播速度，又是光子的运动速度）

Einstein 提出光子学说：$E=h\nu$（$h$是普朗克常数，即$6.626 \times 10^{-34} J\cdot s$)

通过$E=mc^2$，得到：$m=\frac{E}{c^2} =\frac{h\nu}{c^2}$

通过动量公式$p=mc$，得到$p=\frac{h}{\lambda}$

# 德布罗意关系式

1924 年de Broglie( 德布罗意）受到光的波粒二象性理论的启发，提出实物微粒也有波性：
$$
E=h\nu \\
p=\frac{h}{\lambda}
$$


联立得到实物的波长为：$\lambda=\frac{h}{p}=\frac{h}{mv}$

# 波动方程

- 原点的振动方程：（$A$是振幅、$\omega$是角频率，${\varphi}_0$是初相）

  $y_0(t)=A\cos(\omega t + {\varphi}_0)$

- x点的振动方程：（$v$是波的传播速度）

  $y(x,t)=A \cos \left [ \omega(t-\frac{x}{v}) + {\varphi}_0\right ]$

  > 以上也可以通过弹簧简谐振动求解微分方程$F=m \frac{\mathrm{d}^{2} x}{\mathrm{~d} t^{2}}=-kx $得到

扩展到三维波函数，设初相为0，振幅1：

$$
\begin{aligned}
\Psi(\vec{r}，t) &=\cos \left[ \omega t- \omega\frac{\vec{r}}{\vec{v}}\right] \\
&= \cos \left[ 2\pi\nu t - \frac{2\pi\nu}{\lambda \nu} \vec{r} \right] \\
&=\cos \left[\frac{2\pi}{h}Et - \frac{2\pi}{h} \vec{p} \cdot \vec{r} \right] \\
&=\cos \left[\frac{E}{\hbar}t-\frac{\vec{p}}{\hbar}\vec{r}\right]
\end{aligned}
$$

通过欧拉公式$e^{-ix} = \cos x - i \sin x$，得到
$$
\Psi(\vec{r}，t) = e^{-\frac{i}{\hbar}(Et-\vec{p} \vec{r})}
$$

# 含时薛定谔方程

对时间$t$求导，得到$\frac{\partial \Psi}{\partial t}=\frac{-iE} {\hbar}\Psi$，则$E\Psi=i\hbar\frac{\partial\Psi}{\partial t}$，即得到了**含时薛定谔方程**：$\hat{H}\Psi=i\hbar\frac{\partial}{\partial t}\Psi$

算符：

- 对位置$x$求导得到：$\frac{\partial \Psi}{\partial x}=\frac{ip_x} {\hbar}\Psi$，则$\vec{p_x}\Psi=-i\hbar\frac{\partial\Psi}{\partial \vec{x}}$，即**动量算符**为$\hat{p_x}=-i\hbar\frac{\partial}{\partial x}$。
- 对位置$\vec{x}$求二阶导，得到$\frac{\partial ^2}{\partial x^2}=-\frac{p_x^2}{ \hbar^2}\Psi$
- 动能为：$T=\frac{1}{2}mv^2=\frac{\vec{p}^2}{2m}=\frac{1}{2m}(p_x^2+p_y^2+p_z^2)=-\frac{\hbar^2}{2m}(\frac{\partial ^2}{\partial x^2}+\frac{\partial ^2}{\partial y^2}+\frac{\partial ^2}{\partial z^2})\Psi$

- Laplace算符$\nabla^{2}=\left(\frac{\partial^{2}}{\partial x^{2}}+\frac{\partial^{2}}{\partial y^{2}}+\frac{\partial^{2}}{\partial z^{2}}\right)$
- 即**动能算符**为$\hat{T}=-\frac{\hbar^2}{2m}\nabla^{2}$

- **势能算符**就是$\hat{V}= V$
- 总能量=动能+势能，Hamilton**哈密顿算符**$\hat{H}=-\frac{\hbar^2}{2m}\nabla^{2}+ V$

**含时薛定谔方程的广义形式**的表达为$-\frac{\hbar^2}{2m}\nabla^{2}\Psi(\vec{r},t)+V(\vec{r},t)\Psi(\vec{r},t)=i \hbar \frac{\partial }{\partial  t} \Psi(\vec{r},t)$



# 不含时薛定谔方程

假设外势与时间无关，则可以将一维的薛定谔方程写为$\Psi(x,t)=f(t)\psi(x)$

分别对t求导和对x求二阶导，得到：$\frac{\partial \Psi(x, t)}{\partial t}=\frac{d f(t)}{d t} \psi(x)$和$\frac{\partial^{2} \Psi(x, t)}{\partial x^{2}}=f(t) \frac{d^{2} \psi(x)}{d x^{2}}$

带入含时薛定谔方程的广义形式得到：

$i\hbar \times \frac{d f(t)}{d t} \psi(x)=-\frac{\hbar^2}{2m} \times f(t) \frac{d^{2} \psi(x)}{d x^{2}} + V(x)f(t)\psi(x)$

把含有t和x的分别移动到两边：

$i\hbar \frac{1}{f(t)} \frac{d f(t)}{d t} = -\frac{\hbar^2}{2m} \frac{1}{\psi(x)} \frac{d^{2} \psi(x)}{d x^{2}}+V(x)  $

- 左侧与t有关，右侧与x有关，等式成立，说明左右同时等于一个常量， 设常量为能量E，则$i\hbar \frac{1}{f(t)} \frac{d f(t)}{d t} =E$，$\frac{d f(t)}{f(t)}=-\frac{i E}{\hbar} d t$求解得到：

  $\ln f(t)=-i E t / \hbar+C$，$f(t)=e^Ce^{iEt/\hbar}=Ae^{iEt/\hbar}$

  把常数项归于$\psi(x)$，取$f(t)=e^{iEt/\hbar}$

  则$\Psi(x,t)=e^{iEt/\hbar}\psi(x)$

- 右侧也等于E，则：

  $-\frac{\hbar^2}{2m} \frac{d^{2}}{d x^{2}} \psi(x)+V(x)\psi(x)=E\psi(x)$

  三维的即为$(-\frac{\hbar^2}{2m}\nabla^{2}+ V(\vec{r}))\psi(\vec{r})=E\psi(\vec{r})$

得到**不含时的薛定谔方程**$\hat{H}\psi=E\psi$，即：$\frac{\hbar^2}{2m}\nabla^{2}\psi+ (E-V)\psi=0$





[薛定谔于1926年假设了薛定谔方程](https://journals.aps.org/pr/abstract/10.1103/PhysRev.28.1049)。

# 多原子分子的哈密顿量

对于一个多原子分子，其哈密顿算符为：

$$
\hat{H}=-\sum_{p} \frac{\hbar^{2}}{2 M_{p}} \nabla_{p}^{2}-\sum_{i} \frac{\hbar^{2}}{2 m_e} \nabla_{i}^{2}-\sum_i\sum_{p} \frac{\kappa Z_{p} e^{2}}{r_{p i}}+\sum_i\sum_{j<i} \frac{\kappa e^{2}}{r_{i j}}+\sum_{p}\sum_{p<q} \frac{ \kappa Z_{p} Z_{q} e^{2}}{R_{p q}}
$$


其中，$p$和$q$表示原子核，$i$和$j$表示电子。

$r_{pi}$代表电子与原子序数为$Z_p$的核$p$之间的距离，$r_{ij}$代表电子之间的距离，$R_{pq}$代表原子序数为$Z_{p}$和$Z_{q}$的核$p$和$q$之间的距离。

因此，这五项分别代表核的动能算符$\hat{T_n}$，电子的动能算符$\hat{T_e}$，电子和核之间的吸引能$\hat{V}_{ne}$，核之间的排斥能$\hat{V}_{nn}$，电子之间的排斥能$\hat{V}_{ee}$。

通过原子单位，即电子质量$m_e$，电子的基本电荷$e$，约化普朗克常数$\hbar$，库伦常数$\kappa=\frac{1}{4\pi \varepsilon}$均为1a.u.，可以将该式简化为：
$$
\begin{align}
\hat{H} &=-\sum_{p} \frac{1}{2 M_{p}} \nabla_{p}^{2}-\sum_{i} \frac{1}{2} \nabla_{i}^{2}-\sum_{p, i} \frac{Z_{p} }{r_{p i}}+\sum_{j<i} \frac{1}{r_{i j}}+\sum_{p<q} \frac{Z_{p} Z_{q}}{R_{p q}} \\
&= \left[ -\sum_{i} \frac{1}{2} \nabla_{i}^{2} -\sum_i \sum_p \frac{Z_{p} }{r_{p i}}+ \frac{1}{2}\sum_i \sum_{j \ne i} \frac{1}{r_{i j}} \right] + \left[ -\sum_{p} \frac{1}{2 M_{p}} \nabla_{p}^{2} +\sum_{p}\sum_{p<q} \frac{Z_{p} Z_{q}}{R_{p q}} \right] \\
&= \hat{H}_{el} + \hat{H}_{nuc}
\end{align}
$$

# 非相对论近似

根据爱因斯坦提出的广义相对论，可以推得粒子的质量为$m=\frac{m_0}{\sqrt{1-\frac{v^2}{c^2}}}$

在较轻的原子中，电子的运动速度引起的相对论效应较小，因此可以将电子质量当作常数，但是在重元素的体系下会引起严重的误差。



# 核独立近似

由于原子核的质量$ M_{p}$远大于电子质量$m_e$，电子的运动也比核快得多。

因此$\frac{1}{2m_e} \nabla_{i}^{2}$远大于$\frac{1}{2M_p} \nabla_{p}^{2}$，$\frac{1}{2M_p} \nabla_{p}^{2}$可以近似为0。

因此，在电子运动时，我们可以把核看作是固定的，原子核之间的排斥也可以近似为常数，因此只需要独立地考虑电子运动。这个将电子和核的的运动分开的近似是[玻恩-奥本海默近似（Born-Oppenheimer Approximation），](https://onlinelibrary.wiley.com/doi/10.1002/andp.19273892002)则对于电子的哈密顿算符为：
$$
\begin{align}
\hat{H}_{el} =\sum_{i}\left[ \hat{h}_i+ \frac{1}{2} \sum_{j\ne i}\hat{g}_{ij}  \right] 
\end{align}
$$
其中，$\hat{h}_i$为单电子哈密顿算符， $\hat{g}_{ij} $为双电子哈密顿算符。



# 平均场近似 Hatree 方法

将电子间的库仑排斥作用平均化，每个电子均视为在核库仑场与其它电子对该电子作用的平均势相叠加而成的势场中运动，从而单个电子的运动特性只取决于其它电子的平均密度分布〈即电子云〉而与后者的瞬时位置无关。因此：
$$
\begin{align}
\hat{H}_{el} &=\sum_{i}\left[ -\frac{1}{2} \nabla_{i}^{2} - \sum_{p} \frac{Z_{p} }{r_{p i}} +\sum_{j<i} \frac{1}{r_{i j}} \right] \\
&=\sum_{i}\left[ -\frac{1}{2} \nabla_{i}^{2} - \sum_{p} \frac{Z_{p} }{r_{p i}}+  V_i(r_i)   \right] \\
&=\sum_i \hat{h}_i^{eff}

\end{align}
$$
其中第i个电子受到的势能看作：$ V_{i}\left(r_{i}\right)=\sum_{j \neq i} V_{i j}\left(r_{i}\right)=\sum_{j \neq i} \int \frac{q_i q_j}{r_{ij}}=\sum_{j \neq i} \int \frac{e \times e |\psi_{j}|^2}{r_{ij}} d^3r_j=\sum_{j \neq i}\left\langle\psi_{j}\left|r_{i j}^{-1}\right| \psi_{j}\right\rangle $

N电子体系的波函数可写成N个单电子波函数的乘积：
$$
\Psi\left(\vec{x}_{1}, \vec{x}_{2}, \cdots, \vec{x}_{N}\right)=\psi_{1}\left(\vec{x}_{1}\right) \psi_{2}\left(\vec{x}_{2}\right) \cdots \psi_{N}\left(\vec{x}_{N}\right)
$$
由于$\hat{h}_i^{eff}=\varepsilon_i\psi_i$，则$(\sum_i \hat{h}_i^{eff})(\psi_1 \psi_2 \cdots \psi_i \cdots \psi_n)=(\sum_i \varepsilon_i)(\psi_1 \psi_2 \cdots \psi_i \cdots \psi_n)$

# Hatree-Fock方法

独立粒子近似不满足费米子全同粒子的反对称要求，

1929年引入Slater行列式的形式，只要交换两个电子的坐标，符号就会改变，当有两条相同的占据轨道存在时，行列式为0，也体现了Pauli不相容原理。
$$
\Psi\left(\vec{x}_{1}, \vec{x}_{2}, \cdots, \vec{x}_{N}\right)=\frac{1}{\sqrt{N!} }\begin{vmatrix}  \psi_1(x_1)&   \psi_1(x_1) &   \dots &   \psi_N(x_1)\\  \psi_1(x_2)&  \psi_1(x_2)& \dots &\psi_N(x_2) \\ \vdots  & \vdots & \ddots  & \vdots\\  \psi_1(x_N)&  \psi_1(x_N)& \dots & \psi_N(x_N)\end{vmatrix}
$$


$E(\Psi)=<\Psi|\hat{H}|\Psi>=\sum_{i}\left[ <\Psi|\hat{h}_i|\Psi>  + \frac{1}{2}\sum_{j \ne i}<\Psi|\hat{g}_{ij}|\Psi>  \right]$





平均场中：

$\Psi=\hat{A}||$

