---
title: 多组态MCSCF
typora-root-url: 多组态MCSCF
mathjax: true
date: 2020-11-20 13:45:39
updated:
tags: MCSCF
categories: [计算化学, 原理]
description: 多组态方法的一些原理
---







# 与CI的区别

CI：
$$
\Psi^{C I}=\sum_{P} C_{P} \Phi_{P}
$$
MCSCF：
$$
\Psi^{M C S C F}=\sum_{k=0}^{\operatorname{CSF}_{s}} A_{k} \Phi_{k}
$$

- CI解决的是动态相关，MCSCF解决的是静态相关
- 通过变分法求得$$C_P$$，只优化系数。MCSCF中N电子的CSF为：$$\Phi_{k}=\hat{A}\left|\phi_{1} \bar{\phi}_{1} \ldots \phi_{m} \bar{\phi}_{m}\right|$$，单电子轨道为：$$\phi_{i}=\sum_{\mu} \chi_{\mu} C_{\mu i}$$，除了优化系数$$ A_{k}$$，还会优化轨道，即$$C_{\mu i}$$。
- CASSCF中相当于在所选的活性空间中有一个Full CI并优化了所选的轨道。

