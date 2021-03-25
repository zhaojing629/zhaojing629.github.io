---
title: 【Gaussian】柔性力常数
typora-root-url: 【Gaussian】柔性力常数
mathjax: true
date: 2020-09-21 20:32:22
updated: 
tags: 力常数
categories: [计算化学,Gaussian]
description: 计算柔性力常数的方法
---

力常数有力常数、柔性力常数

# 力常数

- 力常数是从高斯计算完频率的地方读取的，或者
  - 直接取Hessian矩阵的对应的对角元
  - 用Gaussian，使用内坐标方式书写gjf里的坐标，然后在使用`#P`的情况下做`freq`任务，这时候在输出文件中会看到`Force constants in internal coordinates`字段，这即是内坐标下的Hessian矩阵。假设输入文件里4-1键对应第5个内坐标，那么在Hessian矩阵中找第5个对角元，就得到了4-1键的力常数。

直接使用Hessian对角元作为键的力常数等于忽略了变量间耦合的影响，这会导致其没法定量准确反映键强（会高估力常数），甚至结论定性错误。



# 柔性力常数

## compliance程序的安装

1. 在Ubuntu系统下安装compliance程序源代码：http://www.oc.tu-bs.de/Grunenberg/compliance.html上免费下载。

2. 在控制台下运行

   ```
   sudo apt-get install gcc
   sudo apt-get install g++
   sudo apt-get install gtkmm-2.4
   sudo apt-get install libgtkglextmm-x11-1.2-0
   sudo apt-get install libgtkglextmm-x11-1.2-dev
   sudo apt-get install liblapack-dev
   ```

3. 在software center里搜gmm，把libgmm++-dev装上。

4. 把Compliance压缩包解压，进入其中，运行

   ```
   tar compliance
   
   ./configure
   make
   sudo make install
   ```

   程序会被安装到/usr/local/bin/compliance。运行compliance即可启动。

## compliance程序的使用

1. 在左上角选File→Open，在新窗口的右下角格式选.fchk，载入Gaussian做freq产生的.fchk文件

2. 调整视角：右键上下拖动体系以缩放，用左键拖动来旋转。

3. 添加感兴趣的坐标，程序会把这些坐标对应的compliance matrix（C矩阵）显示出来。compliance程序是主要用来考察键：

   - 在图上点击右键，可以看到有Stretching（添加键长）、Bending（添加键角）、Torsion三种模式，选择对应的模式

   - 在图上点击两个（三个）原子成为粉色，再点右键选Add/Remove coordinate，则这个键长（键角）项就会被添加。

   - 所有已添加的变量所构成的C矩阵会显示在另一个窗口里。矩阵的单位是 Å/mdyn，要得到柔性力常数就把C矩阵对角元求倒数即可。

     1 mdyn/Å=1 N/cm=100 N/m=100 J/m<sup>2</sup>

   - 点击某一行或者某一列的开头，对应原子也会被高亮，再次点击可以播放动画，再次点击可以停止。也可以通过右键→Toggle animation可以播放动画，Save animation as png可以存一系列图片做成动图
   - S

4. 若要清空，通过File→Close关闭当前文件，再次打开。