---
title: 【CP2K】03.&MGRID中的CUTOFF和RELEL_CUTOFF
typora-root-url: 【CP2K】03.&MGRID中的CUTOFF和RELEL_CUTOFF
mathjax: true
date: 2020-11-21 21:26:52
updated:
tags:
categories:
description: CUTOFF和RELEL_CUTOFF的设置方法和测试
---



# 原理

- `&MGRID`属于` &FORCE_EVAL`的`&DFT`。
- `QUICKSTEP`要求使用实空间（RS）积分网格来表示某些函数，例如电子密度和乘积高斯函数。 `QUICKSTEP`使用多网格系统将乘积高斯映射到RS网格上，因此宽而平滑的高斯函数比窄而锐利的高斯函数映射到更粗糙的网格上。（电子密度始终映射到最精细的网格上。）

- 在这种情况下，从粗糙到精细，需要设置多个级别（默认为4）的多重网格。
- `CUTOFF`：定义了多网格最高级的平面波截止（默认单位为Ry），即控制整体网格精度的最高值。平面波截止频率越高，网格越精细。
- 后续网格级别（从更精细到更粗糙）的相应平面波截止由$$E_{\mathrm{cut}}^{i}=\frac{E_{\mathrm{cut}}^{1}}{\alpha^{(i-1)}}$$定义，α默认值为`3.0`。对于所有多网格级别，`CUTOFF`的值越高，网格越细。
- 构建了多网格后，`QUICKSTEP`需要将高斯模型映射到网格上。`REL_CUTOFF`该关键词控制将哪个乘积高斯映射到多网格的哪个级别。 CP2K尝试将每个高斯映射到网格上，以使高斯覆盖的网格点数（无论宽或窄）都大致相同。`REL_CUTOFF`定义由高斯覆盖的参考网格的平面波截止，其单位标准偏差为$$e^{|\vec{r}|^{2}}$$。高斯映射到多网格最粗糙的级别，该函数将覆盖大于或等于由`REL_CUTOFF`定义的参考网格上$$e^{|\vec{r}|^{2}}$$覆盖的网格点数。
- 因此，影响积分网格和计算准确性的两个最重要的关键字是`CUTOFF`和`REL_CUTOFF`。
  - 如果`CUTOFF`太低，则所有网格将变得粗糙，计算可能会变得不准确；
  - 如果`REL_CUTOFF`太低，即使`CUTOFF`较高，所有高斯也将映射到多网格的最粗糙级别，因此用于计算的有效积分网格可能仍然太粗糙。

# 参数

- `NGRIDS`：定义要使用的多重网格数 ，默认为`4`。

- `CUTOFF`：默认值为280Ry。SE或DFTB计算的默认值为1.0Ry。

  - `CUTOFF`的设置取决于体系中元素的种类。CP2K论坛中建议给不同的原子使用不同的`CUTOFF`：

    ![](/../【CP2K】03-MGRID中的CUTOFF和RELEL-CUTOFF/1.png)

  - 对包含Na\N\O\F\Ne\Ni\Ga等元素的计算，需要设置高达1000Ry的`CUTOFF`来确保计算精度。

- `PROGRESSION_FACTOR`：通过该关键词可以修改α。

- `REL_CUTOFF`：默认为40Ry。一般设置为50±10Ry的值。

# 例子

## Si

以面心立方晶胞中具有8个原子的硅为例，用脚本寻找合适`CUTOFF`和`REL_CUTOFF`。

### 建立模板文件

- `RUN_TYPE`中设置为`ENERGY`，因为只对积分网格的收敛感兴趣，只需要查看能量。
- `CUTOFF`和`REL_CUTOFF`设置为 `LT_cutoff` 和 `LT_rel_cutoff` 是标记，自动化脚本将搜索它们并将其替换为相关值。
- 因为只检查积分网格，与自洽性无关，具有足够精细网格应该提供一致的能量。因此`MAX_SCF`设置为1。

