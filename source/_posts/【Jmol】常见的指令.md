---
title: 【Jmol】常见的指令
typora-root-url: 【Jmol】常见的指令
date: 2021-08-13 19:33:37
updated:
tags: [Jmol, 绘图]
mathjax: true
description: Jmol常见的指令
---









# `background`背景

设置背景颜色或者图像。用法：

- `background [RGB-color]`：设置窗口的背景颜色。

- ` background IMAGE "filename"`：将窗口的背景设置为指定的图像文件，该文件可以是BMP、JPG、PNG或GIF格式。图像被拉伸以适应窗口的大小。
- `background LABELS [color-none-CPK]`：设置使用“label”命令显示的原子标签的背景颜色。是全局操作，而不是对选定的原子。

> - `[RGB-color]`：
>   - 颜色的名字：`white`、`black`……
>   - RGB颜色值：`[255, 0, 255]`，`{255,0,255} `，`{0.5, 0.5, 1}`
>   - 十六进制颜色码：`[xFF00FF]`
> - `[color-none-CPK]`：包含`[RGB-color]`和`none`

# `boundbox`边界框

边界框设置，与`boundingbox`含义相同。

- `show BOUNDBOX`：中心是模型的几何中心而不是旋转中心（即平均原子位置）。输出格式为：

  ```
  boundbox: (centerX, centerY, centerZ) (vectorX, vectorY, vectorZ)
  ```

  - 比如边框的长就是2`vectorX`

