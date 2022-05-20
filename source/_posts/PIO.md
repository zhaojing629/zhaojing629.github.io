---
title: PIO
typora-root-url: PIO
mathjax: true
date: 2021-08-23 15:47:15
updated: 
tags: [PIO]
categories: [计算化学, 软件]
description: 关于PIO代码的使用
---

# 代码位置

https://github.com/jxzhangcc/PIO

# 使用步骤

## Gaussian计算部分

1. 在高斯关键词部分加入pop=nbo6read

   - nboread调用的是高斯自带的NBO3，要用NBO6得到.49，否则格式会有问题。格式修改见[博文](https://mp.weixin.qq.com/s?__biz=MzU5NDYxNjc5Ng==&mid=2247485938&idx=1&sn=addcb81d6a9caed028a9ab86e336847d&chksm=fe7fc141c9084857858ebeb9988bd73c70fd631f354a53aeb7768fcd4c6df9f890de7539d583&mpshare=1&scene=1&srcid=&sharer_sharetime=1589122912458&sharer_shareid=f14b465eb222f6bb34657e2c0fafe383&key=64daf1adc09d7c6ecdf51441f0e0e0081ff30416a8c76cafc75ab07809a89ccb0e3a0fde164cf3daa101192f723f9349e88e6622f494e3da3870bf9eaebe22bf9583324d7112cf0072a7c78f482c98d9&ascene=1&uin=MTY5ODAzMzEyNQ%3D%3D&devicetype=Windows+10+x64&version=62090070&lang=zh_CN&exportkey=AdPzWFyVBDaa5HawSncSSzA%3D&pass_ticket=CJnCOXQ4GY3GwKDSPl0mmbvH12dznP%2F%2Bj30sXI1%2BLh1L4wzPIu4fEYHNwnZHTc2M)。

2. 在高斯输入文件的最后一行加入：

   ```
    $NBO AONAO=W49 FNAO=W49 DMNAO=W49 SKIPBO file=XXX  $END
   ```

   - 中XXX应与之后生成的 .fchk 文件名一致
   - PIO_v3可能会报错，需要49文件的名字为大写的

3. 通过formchk将chk转换成fchk

   ```
   formchk xxx.chk xxx.fchk
   ```

## pio部分

1. 此时应当有 .fchk 文件以及 NBO 生成的 .49 文件

2. pio命令一般在在/home/scicons/bin下，将其添加至环境变量即可。此时执行

   ```
    pio  ${FILENAME}.fchk {碎片1 的原子序号} {碎片2 的原子序号} 
   ```

   - 碎片可以是`xx-xx`这样的格式

3. 如果报错，看体系是否是开壳层的，如果是开壳层，需要对.49文件进行一点修改

   - 开壳层，通过一下命令检查，会出现SPIN出现的行数，会发现默认顺序是aabb，正确的顺序应该是abab

     ```
     grep -n ‘SPIN’ XXX.49
     ```
     ![img](clipboard.png)
     
     <img src="166a906be971e8d3d3b304cee0da821.png" alt="img" style="zoom: 50%;" />
     
     <img src="ffc0c86714dea564d2a80ceeec2bfc1.png" alt="img" style="zoom:50%;" />
     
     <img src="a91083a05da311f08735a5273b29fd7.png" alt="img" style="zoom:54%;" />
     
     <img src="0178a4c2a265eed33bf7da46e8737d8.png" alt="img" style="zoom:54%;" />
   
      - 在NAO密度矩阵部分只有alpha，结束之后紧跟的是NAO的Fock矩阵，而第一个beta实际上是NAO密度矩阵的部分，将这部分移动到alpha密度矩阵的后面即可。
   
      - 利用vim命令进行调换即可，调换方法：
   
        ```
        #先删除第一个beta部分
        :129075,154831d
        #光标停在第一个alpha最后一行，直接p即可
        p
        ```
   
        
   

## 结果分析部分

- pio对结果在生成的txt文件中，pio对的轨道在pio.fchk文件中，而PIMOs的记过在pimo.fchk中
- pio_v3还有raw文件，pio_v4已经删除
- 轨道如果通过pio_v4分析得到，用Multiwfn或者Jmol打开转换得到的molden文件，能量都是0，要避免可以用pio_v3

# Windows下运行

- 需要下载python2和anaconda配置python2的运行环境

- 打开Anaconda的命令行，输入

  ```
   conda activate py27
  ```

- 执行命令：

  ```
  python PIO.py FILENAME.FChk
  ```

- 输入原子：

  ```
  1-5,8,13 6-7,9-12
  ```

  

