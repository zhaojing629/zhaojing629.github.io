---
title: 【GROMACS】6.膜蛋白的计算
typora-root-url: 【GROMACS】6.膜蛋白的计算
mathjax: true
date: 2026-08-19 11:55:43
updated:
tags: [GROMACS, 蛋白质, 膜]
categories: [计算化学, 软件]
description: 用Gromacs计算膜蛋白
---



# 生物膜相关



## 磷脂的结构特征



![image-20260819120623507](/image-20260819120623507.png)

根据磷脂的头部基团和尾部烃链的不同，磷脂有许多种类，常用四个字母表示：

- 前两个字母决定脂肪酸是哪种
- 后两个字母决定头部基团是哪种

比如：

- DPPC： 1,2-Dipalmitoyl-sn-glycero-3-phosphocholine
- DPPE： 1,2-Dipalmitoyl-sn-glycero-3-phosphoethanolamine
- POPC： 1-Palmitoyl-2-oleoyl-sn-glycero-3-phosphocholine

常见的尾部基团：

- DP：二棕榈酰
- PO：1-棕榈酰-2-油酰
- DM：二肉豆蔻酰
- DL：二月桂酰

常见的头部基团：

![image-20260819121451131](/image-20260819121451131.png)

- 磷酸基是带负电的，而PC、PE头部基团的正电部分与之抵消，此时磷脂是中性的。

## 膜蛋白的种类

- 整合蛋白
  多数为跨膜蛋白，跨膜区域为alpha螺旋或者形成桶状的beta折叠。也有些是完全插入膜双层中。与膜结合极为稳定
- 脂锚定蛋白
  与脂质分子以共价键稳定结合
- 外周蛋白
  通过离子键等方式与膜表面蛋白或磷脂的亲水部分结合，不稳定



## 常见的膜力场

