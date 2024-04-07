---
：:：q:ls
title: 【Gaussian】03.单点计算
typora-root-url: 【Gaussian】03.单点计算
mathjax: true
date: 2019-09-09 20:52:39
updated: 
tags: [Gaussian, SCF, 收敛, 单点]
categories: [计算化学, 软件]
description: 单点计算的一些基础和SCF不收敛的一些处理方法
---



# `Geom`几何相关选项

# `Charge`点电荷

- 为分子添加背景电荷，格式为`x y z charge`，单位默认是Å，可以通过选项`Angstroms`，`Bohrs`控制。

- 选项`Check`从chk文件中读取点电荷

- 例子：

  ```
  # B3LYP/6=31G(d) Opt=Z-Matrix Charge NoSymm
   
  Water with point charges
   
  0,1
  O -0.75 -0.94 0.0
  H 0.21 -0.94 0.0
  H-1.07 -0.0 0.0
   
  2.0  2.0 2.0 1.2
  2.0 -2.0 2.0 1.1
  ```

# `SCF`相关选项

## 算法相关

- `DIIS`：迭代子空间中直接求逆。在迭代子空间 (DIIS) 外推方法中使用 Pulay 的直接反演 。默认的加速SCF收敛的方法。使用`NoDIIS`关闭。
- `Fermi`：默认是`NoFermi`关闭。使用Fermi展宽时，此时默认也会择情自动使用能级移动和阻尼。

# 初猜`guess=`

## 算法相关选项

- `Harris`：使用Harris泛函的DFT方法的结果作为初猜。是所有HF和DFT的默认方法。通过自由原子密度叠加作为分子电子密度来构建KS算符，然后将变分得到的轨道用做后续计算的初猜，这步只做一次而不像普通DFT方法继续做迭代。
- `Huckel`：扩展Huckel方法，也不需要迭代。是一些半经验方法（CNDO、INDO、MNDO 和 MINDO3 ）的初猜默认设置。对于涉及许多第二行原子的 PM6 计算，应考虑 Huckel 猜测。 
- `INDO`：实指INDO、CNDO、Huckel的混合。第一行为INDO，第二行为CNDO，第三行及以上为Huckel。
  - 是迭代的方法，给高等级计算提供初猜波函数之前自身也需要初猜（扩展Huckel方法），本身亦有不收敛的可能。
- `Core`：将核哈密顿量对角化以形成初始猜测。是一些半经验方法（AM1、PM3、PM3MM、PM6 和 PDDG ）计算的默认设置。初始的Fock矩阵元只含单电子项而不含双电子项，即密度矩阵用空矩阵，比较粗糙。
- `AM1`：进行AM1计算作为初猜。一般不能直接使用。

## 轨道相关选项

### guess=mix

- `Mix`：HOMO和LUMO混合，以破坏α-β和空间对称性。只有在产生复杂的初始猜测时，才默认进行。`NoMix`指不混合。

1. `guess=mix`只在自旋极化单重态（即使用UHF方法在单重态下做计算，发现有严重自旋污染）时需要考虑加，其他情况（如二重态、三重态）等无需考虑这个问题；
2. `always`表示在结构优化的每一步中都执行`guess=mix`。顾名思义，这只在结构优化中可能有用，而在单点计算中无需加、加了也没用。



## 程序选项

- `Only`：在计算和打印初始猜测后终止计算。

## 读取波函数作为初猜

`guess=read`可以从chk文件中读取波函数作为初猜。

- 比如某个体系之前已经算过一次，并且有chk文件，那么chk文件里就记录了收敛的波函数。若又想重算一次（先用小基组，再用大基组；或者写掉了关键词，想重新算），为了节约时间，可以通过guess-read直接从chk里读取已收敛的波函数，这样SCF只需要一轮就能收敛。

同时`%chk=`部分有两种写法

- `%chk=name.chk`会从该chk文件中读取波函数，并且改写该文件。（覆盖模式）

- 如果避免破坏之前的版本，可以用

  ```
  %oldchk=C:\name.chk
  %chk=C:\new.chk
  # guess=read
  ```

# 检测波函数的稳定性`stable`

- `stable`只检查波函数稳定性
- `stable=opt`如果检查到不稳定就找到一个最近的稳定点，不能与结构优化，限制性优化或IRC等一起使用

提示结果有：

- `The wavefunction is stable under the perturbations considered.` 表示当前的波函数是最稳定的
- `The wavefunction has an RHF -> UHF instability`表示对闭壳层计算，但是基态是开壳层，被当成了闭壳层计算
- `The wavefunction has an internal instability`说明可能是其他情况。



# 片段组合波函数例子

```
%chk=N2_cc-pVDZ_2.0_frag.chk
%mem=4GB
%nprocshared=4
#p UHF/cc-pVDZ nosymm guess(fragment=2)

title

0 1 0 4 0 -4
N(fragment=1)   0.0   0.0   0.0
N(fragment=2)   0.0   0.0   2.0

--Link1--
%chk=N2_cc-pVDZ_2.0_frag.chk
%mem=4GB
%nprocshared=4
#p UHF chkbasis nosymm guess=read geom=allcheck stable=opt
```









