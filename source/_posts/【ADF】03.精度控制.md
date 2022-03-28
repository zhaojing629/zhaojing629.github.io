---
title: 【ADF】03.精度控制
typora-root-url: 【ADF】03.精度控制
date: 2021-12-06
updated:
description: Engine ADF中的精度控制
tags: [AMS, ADF, 精度]
mathjax: true
categories: [计算化学, 软件]
---



# `NumericalQuality`

- 设置ADF计算的质量，包括BeckeGrid（数值积分）和 ZlmFit（密度拟合）。
- 选项有`Basic`、`Normal`（默认）、`Good`、`VeryGood`、`Excellent`

# `BeckeGrid`数值积分

数值积分格点的选项。

```
BECKEGRID
  Quality [basic|normal|good|verygood|excellent]
  {QualityPerRegion
     Region myregion
     Quality {Basic|Normal|Good|VeryGood|Excellent}
  End}
  {qpnear qpnear}
  {RadialGridBoost boost}
End
```

- `Quality`：选项有`auto`（默认）、`Basic`、`Normal`、`Good`、`VeryGood`、`Excellent`。会覆盖`NumericalQuality`中的设置。

- `QualityPerRegion`：设置特定区域的原子的积分格点质量。

  ```
  BeckeGrid
    QualityPerRegion Region=Accurate Quality=Good
    QualityPerRegion Region=Far      Quality=Basic
  End
  ```

- `qpnear`：默认为`4`Å。当在输入文件中指定了点电荷时，ADF 仅围绕那些接近原子的点电荷生成网格。`qpnear`指定的是最近的距离。

- `RadialGridBoost`：默认为`1.0`。增加径向积分点的数量。一些 XC 泛函需要非常精确的径向积分网格，因此 ADF 会自动将径向网格提升 3 倍用于一些数值敏感泛函。

# `ZLMFIT`密度拟合

总电子密度被分成原子密度（以类似于为贝克网格划分体积的方式）。然后通过径向样条函数和实球谐函数 (Zlm) 的组合来近似这些原子密度。

```
ZLMFIT
 Quality {basic|normal|good|verygood|excellent}
 {QualityPerRegion
    Region myregion
    Quality {Basic|Normal|Good|VeryGood|Excellent}
 End}
End
```

- `Quality`：选项有`auto`（默认）、`Basic`、`Normal`、`Good`、`VeryGood`、`Excellent`。会覆盖`NumericalQuality`中的设置。

- `QualityPerRegion`：设置特定区域的原子的 Zlm Fit 质量。

  ```
  ZlmFit
     QualityPerRegion Region=Accurate Quality=Good
     QualityPerRegion Region=Far      Quality=Basic
  End
  ```