- 显示边界框：

  ```
  boundbox [atom-expression] [line-width-or-type]
  ```

  - `[atom-expression]`见[原子表达](#[atom-expression]原子表达)。默认是`*`

  - `[line-width-or-type]`：`ON/OFF/DOTTED`（默认是`ON`，即实线）或`整数(1-19)`或者`小数(<2.0)`（后两者似乎与实线的粗细有关）

- 通过中心和向量设定一个边界框：

  ```
  boundbox [atom-expression-or-coordinate] [xyz-coordinate] [line-width-or-type]{default: unchanged}
  ```

- 通过两个角设定一个边界框：

  ```
  boundbox CORNERS [atom-expression-or-coordinate] [atom-expression-or-coordinate] [line-width-or-type]{default: unchanged}
  ```

- ` getProperty boundBoxInfo`：获取边界框的信息

# rotate

默认为以逆时针方式绕 y（垂直）轴每秒旋转 10 度，即：

```
rotate spin y 10
```

选项：

- `axis`：axis可以是`x`， `y`， `z`，`-x`， `-y`，`-z`，绕六个标准轴中的一个旋转。隐含的轴是窗口的轴，而不是分子的轴。如果需要按分子的轴，则需要`MOLECULAR `关键词。
- `axis number`：绕着某个轴旋转多少度，可以是负的，如果在前面加上`spin`，表示每秒旋转多少度。

- `axis num1 num2`：围绕某个轴以num2的速度旋转num1度。

- `{atom expression or point} {atom expression or point} number`：围绕两个点形成的轴旋转多少度。可以是点，也可以是原子。

  ```
  #rotate x 10 等同于
  rotate {0 0 0} {1 0 0} 10
  spin {atomno=1} {atomno=2}
  ```

- `INTERNAL`等同于`MOLECULAR `，根据分子的轴旋转。
- `spin`：根据给定的速度自旋。

# color

默认的颜色标准：http://jmol.sourceforge.net/jscolors/#JavaScript%20colors

可以通过select选中后，再指定颜色 `select \*.N?; color green`；也可以通过`color {*.N?} green`，通常的语法为：

```
color [object] [translucent/opaque] [color, property, or color scheme]
```

- `[object]` ：可以是`atoms`, `bonds`, `backbone`, `cartoon`, `stars`, `rockets`, `ribbon`, `dots`, `label`, `echo`, `hbonds`, `ssbonds`, `axes`, `boundbox`, `measures`, `polyhedra`, `isosurface`, `pmesh`, `unitcell`。

## 透明

```
color atoms TRANSLUCENT
```

```
color bonds TRANSLUCENT 1
```



# select

- `select`：默认选中所有原子，=`select all`=` select *`
- `select none`：选中0个原子=`select 0`
- `select [atom-expression]`：基于[atom-expression]选择原子
- `select add/remove [atom-expression]` ：将指定的原子添加/移除到选定的集合中。

例子：

```
#选择C元素
select _C
#选择第一个U元素
select (_U)[1]
#选择所有原子中第一个原子
select (*)[1]
#选择所有原子中第1-6个原子
select (*)[1][6]

#选择所有原子中第1，6个原子
select (*)[1],(*)[6]

select ({0 5})
select ({0 70:74})

#选择1-8，65-75原子
select (*)[1][8], (*)[65][75]

#选择所有成键的原子
select bonded
#选择所有连接的原子
select connected
#选择已经选择的原子
select selected
#选择第1，3，5个原子
x = [1,3,5]; select atomno=x
#选择第34、35个原子
select @34, @35
#选择元素序号10~110之间的原子
select {elemno>=10 and elemno<=110}
```



# label

- 原子的标记参见[atom properties]。

## 相关设置

- `set fontScaling OFF`：当fontScaling设置为ON时，在此之后创建的任何标签都会在模型缩放时进行缩放。

- `set fontSize [font-size]`：为当前选定的原子设置原子标签的字体大小。
- ` set labelOffset [x-offset] [y-offset] [atom-expression]`：设置相对于被标记原子的标签偏移量。正数表示原子中心和标签开头之间的像素数。负数表示原子中心和标签末端之间的像素数，整个标签在原子的左侧。任一方向的零表示以该方向为中心。
- `set labelAlignment position`：position可以是`LEFT`, `RIGHT`,或`CENTER`。将多行标签内的标签文本对齐方式设置为左对齐、右对齐或居中对齐。
- 设置[颜色](#color)：注意无法和背景颜色设置相同颜色。



# font

语法：

```
font [object-with-text] [font-size] [font-face] [font-style] [scaling factor]
```

- [object-with-text]有：`axes`、`ECHO`、`HOVER`、`LABEL`、`measure`
- [font-size]：6-63之间的整数
- [font-face]字体默认是`SansSerif`，还有`SERIF`、`monospaced`
- [font-style]默认是`Plain`，还有`BOLD`，`italic`和`BOLDitalic`





# Spacefill或CPK

将选定的原子渲染为阴影球体。

- `spacefill on/OFF`：打开或关闭，默认是`ON`。
- `spacefill ONLY`：关闭其他的渲染，包括标签
- `spacefill 数字`：以埃为单位的特定半径的球体。负数`=ONLY`。





# 键相关

## wireframe 

- `wireframe ON/OFF`：打开或关闭，默认是`ON`。
- `wireframe ONLY`：关闭其他的渲染，包括标签。
- `wireframe [radius-in-angstroms]`：以Å为单位显示给定圆柱体直径的线框，要用小数。负数`=ONLY`。

## bondorder

- `bondorder number`：数字可以是`0.5`，`1`，`1.5`，`2`，`2.5`，`3`，`4`， `-1`，`-1.5`，`-2.5`（负数依次是氢键、PARTIALDOUBLE (reverse solid/dash of AROMATIC)，PARTIALTRIPLE2）

## connect 

connect本身删除所有键，然后创建键基于 Jmol 默认键生成算法，全部为单键，不考虑模型文件中可能指示的键合模式。语法：

```
connect [minimum and maximum distances] [source and target atom sets] [bond type] [radius option] [color option] [modify/create option]
```

- `[minimum and maximum distances]`：距离以埃为单位，以小数或整数形式给出。如果仅给出一个距离参数，则表示最大距离。如果既没有给出最小距离参数也没有给出最大距离参数，那么两个原子集之间的所有连接都会被建立。可以在距离后使用 % 符号指定基于键合/离子半径百分比范围而不是固定值连接原子的选项。
- `[source and target atom sets]`：表示目标的原子集合。如果没有给出，就选择当前选定的原子。
- `[bond type] `：可以是`SINGLE`、`DOUBLE`、`TRIPLE`、`QUADRUPLE`、`QUINTUPLE`、`SEXTUPLE`、`AROMATIC`、`PARTIAL`、`PARTIALDOUBLE`、`HBOND`、`STRUT` 或 `UNSPECIFIED`。
  - 在外观上，`AROMATIC` 和 `PARTIALDOUBLE` 是相同的，只是键的哪一侧用虚线表示。
  - `PARTIAL` 和 `HBOND` 都是虚线，但它们的模式不同，新产生的氢键只是细线。
  - 其他键类型包括 `ATROPISOMER`（两个旋转受限的芳环之间的单键）、`AROMATICSINGLE`、`AROMATICDOUBLE`、部分数字键顺序（见`bondorder`）

- `partial`的语法：`connect ... partial N.M`，N代表几条线，M为：

| M    | binary | meaning                       |
| ---- | ------ | ----------------------------- |
| 1    | 00001  | first line dashed             |
| 2    | 00010  | second line dashed            |
| 3    | 00011  | first and second lines dashed |
| 4    | 00100  | third line dashed             |
| ...  | ...    | ...                           |
| 31   | 11111  | all lines dashed              |

例子：

```
partial 1.0	#single
partial 1.1	#same as "partial"
partial 2.0	#double
partial 2.1	#same appearance as "aromatic", though not "aromatic"
partial 2.2	#partialDouble
partial 3.0	#triple
partial 3.1	#partialTriple
partial 3.4	#parialTriple2
```

- `[radius option]`：在`radius`后跟以Å为单位的数字设定宽度。
- `[color option]`：在`color`后跟`translucent`或`opaque`设定透明度、颜色等。
- `[modify/create option]`：
  - `Create`：只会创建新的键，如果已经存在不会受到影响。
  - `Modify`：修改已经存在的键，不会创造新的键。
  - `ModifyOrCreate`：符合则会连接。
  - `Delete`：删除符合的连接。

# measure

## 设置标签和线等

- `set measurementUnits (distance unit)`：设置测量单位，(distance unit)可以是`ANGSTROMS`、`AU`（或 `BOHR`）、`NM`（或 `NANOMETERS`）、（`PM` 或 `PICOMETERS`）、`VDW`、`HZ` 和 `NOE_HZ` 之一。

  ```
  set measurements angstroms
  set measurements nm
  set measurements pm
  ```

- `set measurementLabels ON`：设置为`FALSE`时仅关闭测量标签，保留线条。

- `set showMeasurements TRUE`：设置为`FALSE`时，测量线和标签都关闭。

- `set measurements DOTTED`：设置测量线为虚线。

- `set justifyMeasurements FALSE`：将此参数设为 `TRUE` 可右对齐测量标签

- `set measurements 数字`：数字带小数时，是以Å为单位；整数时是以像素为单位。

- ` set defaultDistanceLabel "format"`、` set defaultAngleLabel "format"`、`set defaultTorsionLabel "format"`：分别设置标签的默认格式

- 设置[字体](#font)

`measure`的语法：

```
measure RANGE <minValue> <maxValue> ALL|ALLCONNECTED|DELETE (<atom expression>) (<atom expression>) ...
```

- `measure ON/OFF`：打开和关闭距离、角度、二面角测量标签和测量线。

- `measure DELETE`：删除所有测量

- `measure "n:labelFormat"`：测量对象及其单位

  - `n:`为2、3、或4，代表键长、键角、二面角。
  - `n:`和`labelFormat`之间可以放`[atom properties]`原子属性来表示

  - `label format`默认为`"%VALUE %UNITS"`，`%VALUE`可以表示小数位数；`//unit`，代表测量单位等。` //A`就是Å，还有`//nm`，`//pm`等
  - 

例子：

```
measure RANGE 1.5 2.5 ALL (_C) (_U) "2://pm"
```

```
 measure 1.4 1.5 all (_C)[65][72]  (_C)[65][72]  "2:%a1-%a2 %0.3VALUE //A"
```



# mo

可以将fchk文件通过Multiwfn转化成molden文件再进行绘图

```
100
2
6
```



- `mo ON/OFF`：开启或关闭分子轨道，默认是`ON`
- `mo (integer)`：显示指定的分子轨道，序号从1开始。
  - 注意：Jmol中的轨道是按能量排序的，因此可能和一些fchk文件中的轨道不一致，比如NLMO。可以通过将原始的轨道能量作为标签，保留三位小数，通过`MO list`去查找相应的序号。
- ` mo COLOR [RGB-color] [RGB-color]`：第一个颜色为等值面负的颜色，第二个为正等值面的颜色
  - `mo COLOR [RGB-color]`：将等值面设置成某个颜色
- `mo CUTOFF (decimal)`：设置等值面的值。默认是0.05。
- `mo RESOLUTION (decimal)`：等值面的精度，一般范围是4-10。分辨率越高，等值面越光滑，但是生成速度更慢。

## 显示效果

- `mo mesh nofill`：除了网格，并且填充。默认是` mo mesh nofill`
- `mo fill nomesh`：可以去掉网格线
- `mo translucent`：将等值面设置为透明的，后面可以跟0-1的小数设置透明度。
- `mo nofill nomesh dots`：设置为点填充。
  - `mo fill nodots`：取消点填充。

- `mo fill`：
- `mo opaque`：

## 标题

默认生成的分子轨道左上角有标题，标题的格式可以通过` mo TITLEFORMAT "format"`控制

- `%E `或者`%0.dE`：能量，可以控制小数位数
- `%F`：文件名字
- `%I`：轨道序号
- `%M`：模型序号
- `%N`：轨道总数
- `%O`：占据数
- `%S`：对称性
- `%U`：能量单位
- ` |`：换行
- `?`：(在行开头)表示如果文件中没有该行的数据，则忽略该行

默认的格式是

```
mo TITLEFORMAT "%F | Model %M MO %I/%N | Energy = %E %U | ?Symmetry = %S | ?Occupancy = %O"
```

- 如果想关闭可以使用` mo TITLEFORMAT ""`

# set (lighting)   

- `set zShade OFF`：是否启用“雾”或“淡入淡出”效果。根据与观察者的距离对对象进行着色，使远处的对象淡入背景中。
  - 使用 `SLAB` 和 `DEPTH` 设置的值分别确定无效果点和完全效果点（默认为 100 和 0）。当 `ZSLAB` 不等于 `ZDEPTH` 时（默认均为0），`SLAB` 和 `DEPTH` 的设置被 `ZSLAB` 和 `ZDEPTH` 覆盖。
  - `set zDepth (integer)`和`set zSlab (integer)`：`zDepth`是完全透明的点，`zSlab`是完全不透明的店。
  - ` set zShadePower (integer)`：当zShade设置为 `ON`时，可以调整此参数（通常为 `1`、`2` 或 `3`）以创建更强的雾效果。如果将此值设置为 `0`，会显示黑白阴影遮罩。

# set (perspective) 透视

- `set cameraDepth (positive number)`：设置透视量。默认设置为 `3.0`。数字越大，透视的影响就越小。
- ` set perspectiveDepth ON`：关闭此参数将关闭透视深度。

缩放相关：

- ` set zoomEnabled TRUE`：当设置为 `FALSE` 时，禁用缩放。
- `set zoomHeight FALSE`：当此设置为 `TRUE` 时，Jmol 仅在更改高度时调整缩放。设置 zoomHeight TRUE 会禁用zoomLarge。
- `set zoomLarge TRUE`：当为 `TRUE`时，Jmol 根据窗口大小调整缩放。

# write

- 保存为png格式，语法为：

  ```
  write IMAGE width height PNG n "fileName"
  ```

  - `width` 和 `height` 是可选的，默认为当前帧大小。
  - 压缩量`n` 是一个介于 0 和 10 之间的数字（默认为 2）。
  - 如果 `set imageState TRUE`（默认设置），则 Jmol 将其状态附加到 PNG 文件，从而允许使用单个图像文件作为 2D 图像查看和使用脚本命令或通过拖动以 3D Jmol 状态读取并加入 Jmol 应用程序。

- 保存为png格式，背景是透明的，语法为：

  ```
  write IMAGE width height PNGT n "fileName"
  ```

  - 最好使用不太寻常的颜色作为背景颜色，比如`[x101010]`，确保只有背景是透明的。
  - 最好设置`set antialiasImages FALSE`，以避免图像周围出现参差不齐的边缘。
  - `width` 和 `height` 是可选的，默认为当前帧大小。
  - 压缩量`n` 是一个介于 0 和 10 之间的数字（默认为 2）。
  - 例子：`WRITE PNGT xxxx.png`

- 保存为pov进一步渲染

  ```
  write POVRAY D:/desktop/mo/10-.pov
  ```

  - 生成的ini文件可以直接一起拖入到pov-ray中批量渲染





# [atom-expression]原子表达

相关的表达都可以用关键字`NOT`开头，由`and`、`OR`或`XOR`连接，由`{}`包围。还可以用比较符号 `<`，`<=`，`=`，`>`，`>=`，`!=`和`LIKE` 等关键词，`!=`和`=`不区分大小写，如果需要，用`LIKE`。

## 一般表达

- `all`：所有原子，=`*`
- `bonded`：共价键合的
- `connected`：以任何方式成键，包括氢键
- `none`：无原子
- `selected`：已选定的原子，当文件首次加载是，默认为`all`

## 化学元素

- 元素的英文名，如`carbon`
- `_元素符号`：如` _Cu`；还可以在符号前面加上数字表示同位素，`_31P`
- `nonmetal`：非金属元素=`!metal`，即H，He，B，C，N，O，F，Ne，Si，P，S，Cl，Ar，As，Se，Br，Kr，Te，I，Xe，At，Rn
- `metal`：金属元素，=`!nonmetal`
- `alkaliMetal`：碱金属，Li，Na，K，Rb，Sr，Fr
- `alkalineEarth`：碱土金属，Be，Mg，Ca，Sr，Ba，Ra
- `nobleGas`：稀有气体，He，Ne，Ar，Kr，Xe，Rn
- `metalloid`：准金属，B，Si，Ge，As，Sb，Te
- `transitionmetal`：过渡金属，包括La和Ac。
- `lanthanide`：镧系元素，不包括La
- `actinide`：锕系元素，不包括Ac

## 其他

- `isaromatic`：与芳香族、芳香族单键或芳香族双键类型相连的原子

## 选择原子

- `(carbon)[3][5]`：选择第三到第五个碳原子
- `(carbon)[3]`：选择第三个C原子，[0]表示最后一个原子，负数表示从最后一个原子（0）开始基数。

如果需要嵌入到其他表达式中，还需要在外面加`{}`，比如`measure {(_O)[1]} {(_O)[2]}`

```
#z
select ({4 7 8 12:16 25:29 32 35:40 43:84})
```



# [atom properties]原子属性

https://chemapps.stolaf.edu/jmol/docs/index.htm?ver=14.31#atomproperties

| **property** | **select xxx=y** | **label %[xxx]** | **label %x** | **print {\*}.xxx** | **{\*}.xxx = y** |    **description**     |
| :----------: | :--------------: | :--------------: | :----------: | :----------------: | :--------------: | :--------------------: |
|   atomName   |        √         |        √         |      %a      |         √          |        √         |       原子的名字       |
|    atomno    |        √         |        √         |      %i      |         √          |        √         | 可以用`@`替代`atomno=` |
|   atomType   |        √         |        √         |      %B      |         √          |        √         |        原子类型        |











# getProperty

查看分子的长宽高

显示中勾选边界框，在控制台中输入

```
 getProperty boundBoxInfo
```

设置边界框的坐标

```
 boundbox {0 0 0}{2,3,3}
```