```
&GLOBAL
  PROJECT Si_bulk8
  RUN_TYPE ENERGY
  PRINT_LEVEL MEDIUM
&END GLOBAL
&FORCE_EVAL
  METHOD Quickstep
  &DFT
    BASIS_SET_FILE_NAME  BASIS_SET
    POTENTIAL_FILE_NAME  GTH_POTENTIALS
    &MGRID
      NGRIDS 4
      CUTOFF LT_cutoff
      REL_CUTOFF LT_rel_cutoff
    &END MGRID
    &QS
      EPS_DEFAULT 1.0E-10
    &END QS
    &SCF
      SCF_GUESS ATOMIC
      EPS_SCF 1.0E-6
      MAX_SCF 1
      ADDED_MOS 10
      CHOLESKY INVERSE
      &SMEAR ON
        METHOD FERMI_DIRAC
        ELECTRONIC_TEMPERATURE [K] 300
      &END SMEAR
      &DIAGONALIZATION
        ALGORITHM STANDARD
      &END DIAGONALIZATION
      &MIXING
        METHOD BROYDEN_MIXING
        ALPHA 0.4
        BETA 0.5
        NBROYDEN 8
      &END MIXING
    &END SCF
    &XC
      &XC_FUNCTIONAL PADE
      &END XC_FUNCTIONAL
    &END XC
  &END DFT
  &SUBSYS
    &KIND Si
      ELEMENT   Si
      BASIS_SET SZV-GTH-PADE
      POTENTIAL GTH-PADE-q4
    &END KIND
    &CELL
      SYMMETRY CUBIC
      A     5.430697500    0.000000000    0.000000000
      B     0.000000000    5.430697500    0.000000000
      C     0.000000000    0.000000000    5.430697500
    &END CELL
    &COORD
      Si    0.000000000    0.000000000    0.000000000
      Si    0.000000000    2.715348700    2.715348700
      Si    2.715348700    2.715348700    0.000000000
      Si    2.715348700    0.000000000    2.715348700
      Si    4.073023100    1.357674400    4.073023100
      Si    1.357674400    1.357674400    1.357674400
      Si    1.357674400    4.073023100    4.073023100
      Si    4.073023100    4.073023100    1.357674400
    &END COORD
  &END SUBSYS
  &PRINT
    &TOTAL_NUMBERS  ON
    &END TOTAL_NUMBERS
  &END PRINT
&END FORCE_EVAL
```

### 分析CUTOFF

通过cutoff_inputs.sh脚本生成输入文件:

- `cutoff`的范围为50~500Ry，步长为50Ry。
- 除了 `template.inp`，还需要确保基组和赝势文件 `BASIS_SET` 、 `GTH_POTENTIALS`在当前目录下
- 将新脚本文件的权限设置为可执行，再输入命令行

```shell
#!/bin/bash
 
cutoffs="50 100 150 200 250 300 350 400 450 500"
 
basis_file=BASIS_SET
potential_file=GTH_POTENTIALS
template_file=template.inp
input_file=Si_bulk8.inp
 
rel_cutoff=60
 
for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    if [ ! -d $work_dir ] ; then
        mkdir $work_dir
    else
        rm -r $work_dir/*
    fi
    sed -e "s/LT_rel_cutoff/${rel_cutoff}/g" \
        -e "s/LT_cutoff/${ii}/g" \
        $template_file > $work_dir/$input_file
    cp $basis_file $work_dir
    cp $potential_file $work_dir
done
```

再通过cutoff_run.sh脚本运行一系列输入文件（根据自己服务器的情况重新编写）：

- `cp2k_bin`定义CP2K二进制文件的路径
-  `no_proc_per_calc`设置每个作业并行使用的MPI进程数
- `no_proc_to_use` 设置用于运行所有作业的处理器总数，比如该脚本的意思是，在24核本地工作站上运行，总共16个核用于执行整个测试计算，每个计算使用2个核，最多可以运行8个作业，直到计算完毕。
- 增加权限后，通过`./cutoff_run.sh &`运行。

