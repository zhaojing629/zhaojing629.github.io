---
title: 【Pyscf】02.SCF
typora-root-url: 【Pyscf】02.SCF
mathjax: true
date: 2021-11-05 10:46:39
updated:
tags: [Pyscf,SCF]
categories: [计算化学, 软件]
description: Pyscf的基本输入
---



- 主要是[scf部分](https://pyscf.org/pyscf_api_docs/pyscf.scf.html)
- 自洽场 (SCF) 方法包括 Hartree-Fock (HF) 理论和 Kohn-Sham (KS) 密度泛函理论 (DFT)。

# 方法

HF 或 KS-DFT 波函数中使用的一般自旋轨道可以写为$$\psi_i(1) = \phi_{i\alpha}(r)\alpha + \phi_{i\beta}(r)\beta \;,$$

- 受限（RHF/RKS）
  - 自旋轨道是 alpha（自旋向上）或 beta（自旋向下）：$$\psi_i =\phi_i(r)\alpha$$或者$$\psi_i = \phi_i(r)\beta$$
  - alpha 和 beta 轨道共享相同的空间轨道$$\phi_i(r)$$
  - 闭壳行列式：$$\Phi=\mathcal{A}|\phi_1(r_1)\alpha \phi_1(r_2)\beta \ldots
    \phi_{N/2}(r_{N-1})\alpha \phi_{N/2}(r_N)\beta|$$
- 无限制 (UHF/UKS)：
  - 轨道可以有 alpha 或 beta 自旋，但 alpha 和 beta 轨道可能具有不同的空间分量
  - $$\Phi=\mathcal{A}|\phi_1(r_1)\sigma_1
    \phi_2(r_2)\sigma_2 \ldots \phi_{N}(r_N)\sigma_N|$$
- 受限开壳 (ROHF/ROKS):
  - $$N_\alpha > N_\beta$$，首先$N_\beta$个轨道$$\alpha$$ 和$$\beta$$具有相同的空间分量
  - $$N_\alpha - N_\beta$$是$$\alpha$$自旋
  - $$\Phi=\mathcal{A}|\phi_1
    \alpha \phi_1\beta \ldots \phi_{N_\beta} \alpha \phi_{N_\beta}\beta
    \phi_{N_\beta+1}\alpha \ldots \phi_{N}\alpha|$$
- 广义 (GHF/GKS)

调用方法：

```
mf = scf.RHF(mol).run()
mf = scf.UHF(mol).run()
mf = scf.ROHF(mol).run()
mf = scf.GHF(mol).run()
mf = scf.RKS(mol).run()
mf = scf.UKS(mol).run()
mf = scf.ROKS(mol).run()
mf = scf.GKS(mol).run()
```

# 调用

对象可以通过两种方式创建：

1. 通过pyscf创建

   ```python
   import pyscf
   
   mol = pyscf.M(
       atom = 'H 0 0 0; F 0 0 1.1',  # in Angstrom
       basis = 'ccpvdz',
       symmetry = True,
   )
   
   myhf = mol.HF()
   myhf.kernel()
   
   # Orbital energies, Mulliken population etc.
   myhf.analyze()
   ```

2. 通过gto和scf模块进行创建：

   ```python
   from pyscf import gto, scf
   mol = gto.M(
       atom = 'H 0 0 0; F 0 0 1.1',  # in Angstrom
       basis = 'ccpvdz',
       symmetry = True,
   )
   myhf = scf.HF(mol)
   myhf.kernel()
   ```

# HF

## 一般参数

- `verbose`：打印级别，默认等于`Mole.verbose`
- `max_memory`：内存，默认等于` Mole.max_memory`
- `chkfile`：保存分子轨道，轨道能量等的文件，如果设置为`None`或者`False`，则禁止写入chkfile。
- `conv_tol`：收敛限，默认为`1e-9`
- `conv_tol_grad`：梯度收敛阈值，默认为`conv_tol`的开方
- `max_cycle`：最大迭代次数。如果`max_cycle`≤0，SCF 迭代将被跳过，kernel函数将仅根据初始猜测计算总能量。默认为`50`。

## 初猜

`init_guess`：

- `minao`（默认）：从 cc-pVTZ 或 cc-pVTZ-PP 基组中的第一个收缩函数获得的最小基中投影的原子密度的叠加。猜测轨道是通过对角化由自旋受限猜测密度产生的 Fock 矩阵获得的。

- `1e`：单电子猜测，也称为核猜测，从核哈密顿量$$\mathbf{H}_0 = \mathbf{T} + \mathbf{V}$$的对角化得到猜测轨道，忽略了所有电子间的相互作用和对核电荷的屏蔽。只能作为最后的手段，因为它对分子系统来说不是很好。

- `atom`：原子 HF 密度矩阵的叠加。原子 HF 计算受到自旋限制，并采用球平均分数占据，基态通过完全数值计算的完整基组限制下确定 。

- `huckel`：无参数 Hückel 猜测 ，它基于与 类似执行的动态原子 HF 计算`'atom'`。球平均原子自旋受限 Hartree-Fock 计算产生原子轨道和轨道能量的最小基础，用于构建 Hückel 型矩阵，该矩阵对角化以获得猜测轨道。

- `chkfile`：从*.chk文件中读取轨道并将它们用作初始猜测。

  ```
  from pyscf import scf
  mf = scf.RHF(mol)
  mf.chkfile = '/path/to/chkfile'
  mf.init_guess = 'chkfile'
  mf.kernel()
  ```

  ```
  from pyscf import scf
  mf = scf.RHF(mol)
  dm = scf.hf.from_chk(mol, '/path/to/chkfile')
  mf.kernel(dm)
  ```

- `hcore`

也可以通过`dm0`参数来覆盖 SCF 计算的初始猜测密度矩阵：

```
# First calculate the Cr6+ cation
mol = gto.Mole()
mol.build(
    symmetry = 'D2h',
    atom = [['Cr',(0, 0, 0)], ],
    basis = 'cc-pvdz',
    charge = 6,
    spin = 0,
)

mf = scf.RHF(mol)
mf.kernel()
dm1 = mf.make_rdm1()

# Now switch to the neutral atom in the septet state
mol.charge = 0
mol.spin = 6
mol.build(False,False)

mf = scf.RHF(mol)
mf.kernel(dm0=dm1)
```

## 收敛

- 能级移动增加了占据轨道和虚拟轨道之间的差距，从而减慢和稳定轨道更新。在具有小的 HOMO-LUMO 间隙的系统的情况下，电平转换可以帮助收敛 SCF。

  ```python
  mf = scf.RHF(mol)
  mf.level_shift = 0.2
  mf.kernel()
  ```

  - 通过应用不同的电平转换来打破 alpha 和 beta 简并

    ```python
    mf = scf.UHF(mol)
    mf.level_shift = (0.3, 0.2)
    mf.kernel()
    ```

    



其他函数

- `pyscf.scf.hf.get_init_guess(mol, key='minao')`：为初始猜测生成密度矩阵，`key`是`minao`，`atom`，`huckel`，`hcore`，`1e`,`chkfile`中的一个。

  - 可以获得初猜后，赋值给`dm0`

  ```
  mf = scf.GHF(mol)
  dm = mf.get_init_guess() + 0j
  dm[0,:] += .1j
  dm[:,0] -= .1j
  mf.kernel(dm0=dm)
  ```

  





# `Kernel()`

SCF 驱动程序

```
pyscf.scf.hf.kernel(mf, conv_tol=1e-10, conv_tol_grad=None, dump_chk=True, dm0=None, callback=None, conv_check=True, **kwargs)
```

- `mf`：给定的一个对象，包含控制SCF的所有参数。`Kernel()`会调用：`mf.get_init_guess`，`mf.get_hcore`，`mf.get_ovlp`，`mf.get_veff`，`mf.get_fock`，`mf.get_grad`，`mf.eig`，`mf.get_occ`，`mf.make_rdm1`，`mf.energy_tot`，`mf.dump_chk`。
- `conv_tol`，`conv_tol_grad`：收敛限和梯度收敛阈值
- `dump_chk`：布尔值，chk文件中是否保存SCF中间结果
- `dm0`：数组，初始猜测密度矩阵。如果没有给出（默认），`Kernel()`采用 `mf.get_init_guess` 生成的密度矩阵。

会返回一个列表

- `scf_conv`：布尔值，True 表示 SCF 收敛
- `e_tot`：浮点数，最后迭代的 Hartree-Fock 能量
- `mo_energy`：一维数组，轨道能量。取决于 `mf`对象提供的 eig，可能无法对轨道能量进行排序。
- `mo_coeff`：二维数组，轨道系数
- `mo_occ`：一维数组，轨道占据数。可能不会从大到小排序。

```python
>>> from pyscf import gto, scf
>>> mol = gto.M(atom='H 0 0 0; H 0 0 1.1', basis='cc-pvdz')
>>> conv, e, mo_e, mo, mo_occ = scf.hf.kernel(scf.hf.SCF(mol), dm0=numpy.eye(mol.nao_nr()))
>>> print('conv = %s, E(HF) = %.12f' % (conv, e))
conv = True, E(HF) = -1.081170784378
```



# `analyze()`

分析给定的 SCF 对象：打印轨道能量、占据；打印轨道系数；Mulliken布局分析；偶极矩。

```
pyscf.scf.hf.analyze(mf, verbose=5, with_meta_lowdin=True, **kwargs)
```



