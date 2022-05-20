---
title: 【AMS】04.键级
typora-root-url: 【AMS】04.键级
mathjax: true
date: 2020-6-24 17:09:30
updated:
tags: [AMS, 键级]
categories: [计算化学, 软件]
description: 2020后ADF中关于键级的计算
---









键级的计算要在`Engine ADF`中指定对称性为`NOSYM`

```
  Engine ADF 
    symmetry NOSYM
  EndEngine
```



1. 在`Properties`中指定：

```
Properties
   BondOrders Yes
End
```

2. 在`Engine ADF`中指定：

```
BondOrders
   PrintAll Yes/No
   PrintTolerance float
   TypeForAMS [Nalewajski-Mrozek-1 | Nalewajski-Mrozek-2 | Nalewajski-Mrozek-3 | Mayer | Gopinathan-Jug]
End
```

- `PrintAll`：默认`No`，如果为是，将输出所有5种键级
- `PrintTolerance`：默认为`0.2`，大于该阈值才能被输出
- `TypeForAMS`：选择输出键级的种类。



# 2020版本之前

## MAYER键级等

### 输入

- 优化好的结构，再算single point

- 设置好single piont的相关输入后，再点击ADFinput > Details > Userinput，在窗口中输入： 

  ```
  bondorder printall
  ```

- 默认显示大于0.2的键级，如果需要自定义阈值，例如0.0（所有原子之间的键级无论大小均列出）可以设置为：

  ```
  bondorder printall tol=0.0
  ```

- 同时ADFinput > Details > Symmetry，将默认的Auto改为`NOSYM`。

  ```
  ……
  ……
  bondorder printall
  ATOMS
  1 C      -5.772012228837       0.492926664171      -0.000000000000    
  ……
  ……
  ……
  SYMMETRY NOSYM
  
  BASIS
  type TZP
  ……
  ……
  ```

### 输出

- 计算完毕后，得到所有原子，两两之间的MAYER、G-J、N-M (1)、N-M (2)、N-M (3) (*)键级关系

  ```
  -----------------------------------------------------------------------------------------------
                            DIST. [A]                   BOND-ORDERS
                                                    (THRESHOLD =  0.000 )
   -----------------------------------------------------------------------------------------------
                                        MAYER        G-J    N-M (1)    N-M (2)    N-M (3) (*)
   -----------------------------------------------------------------------------------------------
    C      1 - C      2     1.4005     1.2389     1.4344     1.4936     1.4415     1.5643
    C      1 - C      3     2.4257    -0.0243     0.0085     0.0089    -0.0294     0.0093
    C      1 - C      4     2.8009     0.0719     0.1189     0.1238     0.0845     0.1297
  ```

  