```shell
#!/bin/bash
 
cutoffs="50 100 150 200 250 300 350 400 450 500"
 
cp2k_bin=cp2k.popt
input_file=Si_bulk8.inp
output_file=Si_bulk8.out
no_proc_per_calc=2
no_proc_to_use=16
 
counter=1
max_parallel_calcs=$(expr $no_proc_to_use / $no_proc_per_calc)
for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    mpirun -np $no_proc_per_calc $cp2k_bin -o $output_file $input_file &
    cd ..
    mod_test=$(echo "$counter % $max_parallel_calcs" | bc)
    if [ $mod_test -eq 0 ] ; then
        wait
    fi
    counter=$(expr $counter + 1)
done
wait
```

输出结果:

- 能量：

  ```
  SCF WAVEFUNCTION OPTIMIZATION
  
   Step     Update method      Time    Convergence         Total energy    Change
   ------------------------------------------------------------------------------
  
   Trace(PS):                                   32.0000000000
   Electronic density on regular grids:        -31.9999999980        0.0000000020
   Core density on regular grids:               31.9999999944       -0.0000000056
   Total charge density on r-space grids:       -0.0000000036
   Total charge density g-space grids:          -0.0000000036
  
      1 NoMix/Diag. 0.40E+00    0.4     1.10090760       -32.3804557631 -3.24E+01
      1 NoMix/Diag. 0.40E+00    0.4     1.10090760       -32.3804557631 -3.24E+01
  
   *** SCF run NOT converged ***
  
  
   Electronic density on regular grids:        -31.9999999980        0.0000000020
   Core density on regular grids:               31.9999999944       -0.0000000056
   Total charge density on r-space grids:       -0.0000000036
   Total charge density g-space grids:          -0.0000000036
  
   Overlap energy of the core charge distribution:               0.00000000005320
   Self energy of the core charge distribution:                -82.06393942512820
   Core Hamiltonian energy:                                     16.92855916540793
   Hartree energy:                                              42.17635056223367
   Exchange-correlation energy:                                 -9.42142606564066
   Electronic entropic energy:                                   0.00000000000000
   Fermi energy:                                                 0.00000000000000
  
   Total energy:                                               -32.38045576307407
  ```

- 高斯分布在多网格上的信息

  ```
  -------------------------------------------------------------------------------
  ----                             MULTIGRID INFO                            ----
  -------------------------------------------------------------------------------
  count for grid        1:           2720          cutoff [a.u.]           50.00
  count for grid        2:           5000          cutoff [a.u.]           16.67
  count for grid        3:           2760          cutoff [a.u.]            5.56
  count for grid        4:             16          cutoff [a.u.]            1.85
  total gridlevel count  :          10496
  ```

通过脚本分析输出比较容易：

- 正则表达式搜索`"^[ \t]*Total energy:"`来得到能量

```shell
#!/bin/bash
 
cutoffs="50 100 150 200 250 300 350 400 450 500"
 
input_file=Si_bulk8.inp
output_file=Si_bulk8.out
plot_file=cutoff_data.ssv
 
rel_cutoff=60
 
echo "# Grid cutoff vs total energy" > $plot_file
echo "# Date: $(date)" >> $plot_file
echo "# PWD: $PWD" >> $plot_file
echo "# REL_CUTOFF = $rel_cutoff" >> $plot_file
echo -n "# Cutoff (Ry) | Total Energy (Ha)" >> $plot_file
grid_header=true
for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    total_energy=$(grep -e '^[ \t]*Total energy' $work_dir/$output_file | awk '{print $3}')
    ngrids=$(grep -e '^[ \t]*QS| Number of grid levels:' $work_dir/$output_file | \
             awk '{print $6}')
    if $grid_header ; then
        for ((igrid=1; igrid <= ngrids; igrid++)) ; do
            printf " | NG on grid %d" $igrid >> $plot_file
        done
        printf "\n" >> $plot_file
        grid_header=false
    fi
    printf "%10.2f  %15.10f" $ii $total_energy >> $plot_file
    for ((igrid=1; igrid <= ngrids; igrid++)) ; do
        grid=$(grep -e '^[ \t]*count for grid' $work_dir/$output_file | \
               awk -v igrid=$igrid '(NR == igrid){print $5}')
        printf "  %6d" $grid >> $plot_file
    done
    printf "\n" >> $plot_file
done
```

