---
title: 【Pyscf】01.基本计算设置
typora-root-url: 【Pyscf】01.基本计算设置
mathjax: true
date: 2021-09-02 10:46:39
updated:
tags: [Pyscf,输入]
categories: [计算化学, 软件]
description: Pyscf的基本输入
---





# 定义分子

有三种方法可以定义和初始化一个分子，

1. 使用方法的关键字参数`Mole.build()`来初始化一个分子：

  ```python
  from pyscf import gto
  mol = gto.Mole()
  mol.build(
  	atom = '''O 0 0 0; H  0 1 0; H 0 0 1''',
  	basis = 'sto-3g')
  ```

2. 将几何、基础等分配给Mole 对象，然后调用该`build()`方法：

  ```python
  from pyscf import gto
  mol = gto.Mole()
  mol.atom = '''O 0 0 0; H  0 1 0; H 0 0 1'''
  mol.basis = 'sto-3g'
  mol.build()
  ```

3. 使用快捷功能`pyscf.M()`或`Mole.M()`。这些函数将所有参数传递给`build()`方法：

  ```python
  import pyscf
  mol = pyscf.M(
      atom = '''O 0 0 0; H  0 1 0; H 0 0 1''',
      basis = 'sto-3g')
  ```

  ```python
  from pyscf import gto
  mol = gto.M(
      atom = '''O 0 0 0; H  0 1 0; H 0 0 1''',
      basis = 'sto-3g')
  ```

## 几何

### 笛卡尔形式

默认单位为埃（可以通过将属性设置`unit` 为`'Angstrom'`或`Bohr`来指定单位）：

```
mol = gto.Mole()
mol.atom = '''
    O   0. 0. 0.
    H   0. 1. 0.
    H   0. 0. 1.
'''
mol.unit = 'B' # 不区分大小写，任何不以'B'或'AU'开头的字符串都被视为'Angstrom'
```

- 分子中的原子由一个元素符号加上三个坐标数字表示。不同的原子应该由`;`或 换行符分隔 。在同一个原子中，`,`可以用来分隔不同的项目。空行或以 开头的`#`行将被忽略：

  ```
  mol = pyscf.M(
  atom = '''
  #O 0 0 0
  H 0 1 0
  
  H 0 0 1
  ''')
  mol.natm  #分子的原子个数，会输出2
  ```

- 几何字符串不区分大小写。它还支持输入元素的核电荷：

  ```
  mol = gto.Mole()
  mol.atom = '''8 0. 0. 0.; h 0. 1. 0; H 0. 0. 1.'''
  ```

- 如果需要标记一个原子以将其与其他原子区分开，可以在原子符号前加上数字`1234567890`或特殊字符`~!@#$%^&*()_+.?:<>[]{}|`（非 `,`和`;`）作为前缀或后缀 。通过这种修饰，可以在不同的原子上指定不同的基组、质量或核模型：

  ```
  mol = gto.Mole()
  mol.atom = '''8 0 0 0; h:1 0 1 0; H@2 0 0 1'''
  mol.unit = 'B'
  mol.basis = {'O': 'sto-3g', 'H': 'cc-pvdz', 'H@2': '6-31G'}
  mol.build()
  print(mol._atom)
  #输出结果为：[['O', [0.0, 0.0, 0.0]], ['H:1', [0.0, 1.0, 0.0]], ['H@2', [0.0, 0.0, 1.0]]]
  ```

- 还可以指定 xyz 文件的路径，PySCF 将使用该文件中的坐标来构建`Mole.atom`.

  ```
  mol = gto.M(atom="my_molecule.xyz")
  ```

  ```
  mol = gto.Mole()
  mol.atom = "my_molecule.xyz"
  mol.build()
  ```

- 可以输入以下内部格式的几何图形 `Mole.atom`：

  ```
  atom = [[atom1, (x, y, z)],
          [atom2, (x, y, z)],
          ...
          [atomN, (x, y, z)]]
  ```

  这样可以使用 Python 脚本来构造几何：

  ```
  mol = gto.Mole()
  mol.atom = [['O',(0, 0, 0)], ['H',(0, 1, 0)], ['H',(0, 0, 1)]]
  mol.atom.extend([['H', (i, i, i)] for i in range(1,5)])
  mol.build()
  print(mol._atom)
  #注意输出的结果单位是Bohr的。
  ```

