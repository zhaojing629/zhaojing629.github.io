---
title: 【Linux】Shell脚本
typora-root-url: 【Linux】Shell脚本
mathjax: true
date: 2020-11-22 14:13:54
updated:
tags: [Linux,Shell]
categories: 系统
description: 脚本的一些笔记
---

# echo命令

打印shell变量的值，或者直接输出指定的字符串。

## 语法

```
echo(选项)(参数)
```

选项：

- `-e`：激活转义字符：
  - `\a` 发出警告声；
  - `\b` 删除前一个字符；
  - `\c` 最后不加上换行符号；
  - `\f` 换行但光标仍旧停留在原来的位置；`\v` 与`\f`相同；
  - `\n` 换行且光标移至行首；
  - `\r` 光标移至行首，但不换行；
  - `\t` 插入tab；
  - `\\` 插入\字符；
  - `\nnn` 插入nnn（八进制）所代表的ASCII字符

## 例子

- 显示普通字符串，可以省略双引号

  ```
  echo "It is a test"
  ```

- 显示转义字符，双引号也可以省略

  ```shell
  $ echo "\"It is a test\""
  "It is a test"
  ```

- 显示变量

  ```
  echo "$name It is a test"
  echo $variable
  echo $PATH  #显示当前用户路径PATH的值
  ```

- 显示换行

  ```
  echo -e "OK! \n" 
  ```

- 显示不换行

  ```shell
  $ echo -e "OK! \c" 
  $ echo "It is a test"
  OK! It is a test
  ```

- 显示结果定向至文件

  ```
  echo "It is a test" > myfile
  ```

- 原样输出字符串，不进行转义或取变量(用单引号)

  ```
  echo '$name\"'
  ```

- 显示命令执行结果

  ```
  echo `date`
  ```

## 用echo命令打印带有色彩的文字

文字色：

- `\e[1;31m` 将颜色设置为红色
- `\e[0m` 将颜色重新置回
- 颜色码：重置=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，洋红=35，青色=36，白色=37

```
$ echo -e "\e[1;31mThis is red text\e[0m"
```

背景色：

- 颜色码：重置=0，黑色=40，红色=41，绿色=42，黄色=43，蓝色=44，洋红=45，青色=46，白色=47

```
echo -e "\e[1;42mGreed Background\e[0m"
```

文字闪动：

```
echo -e "\033[37;31;5mMySQL Server Stop...\033[39;49;0m"
```

- 红色数字处还有其他数字参数：0 关闭所有属性、1 设置高亮度（加粗）、4 下划线、5 闪烁、7 反显、8 消隐

# printf 命令

## 语法

```
printf  format-string  [arguments...]
```

- `format-string`：格式控制字符串
  - `%s`：字符串
  - `%c`：ASCII字符。显示相对应参数的第一个字符
  - `%d`，`%i`：十进制整数
  - `%e`，`%E`，`%f`：浮点格式
- `arguments`：参数列表

## 例子

- `%-10s`指一个宽度为10个字符（-表示左对齐，没有则表示右对齐），任何字符都会被显示在10个字符宽的字符内，如果不足则自动以空格填充，超过也会将内容全部显示出来。
- `%-4.2f `格式为左对齐宽度为4，其中.2指保留2位小数

# 流程控制

## if 分支结构

```shell
if commands; then
     commands
[elif commands; then
     commands...]
[else
     commands]
fi
```

### test

commands可以是一个表达式：

```
test expression
```

或

```
[ expression ]
```

- expression返回True，可以是：
  - `-d file`：file 存在并且是一个目录
  - `-e file`：file 存在
  - `-f file`：file 存在并且是一个普通文件
  - 

# &

- `&` 放在启动参数后面表示设置此进程为后台进程。默认情况下，进程是前台进程，这时就把Shell给占据了，我们无法进行其他操作，对于那些没有交互的进程，很多时候，我们希望将其在后台启动，可以在启动参数的时候加一个'&'实现这个目的。

  

