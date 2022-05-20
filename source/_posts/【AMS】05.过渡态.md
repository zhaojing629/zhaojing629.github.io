---
title: 【AMS】05.过渡态
typora-root-url: 【AMS】05.过渡态
mathjax: true
date: 2020-6-24 17:09:30
updated:
tags: [AMS, 过渡态]
categories: [计算化学, 软件]
description: 2020后ADF中关于过渡态的计算
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




# 通过`PESScan`计算

1. **优化反应物和产物的结构**

2. 猜测反应路径进行PESScan扫描计算。

   ```
   Task PESScan
   PESScan
       ScanCoordinate
           nPoints 10
           Distance 1 7 2.092447 3.0
           Distance 1 6 2.092447 3.0
       End
   End
   ```

   - 如果需要确认过渡态，每个点计算频率比较费时，因此可以仅仅确认每个点的特征

     ```
     Properties
        PESPointCharacter Yes/No
     End
     ```

3. 计算2中反应路径最高点，看是否有虚频

   ```
   Task SinglePoint
   Properties
       NormalModes Yes
   End
   ```

4. 对该点进行过渡态搜索，可以读3中的输出来进行计算。

   ```
   Task TransitionStateSearch
   GeometryOptimization
       InitialHessian
           Type FromFile
           File ../3_step/OgF6_Scan.rkf
       End
   End
   Properties
      NormalModes Yes
   End
   ```

## PESScan的详细设置

```
PESScan
   CalcPropertiesAtPESPoints [True | False]
   FillUnconvergedGaps [True | False]
   ScanCoordinate
      nPoints integer
      Coordinate integer [x|y|z] (float){2}
      Distance (integer){2} (float){2}
      Angle (integer){3} (float){2}
      Dihedral (integer){4} (float){2}
      SumDist (integer){4} (float){2}
      DifDist (integer){4} (float){2}
   End
End
```

- `CalcPropertiesAtPESPoints`：是否对 PES 的所有采样点执行额外的属性计算。默认为`False`。

- `FillUnconvergedGaps`：在最初通过 PES 后，从收敛的相邻点重新开始未收敛的点。默认为`Yes`。

- `PESScan`块中至少要包含一个`ScanCoordinate`块，指定要扫描的坐标和计算几何结构数目。默认情况下，沿每个扫描坐标（包括扫描的起点和终点）采样 10 个点。

  - 可以同时扫描两个坐标：

    ```
    ScanCoordinate
       Distance  1 2  0.8 1.1
       Distance  1 3  0.8 1.1
    End
    ```

  - 也可以分别扫描两个坐标

    ```
    ScanCoordinate
       Distance  1 2  0.8 1.1
       Distance  1 3  0.8 1.1
    End
    ScanCoordinate
       Angle  2 1 3  90 130
    End
    ```

    



# 通过`NEB`计算

1. 优化反应物和产物的结构

2. 给出初始结果和最终结构

   ```
   # This is the initial system:
   System
      Atoms
         C   0.0000   0.0000   0.0000
         N   1.1800   0.0000   0.0000
         H   2.1960   0.0000   0.0000
      End
   End
   
   # This is the final system (note the header 'final' in the next line):
   System final
      Atoms
         C   0.0000   0.0000   0.0000
         N   1.1630   0.0000   0.0000
         H  -1.0780   0.0000   0.0000
      End
   End
   
   Task NEB
   Properties
       PESPointCharacter Yes
   End
   NEB
       Images 20
   End
   ```

   - 也可以用`System intermediate`给定第三个结构，来为过渡状态提供更好的近似值。此时最好将`OptimizeEnds`设置为`False`防止创建不平衡的反应路径。

## NEB的相关选项

```
NEB
   Climbing Yes/No
   ClimbingThreshold float
   Images integer
   InterpolateInternal Yes/No
   InterpolateShortest Yes/No
   Iterations integer
   Jacobian float        #固态 NEB
   MapAtomsToCell Yes/No  #固态 NEB
   OldTangent Yes/No
   OptimizeEnds Yes/No
   OptimizeLattice Yes/No  #固态 NEB
   Parallel
      nCoresPerGroup integer
      nGroups integer
      nNodesPerGroup integer
   End
   ReOptimizeEnds Yes/No
   Restart string
   Skewness float
   Spring float
End

```

- `Climbing`：默认为`yes`。使用爬升图像算法将最高图像驱动到过渡状态。
- `ClimbingThreshold`：默认为`0.0`Hartree/Bohr。如果 ClimbingThreshold > 0 并且最大垂直力分量高于阈值，则在此步骤不执行攀爬。此条目可用于在开始搜索过渡态之前获得对反应路径的更好近似。典型值为 `0.01` Hartree/Bohr。

- `Images`：默认为`8`，即NEB 图像的数量（不包括两端）
- `InterpolateInternal`：默认为`yes`。初始 NEB 图像几何形状是通过在初始状态和最终状态之间进行插值来计算的。默认情况下，对于非周期系统，插值是在内部坐标系中执行的，但用户可以选择在笛卡尔坐标系中执行。对于周期系统，插值总是在笛卡尔坐标中完成。
- `InterpolateShortest`：默认为`yes`。允许跨周期性单元边界进行插值。
- `Iterations`：NEB 迭代的最大次数。默认值取决于自由度的数量（图像数量、原子数量、周期维度）。
- `OptimizeEnds`：通过优化反应物和产品几何结构启动 NEB。默认为`yes`。
- `Restart`：提供来自先前 NEB 计算的 ams.rkf 文件以重新开始。
- `ReOptimizeEnds`：重新启动时重新优化反应物和产品的几何形状。默认为`No`。
- `Spring`：力常数，单位是原子单位Hartree/Bohr^2，默认为`1.0`。
- `Skewness`：图像移向或远离 TS 的程度，默认为`1.0`。大于 1 的值将确保图像集中在过渡状态附近。最佳值取决于路径长度、图像数量（更长的路径和更少的图像可能需要更大的 [Skewness]）

在每次迭代中，可以并行计算图像。并行执行通常是完全自动配置的，也可以通过`Parallel`指定：

- `nCoresPerGroup`：每个工作组中的内核数。
- `nGroups`：处理器组的总数。这是将并行执行的任务数。
- `nNodesPerGroup`：每组中的节点数。

# 通过`PESExploration`计算 