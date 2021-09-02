---
title: 【molpro】01.基础
typora-root-url: 【molpro】01.基础
mathjax: true
date: 2019-11-13
updated:
tags: [输入,输出,内存,坐标,基组,赝势]
categories: [计算化学, molpro]
description: 输入文件简单学习
---



# 运行molpro

## 输入

在UNIX系统中，MOLPRO通过unix命令molpro访问：

```
molpro [options] [datafile]
```
- `datafile`：输入文件，可以取任何名字，但是要避免使用.out作为后缀，一般用.inp。unix中出现在molpro输入文件中的文件名总是转化为小写。

- options：大部分选项都有合适的系统默认值，但是也可以在命令行中、环境变量MOLPRO OPTIONS中或文件./molpro.rc，$HOME/.molprorc，和library文件目录下的tuning.rc中（优先级递减）：
  - `-d [directory]` ：定义放置临时文件的目录

  - `-m n_scale`：<span id=mm>指定分配给程序的工作内存，单位是word=8byte</span>

    - `k`，`m`，`g`分别为10<sup>3</sup>，10<sup>6</sup>，10<sup>9</sup>
    - `K`，`M`，`G`分别为2<sup>10</sup>，2<sup>20</sup>，2<sup>30</sup> 

    ```
    #需要1000word的内存
    -m 1k
    #需要1024word的内存
    -M 1K
    ```

  用于并行执行的选项（在使用串行MOLPRO时，将忽略这些选项）：

  - `-n`：定义设置的并行进程个数

    并行内存计算eg. 为具有4个并行计算过程的作业指定100×10<sup>6</sup>个word：100×10<sup>6</sup>×8×4=3.2×10<sup>9</sup>byte

  - `-N` ：等指定工作节点的主机名

## 输出文件

### out文件

执行结果会把输出写到一个名称输入文件截掉扩展名并加上`.out`产生的文件中。如果输出文件已经存在，防止覆盖文件，会把旧文件重命名为后缀为`.out_1`的文件中。如果命令行没有给出`datafile`，那么从标准输入读取数据。在命令行中可以有其他方式：

- `-o [outfile]` ：自定义输出名

  ```
  molpro -o water.output h2o.inp
  ```

- `-s`：不保存旧的输出文件，只是覆盖。

### punch文件

punch文件是output文件的简易形式，它包含了最重要的数据和结果，例如几何结构，能量，偶极矩等。可以用独立的程序readpun处理，它用关键词选择特定的结果，并根据用户提供的格式产生排列好的表格。

```
PUNCH,filename,[REWIND]
```

- 指定的`filename`会在unix中转换成小写

- punch文件如果已经存在，则对其添加内容，如果指定了`REWIND`或者`NEW`，punch文件中所有以前的信息都被覆盖。

- eg.

  ```
  PUNCH,H2O.PUN
  ```

### xml文件

