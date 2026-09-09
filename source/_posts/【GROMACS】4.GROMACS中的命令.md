---
title: 【GROMACS】4.GROMACS中的命令
typora-root-url: 【GROMACS】4.GROMACS中的命令
mathjax: true
date: 2026-08-12 12:07:17
updated:
tags: [GROMACS, 文件]
categories: [计算化学, 软件]
description: Gromacs的命令 `gmx xxx`
---



# 总体

- [Command-line reference - GROMACS 2026.3 documentation](https://manual.gromacs.org/current/user-guide/cmdline.html)
- 可以使用 `gmx help *command*` 或 `gmx *command* -h` 查询帮助
- 如果已安装 MPI 版本的 GROMACS，则默认情况下 `gmx` 二进制文件名为 `gmx_mpi`



# 常用的参数

- `-f`：结构文件（gro、pdb、tpr等)或轨迹文件(tr、xtc等），或xvg文件，或edr文件。
- `-s`、`-c`：结构文件 （gro、pdb、tpr等)。具体视程序而定
- `-n`：索引文件(ndx）
- `-b`、`-e`：设定轨迹中被考虑的部分是从哪里开始（begin)到哪里结束(end)
- `-dt`：轨迹每多长时间被读入一次



# chi

计算chi和其他二面角的所有信息

# distance

distance命令用于计算一批原子对的距离变化(需提供索引文件，相应的组中原子数是2的倍数)，也可以结合selection语句考察两个组之间质心或几何中心距离。

## 例子

- 考察21与29号残基间质心距离随时间的变化

  ```
  gmx distance -s md.tpr -f md.xtc -select "com of resid 21plus com of resid 29" -oall
  ```

  输出了平均值、标准偏差，同时得到distxvg(因用了`-oal`)

  等价：

  ```
  gmx pairdist -f md.xtc -s md.tpr -ref "com of resid 21" -sel  "com of resid 29" 
  ```

- 考察21号残基与蛋白质几何中心距离随时间的变化

  ```
  gmx distance -s md.tpr -f md.xtc -select "cog of resid 21 pluscog of group ""protein"" -oall
  ```

- distance结合`-oh` 时还可以计算两个位置间的距离分 布。如果设`-len a -tol b`， 则统计区间是a±b×a。统计 间隔通过`- binw` 设置。如：考察21与29号残基侧链间几何中心距离分布

  ```
  gmx distance -s md.tpr -f md.xtc -select "cog of resid 21 and group sidechain plus cog of resid 29 and group sidechain" -oh -len 0.7 -tol 0.6 -binw 0.05
  ```

## distance， mindist， pairdist对比

- `distance`：计算一批位置对间的距离，以及两个组的中心间距离，还可以计算距离分布。可以用索引文件，也可以用选择语句
- `mindist`：计算两个组间最近、最远距离。还可以计算某组与其镜像的最近、最远距离，计算组间小于某距离的接触数。必须用索引文件
- `pairdist`：计算两个组间，或一批残基各自间最近、最远距离，以及两个组的中心间距离。可以用索引文件，也可以用选择语句

对于单纯考察两个部分间的距离目的，pairdist最强大，也最方便、灵活。相对于pairdist，distance主要好处是可以计算距离分布，mindist好处是可以计算小于某距离的接触数







# do_dssp

DSSP是最知名的指认二级结构的算法，也有同名的程序dssp。GROMACS的do_dssp是dssp程序的接口(GROMACS较新版本已经无do_dssp了)，用来考察整个轨迹中各个残基所属的二级结构。从2023版开始GROMACS有了原生的DSSP程序`gmx dssp`来替代`gmx do_dssp`。

- 把file目录下的dssp放到usr/local/bin目录下(或设置DSSP环境变量指向此文件的实际路径)。然后增加可执行权限。比如增加环境变量：

  ```
  export DSSP=/path/to/dssp
  ```

- do_dssp给出的ss.xpm用不同颜色展现了各个残基每一帧的二级结构。对于分析二级结构随模拟过程的变化有益。

- 运行以下命令，可以将之转换为图像文件。`-by`和`-bx`应根据实际情况调节，使得图像长宽合适

  ```
  gmx xpm2ps -f ss.xpm -noframe -by 10 -bx 3
  ```

  - 去掉`-noframe`可以显示图例、坐标轴和标签

- 



# dump

用来把GROMACS的各种私有的二进制文件转化成可读形式输出，便于检查和提取数据。

- `-s`： .tpr
- `-f`： .xtc/.trr
- `-e`： .edr
- -cp：.cpt

例子：从info.out中将看到md.cpt中包含的原子坐标/速度、盒子尺寸、当前模拟时间等各种信息。

```
gmx dump-cp mid.cpt > info.out
```

从tpr中可以获取原子间相互作用参数信息，从edr中可以获取每一帧各种能量项，从trr中可以获取每一帧坐标信息、速度、受力信息(若储存了的话)。



# ⭐editconf

```
gmx editconf [-f [<.gro/.g96/...>]] [-n [<.ndx>]] [-bf [<.dat>]]
             [-o [<.gro/.g96/...>]] [-mead [<.pqr>]] [-[no]w]
             [-[no]ndef] [-bt <enum>] [-box <vector>]
             [-angles <vector>] [-d <real>] [-[no]c]
             [-center <vector>] [-aligncenter <vector>]
             [-align <vector>] [-translate <vector>]
             [-rotate <vector>] [-[no]princ] [-scale <vector>]
             [-density <real>] [-[no]pbc] [-resnr <int>] [-[no]grasp]
             [-rvdw <real>] [-[no]sig56] [-[no]vdwread] [-[no]atom]
             [-[no]legend] [-label <string>] [-[no]conect]
```

用来设置模拟体系的盒子，也可以用来平移和旋转结构，或者转换文件格式。

- `-f `：输入结构文件
- `-n`：输入索引文件（可选）
- `-o`：输出结构文件（可选）

设置盒子，会自动把体系放在盒子中央，除非使用了`-noc`

- `-bt`：盒子类型，triclinic（三斜。默认)，cubic（立方）dodecahedron（梭形十二面体），octahedron（截角八面体）
- `-box <vec>`：对triclinic盒子自定义盒子三个边长(a,b,c)，对其它类型盒子只需定义一个边长值
- `-angles α β γ`：使用`-box`时同时自定义盒子向量 (bc,ac,ab) 之间的夹角
- `-d <real>`：将分子边界向X/Y/Z方向延展此值来定义盒子
  - 设定盒子边界距离体系原子多远，设得越大之后加水数目 越多，耗时越高。至少要大于非键作用cutoff的一半，否则蛋 白质会与其相邻镜像的蛋白质作用上。
  - 默认设置下会产生矩形盒子。此时应注意若体系本身偏离球 形很多，且在模拟过程中发生了旋转，则可能会与镜像发生 相互作用。
  - 如果对蛋白质设置消除整体转动，用矩形盒子也完令没问题 。
  - 

