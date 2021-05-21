---
title: 【AMS】03.几何优化
typora-root-url: 【AMS】03.几何优化
date: 2019-09-23
updated:
description: ADF2020版本后的几何优化相关
tags: 几何优化
mathjax: true
categories: [计算化学, AMS]
---









# 几何优化

```
Task GeometryOptimization

GeometryOptimization
   Convergence
      Energy float
      Gradients float
      Step float
      StressEnergyPerAtom float
   End
   MaxIterations integer
   CalcPropertiesOnlyIfConverged Yes/No
   OptimizeLattice Yes/No
   KeepIntermediateResults Yes/No
   PretendConverged Yes/No
End
```

> 20版以前的为：
>
> ```
> GEOMETRY
> 	Converge {E=TolE} {Grad=TolG} {Rad=TolR} {Angle=TolA}
> 	Iterations Niter
> 	Inithess inithessian.file
> 	Hessupd HessUpdate
> 	Optim {Delocal / Cartesian / Internal} {All / Selected}
> 	GEigenvalueThreshold threshold
> 	Branch {New / Old}
> 	Step {Rad=MaxRadStep} {Angle=MaxAngleStep} {TrustRadius=MaxRadius}
> 	DIIS {N=NVect} {CYC=Ncyc}
> 	Externprogram externprog.exe coord=coords.inp energy=energy.out grad=grads.out
> End
> ```

## `Convergence`

收敛部分的设置：

- `Energy`：能量变化，默认是`1e-05`Hartree。
- `Gradients`：核梯度的阈值，默认是`0.001`Hartree/Angstrom
- `Step`：收敛几何允许的最大笛卡尔步长，默认是`0.01`Angstrom
- `StressEnergyPerAtom`：优化晶格向量时使用的阈值，默认是`0.0005`Hartree

收敛判定（如果最大梯度和均方根梯度比收敛准则小10倍，则忽略最后两条）

- 当前几何结构和上一个几何步骤的键能之间的差异小于`Energy`
- 最大笛卡尔核梯度小于`Gradients`
- 笛卡尔核梯度的均方根(RMS)小于2/3`Gradients`
- 最大笛卡尔步长小于`Step`
- 笛卡尔阶跃的均方根(RMS)小于2/3`Step`

优化过程会不断地计算不同的分子结构，直到找到最低能量的结构为止。收敛标准得到5个T表示五个收敛标准都达到。其中第二个标准最重要，一般也是最后一个达到的，第二个标准是势能面的梯度最大值。这个标准非常严格，对于大量过渡金属参与的化学反应，过渡态搜索，有可能达不到这样严格的标准，一般到0.003左右也可以认为收敛了，可以将对应的分子结构拿来使用。

> 2020版以前为总能量、梯度，笛卡尔步长，键角，默认为：
>
> ```
> GEOMETRY
> Converge 1e-3 1e-3 1e-2 0.5
> end
> ```

## 其他

- `MaxIterations`：允许收敛到所需结构的最大几何迭代次数。默认是max(30，$$2 \times N_{free}$$)，$$N_{free}$$是指自由度的数目，接近于3*原子数。
- `CalcPropertiesOnlyIfConverged`：默认为`Yes`，当几何优化（过渡态搜索）收敛时，才计算相应的性质，比如频率，声子等，若为`False`，不收敛也可以计算。
- `PretendConverged`：默认为`No`，当几何优化不收敛会报错。如果改成`True`，只会出现一个警告，并且表明几何优化是收敛的，在一些脚本编写中有用。

## 优化方法`Mehod`

```
GeometryOptimization
   Method [Auto | Quasi-Newton | SCMGO | FIRE | L-BFGS | ConjugateGradients]
   CoordinateType [Auto | Delocalized | Cartesian]
End
```

- `Method`：默认为`auto`，根据系统大小和支持的优化选项自动选择合适的方法。
- `CoordinateType`：默认是`auto`，根据给定的方法选择。准牛顿法和SCMGO方法将使用`Delocalized`，所有其他方法将使用`Cartesian`。

### `Quasi-Newton`

准牛顿几何优化：

```
GeometryOptimization
   Quasi-Newton
      MaxGDIISVectors integer
      Step
         TrustRadius float
      End
      UpdateTSVectorEveryStep Yes/No
   End
End
```

- `MaxGDIISVectors`：设置GDIIS向量的最大数量。默认为`0`，如果> 0将启用GDIIS方法。
- `Step`：信任半径的初始值。
- `UpdateTSVectorEveryStep`：是否在每个步骤用当前特征向量更新TS反应坐标。默认为`Yes`。

准牛顿优化器使用Hessian计算几何优化步骤。Hessian通常在开始时近似，然后在优化过程中进行更新。因此，非常好的初始Hessian可以提高优化器的性能，并导致更快，更稳定的收敛。初始Hessian的选择可以设置：

```
GeometryOptimization
   InitialHessian
      File string
      Type [Auto | UnitMatrix | Swart | FromFile | Calculate | CalculateWithFastEngine]
   End
End
```

- `File`：包含初始Hessian（或包含它的结果目录）的KF文件。这可用于加载先前使用[Properties％Hessian]关键字计算出的Hessian。

