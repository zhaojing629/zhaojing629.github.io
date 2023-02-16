---
title: 【Gaussian】01.基础知识
typora-root-url: 【Gaussian】01.基础知识
mathjax: true
date: 2019-09-03 14:47:37
updated:
tags: [Gaussian, 基组]
categories: [计算化学, 软件]
description: Gaussian中的常见问题
---





# 输入文件基本格式





# 闭壳层与开壳层体系SCF计算

![image-20221107191726335](/image-20221107191726335.png)

- 在Gaussian中，对于多重度不为1的体系，即使在关键词中只写hf，程序也会自动进行UHF计算。
- 如果在关键词一行只写上uhf，则往往这时候的结果会与RHF相同，最终给出的`<S**2>`和S值均为0，没有自旋污染，说明此时得到的就是RHF解。解决方法是加入guess=mix关键词，用以强制混合HOMO和LUMO，以破坏α-β和空间对称性。

# 坐标的输入

- `geom=check`：输入结构从chk中读取，输入文件里此时不能写坐标
- `geom=allcheck`：标题段落、电荷、自旋多重度、坐标都从chk中读取。输入文件里此时不能写坐标多重度等，关键词后面空行直接跟指定的基组或者为空。





# chk文件相关

- 在哪个操作系统下得到的chk文件就要在哪个操作系统下转换：

  - Windows下点击Gaussian图形界面的Utilities-FormChk，选择chk文件

  - Linux使用格式：（直接formchk的前提是已经将formchk添加到环境变量中，否则可以是：相应的路径/formchk）

    ```
    formchk xxx.chk xxx.fchk
    formchk xxx.chk #y
    ```


- 将修改后的fchk转回chk文件

  ```
  unfchk h2_uhf_only.fchk h2_uhf_only.chk
  ```

  





# 电子能量读取

- Hartree-Fock（HF）方法&普通泛函的DFT计算：
  - SCF Done
  - archive段落HF=后面的数值和之前输出的SCF Done后面显示的完全相同

------

以下的方法中，SCF Done以及archive段落的HF=后面的值，基本都是HF级别的电子能量。

- MP2后HF方法：
  - 输出文件里EUMP2 =后面的值
  - archive段落的MP2=后面的值

- 双杂化泛函：
  - 比如用的是B2PLYP双杂化泛函，则最终双杂化泛函的能量就是输出文件中E(B2PLYP) =后面的值
  - 直接从archive段落里读MP2=后头的值

- CCSD(T)：
  - 输出文件中CCSD(T)=后面的值
  - archive段落里读取CCSD(T)=后面的值

------

- CASSCF方法：
  - 直接搜EIGENVALUES AND  EIGENVECTORS OF CI MATRIX，下面的EIGENVALUE后面的值就是相应的电子态的电子能量
  - archive段落的HF=后面的值也是CASSCF的电子能量，如果同时算了多个态的话，这个值是序号最高的那个态的值。

- TDDFT计算
  - 在输出激发态信息的段落中，第几激发态下面就会有一行Total Energy, E(TD-HF/TD-DFT) =，后面的值就是这个激发态的电子能量，相当于基态电子能量加上这个态的激发能。
  - archive段落里HF=后面的值是基态的电子能量，当前激发态的电子能量在archive段落里并没有输出

其他：

- 半经验方法：
  - SCF Done的值就是半经验方法的能量
  - archive段落里依然是以HF=作为标签来输出

​		特别要注意的是，半经验方法在原作者拟合参数的时候大多都是朝着生成焓来拟合的，因此Gaussian做半经验方法计算给出的能量并不是一般意义的电子能量，而是当前体系在标况下的生成焓。由于生成焓是个相对能量，这也是为什么半经验方法计算得到的能量比起用前面那些方法的数量级都要小得多得多。

- 分子力学计算
  - 从输出文件中搜Energy=，后面的值就是分子力学能量
  - 在archive段落以HF=标签来输出

​		注意分子力学计算给出的能量也不是一般意义的电子能量，分子力学计算时根本都没有把原子核与电子单独进行描述，而是每个原子被整个当做一个质点考虑。分子力学的能量零点是每个几何变量都恰处于分子力场定义的能量最低位置。

​		由于半经验方法和分子力学方法给出的能量都不是体系的绝对能量，虽然你说成“电子能量”别人也知道你指的是什么，但是说成“单点能”或简单说成“能量”从语义上更合适。
