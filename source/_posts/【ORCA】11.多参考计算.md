---
title: 【ORCA】11.多参考计算
typora-root-url: 【ORCA】11.多参考计算
mathjax: true
date: 2025-01-17 16:40:51
updated:
tags: [ORCA, 多组态, 多参考]
categories: [计算化学, 软件]
description: ORCA的MRCI教程笔记
---





##  DDCI3

The difference dedicated MRCI

CAS(2,2) NEVPT2 结果可以通过 DDCI3 的自然轨道得到显着改善。

基于收敛后的CASSCF波函数进行计算：

- 要设置`! allowrhf`和`! noiter`，否则程序将使用 Hartree Fock 方法（单参考方法）重新优化轨道。
- `nopop` 禁用 MRCI 群体分析。当计算许多根时，这可能会花费大量的时间。
- 禁用戴维森类型尺寸一致性校正。尺寸一致性误差对计算的交换耦合参数有很大影响。戴维森校正强烈依赖于参考波函数的权重，并且对于较小的参考权重来说是不可靠的。DDCI3 会出现大小一致性错误，但比规范的 MRCI（单打双打）要少得多。因此，没有进行尺寸一致性校正的结果应该是合理的。
- 可以在较大的分子中使用RI近似`intmode ritrafo`

```
! def2-SVP MOREAD PAL4 noiter allowrhf nopop
%moinp "cas2.gbw"
%maxcore 6000
%mrci 
	citype mrddci3
	# preselection cut-off
	TSel 1e-8 # tighter than default TSel 1e-6
	#TPre 1e-4 #default
	
	# singlet multiplicity block
	newblock 1 *
		refs cas(2,2) end
	end
	# triplet multiplicity block
	newblock 3 *
		refs cas(2,2) end
	end
	
	davidsonopt none # no davidson correction
	
	# create natural orbitals (not necessary)
	natorbiters 1	#如果值为1，则产生平均自然轨道，并使用新轨道进行第二次MRCI计算。

end
```

### 输出

- 该程序创建一个文件“.mrci.nat”，这是一个可由 ORCA 读取的常规 gbw 文件。

- 跃迁能量：

  ![image-20250117165117565](/image-20250117165117565.png)

- 不同组态的贡献：

  ![image-20250117172257059](/image-20250117172257059.png)

  ![image-20250117165617573](/image-20250117165617573.png)
  
  - 含义是（这个计算是针对于一个CAS(2,2)的结果），比如对于这个开壳层单重态的结果：
    - [xy]代表了两个轨道，[11]的权重是88.8%，[02]或[20]的离子项占了0.33%
    - 其他的代表非活性空间到活性空间的激发，比如h 84[12]代表了这样一个组态

- 打印更详细的波函数（仅打印weight大于 `TPrintWF` 指定的配置。）

  ```
  %mrci
  	printwf det # wave function printing in determinants 
  	tprintwf 0.1 # cutoff for the printing
  end
  ```

- 
- 

## FIC-MRCI

fully internally contracted MRCI

具有扩展活动空间的非收缩 MRCI 计算非常耗时且需要资源。内部收缩方法可以处理大分子，因为积分不保存在内存中。
