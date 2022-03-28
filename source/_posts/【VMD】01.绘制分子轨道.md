---
title: 【VMD】01.绘制分子轨道
typora-root-url: 【VMD】01.绘制分子轨道
mathjax: true
date: 2020-09-29 10:46:39
updated:
tags: [VMD, 绘图, 分子轨道]
categories: [计算化学, 软件]
description: 通过VMD绘制轨道的基本操作
---



# 单个cube文件

1. 直接将*.cub文件拖入main窗口

2. 将分子改为球棍模型：Graphics→Representation→Drawing method→CPK

3. 新建一个等值面：Graphics→Representation→Create Rep

   1. 修改Drawing method为Isosurface
   2. 修改Isovalue为0.05
   3. 修改等值面风格：在Draw中选择Solid Surface（实心）或者Wireframe（网格显示）
   4. 取消显示边框：修改Show为Isosurface
   5. 修改颜色：在Coloring Method选择colorID，在其后选择颜色，如1（红色）
   6. 修改材质：在Material中选择，比如Glossy

4. 重复步骤3，除了：

   1. 将Isovalue为负的
   2. 颜色修改为另一个颜色，比如0（蓝色）

5. 其他美化：

   1. display→depth cueing→off
   2. display→Rendermode→GLSL
   3. 修改背景为白色：Graphics→Color→Display→Background→White
   4. 取消显示坐标轴：Display→Axes→off
   5. ……

6. 导出：File→Render→Tachyon，修改Filename，Start Rendering即可，此时VMD目录下有相应的\*.dat（是Tachyon的输入文件）和\*.bmp文件（在默认设置下渲染出来的图像文件）。

   - 还可以通过Flie→Save Visualization state...保存当前的操作

7. 进一步渲染，6中是使用的默认方法，可以调用VMD自带的tachyon_WIN32.exe渲染器进一步在当前目录下使用\*dat文件渲染出\*.bmp图像文件，在命令行中输入：

   ```
   tachyon_WIN32.exe XXXX.dat -format BMP -o XXXX.bmp -trans_raster3d -res 2000 1500 -fullshade -numthreads 4 -aasamples 24 -shadow_filter_off
   ```


# 批量处理多个轨道文件

## 1. 生成cube文件

### 打开Multiwfn生成

1. Multiwfn载入*fchk文件后，通过以下命令一步步生成。然后就会在Multiwfn文件夹下生成orb0000XX.cub的文件。

   ```
   200 #其他功能
   3 #保存轨道
   1-4，47-50 #绘制轨道的范围
   3 #选择格点质量
   1 #单独保存每一个
   ```

   - 如果是空轨道，Multiwfn计算格点数据的默认的延展距离不够大，可能造成以比较小的轨道等值面数值显示时轨道等值面被截断，可以在第三行和第四行之间加入以下步骤将延展距离加大到12Bohr：

     ```
     -10
     12
     ```

   - 以上内容可以保存为一个文本文件放在Multiwfn文件夹下用于后续的批处理，如showorb.txt（Multiwfn文件夹中的examples\scripts也有）

2. 再将*.cub文件移动到VMD根文件夹下

### 不打开Multiwfn生成

1. 通过Windows批处理命令，在Multiwfn文件夹下新建showorb.bat文件（Multiwfn文件夹中的examples\scripts也有）：

   ```
   Multiwfn .\XXXXXXXX.fchk < showorb.txt
   move /Y *.cub "XXXX\VMD\"
   ```

   - 修改*.fchk文件的路径和名字
   - 修改VMD的路径，如果路径中有空格，必须加双引号。

2. 直接双击showorb.bat，这个脚本就会调用Multiwfn去对指定的输入文件计算要考察的各个轨道的格点数据，并且导出为cube文件，所有算出来的cube文件会被这个脚本自动挪到VMD目录下。

## 2. 绘制部分

- 把Multiwfn文件包的examples\scripts目录下的VMD绘图脚本**showorb.vmd**拷到VMD目录下，然后用文本编辑器编辑VMD目录下的**vmd.rc**，在最后插入此命令：

  ```
  source showorb.vmd
  ```

  - 它定义了三个命令：
    - `orb`：用来载入和显示轨道。输入orb 33，就会载入VMD目录下的orb000033.cub，并把它的绘制方式修改为等值面图的形式。之后如果比如再输入orb 34，则33号轨道就会被撤销，而将orb00034.cub以等值面形式显示。
    - `orbiso`：用来修改等值面数值，默认为0.05。
    - `orbclean`：用来把VMD目录下所有orb开头的.cub文件全都删掉。

- 启动VMD，在命令行窗口输入就可以显示相应的文件。

  ```
   orb [序号] 
  ```

- 看完轨道后，输入`orbclean`可以把VMD目录下的cub文件都清掉。

### showorb.vmd

#### `orb`命令