- `Type`：默认为`auto`，让程序选择初始模型Hessian。

  - `UnitMatrix`：最简单的初始模型Hessian，只是优化坐标中的一个单位矩阵
  - `Swart`： model Hessian from M. Swart.
  - `FromFile`：从先前计算的结果加载Hessian。配合`File`使用
  - `Calculate`：计算初始的Hessian，计算比较昂贵，大多数建议用于TransitionStateSearch计算
  - `CalculateWithFastEngine`：使用更快的方法计算初始的Hessian

### `FIRE`

```
GeometryOptimization
   FIRE
      AllowOverallRotation Yes/No
      AllowOverallTranslation Yes/No
      MapAtomsToUnitCell Yes/No
      NMin integer
      alphaStart float
      dtMax float
      dtStart float
      fAlpha float
      fDec float
      fInc float
      strainMass float
   End
End
```



## 几何不收敛

- 修改优化方法为准牛顿

  ```
  GeometryOptimization
      Method Quasi-Newton
      Quasi-Newton
        Step
           TrustRadius 0.02
        End
        UpdateTSVectorEveryStep True
      End
  End
  ```

  

# 频率计算

```
Properties
  NormalModes Yes
End
```

## 解析频率



```
Engine ADF
  AnalyticalFreq
    B1Size float
    B1Thresh float
    Check_CPKS_From_Iteration integer
    Debug string
    Hessian [reflect | average]
    Max_CPKS_Iterations integer
    Print string
    PrintNormalModeAnalysis Yes/No
    U1_Accuracy float
  End
EndEngine
```

- `Max_CPKS_Iterations`：解析频率的计算需要求解Coupled Perturbed Kohn-Sham (CPKS)  (CPKS)方程，这是一个迭代过程。如果没有实现收敛（输出中会打印警告" CPKS failed to converge. Frequencies may be wrong")，可以增加迭代次数（收敛不能保证）。默认为`20`


# 有虚频



- 在原本的几何坐标上加上虚频的位移。一个简单的脚本。

  ```shell
  #!/bin/bash
  #简单查看adf输出的末尾能量，点群和是否有虚频，如果有加上虚频的位移矢量。
  #example:adf_simpleout *.out
  
  
  echo " "
  echo " "
  echo "Geometry: "
  opt_geo_line=`grep -n "Coordinates" ${1} |tail -1|cut -d ':' -f 1`   #Coordinates in Geometry Cycle
  sed -n "${opt_geo_line}"',$p' ${1}|grep -o "[a-zA-Z]\{1,\}[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*"
  
  echo ""
  grep 'Bond Energy'  ${1} | tail -3 | awk '{print $3,$4,$5,$6}'
  
  echo ""
  grep 'Symmetry' ${1} |tail -1 | awk '{print $3,$4,$5}'
  
  echo ""
  freqline=`grep -n "Vibrations and Normal Modes" ${1} | tail -1| cut -d ':' -f 1`
  freqstart=`expr ${freqline} + 7`
  firstfreq=`sed -n ${freqstart}p ${1}| awk '{print $1}'`
  echo "The first frequency is ${firstfreq}"
  
  image=$(echo "${firstfreq} < 0" | bc)
  
  if [ $image -eq 1 ]
  then 
   echo ""
   echo "shift:"
   sed -n "${opt_geo_line}"',$p' ${1}|grep -o "[a-zA-Z]\{1,\}[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*" > Geometry.txt
   opt_geo_end_line=`grep -n "[a-zA-Z]\{1,\}[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]*[[:blank:]]\{1,\}-*[0-9]\{1,\}\.[0-9]" *out|tail -1|cut -d ':' -f 1`
   atom_num=`expr ${opt_geo_end_line} - ${opt_geo_line} - 1`  
   freq1=`expr ${freqstart} + 2`
   freq2=`expr ${freqline} + 9 + ${atom_num}`
   sed -n ${freq1},${freq2}p ${1} | awk '{print $2,$3,$4}' > imagefreq.txt
   for ((i=1; i <= ${atom_num};i++));do
     a=`sed -n ${i}p Geometry.txt | awk '{ print $1 }'` 
    
     numx1=`sed -n ${i}p Geometry.txt | awk '{ print $2 }'`
     numx2=`sed -n ${i}p imagefreq.txt | awk '{ print $1 }'` 
     numx3=$(echo " $numx1 + $numx2 "|bc)
      
     numy1=`sed -n ${i}p Geometry.txt | awk '{ print $3 }'`
     numy2=`sed -n ${i}p imagefreq.txt | awk '{ print $2 }'`
     numy3=$(echo " $numy1 + $numy2 "|bc)   
     
     numz1=`sed -n ${i}p Geometry.txt | awk '{ print $4 }'`
     numz2=`sed -n ${i}p imagefreq.txt | awk '{ print $3 }'`
     numz3=$(echo " $numz1 + $numz2 "|bc)
    
     printf "%-10s %10.6f %10.6f %10.6f \n" $a $numx3 $numy3 $numz3 
   done
  rm Geometry.txt imagefreq.txt
  fi
  
  echo " "
  echo " "
  
  ```

  

