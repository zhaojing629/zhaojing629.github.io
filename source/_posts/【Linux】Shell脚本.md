---
title: 【Linux】Shell脚本
typora-root-url: 【Linux】Shell脚本
mathjax: true
date: 2020-11-22 14:13:54
updated:
tags: [Linux,Shell]
categories: 系统
description: 使用脚本、命令的一些笔记
---





# 添加环境变量

linux命令行下面执行某个命令的时候，首先保证该命令是否存在，若存在，但输入命令的时候若仍提示：command not found，这个时候就需要使用`echo $PATH`查看PATH环境变量的设置了，当前命令是否存在于PATH环境变量中，如果不存在，设置方法如下：

## 方法一

```
export PATH=/usr/local/bin:$PATH
```

- 生效方法：立即生效
- 有效期限：临时改变，只能在当前的终端窗口中有效，当前窗口关闭后就会恢复原有的path配置
- 用户局限：仅对当前用户

## 方法二

1. `vim ~/.bashrc `后，在最后一行添加：

   ```
   export PATH=/usr/local/bin:$PATH
   ```

2. 生效：
   1. 关闭当前终端窗口，重新打开一个新终端窗口就能生效
   2. 输入`source ~/.bashrc`命令，立即生效

- 有效期限：永久有效
- 用户局限：仅对当前用户

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

## &

- `&` 放在启动参数后面表示设置此进程为后台进程。默认情况下，进程是前台进程，这时就把Shell给占据了，我们无法进行其他操作，对于那些没有交互的进程，很多时候，我们希望将其在后台启动，可以在启动参数的时候加一个'&'实现这个目的。

## for 循环

```
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

例子：

```
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```

### 数字类循环

```

for((i=1;i<=10;i++));  

for i in $(seq 1 10)  

for i in {1..10}  

#实现1~5之内的数字，按照步数2进行跳跃
for variable  in {1..5..2} 
for variable  in $(seq 1 2 5) 
```

### 字符类循环

```
for i in `ls`;  

for i in $* ;

for i in f1 f2 f3 ;  

list="rootfs usr data data2"  
for i in $list;  
```







# 字符串截取

## 从指定位置开始截取

指定起始位置和截取长度

- 从字符串左边开始计数

  ```
  ${string: start :length}
  ```

- 从右边开始计数，多了`0-`

  ```
  ${string: 0-start :length}
  ```

例子：

```
url="c.biancheng.net"
echo ${url: 2: 9}
> biancheng

echo ${url: 2} #省略 length，截取到字符串末尾
> biancheng.net

echo ${url: 0-13: 9}
> biancheng

echo ${url: 0-13}  #省略 length，直接截取到字符串末尾
> biancheng.net
```

## 从指定字符（子字符串）开始截取

截取指定字符（子字符串）右边的所有字符或者左边的所有字符。

- 使用 # 号截取右边字符

  ```
  ${string#*chars}
  ```

  - 其中，string 表示要截取的字符，chars 是指定的字符（或者子字符串），`*`是通配符的一种，表示任意长度的字符串。`*chars`连起来使用的意思是：忽略左边的所有字符，直到遇见 chars（chars 不会被截取）。

    ```
    url="http://c.biancheng.net/index.html"
    echo ${url#*:}
    echo ${url#*p:}
    echo ${url#*ttp:}
    
    > //c.biancheng.net/index.html
    ```

  - 如果不需要忽略 chars 左边的字符，那么也可以不写`*`

    ```
    url="http://c.biancheng.net/index.html"
    echo ${url#http://}
    
    > c.biancheng.net/index.html
    ```

  - 以上写法遇到第一个匹配的字符（子字符串）就结束了，如果希望直到最后一个指定字符（子字符串）再匹配结束，那么可以使用`##`

    ```
    url="http://c.biancheng.net/index.html"
    echo ${url#*/}
    > /c.biancheng.net/index.html
    
    echo ${url##*/}
    > index.html
    
    str="---aa+++aa@@@"
    echo ${str#*aa}   
    > +++aa@@@
    echo ${str##*aa}  
    > @@@
    ```

- 使用 % 截取左边字符

  ```
  ${string%chars*}
  ```

  - 注意`*`的位置，因为要截取 chars 左边的字符，而忽略 chars 右边的字符，所以`*`应该位于 chars 的右侧。

  - 其他方面`%`和`#`的用法相同

    ```
    url="http://c.biancheng.net/index.html"
    echo ${url%/*}   
    > http://c.biancheng.net
    echo ${url%%/*}   
    > http:
    
    str="---aa+++aa@@@"
    echo ${str%aa*}   
    > ---aa+++
    echo ${str%%aa*}   
    > ---
    ```

    
