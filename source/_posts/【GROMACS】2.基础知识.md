---
title: 【GROMACS】2.基础知识
typora-root-url: 【GROMACS】【GROMACS】2.基础知识
mathjax: true
date: 2026-08-11 9:25:19
updated:
tags: [GROMACS]
categories: [计算化学, 软件]
description: Gromacs的一般知识
---



# MD单位

| 物理量 | 符号 |                           单位                           |
| :----: | :--: | :------------------------------------------------------: |
|  长度  |  r   |                  nm＝ 10<sup>-9</sup> m                  |
|  质量  |  m   | 原子质量单位(u) ＝ 1.660 540 2(10) × 10<sup>-17</sup> kg |
|  时间  |  t   |                 ps＝ 10<sup>-12</sup>  s                 |
|  电荷  |  q   |        e ＝ 1.602 177 33(49) × 10<sup>-9</sup> C         |
|  温度  |  T   |                            K                             |



|  物理量  |     符号     |                             单位                             |
| :------: | :----------: | :----------------------------------------------------------: |
|   能量   |    $E,V$     |                    $\mathrm{kJ~mol}^{-1}$                    |
|    力    | $\mathbf{F}$ |           $\mathrm{kJ~mol}^{-1}~\mathrm{nm}^{-1}$            |
|   压力   |     $p$      |                             bar                              |
|   速度   |     $v$      |                   $\mathrm{e\ nm}$   nm/ps                   |
|  偶极矩  |    $\mu$     |                       $\mathrm{e\ nm}$                       |
|   电势   |    $\Phi$    | $\mathrm{kJ~mol}^{-1}\mathrm{~e}^{-1} = 0.010\,364\,269\,19$ |
| 电场强度 |     $E$      | $\mathrm{kJ~mol}^{-1}\mathrm{~nm}^{-1}\ \mathrm{e}^{-1} =1.036\,426\,919 \times 10^7\mathrm{~V m}^{-1}$ |





# 力场

## 常见力场

红色、蓝色的各自相互兼容：

- GROMOS：烷烃、蛋白、核酸、糖、有机小分子
  相互兼容
- OPLS：蛋白、RNA、糖、有机小分子
- <font color ="red" >AMBER：蛋白、核酸、部分有机小分子</font>
- <font color ="red" >GAFF：各种有机小分子</font>
- <font color ="red" >GLYCAM：糖、磷脂</font>
- <font color ="red" >Lipid：磷脂、胆固醇</font>
- <font color ="blue" >CHARMM：磷脂、核酸、蛋白、糖、部分有机小分子</font>
- <font color ="blue" >CGenFF：各种有机小分子</font>
- Dreiding、UFF;各种类型分子和材料
- COMPASS：有机和一些无机分子、高分子，常用于材料领域的各种性质计算。M$私有，不公开
- MM系列、MMFF94：准确计算各种有机小分子
- ReaxFF：最流行的反应力场
- MARTINI：粗粒化。磷脂、蛋白质、聚合物、糖、胆固醇