最后cutoff_data.ssv中得到

```
# Grid cutoff vs total energy
# Date: Mon Jan 20 21:20:34 GMT 2014
# PWD: /home/tong/tutorials/converging_grid/sample_output
# REL_CUTOFF = 60
# Cutoff (Ry) | Total Energy (Ha) | NG on grid 1 | NG on grid 2 | NG on grid 3 | NG on grid 4
     50.00   -32.3795329864    5048    5432      16       0
    100.00   -32.3804557631    2720    5000    2760      16
    150.00   -32.3804554850    2032    3016    5432      16
    200.00   -32.3804554982    1880    2472    3384    2760
    250.00   -32.3804554859     264    4088    3384    2760
    300.00   -32.3804554843     264    2456    5000    2776
    350.00   -32.3804554846      56    1976    5688    2776
    400.00   -32.3804554851      56    1976    3016    5448
    450.00   -32.3804554851       0    2032    3016    5448
    500.00   -32.3804554850       0    2032    3016    5448
```

- 数据显示，在`REL_CUTOFF `为60 Ry的情况下，`CUTOFF`设置 为250 Ry或更高将产生总能量误差小于$$10^{-8}$$Hatree。
- 随着`CUTOFF`的增加，分配给最精细网格的高斯数减少。简单地增加`CUTOFF`而不增加`REL_CUTOFF`可能最终导致能量收敛缓慢，因为越来越多的高斯被推到更粗糙的网格级别，从而抵消了`CUTOFF`的增加。

### 分析REL_CUTOFF

同样的方法，将`CUTOFF`设置 为250 Ry来测试`REL_CUTOFF`

在已有的 `template.inp`模板基础上，脚本修改为：

```shell
#!/bin/bash
 
rel_cutoffs="10 20 30 40 50 60 70 80 90 100"
 
basis_file=BASIS_SET
potential_file=GTH_POTENTIALS
template_file=template.inp
input_file=Si_bulk8.inp
 
cutoff=250
 
for ii in $rel_cutoffs ; do
    work_dir=rel_cutoff_${ii}Ry
    if [ ! -d $work_dir ] ; then
        mkdir $work_dir
    else
        rm -r $work_dir/*
    fi
    sed -e "s/LT_cutoff/${cutoff}/g" \
        -e "s/LT_rel_cutoff/${ii}/g" \
        $template_file > $work_dir/$input_file
    cp $basis_file $work_dir
    cp $potential_file $work_dir
done
```

运行计算：

```shell
#!/bin/bash
 
rel_cutoffs="10 20 30 40 50 60 70 80 90 100"
 
cp2k_bin=cp2k.popt
input_file=Si_bulk8.inp
output_file=Si_bulk8.out
no_proc_per_calc=2
no_proc_to_use=16
 
counter=1
max_parallel_calcs=$(expr $no_proc_to_use / $no_proc_per_calc)
for ii in $rel_cutoffs ; do
    work_dir=rel_cutoff_${ii}Ry
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    mpirun -np $no_proc_per_calc $cp2k_bin -o $output_file $input_file &
    cd ..
    mod_test=$(echo "$counter % $max_parallel_calcs" | bc)
    if [ $mod_test -eq 0 ] ; then
        wait
    fi
    counter=$(expr $counter + 1)
done
wait
```

分析结果

