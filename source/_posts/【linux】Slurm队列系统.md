---
title: 【linux】Slurm队列系统
typora-root-url: 【linux】Slurm队列系统
mathjax: true
date: 2022-11-07 14:47:37
updated:
tags: [Linux, Linux]
categories: 系统
description: Slurm队列系统的基本操作
---





# 查看队列设定和节点状态

- `sinfo`：显示队列或节点状态，具有非常多过滤、排序和格式化等选项。

主要参数：

- `-l`、`--long`：显示详细信息。



# 提交任务

三种模式：

- 批处理作业（采用`sbatch`命令提交，最常用方式）
-  交互式作业提交（采用`srun`命令提交）
-  实时分配模式作业（采用`salloc`命令提交）

常用参数：

- `--exclusive[=user|mcs]`：设定排它性运行，不允许该节点有它人或某user用户或mcs的作业同时运行。
- `-N`：采用特定节点数运行作业。注意，这里是节点数，不是CPU核数。
- `-n`：设定所需要的任务总数。默认是每个节点1个任务，注意是节点，不是CPU核。
- `-p`：使用<partition_names>队列
- `-t`：作业最大运行总时间，到时间后将被终止掉。

## sbatch

sbatch提交一个批处理作业脚本到Slurm。脚本文件基本格式：

- 第一行以#!/bin/sh等指定该脚本的解释程序，/bin/sh可以变为/bin/bash、/bin/csh等。
- 在可执行命令之前的每行“#SBATCH”前缀后跟的参数作为作业调度系统参数。在任何非注释及空白之后的“#SBATCH”将不再作为Slurm参数处理。
- 默认，标准输出和标准出错都定向到同一个文件slurm­%j.out，“%j”将被作业号代替。





# 取消任务

- `scancel`：取消排队或运行中的作业或作业步，还可用于发送任意信号到运行中的作业或作业步中的所有进程。



# 查看任务

## squeue

- `squeue`：显示队列中的作业及作业步状态，含非常多过滤、排序和格式化等选项。

主要参数：

- `-u <user_list>`：显示特定用户的作业信息

## scontrol

- `scontrol show job <jobid>`：显示作业号为JOBID的作业信息