# SCF不收敛的常用做法

首先要使用`#P`，这样SCF迭代过程的每一轮信息才会输出出来，能够了解当前已经迭代到了第几轮，能量变化（Delta-E）、密度矩阵元最大变化（MaxDP）和密度矩阵平均变化（RMSDP）是多少，当前离收敛限还有多远（收敛限会在SCF开始之前明确提示）以及迭代过程是否有收敛的趋势。

- 可以通过`grep “SCF Done”  *log`和`grep "Delta-E=" *log`来输出并查看趋势。

## 常用方法

参考http://sobereva.com/61：

- 使用`int=ultrafine`增加泛函积分格点的精度。
  - 对于M06、M06-2X等明尼苏达系列泛函可尝试。对于其它泛函见效几率则比较有限。
  - G09默认是`int=fine`，相当于(75,302)，可以提升到`int=ultrafine`（G16默认），相当于(99,590)

- 使用`SCF=NoVarAcc`避免因自动降低积分精度，即使迭代过程中精度不发生变化。
  - Gaussian会自动在计算初期时降低积分计算精度以加快计算，但有可能因此阻碍收敛。
  - 对于使用了弥散函数的情况出现不收敛时建议尝试。

-  用`int=acc2e=12`（G16默认）可以增加积分精度。
  - 对因为使用大量弥散函数（其它情况不算）导致的大体系难收敛问题奏效几率较大。

- 用`SCF=noincfock`避免近似方式构建Fock矩阵。
  - Gaussian默认使用Incremental Fock方式以近似方式构建Fock矩阵来显著节约迭代过程每一步的时间，但可能因此阻碍收敛。

> 含有很**大量弥散**函数的基组（如aug-cc-pVTZ及更大）计算中、大体系时，往往很难收敛。
>
> `SCF(novaracc,noincfock) int=acc2e=12`同时使用（对于G16`SCF(novaracc,noincfock)`即可），解决问题的几率较大，而耗时增加不算很大。但是如果基组里弥散函数不多，或者没加弥散函数，解决不收敛的概率不太高。

- 使用`SCF=vshift=x`（x=300~500）用能级移动法提升虚轨道能量以增大HOMO-LUMO gap，避免虚轨道和占据轨道间过度混合。
  - 只影响收敛过程，而不影响任何最终计算结果，包括轨道能级。
  - 对于HOMO-LUMO gap较小情况，常见的比如**含过渡金属**的体系，可尝试。从300依次增加。
- 用`SCF=conver=N`改变收敛限。令密度矩阵RMS收敛限为1E-N，密度矩阵最大变化和能量收敛限都为1E(-N+2)。
  - G09/16对单点计算默认是`SCF=tight`，相当于`SCF=conver=8`，对密度矩阵的收敛要求有点太严，往往不容易达到，而且达到的时候能量通常都早已经收敛到极高精度了。
  - 对于计算单点能的目的可降到`conver=6`，相当于把收敛标准放宽100倍，通常收敛时能量变化已经非常小了。
  - 但是做几何优化、振动分析的时候不建议降低默认的SCF收敛限，否则可能结果不准确，还可能阻碍几何优化的收敛。
  - 如果优化时有些体系的初猜结构可能构建得和实际结构偏差较大，导致优化初期SCF收敛难，可降低SCF收敛限到`=6`使结构粗略收敛，再在最后的结构下用默认的SCF收敛限进一步严格优化。但此法对于G16不适用，因为G16中后HF和涉及能量导数的任务都强制要求收敛到至少`SCF=conver=8`的水平，否则无法继续进行。
