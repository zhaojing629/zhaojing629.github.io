---
title: 【AMS】03.振动光谱
typora-root-url: 【AMS】03.振动光谱
date: 2019-09-23
updated:
description: 计算频率的一些
tags: 频率
mathjax: true
categories: [计算化学, AMS]
---





- 通过系统的Hessian矩阵求得，即能量对于原子坐标的二阶导数得到Hessian矩阵。然后Hessian的特征值是频率，特征向量是简正模式。
- 完整 Hessian 的计算非常昂贵（全Hessian的数值计算需要6N个单点计算），因此只能计算完整光谱的一部分或者仅获得系统区域的模式。完整、部分或近似 Hessian 本身对于（基于 Hessian 的）几何优化或过渡状态搜索很有用。
- 振动谱是通过在PES的一个(局部)最小值上微分法向模的特性而获得的。如果没有几何优化，会得到虚频。

- 通常与`Task SinglePoint`、`Task GeometryOptimization`或`Task TransitionStateSearch`一起使用 

- 计算简正模式或振动光谱是通过：

  ```
  Properties
     NormalModes Yes/No
     Raman Yes/No
     VROA Yes/No
     VCD Yes/No
     Phonons Yes/No
  End
  ```

# 红外光谱

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

  

