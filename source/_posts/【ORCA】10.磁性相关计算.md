---
：去！title: 【ORCA】10.磁性相关计算
typora-root-url: 【ORCA】10.磁性相关计算
mathjax: true
date: 2025-01-07 16:54:26
updated:
tags: [ORCA, 磁性]
categories: [计算化学, 软件]
description: ORCA中磁性的计算
---





# g tensor

## CASSCF

```
%casscf 
...
	rel
		dosoc true   #spin-orbit coupling (and ZFS)
		gtensor true
	end
...
 end
```

CASSCF中有两种方法计算：

- Effective Hamiltonian method，对任何多重度都可以（Kramers或nonKramers系统）
- Quasi-degenerate perturbation theory (QDPT)方法，只对单个Karmer双重态（奇数个电子）有效

### 输出

- Effective Hamiltonian Method得到的结果：

  ![image-20250117154939895](/image-20250117154939895.png)

  - 输出显示总 g 矩阵，后跟三个主成分及其方向（特征向量eigenvectors）。特征向量是列向量
  - 此例子中$g_z=2.99,g_{x,y}=2.24$

对于重元素，使用相对论效应和SOC时，需要增加%rel模块

```
%rel  
	picturechange 2 # second order DKH SOC 
	fpFWtrafo false # recommended option for g-tensor 
end
%casscf 
...
	rel
		dosoc true   #spin-orbit coupling (and ZFS)
		gtensor true
	end
...
 end
```



# D-tensor

## CASSCF

```
%casscf 
...
	rel
		dosoc true   #spin-orbit coupling (and ZFS)
		dtensor true
	end
...
 end
```

- 有两种方法计算，the 2nd Order PT approach（二阶 PT 方法）和Effective Hamiltonian Method
  - 在存在低激发态 (< 1000 cm-1)（通过 SOC 与基态贡献）的情况下，二阶 PT 方法对于计算零场分裂 (ZFS) 无效。

### 输出

![image-20250117161710614](/image-20250117161710614.png)

- analysis of the individual contributions to the D-tensor

  ![image-20250117161848921](/image-20250117161848921.png)





# 磁化率曲线的计算

## CASSCF



```
      soc
        dosoc true
        domagnetization true       # Calculate magnetization (def: false)
        dosusceptibility true      # Calculate susceptiblity (def: false)
        LebedevPrec            5   # Precision of the grid for different field
                                   # directions (meaningful values range from 1
                                   # (smallest) to 10 (largest))
        nPointsFStep           5   # number of steps for numerical differentiation
                                   # (def: 5, meaningful values are 3, 5 7 and 9)
        MAGFieldStep       100.0   # Size of field step for numerical differentiation
                                   # (def: 100 Gauss)
        MAGTemperatureMIN    4.0   # minimum temperature (K) for magnetization
        MAGTemperatureMAX    4.0   # maximum temperature (K) for magnetization
        MAGTemperatureNPoints  1   # number of temperature points for magnetization
        MAGFieldMIN          0.0   # minimum field (Gauss) for magnetization
        MAGFieldMAX      70000.0   # maximum field (Gauss) for magnetization
        MAGNpoints            15   # number of field points for magnetization
        SUSTempMIN           1.0   # minimum temperature (K) for susceptibility
        SUSTempMAX         300.0   # maximum temperature (K) for susceptibility
        SUSNPoints           300   # number of temperature points for susceptibility
        SUSStatFieldMIN      0.0   # minimum static field (Gauss) for susceptibility
        SUSStatFieldMAX      0.0   # maximum static field (Gauss) for susceptibility
        SUSStatFieldNPoints    1   # number of static fields for susceptibility
      end
```







# SINGLE_ANISO

```
source /share/apps/anaconda3/bin/activate /work/chem-zhaoxk/.conda/envs/gnuplot-5.4.10

#把anisoinp文件中 DATA部分的路径删掉只留下文件名
~/apps/orca601/otool_single_aniso < N4UCoP3_CASSCF_7e7o_2spin.anisoinp > single_aniso.output
```



## 输出

- 各个轨道的mJ（磁量子数）百分比贡献

![image-20250206182306324](/image-20250206182306324.png)
