---
title: 【AMS】03.振动光谱
typora-root-url: 【AMS】03.振动光谱
date: 2019-09-23
updated:
description: 计算频率的一些
tags: [AMS, 频率]
mathjax: true
categories: [计算化学, 软件]
---





- 通过系统的Hessian矩阵求得，即能量对于原子坐标的二阶导数$$H_{ij} = \frac{\partial^2E}{\partial{}R_i\partial{}R_j}$$得到Hessian矩阵。然后Hessian的特征值是相应简正模式的力常数（按照谐振子公式，可以求得谐振频率），特征向量是简正模式。

  - （非质量加权的）Hessian 作为变量保存在引擎结果文件 `AMSResults%Hessian`中。它不会打印到文本输出。列/行索引的顺序为：原子 1 的 x 分量、原子 1 的 y 分量、原子 1 的 z 分量、原子 2 的 x 分量等。

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

`ADF`块中也有相应的设置。

## 重新扫描虚频

主要用于识别虚频，因此是默认开启的

```
NormalModes
   ReScanModes Yes/No
   ReScanFreqRange float_list
End
```

- `ReScanModes`：默认是`Yes`，在正常模式计算结束后是否扫描虚模式。
- `ReScanFreqRange`：默认是`[-10000000.0, 10.0]`，指定将扫描所有模式的频率范围。

> ADF19中，这部分的关键词为`SCANFREQ low high {NUM=num DISRAD=disrad}`
>
> - low high：扫描频率的反位，虚频用负数
> - num：默认是2，用于数值微分的点数，还可以用4和6

# `VibrationalAnalysis`数值频率

数值频率计算是通过请求`VibrationalAnalysis`任务来执行的 

```
Task VibrationalAnalysis
VibrationalAnalysis
   Type ModeScanning
   Displacement 0.001
   NormalModes
     ModeFile adf.rkf
     # select all modes with imaginary frequencies
     ModeSelect
        ImFreq true
     End
   End
End
```




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

  