修改结构：

- `-translate <vector>`：对体系在X/Y/Z方向进行平移的距离
- `-rotate <vector>`：绕X， Y和Z轴的旋转角度， 单位为度
- `-scale <vector>`：将原子坐标在三个方向乘以此数值(可达到比如调节密度的目的）
- `-[no]princ`：使某个组的最长的主轴向X轴对齐。
- `-mead foo.pqr`：如果读入的是`.tpr`文件，则可以输出`.pqr`文件，格式类似`pdb`，但同时记录了原子电荷和原子半径信息



不管模拟时用的是什么特征的盒子，出于效率的 考虑， GROMACS 内部计算时都是利用矩形盒子 来考虑PBC， 故产生的轨迹文件和结构文件也都 是以矩形盒子的形式来记录粒子位置的。

VMD 的 pbcbox命令可以根据当前盒子对应的平移 矢救显示出相应的三斜盒子。

# energy

用于从能量文件(.edr)中提取动能、势能的各种成分、温度、盒子尺寸、压力、维里值、体积、密度、能量组之间的非键作用能等数据，输出随时间的变化，并进行统计分析得到平均值、RMSD、漂移量，并可以计算一些体系的热力学性质。

- `-f`：.edr文件

- `-o`：.xvg文件(默认为energy.xvg)

- `-dp`：在xvg文件中以更高精度输出数据

  运行比如`gmx energy -f md.edr`，然后将屏幕上感兴趣的量的序号依次输入;每输入一个按一次回车，最后以空行或0结束，则被选中的量随时间变化就会被提取并一起记录到energy.xvg中。使用`xmgrace -nxy energy.xvg`即可作到一张图上(若只有一套Y数据则不需要`-nxy`)

- `-fluct_props`：计算与性质波动有关的量，诸如热容、等温可压缩系数、热膨胀系数

- `-nmol <int>`：体系中的分子数，默认为1。对于计算热力学量时应当设为实际值，否则计算出的结果可能错误
  只有选择全了相应条目的`Energy terms needed`下面的项，才会在提取数据后将相应的量也算出来。

- `-fee`：选项会计算体系与理想气体状态时的自由能差值

  $\Delta A = A(N,V,T) - A_{idealgas}(N,V,T) = kT \ln(<\exp(U_{pot}/kT)>)$

  $\Delta G = G(N,p,T) - G_{idealgas}(N,p,T) = kT \ln(<exp(U_{pot}/kT)>)$

  在界面里应当选择Potential 。在输出信息中的  -kT ln<e^(E/kT)>列下方的数值即是要取的值

- `-f2`：提供另一个edr文件，用于计算两种参数下体系的自由能差。两个edr文件里的帧数需相同，应来自同一体系。

  $\Delta G = -kTln(<exp(-(E_B-E_A) / kT)>_A),$

  界面里应选择Total Energy。

- `-fetemp <real>` ：估算自由能时用的参考温度，默认为300 K

例子：

```
gmx energy -f npt-nopr.edr -o enrg-npt.xvg
```



# genion

将结构中指定的组(一般是溶剂组)的部分分子随机替换为单原子离子。

- `-s`：`.tpr`文件
- `-n`：索引文件(可选)
- `-p`：拓扑文件(会对之进行恰当修改)
- `-o`：结构文件

用法：默认为加入Na+、Cl-，若自设离子可用`-pname [阳离子名] -pq [阳离子电荷数] -nname [阴离子名] -nq [阴离子电荷数]`，离子名均为大写，如NA、CL、CA

- `-np 阳离子数 -nn 阴离子数 ` 
- `-conc 盐浓度(mol/L)`
- `-neutral 加入足够离子使体系电荷中性化`

genion如果要求加入的离子数非常多的话，可能会出现No more replaceable solvent的提示导致运行失败：

- 可以被genion替换的溶剂分子是距离离子超过`rmin`的溶剂分子。当被替换的溶剂分子已经很多，没有其它满足条件的可被替换的溶剂分子时，就会出现上述错误。
- 解决方法是加上`-rmin [离子间最小距离]`，将离子间最小距离设成小于默认的0.6 nm的值。但也不能设得太小，否则可能导致带电相同的离子间出现位置太近，由于静电互斥过强导致模拟一开始崩溃。

genion命令无法加入多原子离子。可以利用packmol构建这种体系，也可以用`inisert-molecules`命令通过`-replace`选项对原有分子进行替换。

例子：

- 产生含有5个Ga<sup>2+</sup>和10个NO<sub>3</sub><sup>-</sup>的3×3×3nm水盒子

  ```
  gmx solvate -box 3 3 3 -o waterbox.gro
  gmx insert-molecules -f waterbox.gro -ci NO3-.pdb -nmol 10 -replace -o salt.gro
  gmx insert-molecules -f salt.gro -ci Ca2+.pdb -nmol 5 -replace -o salt.gro
  ```

  每次都选择water组

# ⭐grompp

grompp(GROMACS preprocessor)，读取运行参数文件、拓扑文件和结构文件，将信息处理、整合，产生mdrun的输入文件`.tpr`。

- `-f`：.mdp文件
- `-c`：结构文件
- `-p`：拓扑文件
- `-t`(非必需)：`.trr`轨迹文件(默认读取其最后一帧信息)或`.cpt`文件
  - 精确延续之前的体系状态应当用`-t`提供`.cpt`文件
- `-r`：位置限制文件(使用位置限制时才需要)
- `-n`(非必须)：索引文件
- `-o`：`.tpr`文件
- **`-pp`选项可以输出一个`processed.top`，是预处理器处理top文件后的结果，所有include的文件都会被展开，对ga_1之类参数的引用也直接被实际的参数所替换。**
- `-maxwarn [数目]`：可以设允许最多出现多少个Warmning而不终止运行。默认只要出现Wamning则grompp就会终止。
  - grompp给出的所有Warning都应当留意，往往暗示出输入文件里的错误，若轻易无视之可能模拟崩溃或者得到无意义的结果。

grompp还会自动产生`mdout.mdp`文件，是参数完整的`.mdp`文件，会体现没设定的参数的默认值，并包含许多注释。

grompp是按照top文件里的`[ molecules ]`记录的分子顺序展开成的原子顺序构建`tpr`文件的，从结构文件中只是读取坐标。grompp会按顺序检查top和结构文件里的原子名的对应关系，如果不符合将会给出警告并使用top里的原子名。

## 常见Warning

关于净电荷的常见Warning

- You are using Ewald electrostatics in a system withnet charge. This can lead to severe artifacts, suchas ions moving into regions with low dielectric, dueto the uniform background charge. We suggest toneutralize your system with counter ions, possibly incombination with a physiological salt concentration.
  - 这说明的当前用的是Ewald、PME之类考虑无穷远静电相互作用的方法，但是体系的净电荷不为0，此时模拟可能明显不合理，可能需要修正。
  - 此时应当检查grompp提示的System has non-zerototal charge后面显示的净电荷是多少，有三种情况：
    - 数值非常接近于0：如0.0013。可以用`-maxwarn`无视此警告继续产生tpr
    - 数值是不为0的整数：如3.0、-1.0。说明需要用诸如`gmx genion`加抗衡离子使得整个体系电中性化
    - 数值是一个偏离整数明显的数：如0.167。这必定是因为有的moleculetype里[ atoms ]定义的所有原子电荷加不为整数所致。哪怕每一个分子的净电荷偏离0仅有诸如0.002的程度，但分子数很多时也会造成整体净电荷偏离0非常明显。需要自行检查体系中涉及的各个moleculetype的净电荷(手动加和其中的原子电荷)，对于净电荷轻微偏离0的分子，可手动调整其中某一个或多个原子电荷以令分子的净电荷恰为整数。

关于原子顺序的常见Warning

- 结构文件里的原子顺序必须和拓扑文件里的[ molecules ]及各类分子的[ atoms ]所对应的原子顺序完全一致，否则模拟时参数会错乱。而拓扑文件和结构文件中的原子名、残基名可以相同也可以不同，不同时在用grompp时会出现warning，可以无视，此时mdrun最终产生的gro文件里的原子和残基名将与拓扑文件里的一致。

# hbond

 计算分析氢键

- `-hbn`： 输出氢键网络/氢键存在情况的索引文件。输出格式：.ndx 文件（索引文件）
- `-hbm`： 输出氢键矩阵。输出格式：.xpm 文件

# helix

helix命令可以计算螺旋的基本参数以及随时间的变化。程序会对指定的组通过psi/phi角和氢键判断出其中哪些残基组成了螺旋，然后把螺旋轴区域指向Z方向，之后计算各种参数。

- 计算螺旋参数，会产生大量文件

  ```
  gmx helix -f ../md.xtc -s ../md.tpr -n index.ndx
  ```

- 也可以人为用`-ahxstart`和`-ahxend`指定螺旋中第一个和最后一个残基号。

- 主要输出以下文件，可以用xmgrace绘制属性随时间的变化：

  - psi.xvg、phi.xvg：螺旋中残基的psi、phi角

  - radius.xvg：螺旋的平均半径

  - len-ahx.xvg：螺旋区域的总长度

  - rise.xvg：螺旋内平均每个残基在Z方向上升高量，即总长度除以螺旋中残基数。理想的螺旋此值应为0.15nm

  - twist.xvg：每个残基的螺旋角。alpha螺旋应在100度左右

  - dip-ahx.xvg：螺旋骨架偶极矩

  - caphi.xvg：螺旋中C。间的平均二面角

  - hb3.xvg、hb4.xvg、hb5.xvg：i与+3/4/5残基间的平均氢键长度

  - rs-ahx.xvg：偏离理想螺旋的程度

    输出的zconf.gro是螺旋轴指向Z轴对应的结构

# insert-molecules

将指定的分子插入体系空挡中，或构建一个填充指定分子的盒子。与`solvate`命令关键不同之处在于此命令中被填入的分子只需提供单个分子的结构文件。

- `-f`：被填充的结构文件
- `-ci`：要填入的分子的结构文件
- `-o`：填充后的结构文件，默认为`out.gro`
- `-box <vector>`：构建新盒子并往里填充
  - 如果`-f`和-box一起用，则是把-f文件里的盒子改成`-box`的尺寸后再往空隙里填。

## 随机插入

随机插入，此为默认情况。和solvate命令一样原子间距离肯定不会小于它们之间范德华半径之和(且可以用`-scale`调节半径的倍数)

- `-nmol <int>	`：最多填入的分子数
- `-try <int>	`：尝试插入`-nmol`乘以`-try`次。因此此值越大可能填充进去的分子越多。默认为`10`

- `-rot`：默认为xyz，即填充时分子在三个方向可随意旋转。也可以为`z`(只允许绕Z轴旋转)、`none`(不能旋转)

### 例子

- 将formamide.pdb里的分子填入3×4×4 nm的空盒子，输出solv.gro。尝试最多填入1000个，如果填不下则能填多少填多少，尽可能填满

  ```
  gmx insert-molecules -box 3 4 4 -ci formamide.pdb -o solv.gro -nmol 1000
  ```

- 将ethanol.gro里的分子填入protein.pdb当中溶质与盒子间的空隙，尝试最多填入200个

  ```
  gmx insert-molecules -f protein.pdb -ci ethariol.gro -o solv.gro -nmol 200
  ```

- 把solv.gro的盒子(假设原先为2×2×2nm) 改为2×2×5nm，往多出来的2×2×3nm空间内填充CH4.pdb，尝试最多填入1000个(此法可以构建两相界面体系)

  ```
  gmx insert-molecules -f solv.gro -ci CH4.pdb -box 2 2 5 -o biphase.gro -nmol 1000
  ```

## 指定位置插入

在一批指定的位置插入分子，需自己提供一个`.dat`后缀的文件，每一行指定个分子插入的X，Y，Z坐标（相对于`-ci`文件里的坐标原点而言），用`-ip`选项接上此文件的路径。

```
gmx insert-molecules -box 1 2 2 -ci formamide.pdb -o new.gro -ip pos.dat
```

`pos.dat`的内容类似于：

```
0.25 0.5.0.5
8.25 0.5 1.0
0.25 1.8 0.5
0.25 1.0 1.0
```

- 通常`-ci`指定的结构文件里的分子的中心位置应当处于坐标原点，以令`.dat`设的恰是各个分子中心出现的位置

# make_ndx

制作索引文件

运行`make_ndx`后， 可使用`r`选择残基， `a`选择原子， `name`对多组进行改名， 还可以使用`|`表示或运算， `&`表示与运算. 下面是几个简单的例子：

- `r 56`： 选择56号残基
- `r 1 36 37`： 选择不连续的残基
- `r 3-45`： 选择3至45号残基， 使用连接符指定残基标号范围
- `r 3-15 | r 23-67`： 选择3至15， 23至67号残基
- `r 3-15 & 4`： 选择3至15号残基的主干链原子， 在索引文件中， 4号组为默认的主干链.
- `r 1-36 & a C N CA`： 使用包含`&`的命令指定只包含骨架原子的残基范围



# mdmat

mdmat命令是用来计算各个残基对之间原子间最小距离的工具，会产生距离矩阵dm.xpm。对于轨迹，给出的是平均距离矩阵。
例如：

```
gmx mdmat -f md.xtc -s md.tpr (选择Protein)
gmx xpm2ps -f dm.xpm -bx 15 -by 15
```

默认产生的图是灰度图。xpm2ps若加上`-rainbow blue`可以得到蓝-绿-红变化的图

越白距离越近，越黑距离越远。默认刻度上限是1.5 nm，可以用`-trunc`设

# ⭐mdrun

是GROMACS最关键的命令，用于做各种计算模拟任务。

- `-s`：`.tpr`文件
- `-cpi`：`.cpt`文件(可选，用于精确续算目的。若提供则完整的状态信息从这里读，否则用.tpr里的信息)
  - 运行时每隔一定时间(用`-cpt`来设，默认15分钟)往`.cpt`里写一次完整的状态数据用于续算。前一次的`.cpt`文件会被改名为`_prev`结尾
- `-rerun`：轨迹文件(可选，计算已有轨迹的能量才用)
- `-o`：输出的`.trr`文件
- `-x`：输出的`.xtc`文件(可选)
- `-cpo`：输出的`.cpt`文件(可选)
- `-c`：输出的结构文件
- `-e`：输出的`.edr`文件
- `-g`：输出的`log`文件
- `-deffnm`：设定对所有选项都用的文件名
- `-v`：在终端不断输出当前已跑步数以及预计的完成时间

## 例子

- 常规计算：将运行md1.tpr，输出md1.trr/xtc/log/cpt/edr/gro。gro文件应轨迹最后一帧结构而且是分子保留完整的状态。运行进度预计完成时间不断输出到屏幕上。四个线程将被利用。

  ```
  gmx mdrun -v -deffnm md1 -nt 4 -pin on
  ```

  - 如果要在远程服务器上运行，用比如：`nohup gmx mdrun -deffnm md1 nt 36 -pin on &`，之后若用`exit`命令断开与服务器的连接，任务在服务器上会一直跑完。运行进度可以用`tail -f md1.log`来实时监控。

- 跑完意外中断的任务md1，轨迹、能量、日志文件会接续之前文件断点处继续写入，最终得到的这些文件和一次性完整运行的相同。

  ```
  gmx mdrun -v -deffnm md1 -cpi md1.cpt
  ```

- md1已完整跑完，延续之前的模拟参数，再跑额外的5ns模拟，新任务叫md2

  ```
  gmx convert-tpr -s md1.tpr -extend 5000 -o md2.tpr
  gmx mdrun -v -deffnm md2 -cpi md1.cpt -noappend
  ```

  最终会得到md2.part0002.trr/xtc/log/edr/gro和md2.cpt

- 同上，但是直接在之前md1的输出文件上续写

  ```
  gmx convert-tpr -s md1.tpr -extend 5000 -o md1.tpr
  gmx mdrun -v -deffnm md1 -cpi md1.cpt
  ```

  注：`convert-tpr`还可以结合`-until xxx`将模拟终止时间延长到`xxx`

- heat任务已跑完，想延续其最后的状态结合其它的mdp设定跑prod任务

  ```
  gmx grompp -f prod.mdp -c heat.gro -t heat.cpt -p NANA.top -o prod.tpr
  gmx mdrun -v -deffnm prod
  ```

  - 这样产生的轨迹的初始时间由mdp里的`tinit`定义，如果没定义则默认从0开始计。
  - 注：多次延长模拟时间时，若为了让每一个任务都有独立的从而易于管理的文件，可以每一段延长的模拟都设置对应的mdp文件(如prod2.mdp、prod3.mdp...)并用此法产生相应的tpr文件。

- 用UR.tpr里的参数和设定计算config.pdb结构的能量(即单点能)

  ```
  gmx mdrun -deffnm UR -rerun config.pdb
  ```

- 用SSR.tpr里的参数和设定计算traj.trr里每一帧的能量并写入SSR.edr中

  ```
  gmx mdrun -deffnm SSR -rerun traj.trr
  ```

  - 使用`-rerun`计算某个结构文件或轨迹文件里各个结构的能量时，提供的结构/轨迹文件里的原子顺序必须与.tpr文件精确一致
  - 如果用`-reprod`，可以避免一些自动优化，使得在相同软硬件环境下(包括GROMACS版本)对相同tpr每次跑的结果精确相同。

- 续算：`-cpi md_1.cpt`	从检查点文件继续，`-append`将新轨迹追加到原有 `.trr`/`.xtc` 文件，不覆盖

  ```
  gmx mdrun -deffnm md_1 -cpi md_1.cpt -append
  ```

  

## 并行机制

- MPI：是最普的并行化技术。GROMACS4.5版以前的并行无论节点内还是节点间一律通过MPI实现
- thread-MPI：是MPI的轻量级子集，专门用于节点内并行，从4.5版起开始被GROMACS内置
- OpenMP：是最方便、流行的实现节点内并行的技术，从4.6版开始被GROMACS支持。日前版本在节点内并行时thread-MPI与OpenMP会自动结合使用，每个thread-MPI线程下属会有多个OpenMP线程，总并行线程数是二者的乘积。另外GROMACS的一些个别分析命令如hbond也支持OpenMP并行

基于MPI并行需要在编译时提供MPI库(如OpenMPI)，而基于thread-MPI和OpenMP在节点内并行在编译时不需要额外的库。因此，如果只需要节点内并行则无需提供MPI库并专门编译MPI版，而且用MPI版来并行计算速度还会更慢。

参数：

- `-nt`：设定用几个线程并行。默认用所有CPU逻辑核数来并行。也可以用`-ntmpi`和`-ntomp`分别明确指定其中thread-MPI线程数和下属的OpenMP线程数，二者之积对应总线程数(`-nt`值)。
  - 当节点内n核并行时，top命令看到的gmx进程的CPU占用率原理上应接近n*100%
- **`-ntmpi` (MPI进程数)**：指定**MPI进程（或thread-MPI ranks）** 的数量。默认值`0`表示：有GPU时，每个GPU分配一个rank；无GPU时，每个物理核心分配一个rank。例如：`gmx mdrun -ntmpi 2`。
- **`-ntomp` (OpenMP线程数)**：指定每个MPI进程内的**OpenMP线程数**。例如：`gmx mdrun -ntmpi 2 -ntomp 4` 会启动2个MPI进程，每个进程使用4个OpenMP线程。
- 
- `-pin on`：将线程和CPU核心绑定，避免系统随意调度导致性能损失。
- `-pinoffset [id]`:`-pin on`时绑定的CPU核心从第id个核开始算，第一个核心id为0。此选项默认为0。如果同时跑多个任务且用`-pin on`，总应当结合`-pinoffset`避免有的核心同时做两个任务
- `-pinstride [int]`:`-pin on`时绑定的核的序号的间隔。通常设为1，使得被绑定的核的序号挨着





对于支持超线程的CPU一般建议设成`-nt [CPU物理核数] -pin on`。没有必要关闭超线程。
对于跑非常长、很耗时的轨迹，可以加上比如`-nsteps 20000`只跑20000步，测试一下以下情况的差异以寻找性能最佳的组合用来跑当前任务：

- 用和不用`-nt [物理核心数]`
- 用和不用`-pin on`
- `-ntmpi`与`-ntomp`的不同组合(二者之积应对应实际调用的总核数)

报错：

- Fatal error：Your choice of number of MPI ranks and amount of resourcesresults in using 36 OpenMP threads per rank, which is mostlikely inefficient. The optimum is usually between 1 and 6threads per rank. If you want to run with this setup,specify the -ntomp option. But we suggest to change thenumber of MPI ranks (option -ntmpi).
  - 写上-ntomp 6使得每个thread-MPI线程下属的OpenMP线程在程序建议的范围。OpenMP线程数太高的话性能会打折扣，将hread-MPI和OpenMP恰当搭配并行时性能才最好。

- 模拟小体系时可能有以下提示 NOTE: Parallelization is limited by the smallnumber of atoms, only starting 2 thread-MPIranks, You can use the -nt and/or -ntmpi option to  optimize the number of threads 
  - 说明体系原子数太少，仅能利用2个thread-MP1线程进行计算，不用管。
  - 如果实际模拟时发现CPU利用率很低，可尝试用`-ntmpi 2`结合`-ntomp [物理核心数/2]`，尽可能充分靠OpenMP来并行。

## GPU加速相关

当mdrun检测到有GPU可以利用时GPU版会自动利用GPU计算，当有些功能不支持GPU导致报错时可以明确指定用CPU算。

- `-bonded`、`-nb`、`-pme [auto/cpu/gpu]`：指定成键、非键作用的实空间部分、PME算的非键作用的倒易空间部分用CPU还是GPU算。默认为`auto`
- GPU版mdrun可以通过`-nb cpu -pme cpu -bonded cpu`强行要求只在CPU上算(2018版没-bonded选项)
- `-gpu_id [GPUid]`：有多块GPU且想用来分别跑多个任务时，指定任务在哪个GPU上跑，避免冲突
- `-update gpu`：令约束以及坐标更新也放到GPU上算，从而进一步加快速度，这称为GPU-resident模式，但功能上有限制。
  - 从2020版开始支持，从2023版开始默认开启。2023版以前默认为-`-update auto`，总是在CPU上做。用`export GMX_FORCE_UPDATE _DEFAULT_GPU=true`设置环境变量可以总是强行在GPU上做。
  - 注：为了尽可能避免通信，GPU上做update需要满足updategroups条件。此时如果用了约束，几个原子若共同与某个原子有约束关系，那么在[ atoms ]中这儿个原子应当连续地排在那个原子的后头。例如用`constraints = hbonds时`，氢原子应当连续地排在它相连的重原子的后头。

### 例子

- 16核32线程机子上用两个GPU分别跑两个任务，且各用不同的8个CPU物理核心的最佳的运行方式：任务1：由0-7号CPU核心连同0号GPU运行；任务2由8-15号CPU核心连同1号GPU运行

  ```
  gmx mdrun [命令] -nt 8 -pin on -pinstride 1 -gpu_id 0
  gmx mdrun [命令] -nt 8 -pin on -pinoffset 8 -pinstride 1 -gpu_id 1
  ```



# mindist

计算两组间的最小距离

例如：

- 检查蛋白与其镜像距离

  ```
  gmx mindist -f md.xtc -s md.tpr -pi
  ```

- 





# pairdist

pairdist命令可以实现mindist大多数功能，好处是可以使用selection语句，免得写索引文件，且更为灵活、强大。需要用`-ref`和`-sel`定义两个组。
例：计算21和29号残基最小距离随模拟时间的变化

```
gmx pairdist -f md.xtc -s md.tpr -ref "resid 21" -sel "resid 29"
```

- 用`-typemax`可以考察最大距离的变化
- 用`-refgrouping`和`-selgrouping`接上`res`或`mol`的话，可以分别把ref和sel组划分成残基或分子，从而得到两个组间每对残基或分子间最小/最大距离随时间的变化。

考察两个原子间距离变化也可以用pairdist。例考察5与10号原子间距离：

```
gmx pairdist -f md.xtc -s md.tpr -ref "atomnr 5" -sel "atomnr 10"
```









# ⭐pdb2gmx

pdb2gmx是GROMACS中模拟生物大分子体系的关键性工具。它载入生物大分子结构文件，从相关力场库文件中读取所需信息，给体系恰当加氢和重排原子顺序，最后产生生物分子的拓扑文件。

- `-f`：结构文件，一般用pdb（输入）
  - `pdb2gmx`也适合用来产生其它类型的由单体聚合而成的体系，如聚合物，但需要自已恰当修改rtp文件后pdb2gmx才能处理。
  - pdb2gmx不是普性的拓扑文件产生工具，对rtp文件里没有定义的小分子，不可能用pdb2gmx产生拓扑文件
- `-o`：整理后的结构文件，默认为conf.gro
- `-p`：拓扑文件，默认为topol.top
- `-i`：位置限制文件，默认为posre.itp
- `-ff <string>`：设定所用力场，默认是交互式选择
- `-water <enum>`：设定所用水模型，默认是交互式选择
- `-heavyh`：把氢原子质量设为4(并从相连重原子上扣除相应质量)，使氢的运动减缓，从而能用更大步长
- **`-ignh`：忽略输入文件里所有氢。NMR测定的pdb里虽然有所有的氢，某些程序(如分子对接程序)产生的结构文件里也往往有氢，但原子名大概率不标准，应当用此选项让pdb2gmx按标准规则加氢**
  - **通常建议始终带上`-ignh`**
- `-ter`：交互式选择如何处理末端氨基和羧基，默认是搞成带电状态。对AMBER力场不适用(因为它是直接按照r2b文件对残基处在氮端和碳端的情况进行设定)
- `-merge`：默认是`no`，代表每个链作为单独的`[ moleculetype ]`。也可以用`all`都弄到个`[ moleculetype  ]`里，或`interactive`由用户下面则

以下如果都要交互式选择，则用`-inter`选项：

- `-[no]ss`：交互式地选择二硫键            
- `-[no]ter`：交互式地选择蛋白末端, 默认带电 
- `-[no]lys` ：交互式地选择lys赖氨酸类型, 默认带电            
- `-[no]arg` ：交互式地选择arg精氨酸类型, 默认带电            
- `-[no]asp`：交互式地选择asp天冬氨酸类型, 默认带电          
- `-[no]glu`：交互式地选择glu谷氨酸类型, 默认带电            
- `-[no]gln`：交互式地选择gln谷氨酰胺类型, 默认中性          
- `-[no]his`：交互式地选择his组胺酸类型, 默认通过检查氢键判断



## `pdb2gmx`利用的文件

（在力场文件夹中，`pdb2gmx`按照此顺序处理： r2b→hdb→ rtp→tdb）

- `aminoacids.r2b`：

  - 含有将结构文件里的残基名转化到building block 名的对应关系。同一个残基在不间力场里的名字有时不同， 所以需要先做这个转换再套用 rtp

  - 例子：G54A7力场的 r2b文件：

    ```
    ;GMX   Force-field
    CYS    CYSH
    HISD   HISA
    HISE   HISB
    LYS    LYSH
    LYSN   LYS
    HEM    HEME
    ```

  - 例子：AMBER力场比较特殊，第3 、 4 列说明如果残 基在氮端和碳端时分别改名成什么。第5列是对于单个两亲氨基酸的悄况，当前未定义：

    ```
    ; rtp residue to rtp building block table
    
    ;      main  N-ter C-ter 2-ter
    ALA    ALA   NALA  CALA  -
    ARG    ARG   NARG  CARG  -
    ```

- `aminoacids.hdb`：hydrogen database 。设定氢原子 如何连接 到重原子上，用于自动补氢

  - 例子：

    ```
    ALA     1       
    1	1	H	N	-C	CA
    ARG     4  →下面要定义的项数     
    1	1	H	N	-C	CA
    1	1	HE	NE	CD	CZ
    2	3	HH1	NH1	CZ	NE
    2	3	HH2	NH2	CZ	NE
    ```

    - 第一列：这一项要加氢的数目
    - 第二列：加氢的规则
    - 第三列：加入的氢原子名。此项加两个氢，因此名称将为HH21和HH22
    - 第4-6列：加氢时候用于定位几何位置的原子

- `aminoacids.rtp`：residue topology parameter。记录残基(以 及水、个别小分子、离子)的拓扑信息， pdb2gmx载入结构文 件时会依照此文件构建拓扑信息。

  - 例子：AMBER力场中 rtp文件的一部分

    ```
    [ bondedtypes ] ;设定成键项的函数类型以 及产生拓扑信息的规则
    ; bonds  angles  dihedrals  impropers all_dihedrals nrexcl HH14 RemoveDih
         1       1          9          4        1         3      1     0
    ...
    [ GLY ] ; HAx atoms assigned new ff03 atom type
     [ atoms ] 
     ; 原子名 原子类型		  原子电荷     序号
         N    N           -0.374282    1
         H    H            0.253981    2
    ...
     [ bonds ]
         N     H
         N    CA
    ...
         C     O
        -C     N  ;原子名带负号、正号分别是指上一个、下一个残基的原子
     [ impropers ]
        -C    CA     N     H
        CA    +N     C     O
    ```

  - pdb里原了顺序与 rtp里可以 不同， pdb2gmx会按照原子 名来匹配。
  - pdb2gmx会根据 rtp里设定的成键关系，自动产生所有该 有的`[ angles ]` 、`[ dihedrals ]` 、 [ pairs ] 项。
    - rtp里若直接定义了`[ angles ]`等项，会稷盖自动产生的。 GROMOS 力场的 rtp直接就定义完整了所有成键项。

- `aminoacids.n.tdb`和`aminoacids.c.tdb`：termini database， 是氨基酸的氮端和碳端的末端数据库，设定对末端残基如何删除、 添加、替换原子和连键

  - 注：Amber力场`tdb`文件为空，是因为它在 rtp 里就对末端残基直接定义了不同类 型，不需要再按照`tdb`的规则对末端残基在普通残基基础上做额外处理。

  - 例子：此例说明把 N原子的原子类型改为 NL， CA原子的原子类型改为CH1。 **按照4号规则**，以 N 、 CA、 C为参考 **加入3个H类型氢原子**，分别名为 H1 、  H2 、 H3 。**原先残基中名为 H的原子 则被删除**。然后设定新加入的原子 与其它原子间的成键关系。

    ```
    ; G54A7力场的氮端tdb文件的一部分 aminoacids.n.tdb
    [ None ]
    
    [ NH3+ ]
    [ replace ]
    N		NL	14.0067	0.129
    CA		CH1	13.019	0.127	0
    [ add ]
    3	4	H	N	CA	C	  ;H代表新加入的氢的名称前缀
    	H	1.008	0.248     ;新加入氢原子类型、质量、电荷
    [ delete ]
    H
    [ bonds ]
    N	H1	gb_2
    N	H2	gb_2
    N	H3	gb_2
    [ angles ]
    H1	N	H2	ga_10
    H2	N	H3	ga_10
    ...
    [ dihedrals ]
    H1	N	CA	C	gd_39
    ...
    ```

  - `[ none ]` 代表对于非末端残基 什么都不做修改 

  - `[ NH3+ ]` 代表对于氮端的且质子化的 氨基酸要做哪些处理

  - 例子：G54A7力场的碳端tdb文件的一部分 `aminoacids.c.tdb`。此例说明把C原子的原子名重置为C。按照8号规则，以C、CA、N做为参考位置加入2个OM类型氧原子，分别名为O1和O2。但如果原本结构中就已经有O和OXT原子了，则直接将之改成名为O1和O2的OM类型原子。

    ```
    [ COO- ]
    [ replace ] ;此处代表对于碳端的且羧基要设成带电状态的氨基酸要做哪些处理。
    C	C	C	12.011	0.27
    O	O1	OM	15.9994	-0.635
    OXT	O2	OM	15.9994	-0.635
    [ add ]
    2	8	O	C	CA	N
    	OM	15.9994	-0.635
    [ bonds ]			;然后设定新加入的原子与其它原子间的成键关系。
    C	O1	gb_6
    C	O2	gb_6
    [ angles ]
    O1	C	O2	ga_38
    CA	C	O1	ga_22
    CA	C	O2	ga_22
    [ dihedrals ]
    N	CA	C	O2	gd_45
    N       CA      C       O2      gd_42
    [ impropers ]
    C	CA	O2	O1	gi_1
    ```

- `aminoacids.vsd`：virtual site database文件，用于设定症拟点， 一般用不着

## 注意

常见提示：WARNING: Residue 18 named GLU of a molecule in the input file was mapped to an entry in the topology database, but the atom CG used in i!,at entry Is not found in the input file. Perhaps your atom and/or residue naming needs to befixed.

- 这说明 pdb2gmx在将输入的结构文件里的 第 18号残基 GLU 与 rtp文件里的 [GLU] 字段 匹配时，发现结构文件里这个残基少了名为 CG 的原子，显然需要补全结构文件里的这 个缺失的原子后再用 pdb2gmx 。但也有可 能这个原子实际存在，只是结构文件里的原 子名不对，此时需要修改原子名。  
- 注意这里的残基号是从 1 开始排的，和 pdb 文件里记录的残基号未必相同。



# rdf

计算径向分布函数



例如：

考察蛋白质表面附近水的分布

```
gmx rdf -f md.xtc -s md.tpr -ref protein -sel "mol com of resname SOL" -surf mol -rmax 1
```

- `-surf mol`是把ref组划分成一个个分子，计算sel组原子与ref组里各分子中最近原子间的rdf。由于蛋白质整体就是一个分子，所以这样算的是水的质心与蛋白质最近原子间的rdf，也即体现了蛋白质英表面附近水的分布特征。
- `-surfres`是把ref组划分成一个个残基。
- 用`-surf mol`或`res`时会用`-norm none`，此时给出的g(r)不是一般意义的径向分布函数，而是：$g(r)=\frac{\partial N_{\text {sel }}(r)}{\partial r} \approx \frac{N_{\text {sel }}(r+\delta)-N_{\text {sel }}(r)}{\delta}$，N<sub>sel</sub>(r)是r内sel组的粒子数，δ是统计间隔
- r越大处，由于壳层体积越大，因此这种方式给出的g(r)有越大的倾向

# rms

RMSD (root mean square deviation，方均偏差)是最重要的衡量几何结构偏差的标准，即计算当前结构与参考结构间的MSD再开根号：
$$
\mathrm{RMSD}=\sqrt{\frac{1}{N_{\text {atm }}} \sum_{A}^{N_{\text {atm }}}\left|\mathbf{r}_{A}-\mathbf{r}_{A}^{\text {ref }}\right|^{2}}
$$

- N<sub>atm</sub>为所选范围内的原子数，A是其中原子序号。ref上标代表参考结构。

另一种是质量权重的RMSD：
$$
\mathrm{RMSD}=\sqrt{\frac{1}{M} \sum_{A}^{N_{\text {atm }}}m_A\left|\mathbf{r}_{A}-\mathbf{r}_{A}^{\text {ref }}\right|^{2}}
$$

- M：所选范围原子质量和

例子：

运行以下命令，计算轨迹中每一帧的结构和参考结构(-s提供的结构文件)间的质量权重的RMSD：

```
gmx rms -f md.xtc -s md.tpr -o rmsd_protein.xvg
```

- 要叠合的组，和要计算RMSD的组都选Protein。

其他

- [一个到达小分子RMSD阈值自动终止Gromacs模拟的小脚本 - 分子模拟 (Molecular Modeling) - 计算化学公社](http://bbs.keinsci.com/thread-51369-1-1.html)

# rama

计算Ramachandran拉式构象图







# rmsf

RMSF (root mean square fluctuation，方均根波动)衡量某个原子在整个轨迹中相对子平均位置的波动程度，对于展现不同区域的柔性很有用。
$$
\mathrm{RMSF}_A=\sqrt{\frac{1}{N_{\text {frame}}} \sum_{i}^{N_{\text {frame}}}(\mathbf{r}_{A}^{i}-\mathbf{r}_{A}^{\text {avg}})^{2}}
$$
可以将RMSF按下式转换为B因子（Tian Lu, et al., Biochemistry, 48, 7986 (2009)）：
$$
B_A=(8/3)\times \pi^2 \times \mathrm{RMSF}_A^2
$$
pdb中的B因子单位是A，GROMACS给出的RMSF单位是nm

- 可以将蛋白质的pdb文件中的原子B因子转换成残基的RMSF，从而可以和rmsf_protein.xvg里的数据进行对比，判断力场、模拟设定是否合理：[原子-残基B因子/rmsf转换小工具ba2r - 思想家公社的门口：量子化学·分子模拟·二次元](http://sobereva.com/32)





# sasa

使用sasa命令可以考察蛋白的溶剂可及表面积。

- 如果按照原子电荷在-0.2~0.2区间作为疏水区域，其它作为亲水区域，可以用以下命令来计算这两部分各自的面积。

```
gmx sasa -f md.xtc -s md.tpr -surface "group protein" -output ' "Hydrophobic" group protein and charge {-0.2 to 0.2}; "Hydrophilic" group protein and not charge {-0.2 to 0.2}'
```

- 此处`-surface`设置定义总表面用的组，`-output`后面定义单独输出表面上的哪些部分。

- 还可以用`-probe [半径]`来设置溶剂球的探针半径，默认的1.4 埃对应水溶剂分子。

  - 注：此写法在Windows的cmd利Powershell终端下没法用，用Windows版的话可以在cmder模拟的Bash环境下运行

- gmx sasa还可以接上-tv得到某个组的被溶剂可及表面(SAS)包围的体积随时间的变化。例如对蛋白质进行计算：

  ```
  gmx sasa -f md.xtc -s md.tpr -tv
  ```

  - 之后选Protein组。用grace对得到的volume.xvg进行绘图。

# solvate

可以生成一个充满指定分子的盒子，也可以**在`-cp`指定的结构文件中加溶剂分子把盒子空隙填满。**GROMACS会先把整个模拟盒子用此文件里的体系通过平移复制填满，然后扣掉和溶质有重叠的溶剂分子。

- `-cp`： 带盒子参数的分子坐标文件， 一般是`editconf`的输出文件
- `-cs`： 添加的水分子模型， 如spc216， spce， tip3p， tip4p等。默认填入的溶剂是`share/gromacs/top/spc216.gro`，这是对216个SPC水组成的盒子经过动力学模拟后己跑到充分平衡状态的文件。如果要填入其它溶剂分子则用`-cs [文件名]`来指定，文件也应当是经过NPT动力学模拟后的单一纯溶剂体系结构文件。
- `-o`： 输出坐标文件， 就是添加水分子之后的分子坐标文件， 默认为`.gro`文件， 但也可以为其他格式， 如pdb
- `-p`： 体系拓扑文件， `gmx solvate`会往里面写入添加水分子的个数. 这个不要忘记， 不然在进行下一步计算时， 会出现坐标文件和拓扑文件中原子数不一致的错误





- `-maxsol [数目]`可以设定只填入多少溶剂分子，填充会很不均匀。
- -`shell [厚度]`可以填充指定厚度的溶剂层。
- `-p [top文件名]`还会同时对指定的拓扑文件进行修改，将其中的溶剂分子数设为当前值。
- `-scale <real>`：当溶剂与溶质之间距离小于它们的范德华半径和，则溶剂会被去掉。范德华半径是`share/gromacs/top/vdwradii.dat`的半径值乘以`0.57`（默认值）。对水中的蛋白质， 使用默认值0.57可以得到接近1000 g/l的密度值。

## 例子

- 生成2×5×4nm的水盒子体系

  ```
  gmx solvate -box 2 5 4 -o test.gro
  ```

- 在protein.gro的盒子空档中填充水分子

  ```
  gmx solvate -cp protein.gro -o solv.gro
  ```

- 在protein.gro中的溶质附近0.5nm范围内填满水分子(前提是.gro里的盒子己足够大)

  ```
  gmx solvate -cp protein.gro -o solv.gro -shell 0.5
  ```





# ⭐trjconv

此命令用于轨迹文件的处理，主要用处：

- 转换轨格式(xtc/trr/gro/pdb之间转换)
- 减少帧数
- 只保留指定组的原子
- 截取部分轨迹
- 修改轨迹中对周期性的描述
- 将轨迹向参考结构叠合

合并轨迹用`trjcat`

参数：

- `-f`：被处理的轨迹文件
- `-s`：.tpr/gro/pdb文件(可选，输出结构文件及`-fit`时必须)
- `-n`：.ndx文件(可选)
- `-o`：新产生的轨迹文件
- `-skip <int>`：每几帧输出一次，默认为1
- `-dump <time>`：输出离指定时间最近的帧
- `-pbc <选项>`：修改PBC处理方式
  - 默认值为`none`，即不对轨迹的PBC描述做任何修
  - `atom`：只要原子越过盒子边界就返回另一边。这是mdrun直接产生出的轨迹对应的情况。这会导致边界处分子/残基被截断
  - `mol/res`：分子/残基的质心如果跨越了盒子，则分子/残基就挪到盒子另一头，这保证了分子残基的完整性。如果因为用了`-trans`和`-center`使得有的分子/残基处于盒子外，也可以由此得到修正
    - 注：mdrun直接产生的gro文件对应的是mol状态
  - `nojump`：使得原子即便跨越了盒子边界也照样运动(相对于第1帧而言)，而不会被挪到另一边。这保证了轨迹的连续性。
    - GROMACS自带的分析工具基本都能自动、恰当地在分析轨迹时考虑PBC问题。但第三方的分析程序则可能没法恰当处理PBC轨迹，如果不先搞成`nojump`的形式则会得到错误的结果。
  - `cluster`：选定一个组(通过index文件定义)，使得这个组保持完整。主要用于令轨迹中分子团簇(包括诸如蛋白质+配体复合物)保持完整。使用前应先使用mol保证分子的完整性
- `-ur <选项>`：修改盒子描述方式。默认为`rect`(矩形)，亦可`tric`(三斜)或`compact`(距离中心盒子中央最近部分，即Weigner-Seitz cell)。如果最初`editconf`的时候用`-bt`指定为了截角八面体或棱形十二面体盒子，用`-ur compact`处理出的轨迹或结构文件里的原子就会出现在这种盒子范围里。
- `-center`：平移体系使得指定组的几何中心处在盒子中央。盒子中心可以由`-boxcenter`具体定义
- `-trans <vector>`：对所有坐标按照矢量平移
- `-fit <选项>`：对轨迹中某个组根据参考结构叠合
- `-step`：把轨迹每一帧输出为单独的.gro/pdb文件

读的文件里有速度信息就会被读/写。但受力不会被读/写，除非写了`-force`

## 例子

- 将`all.trr`中3 ns到5 ns的轨迹每隔100ps一次提取出来到3_5.xtc

  ```
  gmx trjcon -f all.trr -b 3000 -e 5000 -dt 100 -0 3_5.xtc
  ```

- 从all.trr中提取出grp.ndx里定义的某个组到sub.trr

  ```
  gmx trjconv -f all.trr -n grp.ndx -o sub.trr
  ```

  - 如果用`-s`提供了结构文件，即便没用`-n`也会提示选择要输出的组

- 提取md.trr中最接近3000ps的结构和速度到3000ps.gro

  ```
  gmx trjconv -f md.trr -s md.tpr -o 3000ps.gro -dump 3000
  ```

- 将轨迹按照index.ndx里的某个组进行叠合输出到new.xtc，参考结构是ref.gro

  ```
  gmx trjconv -f sol.trr -s ref.gro -n index.ndx -fit rot+trans -o new.xtc
  ```

  - 程序会让选择两次组，第一次选择对哪个组做叠合，第二次选择输出文件里包含哪个组的信息

- 把md.xtc中从50ns开始到末尾的轨迹输出到cen.xtc，并对每一帧结构进行平移使得选定的某个组的质心恒处在盒子中心

  ```
  gmx trjconv -f md.xtc -b 50000 -o cen.xtc -n index.ndx -center
  ```

- 令sol.trr中的分子保持完整(必须提供.tpr)

  ```
  gmx trjconv -f sol.trr -s sol.tpr -pbc mol -o new.xtc
  ```

  - 若再用以下命令，则分子运动轨迹会保持连续，而不被盒子边界所截断

    ```
    gmx trjconv -f new.xtc -pbc nojump -o yuri.xtc
    ```



# xpm2ps

`gmx xpm2ps`能够将XPM(XPixelMap)矩阵文件转换为漂亮的颜色映射图. 只要提供了正确的矩阵格式， 还可以显示标签和坐标轴. 矩阵数据可以通过一些程序得到， 如`gmx do_dssp`， `gmx rms`或`gmx mdmat`.
