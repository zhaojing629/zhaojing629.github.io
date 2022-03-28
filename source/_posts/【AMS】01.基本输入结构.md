---
title: 【AMS】05.过渡态
typora-root-url: 【AMS】05.过渡态
date: 2021-12-10
updated:
description: AMS计算过渡态的一般过程
tags: [AMS, 过渡态]
---



# 1. 线性扫描

- 将反应物放在一起，猜测反应路径，即一个反应物靠近另一个反应物的过程。可以是键长、键角、二面角等。

- 设置扫描的范围和点数。

  ```
  Task PESScan
  PESScan
      ScanCoordinate
          nPoints 10
          Angle 6 1 7 28.9  90
      End
  End
  ```

- 如果是两个参数同时 变化，扫描10个点，则是：

  ```
  Task PESScan
  PESScan
      ScanCoordinate
          nPoints 10
          Distance  1 2  0.8 1.1
          Distance  1 3  0.8 1.1
      End
  End
  ```

- 计算完成后，基于能量最高的点再进行单点频率计算。

# 2. 频率计算

```
Task SinglePoint
Properties
  NormalModes YES
END
```

# 3. 过渡态搜索

```
Task TransitionStateSearch
GeometryOptimization
    InitialHessian
        Type FromFile
        File ../2_SinglePoint/XXXX.rkf
    End
End
Properties
    NormalModes Yes
End
```