除了生成.out文件外，还用. XML后缀创建结构化XML文件(实际上是.out文件的父文件)。这个文件可以用于结果的自动处理，例如[Jmol程序](http://jmol.sourceforge.net/)（需要下载[java运行环境JRE](https://www.java.com/en/download/manual.jsp)）的图形化呈现。

- `-X`或者`--xml-output`：指定输出文件为格式规范的XML文件，适于自动后期处理。重要的数据如输入，结构，以及结果都被加上标记，通常的大块描述性输出都作为XML注释折叠起来。
- `--no-xml-output`：强制产生纯文本输出。
- `--xml2txt`：将xml文件转换为纯文本文件，此时molpro的输入文件应该是一个xml文件。

### 9个二进制文件

- 程序通过它们的编号（1到9）可以简单地识别它们。

- 默认是临时文件，用[`FILE`命令](#file卡)可以把计算出的数据作为轨道和能量保存到永久文件中，并在以后的阶段使用它们重启计算，默认的保存路径为$HOME/wfu，可以使用`-W`修改路径：

  ```
  molpro -W ./ h2o.inp
  ```

- 文件类型：
  - 文件1：主文件，存有基组，几何结构，以及单电子和双电子积分。
  - 文件2：默认是转存文件，用于存储波函的信息，即：轨道，轨道能量，可选的CI矢量，以及密度矩阵。
  - 文件3：辅助文件，和文件2一起用于续算
  - 文件4~8：草稿文件空间，用来分类积分，存储转换的积分和CI矢量。这些文件通常无需存为永久文件。

  通常文件1和2（以及3）被声明为用于续算的永久文件。文件2对于重新启动计算是必不可少的，而文件1上的积分可以重新启动，也可以重新计算。把波函信息存储在文件2中是非常有用的，因为对于每个新的结构，积分文件都会被改写，而一个计算中的轨道和CI因子可以用作下一个相近几何结构计算的初始猜测。

### 记录文件

- 记录文件的名称是正整数，引用格式为record.file，比如2100.2表示命名为2100的2文件。记录文件的名称比较随意，它们的数值与记录在文件中的顺序无关。
- 不要使用≥2000的记录名字，因为有一些默认的记录为：
  - `2100`：RHF转存记录（闭壳层和开壳层）
  - `2200`：UHF转存记录
  - `2140`：MCSCF转存记录
  - `4100`：CPHF续算信息
  - `5000`：MCSCF梯度信息
  - `5100`：CP-MCSCF梯度信息
  - `5200`：MP2梯度信息
  - `5300`：Hessian续算信息
  - `5400`：频率续算信息
  - `6300`：域的续算信息

- 如果一个输入包含同一类型的几个波函计算，例如不同活性空间的几个MCSCF计算，则对同一类型的每个计算，记录编号加1。比如第一个SCF计算的结果存储在转存记录2100.2中，第二个SCF计算存于2101.2记录，第一个MCSCF计算存于2140.2，第二个MCSCF存于2141.2等等。这些数字和输入中出现的顺序有关，而不是按照计算实际执行的顺序。

### put输出其他格式

```
PUT,style,file,status,info
```

- `style`：
  - `GAUSSIAN`：写一个完整的GAUSSIAN输入文件，默认为`# sp`计算
  
  - `XYZ`：输出xyz文件
  
  - `XYZGRAD`：包含能量梯度的XYZ文件（列依次是：x，y，z，charge，gx，gy，gz，梯度为-1*eV/A）
  
  - `CRD`：坐标将用CHARMm CRD格式书写
  
  - `MOLDEN`：将创建用于MOLDEN可视化程序的接口文件
  
    - 注意：<font color=red>molden文件不支持含h以上角动量的基组，如果仅需要可视化轨道查看，那么可以将基组中的h删去，输出molden文件，结果差别很小。</font>
  
    ```
    put,molden,h2o.molden;
    ```
  
  - `IRSPEC`：gnuplot输入文件，该文件可用于绘制IR光谱
  
  - 忽略则写入当前结构的Z矩阵，可能的话还写入梯度。
- file定义写入数据的文件名；如果为空，数据将写入到输出流中。如果忽略status或设置为NEW，那么文件中所有的旧内容都被清除；否则对文件追加。

# 输入文件格式

## 一般结构

```
***,title			! 标题（可选）
memory,4,m 			! 内存指定（可选）
file,1,name.int 	! 命名永久的积分文件（可选）
file,2,name.wfu 	! 命名永久的波函文件（可选）

gprint,options 		! 全局打印选项（可选）
gthresh,options 	! 全局阈值（可选）
gdirect[,options] 	! 全局直接积分选项（可选）
gexpec,opnames 		! 单电子算符的全局定义（可选）

basis=basisname 	! 基的定义。如果不出现，使用cc-pVDZ
geometry={...} 		! 结构定义。

var1=value,var2=value,... 	! 设定结构和/或波函定义中的变量

{command,options 		! 程序或流程的名称
directive,data,option 	! 命令的指令（可选）
...
} 				! 结束命令区
--- 			! 结束输入（可选）
```

- 输了memory卡应该是紧随标题的第一个以外，其他basis，geometry，gprint，gdirect，gthresh，gexpec，以及变量定义的顺序是任意的。
- 可以在一个程序后调用其它几个程序。在程序的调用之间还可以重新定义基组和/或分子结构；程序将会自动确认是否需要重新计算积分。

## 一般规则

- `,`移到下一个制表位，即用来划定输入范围。
- `;`结束记录，开始一个新的记录。用分号隔开的基本命令单位称为卡（card）。一个给定的输入行可以包含多个有效命令（用；隔开），也可以只有一个。
- `!`忽略该输入行后面的内容（用于注释）。
- 内容不区分大小写，统一转换为大写处理。引号中的内容会被认为是字符串，不会进行大小写转换。
- 整数后面加上`.`，程序只读取浮点数

一般只占用一行的命令：

- `***`总是第一个数据行，title可以任选，但是如果文件1用于续算，title必须总是相同。这个卡的作用是重新设置所有程序的计数器等。如果忽略***卡，title假定用默认值，全是空格。
- `INCLUDE`包含其它的输入文件。使用`INCLUDE`可以打开辅助输入文件。如果遇到了`INCLUDE`命令，则打开新的输入文件并读取到结束，然后在第一个输入文件中继续INCLUDE卡之后的输入。`INCLUDE`也可以嵌套。
- `FILE`指定已命名的文件
- `TEXT`打印文本
- `TITLE`定义运行的标题或表格的标题
- `CON`指定轨道组态
- `---`结束文件（忽略之后的输入）

## 一般格式

整体格式一般是：

```
COMMAND, options
```

或者

```
{ COMMAND,options
directives
data
}
```

- 命令（COMMAND）比如有`HF, MP2, CCSD(T), MCSCF, MRCI`
- 指令（directives）比如有`OCC, CLOSED, WF, PRINT`等，格式一般`DIRECTIVE,data,options`
- 选项（options）的格式一般是`NAME[=value]`
  - 多个选项以逗号或空格分隔。
  - 如果选项在COMMAND一行或命令块内的指令上给出，则它们仅对相应的程序有效。

# memory卡

```
MEMORY,n,scale;
```

- [与命令行中的`-m`不同](#mm)，scale中`k`，`m`，`g`不区分大小写，统一按10<sup>3</sup>，10<sup>6</sup>，10<sup>9</sup>
- 优先于命令行中的`-m`。两者都省略的话，程序将使用默认的内存大小8mw (64 Mb)。

MOLPRO可以根据用户的需要动态分配内存。因此不需要保存有不同内存大小的不同版本程序。所需要的内存大小取决于分子的大小、基组、分子的对称性和使用的方法，因此很难提前预测。大多数计算运行在16mw或更少，但在大的情况下，低对称性可能需要更多。一个比较好的选择是64MW（512MB），前提是系统有足够的内存。

- 算到一半但是没有报错就停止了，可以将.sub文件中并行核数设大一些，比如24，再将molpro中的并行设置-n中的设置小一些。

# file卡

对所有的永久文件，默认设置是RESTART。所有的临时文件在需要时通常自动分配。I/O缓存分配到动态内存的顶端，缓存的大小会减少可用的内存。因此MEMORY卡必须出现在第一个FILE卡之前。

```
FILE,file,name,[status]
```

- `file`是逻辑MOLPRO文件序号(1-9)
- `name`是文件名（将被转换成小写字母）
- `status`可以是：
  - `UNKNOWN`打开永久文件。如果存在，自动续算。这是默认的。
  - `OLD`作用同`UNKNOWN`。如果该文件不存在，不会发生错误。
  - `NEW` 打开永久文件。如果已经存在，则清除，不续算。
  - `ERASE` 作用同`NEW`。
  - `SCRATCH` 打开临时文件。如果已经存在，则清除，不续算。任务完成后，文件不
    再存在。
  - `DELETE` 作用同`SCRATCH`。

例子：

- 分配永久文件1的名称H2O.INT，如果存在会使用它进行续算。比如第一个输入中只计算了hf和ccsd(t)，使用了该指令，后续计算casscf和MRCI的时候，指定了相同的文件，，MOLPRO将自动恢复保存在给定文件中的所有数据，积分和轨道将被重新启动。

  ```
  FILE,1,H2O.INT
  ```

- 分配永久文件2的名称H2O.WFU，即禁用自动重启机制

  ```
  FILE,2,H2O.WFU,NEW
  ```

- 在大多数情况下，文件1可能非常大(它包含两个电子的积分)，而重新计算积分的成本可能只占总时间的一小部分，因此可以只在输入中只定义文件2，积分会自动重新计算。

# print/gprint 全局打印选项

通常，有两种打印选项：一种是局部的，由print指令指定，仅在一个作业步骤中使用；一种是全局的，在各个程序以外可以用GPRINT命令设置全局打印选项（g可用可不用，用了可以避免与程序特定的PRINT卡相混淆）。局部打印命令是特定方法输入的一部分，因此必须直接遵循相应的命令。全局打印选项作用于所有后续方法。

```
GPRINT,key1[=value1],key2[=value2],. . .
NOGPRINT,key1,key2,. . .
```

- 除了`DISTANCE`，`ANGLES`，和`VARIABLE`之外，全部选项默认都不打印。`key`有：
  - `BASIS`：打印基的信息
  - `DISTANCE`：打印键长（默认）
  - `ANGLES`：打印键角信息（默认=0）。如果大于0，还打印二面角
  - `ORBITAL`：打印SCF和MCSCF的轨道
  - `CIVECTOR`：打印MCSCF的CI矢量（注意，默认情况下只打印大于0.05的CI系数。）
  - `PAIRS`：打印CI和CCSD中的电子对列表
  - `CS`：打印CI和CCSD中的单激发信息
  - `CP`：打印CI和CCSD中的对激发信息
  - `REF`：打印CI中的参考CSF及其因子
  - `PSPACE`：打印p-空间组态
  - `MICRO`：打印MCSCF和CI中的微迭代
  - `CPU`：打印详细的CPU信息
  - `IO`：打印详细的I/O信息
  - `VARIABLE`：每当变量设置或改变时，就打印变量（默认）
- value可以省略，当values，大于0的值可用于调试，在有些情况下会给出更多的信息。
- `NOGPRINT,key`等价于`PRINT, key =-1`。

```
gprint,basis             !print basis set information
gprint,orbitals          !print occupied orbitals
gprint,orbitals=2        !print occupied and the two lowest virtual orbitals
                         !in each symmetry
gprint,civector          !print configuration coefficients
```

# geometry卡

定义分子结构可以用标准Z矩阵形式，或XYZ形式。GEOMETRY必须出现在其它修改分子结构的命令之后。

```
[SYMMETRY, options ]
[ORIENT, options ] 
[ANGSTROM] 
[BOHR]
geometry={ 
原子说明 
} 
```

- `symmetry`选项
  - `SYMMETRY,NOSYM`禁止使用对称性，也可以只用`NOSYM`
  - `SYMMETRY,AUTO`允许使用对称性
- `orient`选项：（也可以用`CENTRE=MASS|CHARGE`指定对称中心。）
  - `CHARGE`：定位分子，使得电荷中心是原点，轴是四极矩的本征矢。
  - `MASS`：定位分子，使得质心是原点，轴是惯性张量的本征矢（对Z矩阵输入是默认的）
  - `NOORIENT`：禁止分子重新定位（对XYZ输入是默认的） 
  - `SIGNX=±1`：强制第一个非零x坐标为正或负。类似地，可以用`SIGNY`和`SIGNZ`设置y、 z坐标。这对固定遍及几种不同计算和结构的分子方位非常有用。也可以设定系统变量`ZSIGNX`，`ZSIGNY`，`ZSIGNZ`为正值或负值来获得同样的效果。
  - `PLANEXZ`：对于C<sub>2v</sub>和D<sub>2h</sub>点群，强制主平面是xz，而不是默认的yz。结构构建程序尝试交换坐标轴，使尽可能多的原子位于主平面中，因此对于平面分子的特殊情况，这意味着所有原子都会位于主平面。也可以指定`PLANEYZ`和`PLANEXY`，但是后者目前对C2v点群会发生错误。
- `geometry`也可以通过`geometry=file`从文件中读取

## xyz输入

- 第一行是原子个数，第二行是任意的标题，前两行可以省略。坐标中单位默认为Å。
- 元素符号后面可以加序号，用于对于同一类型不同原子使用不同的基组。

```
geometry={
   4
  FORMALDEHYDE
C          0.0000000000        0.0000000000       -0.5265526741
O          0.0000000000        0.0000000000        0.6555124750
H          0.0000000000       -0.9325664988       -1.1133424527
H          0.0000000000        0.9325664988       -1.1133424527
}
```

## Z矩阵输入

- 坐标默认为玻尔 bohr，可以使用`angstrom`关键词改变

```
angstrom
geometry={
C
O   C  1.182
H1  C  1.102  O  122.1789
H2  C  1.102  O  122.1789  H1  180
}
```

也可以通过Z矩阵输入XYZ形式

```
angstrom
geometry={
C,,        0.0000000000 ,     0.0000000000 ,    -0.5265526741
O,,        0.0000000000 ,     0.0000000000 ,     0.6555124750
H,,        0.0000000000 ,    -0.9325664988 ,    -1.1133424527
H,,        0.0000000000 ,     0.9325664988 ,    -1.1133424527
}
```

也可以使用变量

```
geometry={
C
O  , C , rco
H1 , C , rch , O , hco
H2 , C , rch , O , hco , H1 , 180
}

rco=1.182 Ang
rch=1.102 Ang
hco=122.1789 Degree
```

# 基组

## 笛卡尔和球谐基函数

MOLPRO默认使用球谐基函数(5d，7f等)，即使是对Pople基组，如6-31G**，也是如此。可以用`CARTESIAN`命令使用笛卡尔函数，随后所有的计算都使用笛卡尔基函数，在续算中也是如此，可以通过`SPHERICAL`换成球谐基函数，但是要在给基组之前给出相应的命令。

## 基组库

基组库由一组无格式文本文件以及相应的索引构成，组成了通用的基组（原高斯函数和相应的收缩）和有效芯势数据库。这些文件可以在源文件的目录树中找到，分别为lib/*.libmol和lib/libmol.index，但更方便的方法是从数据库里查找：

- [美国太平洋西北国家实验室（Pacic Northwest NationalLaboratory）的基组数据库](https://www.basissetexchange.org/)
- [Stuttgart 有效芯势和基组](http://www.tc.uni-koeln.de/PP/clickpse.en.html)
- [molpro网页的basisi.php脚本](https://www.molpro.net/info/basis.php?portal=user&choice=Basis+library)，可以本地安装也可以直接在网页中获取

## 默认基组及其调用

### 指定

- 对任何对称唯一的原子组都没有定义基组，那么程序假定使用全局默认值（VDZ）

- 通过一下方法指定基组。

  ```
  BASIS,basis
  ```

  或

  ```
  BASIS=basis
  ```

- 默认基组可以在输入文件能量计算前的任何位置定义，并且只能使用一个BASIS卡。默认基组应用于所有类型的原子，但是可以对特定的原子替换成不同的基组。

- `BASIS`不能作为变量，比如`$BASIS=[AVDZ, AVTZ, AVQZ]`，使用遍历的方法为：

  ```
  $aobases=[AVDZ, AVTZ, AVQZ]
  do i=1,#aobases
  basis=aobases(i)
  ...
  enddo
  ```

### 可调用的基组

- `basis`可以在文件lib/defbas中查找，包含的通用基组有：
  - 所有的Dunning关联一致基组，用基组的标准名称（cc-pVXZ，aug-cc-pVXZ）或缩写（VXZ，AVXZ）调用。对于Al-Ar，用标准名称cc-pV(X+d)Z，aug-cc-pV(X+d)Z，或VXZ+d，AVXZ+d，可以得到紧凑的d扩充集。X=D,T,Q,5的基组适用于H-Kr，X=6适用于B-Ne和Al-Ar。
  - 用于芯关联的关联一致基组cc-pCVXZ，aug-cc-pCVXZ，或CVXZ，ACVXZ（X=D,T,Q,5），以及更新的“加权集”cc-pwCVXZ，aug-cc-pwCVXZ，或WCVXZ，AWCVXZ（X=D,T,Q,5）。这些基组适用于Li-Kr（CVXZ不包括Sc-Zn）。
  - Douglas-Kroll-Hess相对论版本的关联一致基组，可以使用加上-DK后缀的标准名称或简称，例如，cc-pVXZ-DK或VXZ-DK。X=D-5适用于H-Kr，X=T适用于YCd和Hf-Hg。三阶DKH收缩集适用于Hf-Hg，需要加上后缀-DK3。
  - Peterson等人用于用于显关联计算的F12基组：cc-pVXZ-F12，cc-pCVXZ-F12，或VXZ-F12，CVXZ-F12，其中X=D,T,Q。它们适用于H-Ar。
  - Turbomole def2系列基组：SV(P)，SVP，TZVP，TZVPP，QZVP，QZVPP。它们可用于除了f区元素之外的整个周期表。
  - 对于第一行原子（不是H和He），有旧一些的Dunning/Hay分块收缩双zeta基（DZ和DZP）。
  - Roos的ANO基组用于H-Ar（ROOS）。
  - Stuttgart ECP和相应基组（例如ECP10MDF），以及Peterson等人基于ECP的关联一致基组：cc-pVXZ-PP，aug-cc-pVXZ-PP，cc-pwCVXZ-PP，aug-cc-pwCVXZ-PP，或VXZ-PP，AVXZ-PP，WCVXZ-PP，AWCVXZ-PP。后者适用于Cu-Kr，Y-Xe，和Hf-
    Rn（芯关联集目前仅用于过渡金属）。
  - Hay ECP和相应基组（ECP1和ECP2）。
  - 其它一些Karslruhe基组（SV，TZV，以及用于某些元素的TZVPPP）。
  - 用于Ga-Kr的Binning/Curtiss集（BINNING-SV，BINNING-SVP，BINNING-VTZ和BINNINGVTZP）
  - 大多数Pople基组使用其标准名称（例如6-31G*，6-311++G(D,P)，等）。在这种情况下需要特别注意，不能使用下面描述的用于限定基组的括弧修饰机制，必须使用被指定的整个标准基组。
- 此外，还可以使用很多密度拟合和单位分解（resolution of the identity，RI）基组。在密度拟合计算中，对Dunning的关联一致基组自动选择合适的Weigend VXZ/JKFIT，XZ/MP2FIT，或AVXZ/MP2FIT集（还可以用扩充版本的AVXZ/JKFIT 用于拟合Fock矩阵，但默认不使用）。对于def2系列的轨道基组，使用合适的辅助集（例如，TZVPP/JFIT，TZVPP/JKFIT，TZVPP/MP2FIT）。原则上说，这些JKFIT集是通用的，可以与AVXZ基组一起使用。初步结果表明它们也可用于cc-pVXZ-PP和aug-cc-pVXZ-PP系列的基组。
- 对于使用cc-pVXZ-F12轨道基组的显关联F12计算，默认用相应的VXZ-F12/OPTRI基组构造附加的辅助轨道基（complementary auxiliary orbital basis；CABS）。对于其它轨道基组，默认使用合适的JKFIT集。

### 对于角动量的限制

- 可以使用一些关于最大角动量函数的限制，或是收缩函数的数量限制，比如减少基组的最大角动量：

  - 忽略正常情况下出现在VQZ基组中的𝑓和𝑔函数：

  ```
  BASIS,VQZ(D)
  ```

  - 指定氢的最大角动量是1，也就是忽略氢的𝑑轨道：

  ```
  BASIS,VQZ(D/P)
  ```

- 对于一般收缩基组，可以用扩充的语法直接给出每个角动量收缩函数的数量

  - 从Roos的ANO数据集产生6-31G*大小的基组：

  ```
  BASIS,ROOS(3s2p1d/2s)
  ```

## 单个原子的默认基组

- 只需要在默认基组后加上`atom1=name1,atom2=name2,...,`，`atom`即元素符号，`name`为相应的基组名。**默认基组必须在原子特定基组之前指定**。（<font color=red>此外，基组中有的不是名字定义，而是用的原始集和收缩集文本来定义的，应当先写名字定义的，否则可能出错</font>，当计算中出现了比较奇怪的错误，在检查其他地方没有问题之后，可以尝试更换基组区的ECP、单个原子基组、价电子基组的顺序，或者更换文本定义的基组尝试。）

  - 比如使用cc-pVTZ作为默认的基组，但是对氢原子使用cc-pVDZ：

    ```
    basis=vtz,h=vdz
    ```

    或

    ```
    basis,vtz,h=vdz
    ```

    或

    ```
    basis,default=vtz,h=vdz
    ```

## 基组区

通过`BASIS ... END`块或者`BASIS={...}`指定，一般形式如下：

```
BASIS
	SET,setname1,[options]
		DEFAULT=name
		atom1=name1
		atom2=name2
		原始基组说明
	SET,setname2,[options]
		...
END
```

- 可以在基组区给出任何数量的基组。每个基组的定义由SET指令开始，其中可以指定基组名和更多选项。

- 基组区的第一个基组默认是轨道基组，这种情况下可以忽略指令`SET,ORBITAL`

- `DEFAULT`指定默认基组，与单行基组输入完全相同。之后可以接各个原子的基组说明。默认基组和原子特定基组也可以合并到一行，之间用逗号隔开。

  ```
  !对氧和氢分别用AVTZ和VDZ覆盖默认基组VTZ
  DEFAULT=VTZ,O=AVTZ,H=VDZ
  ```

- SET，DEFAULT，atom=name这些说明都是可选的。如果没有给出DEFAULT，将使用前面最后一个BASIS卡定义的默认基组。

- 可以先后连续出现几个BASIS卡/区。对给定的原子总是使用最后指定的说明和类型（默认类型为`ORBITAL`）。

- 如果对任何唯一原子组都没有指定基组，程序假定为VDZ。

- 如果`setname`是`JKFIT`，这个基在DF- hf或DF- ks中自动使用，除非使用BASIS或DF_BASIS选项进行不同的指定。但是请注意，如果使用了不同的名称(例如`JK`)，情况就不是这样了。在这种情况下需要给出`DF-HF,BASIS=JK`以便使用DF-HF中的辅助基。

# 赝势

指定方式（<font color=red>最好在`basis`中首先指定ECP，再指定基组）</font>：

```
ECP,atom,[ECP specification]
```

- ECP specification说明部分可以包含一个关键词，用于引用基组库中存储的赝势，也可以（连续在几个输入卡中）直接定义。
- 注意：目前molpro对ECP的支持到Db，后面的元素不认，因此用相应元素的ECP则需要修改元素符号，比如将Og修改为Rn，但是此时Rn的内层电子数不满足92，需要改成60。

### 通过ECP库的输入

一共有两种：

- Los Alamos小组：
  - 校正到一个合适原子参考态的轨道能量和密度
  - 关键词是`ECP1`和`ECP2`；当对给定的原子有一个以上的赝势时，ECP2用于表示小芯ECP的定义。（例如对Cu，`ECP1`表示类Ar的18电子芯， 而`ECP2`模拟类Ne的10电子芯，把3s和3p电子放入到价层）对于包含电子关联的精确计算，推荐把主量子数等于价轨道的所有芯轨道放入到价轨道中。 
- Stuttgart/Köln小组：
  - 用多个原子态的总价电子能量产生。 
  - 关键词的形式为：`ECPnXY`：
    - n是用赝势代替的芯电子数量
    - X表示用于产生赝势的参考体系（X = S，单价电子离子；X = M，中性原子）
    - Y 表示参考数据的理论级别（Y=HF：Hartree-Fock；Y=WB：准相对论；Y=DF：相对论） 
  - 对于单个或两个价电子的原子而言，X = S，Y=DF是很好的选择，否则推荐X = M，Y=WB （或Y=DF） 。（对于较轻的原子，或者为了讨论相对论效应，相应的Y=HF赝势也可能会有用。）
  - 此外还可以使用自旋轨道（SO）势和芯极化势（CPP），用于b)类ECP，但目前不包含在基组库中，因此需要另外输入

在以上两种情况中，**赝势和相应的基组使用相同的关键词**，但对前一种需要使用前缀`MBS-`...。



例子：AuH分子在r(exp)的CCSD(T)结合能；使用Stuttgart/Koeln小组的标量相对论19价电子赝势

```
***,AuH
gprint,basis,orbitals;
geometry={au}
basis={
ecp,au,ECP60MWB;              ! ECP input
spd,au,ECP60MWB;c,1.2;        ! basis set
f,au,1.41,0.47,0.15;
g,au,1.2,0.4;
spd,h,avtz;c;
}
rhf;
{rccsd(t);core,1,1,1,,1;}
e1=energy
geometry={h}
rhf
e2=energy;
rAuH=1.524 ang                ! molecular calculation
geometry={au;h,au,rAuH}
hf;
{ccsd(t);core,2,1,1;}
e3=energy
de=(e3-e2-e1)*toev            ! binding energy = 3.11 eV
```

### 直接输入ECP

对每种赝势，必须提供以下信息：

- 一个卡，形式为：

  ```
  ECP,atom,ncore,lmax,l′max;
  ```

  $$V_{ps}= -\frac{Z-n_{core}}{r} + V_{l_{max}}
            +\sum_{l=0}^{l_{max}-1} (V_l-V_{l_{max}}){\cal P}_{l}
            +\sum_{l=1}^{l'{max}} \Delta V_l {\cal P}_{l} \vec{l}\cdot\vec{s} {\cal P}_{l} ;$$

  - `ncore`是用赝势$V_{ps}$代替的芯电子数量
  - `lmax`是$V_{ps}$标量相对论部分的半局域项数量
  - `l′max`是相应的SO部分的项个数

- 定义$ V_{l_{max}}$的一些卡：

  ```
  m_1,γ_1,c_1;m_2,γ_2,c_2;...
  ```

  $$V_{l_{max}} = \sum_{j=1}^{n_{l_{max}}} c_j r^{m_j-2} e^{-\gamma _j r^2}$$

  - 第一个给出展开式长度$n_{l_{max}}$，接下来的$n_{l_{max}}$给出参数

- 定义标量相对论半局域项的一些卡:

  ```
  ml_1,γl_1,cl_1; ml_2,γl_2,cl_2;... 
  ```

  $$V_l -V_{l_{max}}=\sum_{j=1}^{n_l} c_j^l r^{m_j^l-2} e^{-\gamma _j^l r^2}$$

  - 顺序是$l=0,1,\ldots , l_{max}-1$
  - 对每一项，必须给出一个展开长度是$n_l$的卡，后面再接$n_l$个卡

- 类似的，是一些径向势$\Delta V_l$因子的卡，定义$V_{ps}$的SO部分

例子：Cu原子SCF d10s1→d9s2激发能，使用相对论Ne-芯的赝势和Stuttgart/Koeln小组的基组

```
***,CU
gprint,basis,orbitals
geometry={cu}
basis
ECP,1,10,3;   	! ECP input
 1; 			! NO LOCAL POTENTIAL
 2,1.,0.;
 2; 			! S POTENTIAL
 2,30.22,355.770158;2,13.19,70.865357;
 2; 			! P POTENTIAL
 2,33.13,233.891976;2,13.22,53.947299;
 2; 			! D POTENTIAL
 2,38.42,-31.272165;2,13.26,-2.741104;
! (8s7p6d)/[6s5p3d] BASIS SET
s,1,27.69632,13.50535,8.815355,2.380805,.952616,.112662,.040486,.01;
c,1.3,.231132,-.656811,-.545875;
p,1,93.504327,16.285464,5.994236,2.536875,.897934,.131729,.030878;
c,1.2,.022829,-1.009513;C,3.4,.24645,.792024;
d,1,41.225006,12.34325,4.20192,1.379825,.383453,.1;
c,1.4,.044694,.212106,.453423,.533465;
end
rhf;
e1=energy
{rhf;occ,4,1,1,1,1,1,1;closed,4,1,1,1,1,1;wf,19,7,1;}
e2=energy
de=(e2-e1)*toev  ! Delta E = -0.075 eV
```