- Kukol(2009)：JCTC,5,615。完全兼容G53A6，结果很好。支持DPPC、DMPC、POPG、POPC、DMPC。itp文件
  和预平衡后的结构可从[原文的补充材料](https://pubs.acs.org/jctcce/article-abstract/5/3/615/196635/Lipid-Models-for-United-Atom-Molecular-Dynamics?redirectedFrom=fulltext)里得到。**此力场的POPC不建议使用**
- Poger(2010)：JCTC,6,325、JCC,31,1117。完全兼容
  G53A6。支持DPPC、DLPC、DMPC、DOPC、POPC
- 54A8_v1：JCTC,15,5175(2019)。对G54A8用于磷脂头
  部的残基的电荷做了明确定义，调整了个别范德华参数，使
  得模拟磷脂有较好的效果。力场目录gromos54a8.ff_v1、
  DLPC、DMPC、DOPC、DPPC、POPC、POPG的拓扑文
  件、含512个磷脂平衡后的结构文件可在此下载： [Biomembrane simulations - Fraternali Lab](https://fraternalilab.github.io/biomembrane-simulations/)

用联合原子力场模拟膜体系比全原子力场快得
多，在磷脂区域前者的原子数只有后者的1/3

- Stockholm lipids (Slipids) (初f2012, 最新2020) ：全原子，兼容AMBER力场，质量非常好。支持DPPC、DLPC, DMPC. POPC,DOPC, SOPC、 POPE.DOPE等20多种磷脂，以及鞘磷脂、胆固醇，itp文件和致平衡后的结构可从此处下载:http://www.fos.su.se/~sasha/SLipids/Downloads.html
- Lipid：是AMBER系列力场的扩展，完全兼容AMBER力场。参数来自GAFF，几种头部(PC,PE,PS,PH,P2,PGR,PGS,PI)和几种尾部可以自由搭配(模块化)组成磷脂，还支持胆固醇、鞘磷脂。AmmberTools程序中的leap直接能用此力场
  - Lipid有以下版本，精度不断提升，支持的分子范围不断扩展
    .
    - Lipid11:JPCB, 116, 11124 (2012)
      
    - Lipid14:JCTC, 10, 865 (2014)
      
    - Lipid17:未公开发布，AMBER支持，在Lipid14基础上调整了参数和原子电荷，并扩展了头部和尾部的类型。
      - GROMACS的拓扑文件可以在此获取:
        [xiki-tempula/gmx_lipid17.ff: a gromacs port of the amber lipid force field LIPID17](https://github.com/xiki-tempula/gmx_lipid17.ff) 
      - 在[Gromacs可用的Amber14SB_ROC_lipid17力场包 - 分子模拟 (Molecular Modeling) - 计算化学公社](http://bbs.keinsci.com/thread-43558-1-1.html)中给了含有各种磷脂定义的rtp文件，以
        及拉直后的各种磷脂的gro文件。
    - Lipid21: JCTC, 18, 1726 (2022)

- Berger (1997):Biophys. J.,72,2002.联合原子膜力场。成键參数基于GROMOS87，LJ参数基于OPLS-UA，很常用也银好，唯一致命的问题在于不直接兼容如今常用的GROMOS96力场，因此目前不再推荐用。Berger力场本身没直接提供参数和拓扑文件，Tieleman基于Berger的参数制作了DPC、POPC、DPPC、DMPC、DLPC、 DOPC、PLPC、 POPE的itp文件. 
- CHARMM27及改进版CHARMM36:质量不错的膜力场.在GROMACS的charmm27.ff/lipids.rtp文件中对LPPC. DLPE、 DMPC、 POPC, POPE、 PALM.
  PCGL等脂类分子做了定义
- G43A1-S3: J. Phys. Chem. B, 113, 2748 (2009)Chiu等人弄的兼容G43A1的膜力场。支持PC、PE、鞘磷脂和胆固醇。非主流
- MARTINI:粗粒化力场，包含磷脂。itp文件可在[Downloads – Martini Force Field Initiative](https://cgmartini.nl/docs/downloads/)下载
- GLYCAM06:支持了少数磷脂分子，非主流
- GAFF:虽然因其普适性也可以处理磷脂，但直接用在膜模拟效果不好。在Soft Matter,8,9617(2012)中提出的GAFFipid是基于GAFF的阶段性的膜力场，现已被Lipid力场取代
- GROMOS96:rtp本身也自带了DPPC参数，结果不好
- FUJI:JCTC, 16, 3664 (2020). 与FUJI蛋白质力场兼容。扭转势基于高精度LCCSD(T)/aug-cc-pVTZ势能曲线进行拟合，原子电荷使用许多构象平均的RESP电荷，原子类型在GAFF基础上进行了扩展。支持PC和PE头部以及LA、MY、OL、PA、ST尾部。此力场强调与严格的PME方式算的范德华作用兼容性好

## 与脂质有关的网站

- Limonada (Lipid Membrane Open NetworkAnd Database): [Limonada - Home](https://limonada.univ-reims.fr/)包含以下内容
  磷脂:
  - 有400种以上磷脂的信息，包括简称、完整命名、结构图、分类、化学组成、PubChemID号等
  - 磷脂的拓扑文件:有超过600个拓扑文件，对应不同磷脂、不同力场、不同程序。力场以CHARMM36为主，也有基于GROMOS的、Slipid的、MARTINI的
  - 生物膜:包含几十种实际的生物膜(混合膜)，提供了名称、磷脂成份、预平好衡的结构和模拟条件等信息
- lipidbook:[Lipidbook - A public repository for lipid force field parameters and topologies](https://www.lipidbook.org/)。包含了A近百个已发表的磷脂及相关分子的拓扑文件，每个对应一种“力场-程序-脂质类型”，可以通过条件搜索。收录的磷脂力场并不全面
- lipidbank:[LipidBank](https://lipidbank.jp/)。脂质数据库，可以分类查询，得到脂质结构、基本参数和实验信息
- LIPID MAPS: [LIPID MAPS ](https://www.lipidmaps.org/databases/lmsd/browse)同上
- MemProtMD:[MemProtMD](https://memprotmd.bioch.ox.ac.uk/)跨膜蛋白模拟数据库。数据以流程化方式获得:从RCSB蛋白质数据库中选取跨膜蛋白，加入离子、水、磷脂后用GROMACS结合MARTINI粗粒化力场做1微秒动力学模拟(期间磷脂会自组装成膜)，之后还原成全原子模型进一步分析。数据库中提供了这些膜蛋白的模拟截图、分析统计数据、模拟涉及的全部文件，以及模拟前后的粗粒化和全原子模型的结构文件。数据库里的蛋白一直不断增加，截止到2021年4月已经包含5000个蛋白

## 磷脂膜体系模拟要点

- 起码得用6×6×2共72个磷脂大小的体系，**一般都用8×8×2=128个磷脂的模型**

- 应当让膜平面在XY平面上。两层膜间的节面位于盒子Z轴的中间

- 要用semiisotropic控压，使得压浴对X/Y和Z方向分别耦合

- 模拟温度应当高于磷脂的相变温度(熔点)，否则磷脂处于高度有序的晶态而缺乏流动性。相变温度与磷脂自身特征和所用力场有关，实验的相变温度：

  ![image-20260819134513785](/image-20260819134513785.png)

- 应当注意膜力场与色散的能量-压力校正的兼容性。诸如Kukol、Lipid14膜力场原文里用了这种校正，自行模拟时也应当使用。而CHARMM36磷脂力场则没有使用

- 磷脂与“水+离子”应分别控温，如果再插入蛋白，则共有三个控温组

- 消除平动建议设定为comm_grps = lower upper SOL来对下层、上层膜和水分别消除平动。否则由于两层膜，以及膜与水之间耦合较弱，容易产生虚假的相对滑动。如果是膜蛋白体系，则蛋白和两层膜作为同一组消除平动

- 勿忘去掉疏水区域的水。如果一开始结构较烂，发现水自发钻进疏水区，可尝试给水的Z方向加限制势，等平衡后再放开

- 因为磷脂分子较大，弛豫速度远比小分子慢，通常得模拟好几十ns才能充分平衡。如果是混合膜体系，则往往得跑上百ns

## 磷脂膜体系的构建

- 直接下载:在一些研究磷脂模拟的课题组页面上、一些模拟文章的补充材料中有磷脂膜的结构文件，
- genmixmem:卢天开发，可以生成单一或混合组分的磷脂双层膜初始结构。用户需自行提供磷脂的结构文件。下载地址: http://sobereva.com/245
- Packmol:可以通过恰当设定磷脂分子的堆积方式从而构建双分子膜。但是往往耗时较高或者根本不收敛，磷脂分布往往不均匀容易有窟窿，导致水容易钻进去。用户需自行提供磷脂的结构文件
- PACKMOL-Memgen:自动化构建纯膜、混合膜、膜蛋白体系的工具，会自动调用Packmol。只适合结合Lipid17在Amber下使用或结合CHARMM36在NAMD下使用
- http://www.charmm-gui.org:可以用来构建基于CHARMM36力场的磷脂膜以及膜蛋白体系结构，可以同时加水和离子。构建的质量较好，比:较致密。支持的脂质种类十分丰富。
  - 进入界面后择Input Generator-MembraneBuilder-Bilayer Builder可。另外还可以选产生GROMACS的输入文件，这样在所有步骤都结束得到的压缩包里就会有对应CHARMM36力场
  - GROMACS的输入文件。
    必须有edu邮箱才能申请免费的账号并使用。
- [MemGen](http://memgen.uni-goettingen.de/):在线工具，上传单分子结构文件，并输入单层膜面积、每磷脂对应的水数、盐浓度后就可以返回生成好的膜结构
- MemBuilderIl:http://bioinf.modares.ac.ir/software/mb2在线工具。可以产生一些磷脂的双层膜，可以定义每种磷脂多少个来混合，同时直接在膜外加上水。但是产生的结构往往并不怎么样比如磷脂是歪的，而且两层膜以及膜与水之间的距离往往也太远。此工具还能产生囊泡、胶束的结构。
- [PlayMolecule - Click. Compute. Discover.](https://open.playmolecule.org/tools/membranebuilder):构建任意比例、任意尺寸的POPC/POPE/胆固醇的纯膜或混合膜的在线工具。有其它任务在排队执行时可能需要等很长时间才能开始执行
- VMD的Extensions - Modeling - MembraneBuilder:只能产生POPE、POPC的膜结构
- BUMPy: https://github.com/MayLab-UConn/bumpy.基于Python，特点是可以构建曲率的双层膜

# 膜的模拟

以Kukol文件中的dppc128_40ns.pdb为例

- 建立DPPC目录

- 将dppc128_40ns.pdb拷到当前目录并改名为memwat.pdb。这是Kukol膜力场中作者事先经过40ns充分平衡后的膜结构文件

- 将dppc_53a6.itp拷到当前目录,这是DPPC对应的Kukol力场的itp文件

- mdp模板\mem\md.mdp：由于当前结构已经充分平衡过，因此可以直接做动力学。

  ```
  define =
  integrator = md
  dt         = 0.002   ; ps
  nsteps     = 1000000 ; 2ns
  comm-grps  = lower upper SOL
  energygrps = 
  ;
  nstxout = 0
  nstvout = 0
  nstfout = 0
  nstlog  = 1000
  nstenergy = 1000
  nstxout-compressed = 1000
  compressed-x-grps  = system
  ;
  pbc = xyz
  cutoff-scheme = Verlet
  coulombtype   = PME
  rcoulomb      = 1.0
  vdwtype       = cut-off
  rvdw          = 1.0
  DispCorr      = EnerPres
  ;
  Tcoupl  = V-rescale
  tau_t   = 0.2 0.2
  tc_grps = DPP SOL
  ref_t   = 325 325
  ;
  Pcoupl     = parrinello-rahman
  pcoupltype = semiisotropic
  tau_p = 2.0
  ref_p = 1.0 1.0
  compressibility = 4.5e-5 4.5e-5
  ;
  gen_vel  = no
  gen_temp = 325
  gen_seed = -1
  ;
  freezegrps  = 
  freezedim   = 
  constraints = hbonds
  ```

  - 参考温度改为325K，因为DPPC的相变温度为315K，应适当设高一些
  - 注意此mdp文件中DPPC与SOL分别设了控温组，用了半各项同性控压，而且comm-grps=lower upper SOL使得上层磷脂、下层磷脂和水分别消除平动。

- 用此命令产生index.ndx文件

  ```
  gmx make_ndx -f memwat.pdb  (直接q)
  ```

- 在VMD中载入memwat.pdb,将卢天的rangeindex.tcl脚本复制到VMD命令行，分别输入：

  ```
  rangeindex "same residue as resname DPP and z<20"
  rangeindex "same residue as resname DPP and z>40"
  ```

  这会把将下层和上层膜的原子序号导出到D:\range.txt，然后在index.ndx后面增加`[ lower ]`和`[ upper ]`组:

  ```
  [ lower ]
  1 2 3 4 5 6  
  ...
  
  [ upper ]
  3201 3202 3203 3204 3205 3206 
  ...
  ```

- 建立topol.top，内容如下：

  ```
  #include "gromos54a7.ff/forcefield.itp"
  #include "gromos54a7.ff/spc.itp"
  #include "dppc_53a6.itp"
  
  [ system ]
  128 DPPC, hydrated
  
  [ molecules ]
  DPPC		128
  SOL		3655		（不知道有多少个水的时候载入VMD会显示）
  ```

  虽然Kukol力场提出时对应的是53A6，
  但与54A7也是兼容的。

- 运行以下命令开始2ns动力学模拟

  ```
  gmx grompp -f md.mdp -c memwat.pdb -p topol.top -o md.tpr -n index.ndx
  ```

  ```
  gmx mdrun -v -deffnm md
  ```

- 使分子保持完整，顺带去除水（输出组都选择DPPC）

  ```
  gmx trjconv -f md.xtc -s md.tpr -o md_fix.xtc -pbc mol
  gmx trjconv -f md.gro -s md.tpr -o md_fix.gro -pbc mol
  ```

  
  

## 结果

### 磷脂头部平均表面积

最常用的衡量膜模拟质量的参数就是磷脂平均表面积。不过不同实验手段测出来的差异往往不小。323K下DPPC平均每个磷脂面积的实验值在0.629~0.643 nm2。

使用以下命令提取模拟过程中盒子X、Y尺寸，假设从500ps开始已经进入平衡:

```
gmx energy -f md.edr -o XY.xvg -b 500
```

选17 Box-X和18 Box-Y。
然后把XY.xvg去掉开头部分，后缀名改为.txt，导入进Origin里，新增一列定义为盒子X与Y尺寸的乘积，统计其平均值，为40.2nm2，因此平均每个DPPC面积为40.2/64=0.628 nm2.

### 膜的可压缩度

等热面积可压缩度衡量模拟过程中膜面积S的波动程度，波动程度越大说明膜越软，和流动性有
一定正相关
$$
\chi_{T}^{s}=\frac{1}{k_{\mathrm{B}} T} \frac{\left\langle(S-\langle S\rangle)^{2}\right\rangle_{\mathrm{NPT}}}{\langle S\rangle_{\mathrm{NPT}}}
$$
可以用卢天开发的memstat进行计算。

启动memstat程序，输入XY.xvg的路径，程序即给出平均膜面积，每一帧的膜的面积输出到了当前目录下的xysize.txt里。然后输入当前模拟的平均温度325，就会输出膜的可压缩度1.187281m2/J。

### 数密度分布

将要统计水和磷脂中磷原子垂直于膜平面的分布。首先在索引文件里增加磷原子(原子名为P)对应的组，运行

```
gmx make_ndx -f md.tpr -n index.ndx
```

输入a P，然后按q保存。

```
gmx density -f md.xtc -s md.tpr -ng 2 -center -n index.ndx -b 500 -dens num
```

输入0(格子以体系中心为原点定义)、选择磷的组、选择water组

```
xmgrace -nxy density.xvg
```

![image-20260819153915154](/image-20260819153915154.png)

- 有一部分水跨过磷酸基，毕竟更下面的酯基也是亲水的
- 双层膜的厚度有不同定义方式，一种计算方式是取头部原
  子在两侧的密度的峰之间的距离。

### 电子密度分布

将前例统计数密度分布里的`-dens num`改为`-dens electron`即可统计电子密度分布。

在此之前必须先在当前目录下提供electrons.dat文件，里面记录各个原子名对应的电子数，实际统计时用的电子数是此文件里电子数加上原子电荷值。

此例electrons.dat内容为

```
4
P= 15
HW1 = 1
HW2 = 1
OW = 8
```

### 有序度参数$S_z$

$$
S_{z}=\frac{3\left\langle\cos ^{2} \theta_{z}\right\rangle-1}{2}
$$



- $\theta_{z}$是i+1与i-1之间连线与z轴的夹角，尖括号是时间平均。
- $S_{z}$代表模拟过程中i+1与i-1连线一直严格平行于z轴
- $S_{z}=1/2$代表连线一直垂直于z轴。
- 对于磷脂可以依次计算烃链上每个原子的$S_{z}$，然后绘图，用以考察磷脂尾巴的有序度。

order命令是用来计算有序度参数的工具。如果要对一条链计算，则需要提供索引文件，文件里从第一个组到最后一个组依次是这条链从第一个原子到最后一个原子的序号。每个组可以包含体系中所有等价原子，这样同类分子的有序度参数将被取平均。

为了能够在make_ndx里选择组，需要先记下烃链上各个原子的名称。将卢天的atmlab.tcl里的内容放到VMD里执行，然后运行atmname "resid 1 " 0 (假设0为当前体系ID) 使1号残基所有原子名显示出来。

运行：

```
gmx make_ndx -f md.gro -o order.ndx
```

依次输入

```
del 0-5			(删除原有的所有组)
a C11			尾巴前半段
a C12
...
a C19
a C110			尾巴后半段
a C111
...

a C116
q
```

也可以将以上要输入的内容写入到某文本文件order.inp里，然后通过重定向方式执行make_ndx命令：

```
gmx make_ndx -f md.gro -o order.ndx < order.inp
```

运行以下命令计算烃链上的$S_{z}$参数(默认以z轴作为参考)

```
gmx order -f md.xtc -s md.tpr -n order.ndx -o order.xvg -szonly
```

绘图:

```
xmgrace order.xvg
```

考虑的烃链上的原子有16个，故orderxvg里有14个值，对应C11-C13, C12-C14.……C113-C115, C114-C116

![image-20260819155506409](/image-20260819155506409.png)

### 氘代有序度参数$S_{CD}$

$$
S_{CD}=\frac{3\left\langle\cos ^{2} \theta_{CD}\right\rangle-1}{2}
$$

氘代有序参数值域为[-1/2,1]，数值越大尾巴无序度越高，数值越小尾巴越有序。$S_{CD}$可以通过将氢原子
氛代后实验测定。

$S_{CD}$用order命令也可以算。步骤同前，去掉`-szonly`选项，则计算后就会产生deuter.xvg，其中第二列是$-S_{CD}$。而产生的order.xvg文件的最后一列依然是$S_{z}$参数。

### 侧向扩散系数

运行以下命令绘制磷脂的侧向方均位移曲线(选择P 组使磷原子作为磷脂的参考点)

```
gmx msd -s md.tpr -f md.xtc -n index.ndx -lateral z 
xmgrace msd.xvg
```

![image-20260819155913248](/image-20260819155913248.png)

### 磷脂的运动轨迹

产生分子运动保持连续的轨迹和结构文件

```
gmx trjconv -f md.xtc -s md.tpr -o md_DPPCnojump.xtc -pbc nojump
gmx trjconv -f md.gro -s md.tpr -o md_DPPCnojump.gro -pbc nojump
```

输出组都选DPPC。

在VMD中载入轨迹，然后将卢天的showtrj.tcl里的脚本在控制台执行添加绘制轨迹的命令，然后运行

```
showtrj "name P and resid 1 to 64" 0 1000 10
```

这便将1001帧轨迹中单层膜当中的磷原子的运动轨迹绘制了出来，每10帧绘制一次。

### 特征二面角的统计



# 膜蛋白的模拟

## 将蛋白质嵌入膜的方法

- VMD:直观，但蛋白与磷脂有时空隙大，需要较长时间模拟至平衡，模拟期间盒子会收缩

- Packmol:不好收敛，不好控制

- CHARMM-GUI:虽然傻瓜化，但仅限CHARMM力场，且灵活度比较有限

- inflatgro:有对应的实现脚本，兼容GROMACS。inflatgro2的原理见J. Chem. Inf.Model., 52, 2657 (2012)

  ![image-20260819161823280](/image-20260819161823280.png)

  - inflatgro方法以及传统的蛋白嵌入膜的方法全面讨论:Methods,41,475 (2007)

- membed:是最理想的嵌入膜的方法，已写入GROMACS。原理见JCC,31,2169 (2010)

  - 先把蛋白与预平衡好的膜的相对位置摆好，然后令蛋白在xy方向收缩，去除与之重叠的磷脂，之后在模拟过程中蛋白逐步膨胀回原样，并不断排挤周围的磷脂，使得磷脂与蛋白紧密接触

    ![image-20260819162005367](/image-20260819162005367.png)

## 实例

将1a11跨膜蛋白嵌入预平衡的DPPC磷脂双层膜

- 将1a11.pdb、dppc128_40ns.pdb
  、dppc_53a6.itp复制到1a11目录下

- 产生1a11的拓扑文件：(选G54A7力场，SPC水)

  ```
  gmx pdb2gmx -f 1a11.pdb -o protein.pdb -p topol.top -ignh
  ```

- 在topol.top中添加对dppc_53a6.itp的引用，并且在`[ molecules ]`的**<font color=red>开头</font>**添加与dppc128_40ns.pdb对应的DPPC 128和SOL 3655

- 把protein.pdb的内容到dppc128_40ns.pdb的最后，保存为mix_prior.pdb。用VMD载入之。用pbcbox显示出盒子边框，关闭水和磷脂的显示，然后建立一个选择范围为protein的描述，然后按数字键9(根据描述方式设定移动对象)，参照盒子边框调整好蛋白相对于磷脂膜的位置和朝向后，重新显示磷脂看插入位置是否合适，确认无误后保存为mix.pdb

  - pbc box

  - Display→Orthographic

  - 确保选中的是protein

    ![image-20260819164247470](/image-20260819164247470.png)

    ![image-20260819164330149](/image-20260819164330149.png)

  - 通过9和R调整蛋白质，9的时候shift蛋白质可以旋转，最后将蛋白质放在x、y、z三个方向都是中间

    ![image-20260819165625672](/image-20260819165625672.png)

- 基于常规MD的mdp文件编写蛋白插入磷脂过程的mdp文件insert.mdp，要点:

  - 模拟步数设1000

  - xtc保存频率建议设50，以便监控插入过程

  - 以下内容必须有:（新版gromacs不支持energygrp_excl = Protein Protein）

    ```
    energygrps = Protein
    cutoff-scheme = group
    freezegrps = Proteinfreezedim = Y Y Y
    energygrp_excl = Protein Protein
    ```

  - 步长建议设1fs

- 编写插入蛋白过程的控制文件membed.dat

  ```
  nxy                      = 1000
  nz                       = 0
  xyinit                   = 0.100000
  xyend                    = 1.000000
  zinit                    = 1.000000
  zend                     = 1.000000
  rad                      = 0.200000
  ndiff                    = 0
  maxwarn                  = 10
  pieces                   = 1
  asymmetry                = no
  ```

  - 这代表一开始把蛋白在xy方向收缩到原本的0.1倍大小(xyinit)，在1000步(nxy)的MD过程中，逐渐膨胀到原先大小(xyend)。z方向尺寸始终不变。允许最多有10个警告。
  - 如果模拟时提示水不能被SETTLE，在确认建模合理的前提下把rad逐渐调大再试，或尝试重新搭结构。rad是检测膜与被嵌入的组之间的重叠的探针半径。默认0.22nm

- 当前体系不是电中性，加抗衡离子，选择替换掉SOL:

  - 产生临时tpr文件

  ```
  gmx grompp -f insert.mdp -c mix.pdb -p topol.top -o insert.tpr -maxwarn 10
  ```

  - 替换离子

  ```
  gmx genion -s insert.tpr -p topol.top -o init.gro -neutral
  ```

- 将topol.top复制个备份topol_init.top(免得插入膜时候程序崩溃而此文件又被改乱)

- 执行以下命令把膜插进去

  ```
  gmx grompp -f insert.mdp -c init.gro -p topol.top -o insert.tpr -maxwarn 10
  gmx mdrun -v -deffnm insert -membed membed.dat -mp topol.top
  ```

- 第一个组选Protein，第二个组选DPPC(注:如果用自定义组，需要用`-mn`结合索引文件)







- 运行：

  ```
  gmx make_ndx -f insert.gro
  ```

- 输入：将蛋白和DPPC组成新的组Protein DPPC

  ```
  10 | 2
  ```

- 将模拟DPPC时候的md.mdp拷来，作如下修改

  ```
  comm-grps = Protein_DPPC Water_and_ions
  tc_grps = Protein DPPC Water_and_ion
  stau t =0.2 0.2 0.2
  ref t = 325 325 325
  ```

- 把md.mdp复制成pr.mdp，用来做200 ps限制性动力学，使得模拟过程中给蛋白位置施加限制势，对水在Z方向也施加限制势，免得在磷脂弛豫之前水趁机溜进蛋白与磷脂的缝隙。

  - 在pr.mdp中设置200ps模拟时间，并且做以下设置

    ```
    define = -DPOSRES -DPOSRES_WATER
    refcoord_scaling = com
    ```

  -  在topol.top里把水的限制势的x和y分量都设0

- 运行以下命令开始200ps限制性动力学模拟

  ```
  gmx grompp -f pr.mdp -c insert.gro -p topol.top -o pr.tpr -nindex.ndx -r insert.gro
  gmx mdrun -v -deffnm pr
  ```

- 运行以下命令开始2ns动力学模拟

  ```
  gmx grompp -f md.mdp -c pr.gro -p topol.top -o md.tpr -n
  index.ndx
  gmx mdrun -v -deffnm md
  ```

- 保持磷脂完整并去除水：输出组都选non-Water

  ```
  gmx trjconv -f md.gro -s md.tpr -o fixed_nowat.gro -pbc mol
  gmx trjconv -f md.xtc -s md.tpr -o fixed_nowat.xtc -pbc mol
  ```

  



# 使用inasne.py



地址： https://github.com/Tsjerk/Insane

安装：

```
pip install insane
```

