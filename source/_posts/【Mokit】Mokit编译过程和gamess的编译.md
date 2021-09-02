---
title: 【MOKIT】MOKIT及其相关软件编译过程
date: 2020-05-29 16:20:02
typora-root-url: 【MOKIT】MOKIT及其相关软件编译过程
mathjax: true
updated:
tags: [DLPNO]
categories: [计算化学, MOKIT]
description: 进行Linux下MOKIT编译过程和gamess的编译，OpenMolcas的编译
---

参考量子化学公众号的博文：

- [自动做多参考态计算的程序MOKIT](https://mp.weixin.qq.com/s/bM244EiyhsYKwW5i8wq0TQ)
- [GAMESS编译教程](https://mp.weixin.qq.com/s?__biz=MzU5NjMxNjkzMw==&mid=2247483886&idx=1&sn=c06c747a0c473e0f1928b6f10f139051&chksm=fe65c784c9124e92d52b88b122acbec5439fe155ad6cbe2b7a902223387502dbbdae663e19aa&scene=21#wechat_redirect)

# MOKIT编译

1. [下载](https://gitlab.com/jxzou/mokit)MOKIT整个源码压缩包，在Linux系统下的安装目录解压，重命名

   ```shell
   unzip mokit-master.zip
   mv mokit-master mokit
   ```

2. 进入mokit文件夹编译

   ```shell
   cd mokit/src
   make all
   ```

   注意：该步骤之前需要先找到Intel编译器的目录，否则会出现没有ifort命令的错误。

   ```shell
   source /opt/intel/bin/compilervars.sh intel64
   ```

3. 编写mokit的运行脚本mokit.sub

   ```shell
   #!/bin/bash
   
   export MOKIT_ROOT=/home/$USER/software/mokit
   export PATH=$MOKIT_ROOT/bin:$PATH
   export PYTHONPATH=$MOKIT_ROOT/lib:$PYTHONPATH
   
   export ORCA=/home/scicons/orca_4_1_2_linux_x86-64_shared_openmpi313
   export GMS=/home/zhaojing/software/gamess/rungms
   
   automr ${1}>& test.out&
   ```

   需要用到Gaussian、Gamess、ORCA、molpro等软件：

   - MOKIT会识别系统中的GAUSS_EXEDIR变量，必要时自动调用Gaussian软件。但是有时候无法识别就需要手动在sub文件中添加以下三句，将`g16root=`后更改为服务器中高斯的目录即可。

     ```shell
     export g16root=/home/scicons/Gaussian16B
     source $g16root/g16/bsd/g16.profile
     export GAUSS_SCRDIR=`mktemp -d`
     ```

   - 变量ORCA对应量化软件ORCA可执行文件的完整路径

   - 变量GMS对应量化软件GAMESS可执行文件的完整路径（如果没有需要进行安装）

   - PySCF、OpenMolcas和Molpro软件分别由python、pymolcas和molpro命令运行，无需告诉MOKIT它们的位置。

4. 将mokit.sub修改为可执行文件，运行即可

   ```
   chmod +x mokit.sub
   mokit.sub xxxx.gjf
   ```

   

# GAMESS编译

1. [下载gamess的安装包](http://bbs.keinsci.com/thread-727-1-1.html)，解压到安装目录文件下

   ```
   tar -zxvf gamess-current.tar.gz
   ```

2. 不要忘记`source /opt/intel/bin/compilervars.sh intel64`这一步

3. 进入gamess目录，执行./config，开始进行配置：

   1. enter
   2. 输入机器类型：`linux64`
   3. 设置安装目录，可选默认路径直接回车，也可自己定义路径
   4. enter
   5. 版本号，可以自己设定，默认为00，则编译完成后会生成gamess.00.x可执行文件。（注意该步骤，mokit中的可执行文件使用的是gamess.01.x，所以最好此步包括后面的`./lked gamess 00`都用01。）
   6. 选择fortran编译器，此处填`ifort`
   7. 编译器版本号，此处填`18`
   8. enter
   9. 选择数学库版本，此处填`mkl`
   10. 填写MKL库路径，软件会自动识别目录，如果正确，可以直接复制。
   11. `proceed`
   12. enter
   13. enter
   14. 一般做节点内并行，选`sockets`即可
   15. no
   16. 后面还有一些yes no，不太清楚……

4. 编译DDI，这是GAMESS官方的并行库。

   ```
   cd ddi
   ./compddi
   mv ddikick.x ..
   ```

5. 编译源代码并生成可执行文件

   ```
   cd ..
   ./compall >& compall.log &
   ```

   这一步需要极其久的时间，完成后生成gamess.00.x可执行程序

   ```
   ./lked gamess 00
   ```

6. 修改rungms脚本

   ```
   set SCR=/scratch/$USER/gamess  #这是临时文件目录
   set USERSCR=/scratch/$USER/gamess  #同上
   set GMSPATH=/opt/gamess  #GAMESS的安装目录
   ```

   向下找到

   ```
   if ($NCPUS > 1) then
         switch (`hostname`)
   ```

   在这个switch语句中添加一个case语句：

   ```
   case node01:  #输入节点名字
               if ($NCPUS > 16) set NCPUS=16 #最多使用进程数
               set NNODES=1
               set HOSTLIST=(`hostname`:cpus=$NCPUS)
               breaksw
   ```

   用户将/opt/gamess这个目录写入环境变量：

   ```
   export PATH=$PATH:/opt/gamess
   ```

   测试输入文件，`rungms XXX` 如果看到最后输出ddikick.x: exited gracefully.，则说明运行成功。

# OpenMolcas与QCMaquis 的安装
