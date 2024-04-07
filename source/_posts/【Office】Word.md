---
title: 【Office】Word
typora-root-url: 【Office】Word
mathjax: true
date: 2024-02-28
updated:
tags: [Office, Word]
categories: [办公, 软件]
description: Word的一些技巧
---



# 公式编号及引用

编号：

1. `alt+fn+f9`进入域代码模式

2. 在章节标题处`ctrl+fn+f9`输入域代码的大括号（shift是切换当前域代码），插入如下

   ```
   { SEQ seq \h}{ SEQ eq \r \h}
   ```

   - `SEQ` 是关键词
   - `seq` 是变量名字，可以是其他的，比如chart等
   - `\h` 表示隐藏域的结果
   - `\r`自此之后重置序号计数器为1 

3. 复制2中的代码到每一个章节的标题后面

4. 公式编号：输入完公式后输入`#({ SEQ seq \c}-{ SEQ eq })`，再回车。连接符号是`-`，也可以是`.`等自定义

5. `alt+fn+f9`退出域代码模式

6. `alt+shift+u`更新域代码，或者直接打印预览一下

引用：

1. 选中公式编号，插入书签，输入名称
2. 引用的时候用交叉引用就可以了
