---
title: 【Pymol】常见指令
typora-root-url: 【Pymol】常见指令
mathjax: true
date: 2026-08-20 11:22:07
updated:
tags: [Pyscf,输入]
categories: [计算化学, 软件]
description: 记录Pymol的一些使用过程
---


# 安装

pymol有两个版本，[官网](https://pymol.org/)：

- 官方商业版
- 开源版

安装方法wiki上有：[Windows Install - PyMOL Wiki](https://pymolwiki.org/Windows_Install)

- 直接使用一键安装（只试了这种方法）
- 



# 软件界面

参考：[PyMOL：安装及入门笔记](https://pengpengyang94.github.io/2020/08/pymol安装及入门笔记/)

![pymol-1-1.png](/hHvMG3aV5nJks1r-17871970420692.png)

- ① 菜单栏
- 红框部分为 **External GUI**，可以点击 `Display` - `External GUI` - `Toggle Floating` 或使用快捷键 `Ctrl + E` 将该部分与初始界面分离或合并。
  - ② 操作记录窗口
  - ③ 常用命令窗口
  - ④ 命令输入窗口
- ⑤ 可视化窗口
- ⑥ 对象窗口，显示编辑的文件，类似于图层的概念。
- ⑦ 模式窗口，主要控制鼠标的控制模式

## ① 菜单栏

### File

- Get PDB：直接通过PDB序列号载入文件，只需在红框中填入 四字母的 **PDB ID**（如 **4hbk**），点击下方的 **Download** 即可。

  ![pymol-1-2.png](/UNT3iOZIrnuHVWy.png)

### Display

- Background：设置背景颜色
- 

## ⑥ 对象窗口

![pymol-1-3.png](/6zitKXBQgsFdvHr.png)

-  `all` 代表的是其中包含的所有项目
- `4hbk` 是载入的蛋白
- `（sele）`是鼠标目前选中的氨基酸

每个项目中后面均有A、S、H、L 和 C 五个选项，意义如下：

- A: Action，包含放大、剧中，复制，显示及比对等一系列的操作。
- S: Show，设置不同的显示方式。
  -  `as`：改变外观为 xxx
  - 其他选项：在原有的基础上，添加XXX这一层外观
- H: Hide，隐藏显示的方式，与 S 基本对应。
- L: Label，设置不同的标记方式。
- C: Color，设置不同的着色方式。

### A: Action

![pymol-1-4.png](/EBNCqgaej2DVO4F.png)



- **preset** 可以便捷的修改显示方式，主要有以下几种显示方式：

  - simple：简单形式

  - ball and stick：球棍模型

  - b-factor putty：基于 b-factor 数值显示蛋白的柔性
  -  ligand sites：查看小分子和蛋白的氢键作用

  - pretty：美观的 cartoon 样式

  - publication：高质量出版标准

- generate：显示蛋白的静电势图

  - vacuum_electrostatics - protein contact potentia

---

- rename object：重命名
- Copy to object：复制
- delete object：删除

---

- Hydrogens：氢原子的相关操作
  - `add`：增加所有氢原子
  - `add polar`：增加极性氢原子
  - `remove`：删除所有氢原子
  - `remove non polar`：删除所有非极性氢原子
- remove waters：删除水分子

---

### L: Label

![image-20260820120801107](/image-20260820120801107.png)

择好需要 **Lable** 的对象后，可以对其进行如下不同方式的标记。

- `L` - `clear`：删除该对象上所有的 **Label**
- `L` - `residue`：在 α 碳原子上标记其氨基酸残基**三**字母名字和编号
- `L` - `residue（oneletter）`：标记其氨基酸残基**一**字母名字和编号



- `L` - `element symbol`：显示对象上所有原子的元素名字
- `L` - `one letter code`：标记其氨基酸残基**一**字母名字
- 
- `L` - `vdw radius`：显示原子的范德华半径
- 

### C: Color

- `C` - `by element`：按原子类型着色
- `C` - `by chain`：按链着色
- `C` - `by ss`：按二级结构着色
- `C` - `reds`：整体标红



## ⑦ 模式窗口

- 点击**模式窗口**中的 **S**可以显示显示结构序列（或`Display` - `Sequence` ）

![pymol-1-7.png](/vyENThLGwrKk4Rn.png)





## 切换工作路径及载入文件

- 不同项目使用不同的工作路径：

  -  `File` - `Working Directory` - `Change...` 来切换路径，也可以输入指令进行切换

    ```
    # 切换至 C:\Users\DELL\Desktop\pymol\pdb 
    cd C:\Users\DELL\Desktop\pymol\pdb
    # 查看当前工作路径
    pwd
    ```

- 载入文件有三种方式：

  - 点击 `File` - `Open...` 加载文件

  - 拖拽文件至可视化窗口

  - 使用 `load`指令

    ```
    # 加载 protein.pdb 
    load protein.pdb
    ```

    







# 常见指令

[Category:Commands - PyMOL Wiki](https://pymolwiki.org/Category:Commands)





## [align](https://pymolwiki.org/Align)

先进行序列比对，随后进行结构叠加， 对序列相似度（同一性>30%）的蛋白质表现不错。 对于序列同一性较低的蛋白质，[super](https://pymolwiki.org/Super)和[cealign](https://pymolwiki.org/Cealign)命令表现更好。

对齐两个相似蛋白质结构：

```
align mobile, target 
```



## [Alter](https://pymolwiki.org/Alter)/[Iterate](https://pymolwiki.org/Iterate)

**`alter`** 命令等效于 **`iterate`** 命令，但它提供了对公开变量的读写访问权限。如果更改的标识符会影响原子排序，则需要调用 [`sort`](https://pymolwiki.org/Sort) 命令根据新的标识符重新排序。



## [Count_Atoms](https://pymolwiki.org/Count_Atoms)

**count_atoms** 返回所选区域中原子的数量。

```
count_atoms (selection)
```



## [Create](https://pymolwiki.org/Create)

可以根据选定的对象创建一个新的分子对象。它也可以用于在现有对象中创建状态。

```
create name, (selection) 
```





## [extract](https://pymolwiki.org/Extract)

`extract` 命令的作用是把选中的原子从原对象中“剪切”出来，并生成一个新对象

```
extract name, selection [, source_state [, target_state ]]
```





## h_add

```
alter sele, formal_charge=1
h_add sele
```



## [matrix_copy](https://pymolwiki.org/Matrix_Copy)

Matrix_copy 将对象矩阵从一个对象复制到另一个对象。该命令通常在蛋白质结构比对之后使用，目的是将其他相关对象置于同一参考系中。

```
matrix_copy source_name, target_name
```





## [Select](https://pymolwiki.org/Select)

**`select` 函数**会根据原子选择创建一个命名选择。

```
select name [, selection [, enable [, quiet [, merge [, state ]]]]]
```

创建名为“sele”的选区的便捷快捷方式：

```
select (selection)
```

PyMOL 最基本的选择逻辑是：`属性 值`，`resn POPC`residue name 是 POPC 的所有原子。`resi 7`residue ID 是 7 的所有原子。组合条件用`and`。`resn POPC and resi 7`residue name = POPC，并且 residue ID = 7。



## [Show](https://pymolwiki.org/Show)

```
show
show reprentation [,object]
show reprentation [,(selection)]
show (selection)
```

例子：

```
# 用线条表示主干结构
show lines,(name ca or name c or name n)


# 显示所有对象的带状表示
show ribbon

# 将所有hetero atoms显示为球体
show spheres, het

# 仅显示极性氢
hide everything, ele h
show lines, ele h and neighbor (ele n+o)
# 显示行、ele h 和邻居 (ele n+o)
hide (h. and (e. c extend 1))

#上述代码隐藏了所有非极性氢的表示形式，包括表面表示形式，导致表面表示形式损坏。或许更好的做法是直接移除非极性氢
hide everything, ele h
show lines, ele h and neighbor (ele n+o)
remove (h. and (e. c extend 1))
```



- 找出距离 bad_popc 中任意原子 4 Å 以内的蛋白原子。

  ```
  polymer.protein within 4 of bad_popc
  ```

- 找到 4 Å 内的蛋白原子以后，把这些原子所属的整个 residue 都选进来。这对于观察蛋白—配体相互作用特别有用。

  ```
  byres (polymer.protein within 4 of bad_popc)
  ```

  

















## [zoom](https://pymolwiki.org/Zoom)

**缩放**操作会调整窗口和原点的大小，使其覆盖所选原子。

```
zoom [ selection [,buffer [, state [, complete ]]]]
```

例子：

```
# 根据PyMOL中加载的内容自动缩放
zoom

#
zoom complete=1

# 仅对链A进行缩放
zoom (chain A)

# 在残基142上缩放
zoom 142/

# 中心处对每个对象均匀缩放20埃
center prot1
zoom center, 20
```

通常情况下，缩放命令会尝试猜测一个最佳的可视化缩放级别，在保证清晰显示的同时，避免原子偶尔被裁剪出视野。您可以通过将“complete ”选项设置为 1 来更改此行为，这将确保整个选区的原子位置都能完整地显示在正交视图的视野中。为了完全防止裁剪，您可能还需要添加一个缓冲区（通常为 2 Å），以补偿透视变换以及超出原子坐标范围的图形表示。

```
complete = 0 or 1
```