- 尝试其它泛函作为初猜。若某个泛函下计算不收敛，可以尝试其它泛函，如果能收敛，再[用`guess=read`读取其收敛的波函数作为初猜](#读取波函数作为初猜)。
  - 比如M06-2X等明尼苏达系列泛函SCF难度往往高于其它泛函，碰到难收敛的时候，可以试试B3LYP等泛函，如果发现能收敛，将之作为M06-2X的初猜。
  - 通常HF成份越高的泛函往往越容易收敛，特别是对于含过渡金属的体系来说。
- 尝试小基组作为初猜。小基组通常比大基组更容易收敛。直接用大基组难收敛但小基组能收敛时，可将小基组收敛的波函数作为大基组计算时的初猜。
  - 比如def2-TZVP收敛不了，但def2-SVP能收敛，可尝试用后者收敛的波函数作为def2-TZVP计算时的初猜。
  - 比如加弥散函数后收敛会变得更困难，用aug-cc-pVTZ计算时发现不收敛，cc-pVTZ能收敛则将其收敛的波函数当aug-cc-pVTZ的初猜
  - 两个基组尺寸差异太大没什么意义，比如拿STO-3G收敛的波函数当def2-TZVP的初猜对收敛并不会带来明显的益处。
  - 对于特别难收敛的情况，可以尝试逐级提升基组档次，如STO-3G→3-21G→6-31G*→6-311G**→def2-TZVP。
- 使用`guess=huckel`、`guess=INDO`[改变默认的初猜方法](#算法相关)。
- 使用`SCF=QC`或者`SCF=XQC`二次收敛方法（Quadratic convergence, QC），这种方法收敛所需步数通常比默认情况更少，有一定可能性解决SCF不收敛。
  - G09中，`SCF=XQC`代表先用普通方式迭代到64轮（或者自己用`scf=maxcyc`设的值），如果不收敛再自动切换为QC。
  - 而G16中用`SCF=XQC`时，是用`MaxConventionalCycles=N`设定常规迭代多少轮不收敛才切换为XQC，N默认为`32`。
  - 缺点：
    - QC方法耗时颇高，SCF每一轮的耗时是平常的好几倍
    - 如果必须借助此方法SCF才能收敛的话，非常有可能最终并没有收敛到最稳定的波函数，导致得到的能量高于此结构下当前级别的基态的真实值，因此结果无意义。用QC时建议同时加上stable关键词检测一下所得波函数稳定性（如果是优化，则对最后一个结构测试一下稳定性。）
    - 用QC时照样还是可能最后不收敛，最终会提示L508报错，这期间会做漫长的计算，导致花了大量时间做无用功。
- `SCF=Fermi`使用Fermi展宽
- 使用`SCF=noDIIS`关闭DIIS的SCF加速方法。
- 修改分子的几何结构。略微改变分子几何结构，比如稍微缩短/伸长键长、改变键角，若能得到收敛的波函数，可作为原来的几何构型下计算的初猜。Gaussian在几何优化中一般也会自动将当前步结构的收敛波函数作为计算下一步结构的波函数的初猜。
- 对于开壳层体系，可以先计算相应的闭壳层离子体系得到收敛的波函数，然后读取其收敛的波函数作为初猜。
  - RO方式计算开壳层体系比非限制性计算(U)难收敛得多得多，如果RO收敛不了，先改成U

- 先计算电离态，将得到收敛波函数用作初猜。因为电子数少的时候往往更容易收敛，比如阳离子比阴离子一般容易收敛。

- 含有溶剂可以使用其它溶剂下或者真空下或者其它溶剂模型计算谨慎性初猜。
- `SCF=maxcyc=N`或者`scfcyc=N`加大迭代次数。默认的128已经绝对够大，一般60步不收敛的话继续算下去收故成功的可能性就已经微乎其微了。

- 改用其它方法或基组，或尝试其它程序来计算当前体系。通过转换结果文件来作为Gaussian的初猜。
  - 用Multiwfn载入那个程序产生的含有基函数信息的文件（如.molden），进入主功能100的子功能2，选择导出波函数为fch文件，之后再用Gaussian的unfchk工具将之转换成chk文件，然后Gaussian计算时用`guess=read`从中读取波函数作为初猜

- `IOp(5/37=N)`：：默认情况下，默认情况下，SCF 迭代每 20 个周期，高斯将完整重建 Fock 矩阵。可以选择 N<20，并加入 IOp（5/37=N） 选项，每 N 个 SCF 周期形成 Fock 矩阵。

## 批量脚本

将上述方法都试一下的脚本，先新建一个文件夹，在其中存在.gjf和.sub文件，.gjf部分写入`# SCF`

```shell
#!/bin/bash

mkdir 00_NoConv
mv * 00*
mkdir 01_novaracc_noincfock 02_vshift300 03_vshift400 04_vshift500 05_huckel 06_INDO 07_QC 08_XQC 09_Fermi 10_NODIIS 11_mix

for i in 01 02 03 04 05 06 07 08 09 10 11; do cp 00_*/*gjf 00_*/g16* ${i}* ;done


sed -i 's/\#/&SCF\(novaracc,noincfock,maxcyc=300\) /' 01_novaracc_noincfock/*gjf
sed -i 's/\#/&SCF\(vshift=300,maxcyc=300\) /' 02_vshift300/*gjf
sed -i 's/\#/&SCF\(vshift=400,maxcyc=300\) /' 03_vshift400/*gjf
sed -i 's/\#/&SCF\(vshift=500,maxcyc=300\) /' 04_vshift500/*gjf
sed -i 's/\#/&SCF\(maxcyc=300\) guess=huckel /' 05_huckel/*gjf
sed -i 's/\#/&SCF\(maxcyc=300\) guess=INDO /' 06_INDO/*gjf
sed -i 's/\#/&SCF=QC /' 07_QC/*gjf
sed -i 's/\#/&SCF=XQC /' 08_XQC/*gjf
sed -i 's/\#/&SCF\(maxcyc=300,Fermi\) /' 09_Fermi/*gjf
sed -i 's/\#/&SCF\(maxcyc=300,NODIIS\) /' 10_NODIIS/*gjf
sed -i 's/\#/&SCF\(maxcyc=300\) guess=mix /' 11_mix/*gjf

for i in 01 02 03 04 07 08 09 10 11; do cd ${i}*; zsub g16*; cd ..; done 
```