```shell
 #!/bin/bash
 
rel_cutoffs="10 20 30 40 50 60 70 80 90 100"
 
input_file=Si_bulk8.inp
output_file=Si_bulk8.out
plot_file=rel_cutoff_data.ssv
 
cutoff=250
 
echo "# Rel Grid cutoff vs total energy" > $plot_file
echo "# Date: $(date)" >> $plot_file
echo "# PWD: $PWD" >> $plot_file
echo "# CUTOFF = ${cutoff}" >> $plot_file
echo -n "# Rel Cutoff (Ry) | Total Energy (Ha)" >> $plot_file
grid_header=true
for ii in $rel_cutoffs ; do
    work_dir=rel_cutoff_${ii}Ry
    total_energy=$(grep -e '^[ \t]*Total energy' $work_dir/$output_file | awk '{print $3}')
    ngrids=$(grep -e '^[ \t]*QS| Number of grid levels:' $work_dir/$output_file | \
             awk '{print $6}')
    if $grid_header ; then
        or ((igrid=1; igrid <= ngrids; igrid++)) ; do
            printf " | NG on grid %d" $igrid >> $plot_file
        done
        printf "\n" >> $plot_file
        grid_header=false
    fi
    printf "%10.2f  %15.10f" $ii $total_energy >> $plot_file
    for ((igrid=1; igrid <= ngrids; igrid++)) ; do
        grid=$(grep -e '^[ \t]*count for grid' $work_dir/$output_file | \
               awk -v igrid=$igrid '(NR == igrid){print $5}')
        printf "  %6d" $grid >> $plot_file
    done
    printf "\n" >> $plot_file
done
```

得到rel_cutoff_data.ssv：

```
# Rel Grid cutoff vs total energy
# Date: Mon Jan 20 00:45:14 GMT 2014
# PWD: /home/tong/tutorials/converging_grid/sample_output
# CUTOFF = 250
# Rel Cutoff (Ry) | Total Energy (Ha) | NG on grid 1 | NG on grid 2 | NG on grid 3 | NG on grid 4
     10.00   -32.3902980020       0       0    2032    8464
     20.00   -32.3816384686       0     264    4088    6144
     30.00   -32.3805115576       0    2032    3016    5448
     40.00   -32.3805116025      56    1976    3016    5448
     50.00   -32.3804555002     264    2456    5000    2776
     60.00   -32.3804554859     264    4088    3384    2760
     70.00   -32.3804554859    1880    2472    3384    2760
     80.00   -32.3804554859    1880    2472    3384    2760
     90.00   -32.3804554848    2032    3016    5432      16
    100.00   -32.3804554848    2032    3016    5432      16
```

- 随着`REL_CUTOFF`值的增加，更多的高斯映射到更精细的网格上。总能量误差减少到小于$$10^{-8}$$
- 当`REL_CUTOFF`大于或等于60 Ry 。结果因此表明60 Ry确实是`REL_CUTOFF`值的合适选择。



综上，说明计算中 设置为如下是最合适的：

```
&MGRID
  CUTOFF 250
  REL_CUTOFF 60 
&END MGRID
```

## H<sub>2</sub>O

32个H<sub>2</sub>O水分子的系统

### 模板文件

- 与Si相比，这是一个更大的系统，在中小型绝缘系统的良好设置中使用`&OT`优化。
- `&PRINT`中保存了`&FORCES`。在MD中，力比能量更重要。