```
proc orb {iorb} {
#修改轨道等值面数值默认值，推荐0.02~0.06
set isoval 0.05

#修改等值面材质，如果想改成透明的，可以使用EdgyGlass或Translucent等
set mater Glossy

#开启额外的3号光源令图像更亮
#light 3 on

color Display Background white
display depthcue off

#设置某个元素的颜色
color Name C tan
#修改tan颜色的定义。这最终使得碳原子比其默认的深青色显得更柔美
#color change rgb tan 0.700000 0.560000 0.360000

display projection Orthographic
display rendermode GLSL
axes location Off

if {[molinfo num]>0} {
set viewpoint [molinfo top get {center_matrix rotate_matrix scale_matrix}]
}
mol delete top

#修改cub文件的命名格式
#mol new AdNDPorb[format %04d $iorb].cub
mol new orb[format %06d $iorb].cub

mol modstyle 0 top CPK 0.800000 0.300000 22.000000 22.000000
mol addrep top
mol modstyle 1 top Isosurface $isoval 0 0 0 1 1

#修改正等值面颜色淡绿色
#mol modcolor 1 top ColorID 12
mol modcolor 1 top ColorID 1

mol modmaterial 1 top $mater
mol addrep top
mol modstyle 2 top Isosurface -$isoval 0 0 0 1 1

#修改负值部分等值面的颜色为淡蓝色
#mol modcolor 2 top ColorID 22
mol modcolor 2 top ColorID 0

mol modmaterial 2 top $mater
if [info exists viewpoint] {
molinfo top set {center_matrix rotate_matrix scale_matrix} $viewpoint
}

#保存当前状态的渲染文件
#render Tachyon $iorb.dat "tachyon_WIN32.exe ${iorb}.dat -format BMP -o ${iorb}.bmp -trans_raster3d -res 2000 1500 -numthreads 4 -aasamples 24 -mediumshade "
render Tachyon $iorb.dat "tachyon_WIN32.exe ${iorb}.dat -format BMP -o ${iorb}.bmp  -aasamples 12"
}
```

其他美化：

- material change mirror Opaque 0.15：修改不透明材质（用于显示分子结构）的mirror属性，大于0的时候通过考虑光线追踪的渲染器渲染的时候就会有反光效果
- material change outline Opaque 4.000000：设定不透明材质的轮廓深度
- material change outlinewidth Opaque 0.5：设定不透明材质的轮廓粗度。设置轮廓可以使原子有勾边效果（有效避免白色的氢原子在某些地方和白色背景连为一体）
- material change ambient Glossy 0.1：设置用于显示等值面的Glossy材质的ambient属性
- material change diffuse Glossy 0.600000
- material change opacity Glossy 0.75：把Glossy材质改为微透明
- material change shininess Glossy 1.0
- display distance -7.0：让视角距离画面的更远，可避免在窗口边缘的物体由于近大远小而畸变太厉害
- display height 10：这句是避免因为减小了distance而导致图像变小
- ……

#### `orbiso`命令

```
proc orbiso {isoval} {
mol modstyle 1 top Isosurface $isoval 0 0 0 1 1
mol modstyle 2 top Isosurface -$isoval 0 0 0 1 1
}
```

#### `orbclean`命令

```
proc orbclean {} {
#修改cub文件的命名格式
#file delete {*}[glob AdNDPorb*.cub]
file delete {*}[glob orb*.cub]
}
```



# 使用脚本任意cube文件

把Multiwfn文件包的examples\scripts目录下的VMD绘图脚本showorb.vmd拷到VMD目录下，然后用文本编辑器编辑VMD目录下的vmd.rc，在最后插入此命令：

```
source showcub.vmd
```

此脚本定义了四条命令，可以直接在VMD的控制台里输入，这里直接给出一些例子：

- `cub MIO`：将VMD目录下的MIO.cub绘制成等值面图，正值和负值部分分别用绿色和蓝色显示，等值面数值分别为默认值0.05和-0.05
- `cub MIO 0.02`：同上，但正值和负值部分等值面数值直接分别设为0.02和-0.02
- `cubiso 0.015`：在使用cub命令后使用，把当前载入的格点数据的正值和负值部分分别设为0.015和-0.015

有的时候我们需要同时将两个cube文件显示在一起，此脚本里也定义了相应命令用于此目的，示例：

- `cub2 eri nozomi`：将VMD目录下的eri.cub和nozomi.cub同时绘制成等值面，分别用绿色和蓝色表示，等值面数值都为默认的0.05（注：如果eri和nozomi格点数据里也有负值部分，负值部分不会被显示出来）
- `cub2 eri nozomi 0.02`：同上，但是二者的等值面数值都直接设为0.02
- `cub2iso 0.015`：在使用cub2命令后使用，代表把已载入的两套cube文件对应的等值面数值都设为0.015

用Multiwfn的主功能5计算完这个体系的自旋密度格点数据后，在后处理菜单选择导出cube文件，当前目录下就得到了spindensity.cub。将此文件挪到VMD目录下，启动VMD，直接输入cub spindensity 0.01
