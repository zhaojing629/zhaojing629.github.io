---
title: 【Linux】Windows下安装虚拟机
typora-root-url: 【Linux】Windows下安装虚拟机
mathjax: true
date: 2020-09-24 20:17:25
updated:
tags: [Linux,虚拟机]
categories: 系统
description: 在Windows下运行Linux相关软件所需
---







# 安装虚拟机

安装VMware虚拟机（或者上北邮人上下载），步骤见https://mp.weixin.qq.com/s/7K3IOzZ6XFVDm5-OjY5otw

# 安装Ubuntu系统

下载ubuntu镜像，安装ubuntu，步骤见https://mp.weixin.qq.com/s/piZJUGii2s-aUDoh8utxUA

注意事项：

- 使用完毕要点击shut down关机，而不要直接关闭VMware。
- 可以通过右键Open in Terminal 打开命令行



# 与windows共享文件夹

- 进入虚拟机中，然后，右击虚拟机的标签，选择设置→选项→共享文件夹→勾选总是启用→添加

- 再在Linux系统中打开文件夹即可

  ```
  cd /mnt/hgfs/<你的共享名>
  ```

  