- [ghost分子](https://github.com/pyscf/pyscf/blob/master/examples/gto/03-ghost_atom.py) 

### Z-matrix 输入格式

```
mol = gto.Mole()
mol.atom = '''
    O
    H  1  1.2
    H  1  1.2  2 105
'''
```

### 打印分子

建立好分子后，会存储为属性`Mole._atom`。

- 一旦`Mole`构建了对象，就可以通过该`Mole.atom_coords()`函数访问分子几何结构。此函数为每个原子的坐标返回一个 (N,3) 数组：

  ```
  print(mol.atom_coords(unit='Bohr')) # unit can be "ANG" or "Bohr"
  #默认单位是Bohr
  ```

## 基组

- 定义基组的最简单方法是将基的名称作为字符串分配给`Mole.basis`：

  ```
  mol.basis = 'sto-3g'
  ```

  此输入将指定的基组应用于所有原子。字符串中基组的名称不区分大小写。名称中的空格、破折号和下划线都将被忽略。

- 如果不同元素需要不同的基组：

  ```
  mol.basis = {'O': 'sto-3g', 'H': '6-31g'}
  ```

- 还可以使用辅助函数输入自定义基组。该函数`gto.basis.parse()`可以解析 NWChem 格式的基础字符串 

  ```
  mol.basis = {'O': gto.basis.parse('''
  C    S
       71.6168370              0.15432897
       13.0450960              0.53532814
        3.5305122              0.44463454
  C    SP
        2.9412494             -0.09996723             0.15591627
        0.6834831              0.39951283             0.60768372
        0.2222899              0.70011547             0.39195739
  ''')}
  ```

  函数`gto.basis.load()`可以从数据库加载任意基组，即使基组与元素不匹配：

  ```
  mol.basis = {'H': gto.basis.load('sto3g', 'C')}
  ```

- GHOST原子：

  ```
  mol.basis = {'GHOST': gto.basis.load('cc-pvdz', 'O'), 'H': 'sto3g'}
  ```

- 与几何输入的要求一样，可以使用原子符号（不区分大小写）或原子核电荷作为`basis`字典的关键字 。数字和特殊字符的前缀和后缀是允许的。如果修饰的原子符号出现在 `atom`但不在 中`basis`，基础解析器将删除所有修饰并在`basis`字典中寻找纯原子符号 ：

  ```
  mol.atom = '8 0 0 0; h1 0 1 0; H2 0 0 1' mol.basis = {'O'：'sto-3g'，'H'：'sto3g'，'H1'：'6-31G'}
  
  #6-31G基组将分配给 atom H1，但STO-3G基将用于 atom H2
  ```

### ECP

- 可以使用属性指定有效核心电位 (ECP) `Mole.ecp`。标量型 ECP 可用于所有分子和晶体方法。[内置标量 ECP 数](https://pyscf.org/user/gto.html#ecp)：

  ```
  mol = gto.M(atom='''
   Na 0. 0. 0.
   H  0.  0.  1.''',
              basis={'Na':'lanl2dz', 'H':'sto3g'},
              ecp = {'Na':'lanl2dz'})
  ```

- ECP 参数可以使用 NWChem 格式直接在输入脚本中指定

  ```
  mol = gto.M(atom='''
   Na 0. 0. 0.
   H  0.  0.  1.''',
              basis={'Na':'lanl2dz', 'H':'sto3g'},
              ecp = {'Na': gto.basis.parse_ecp('''
  Na nelec 10
  Na ul
  0      2.0000000              6.0000000        
  1    175.5502590            -10.0000000        
  2      2.3365719             -6.0637782        
  2      0.7799867             -0.7299393        
  Na S
  0    243.3605846              3.0000000        
  1     41.5764759             36.2847626        
  2     13.2649167             72.9304880        
  2      0.9764209              6.0123861        
  Na P
  0   1257.2650682              5.0000000        
  1    189.6248810            117.4495683        
  2     54.5247759            423.3986704        
  2      0.9461106              7.1241813        
  ''')})
  ```

## 对称性

- 将属性设置为`Mole.symmetry`来为分子计算调用点群对称性`True`：

  ```
  mol = pyscf.M(
       atom = 'B 0 0 0; H 0 1 1; H 1 0 1; H 1 1 0',
       symmetry = True
  )
  ```

- 点群对称信息保存在`Mole`对象中。`symm`PySCF的对称模块 ( ) 可以检测任意点群。检测到的点组保存在 中`Mole.topgroup`，支持的子组保存在 中`Mole.groupname`：

  ```
  print(mol.topgroup)
  #C3v
  print(mol.groupname)
  #Cs
  ```

- PySCF 支持线性分子对称性 D<sub>∞h</sub>（`Dooh`在程序中标记）和C<sub>∞v</sub> （标记为`Coov`），D2h群及其子群。有时需要使用较低的对称性而不是检测到的对称性群。子群的对称性可以由`Mole.symmetry_subgroup`指定（不影响`Mole.symmetry`） ，程序将首先检测可能的最高对称群，然后将点群对称性降低到指定的子群：

  ```
  mol = gto.Mole()
  mol.atom = 'N 0 0 0; N 0 0 1'
  mol.symmetry = True
  mol.symmetry_subgroup = C2
  mol.build()
  print(mol.topgroup)
  #Dooh
  print(mol.groupname)
  #C2
  ```

- 当将特定的对称性分配给 时`Mole.symmetry`，初始化函数`Mole.build()`将测试分子几何形状是否符合所需的对称性。如果没有，初始化将停止并发出错误消息：

  ```
  mol = gto.Mole()
  mol.atom = 'O 0 0 0; C 0 0 1'
  mol.symmetry = 'Dooh'
  mol.build()
  
  #RuntimeWarning: Unable to identify input symmetry Dooh.
  #Try symmetry="Coov" with geometry (unit="Bohr")
  #('O', [0.0, 0.0, -0.809882624813598])
  #('C', [0.0, 0.0, 1.0798434997514639])
  ```

### 轨道

在`Mole`对象中启用对称时，点群对称信息将用于构建对称适应轨道基组

- 对称适应轨道被保存 `Mole.symm_orb`为二维阵列列表。列表中的每个元素都是不可约表示的 AO（原子轨道）到对称适应轨道转换矩阵。
- 不可约表示的名称存储在 中`Mole.irrep_name`，它们的内部 ID存储在`Mole.irrep_id`：

```python
mol = gto.Mole()
mol.atom = 'O 0 0 0; O 0 0 1.2'
mol.spin = 2
mol.symmetry = "D2h"
mol.build()
for s,i,c in zip(mol.irrep_name, mol.irrep_id, mol.symm_orb):
    print(s, i, c.shape)
    
# Ag 0 (10, 3)
# B2g 2 (10, 1)
# B3g 3 (10, 1)
# B1u 5 (10, 3)
# B2u 6 (10, 1)
# B3u 7 (10, 1)
```

对称适应轨道用作以下 SCF 或后 SCF 计算的基函数：

```python
mf = scf.RHF(mol)
mf.kernel()
# converged SCF energy = -147.631655286561
```

可以检查每个不可约表示中 MO 的占用情况：

- 为了标记给定轨道的不可约表示， `symm.label_orb_symm()`需要在`Mole`对象中初始化的点群对称性信息，包括不可约表示的 ID ( `Mole.irrep_id`) 和对称适应基`Mole.symm_orb`。对于每个`irrep_id`， `Mole.irrep_name`给出相关的不可表达符号 (A1, B1 …)。

```python
import numpy
from pyscf import symm
def myocc(mf):
    mol = mf.mol
    irrep_id = mol.irrep_id
    so = mol.symm_orb
    orbsym = symm.label_orb_symm(mol, irrep_id, so, mf.mo_coeff)
    doccsym = numpy.array(orbsym)[mf.mo_occ==2]
    soccsym = numpy.array(orbsym)[mf.mo_occ==1]
    for ir,irname in enumerate(mol.irrep_name):
        print('%s, double-occ = %d, single-occ = %d' %
              (irname, sum(doccsym==ir), sum(soccsym==ir)))
myocc(mf)

# Ag, double-occ = 3, single-occ = 0
# B2g, double-occ = 0, single-occ = 0
# B3g, double-occ = 0, single-occ = 1
# B1u, double-occ = 0, single-occ = 1
# B2u, double-occ = 0, single-occ = 0
# B3u, double-occ = 2, single-occ = 0
```

- 在 SCF 计算中，可以通过为不规则分配 alpha 电子和 beta 电子(alpha,beta)的数量来控制波函数的对称性 ：

```
mf.irrep_nelec = {'B2g': (1,1), 'B3g': (1,1), 'B2u': (1,0), 'B3u': (1,0)}
mf.kernel()
# converged SCF energy = -146.97333043702
mf.get_irrep_nelec()
# {'Ag': (3, 3), 'B2g': (1, 1), 'B3g': (1, 1), 'B1u': (2, 2), 'B2u': (1, 0), 'B3u': (1, 0)}
```



## 电荷和自旋

- 属性`Mole.charge`是定义系统中电子总数的参数。
  - 自定义系统中指定电子总数用`Mole.nelectron`：

- `Mole.spin`是未成对电子的数量*2S*，即 alpha 和 beta 电子的数量之差。

```
mol.charge = 1
mol.spin = 1
```

- 这两个属性不影响`Mole.build`初始化函数中的任何其他参数。可以在`Mole`对象初始化后设置或修改它们 ：

```
mol = gto.Mole()
mol.atom = 'O 0 0 0; h 0 1 0; h 0 0 1'
mol.basis = 'sto-6g'
mol.spin = 2
mol.build()
print(mol.nelec)
#(6, 4)
mol.spin = 0
print(mol.nelec)
#(5, 5)
```





# 其他参数

## 输出、内存和打印级别

- 使用`verbose`命令全局控制打印级别（打印级别可以是 0（安静，无输出）到 9（非常嘈杂）。最有用的消息在第 4 级（信息）和第 5 级（调试）打印。）：

  ```
  mol.verbose = 4
  ```

- 可以指定写入输出的位置（如果未分配此变量，消息将转储到 `sys.stdout`.）：

  ```
  mol.output = 'path/to/log.txt'
  ```

- 可以全局控制最大内存使用量：

  ```
  mol.max_memory = 1000 # MB
  ```
  - 默认大小也可以使用 shell 环境变量PYSCF_MAX_MEMORY定义。

- 属性`output`和`max_memory`也可以从命令行分配：

  ```
  python input.py -o /path/to/my_log.txt -m 1000
  ```

- 默认情况下，命令行具有最高优先级，这意味着脚本中的设置将被命令行参数覆盖。要使输入解析器忽略命令行参数，可以调用 `Mole.build()`with：

  ```
  mol.build(0, 0)
  ```

  第一个`0`防止`build()`转储输入文件。第二个`0`阻止`build()`解析命令行参数。