```
&GLOBAL
  PRINT_LEVEL MEDIUM
  PROJECT cuttoff-test
  RUN_TYPE ENERGY_FORCE
&END GLOBAL
  
&FORCE_EVAL
  METHOD Quickstep
  &DFT
    BASIS_SET_FILE_NAME BASIS_MOLOPT
    POTENTIAL_FILE_NAME GTH_POTENTIALS
    WFN_RESTART_FILE_NAME ../cuttoff-test-RESTART.wfn
    CHARGE 0
    MULTIPLICITY 1
    &MGRID
      NGRIDS 4
      CUTOFF LT_cutoff
      REL_CUTOFF LT_rel_cutoff
    &END
    &QS
      EPS_DEFAULT 1.0E-12
      METHOD GPW
    &END
 
    &SCF
      SCF_GUESS RESTART
      EPS_SCF 5.e-7
      MAX_SCF 15
      &OT
        PRECONDITIONER FULL_ALL
        MINIMIZER DIIS
      &END OT
      &OUTER_SCF
        EPS_SCF 5.0E-7
        MAX_SCF 1
      &END OUTER_SCF
    &END SCF
 
    &XC
      &XC_FUNCTIONAL PBE
      &END XC_FUNCTIONAL
      &XC_GRID
        ! defaults
        XC_SMOOTH_RHO NONE
        XC_DERIV PW
      &END XC_GRID
    &END XC
 
  &END DFT
  &SUBSYS
    &CELL
      ABC 9.8528 9.8528 9.8528
      PERIODIC XYZ
    &END CELL
 
    &KIND H
      BASIS_SET DZVP-MOLOPT-SR-GTH-q1
      POTENTIAL GTH-PBE-q1
    &END
 
    &KIND O
      BASIS_SET DZVP-MOLOPT-SR-GTH-q6
      POTENTIAL GTH-PBE-q6
    &END KIND
 
    &TOPOLOGY
      COORDINATE XYZ
      COORD_FILE_NAME ../structure.xyz
      CONNECTIVITY OFF
    &END TOPOLOGY
  &END SUBSYS
 
  &PRINT
    &FORCES
    &END
  &END
&END FORCE_EVAL
```

### 生成输入

利用脚本生成输入文件后再提交任务

```
#!/bin/bash

cutoffs="100 200 300 400 500 600 700 800 900 1000 1100 1200"

template_file=input_template.inp
input_file=input.inp

rel_cutoff=60

for ii in $cutoffs ; do
    work_dir=cutoff_${ii}Ry
    if [ ! -d $work_dir ] ; then
        mkdir $work_dir
    else
        rm -r $work_dir/*
    fi
    sed -e "s/LT_rel_cutoff/${rel_cutoff}/g" \
        -e "s/LT_cutoff/${ii}/g" \
    $template_file > $work_dir/$input_file
done
```

再比较输出中的CUTOFF-能量、CUTOFF-Force曲线

## summary

- 将力的收敛与几何优化的默认收敛标准进行比较决定了是否收敛

- 基组或赝势决定了`CUTOFF`，高斯指数越大，需要用越大的网格数。比如O，电负性很强，具有比较收缩的2s，基组中最大的高斯指数为10.4 Bohr<sup>-2</sup>，而相同的基组的：Si中只有2.7，因此可以用比较粗糙的格点表示。

  ```
  Normalised Cartesian orbitals:
  
                   Set   Shell   Orbital            Exponent    Coefficient
  
                     1       1    2s               10.389228       0.396646
                                                    3.849621       0.208811
                                                    1.388401      -0.301641
                                                    0.496955      -0.274061
                                                    0.162492      -0.033677
  ```

  ```
   Si DZVP-MOLOPT-GTH DZVP-MOLOPT-GTH-q4
   1
   2 0 2 6 2 2 1
        2.693604434572  0.015333179500 -0.073325401200 -0.005800105400  0.023996406700  0.043919650100
        1.359613855428 -0.283798205000  0.484815594600 -0.059172026000  0.055459199900  0.134639409600
        0.513245176029 -0.228939692700 -0.276015880000  0.121487149900 -0.269559268100  0.517732111300
        0.326563011394  0.728834000900 -0.228394679700  0.423382421100 -0.259506329000  0.282311245100
        0.139986977410  0.446205299300 -0.018311553000  0.474592116300  0.310318217600  0.281350794600
        0.068212286977  0.122025292800  0.365245476200  0.250129397700  0.647414251100  0.139066843800
  ```

- 另外，收敛主要由GGA功能中的梯度项的计算决定。对于BLYP泛函需要进行平滑处理。平滑可以比默认更快的收敛力。

