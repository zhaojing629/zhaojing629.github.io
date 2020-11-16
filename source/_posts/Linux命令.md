---
title: Linux命令
typora-root-url: Linux命令
date: 2019-09-25 
updated:
description: 常用的一些Linux命令
tags: Linux
categories: 系统
---

# 文件管理

## chmod

Change mode 修改文件或目录的权限

### 语法

```
chmod [OPTION] MODE FILE
```

- OPTION：
  - `-c`当文件的权限更改时输出操作信息
  - `-f`若该文件权限无法被更改也不要显示错误讯息
  - `-v`显示权限变更的详细资料
  - `-R`对目录以及目录下的文件递归执行更改权限操作
- MODE：`[ugoa][[+-=][rwxX]`或者`abc`
  - `u`符号代表当前用户；`g`符号代表和当前用户在同一个组的用户；`o`符号代表其他用户。`a`符号代表所有用户。
  - `+`符号代表添加目标用户相应的权限；`-`符号代表删除目标用户相应的权限；`=`符号代表添加目标用户相应的权限，删除未提到的权限。
  - `r`符号代表读权限以及八进制数`4`；`w`符号代表写权限以及八进制数`2`；`x`符号代表执行权限以及八进制数`1`；`X`符号代表如果目标文件是可执行文件或目录，可给其设置可执行权限。
  - a,b,c各为一个数字，分别表示User、Group、及Other的权限，7代表可读、可写、可执行；0代表无任何权限：
    - 若要rwx属性则4+2+1=7；
    - 若要rw-属性则4+2=6；
    - 若要r-x属性则4+1=5

### 例子

- 将文件 file1.txt 设为所有人皆可读取 
  ```shell
  chmod ugo+r file1.txt
  chmod a+r file1.txt
  ```
- 将文件 file1.txt 与 file2.txt 设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入 
  ```shell
  chmood ug+w,o-w file1.txt file2.txt
  ```
- 将 ex1.py 设定为只有该文件拥有者可以执行 
  ```shell
  chmod u+x ex1.py
  ```
- 将目前目录下的所有文件与子目录皆设为任何人可读取 
  ```shell
  chmod -R a+r *
  ```
- 通过数字指定：
  - `700`表示User可读可写可执行，其它任何用户（除root外），对此文件不可读不可写不可执行。
  - 如果一个程序被root安装在诸如/opt、/local/user/这样的路径，默认状况下，其它用户对这些路径下的文件、文件夹没有写、执行的权限，因此并不能运行安装的软件。因此root用户需要对整个软件文件夹赋予`755`的权限。这样普通用户对软件具有读、执行的权限，但不能做任何修改。
  - `chmod a=rwx file`即`chmod 777 file`
  - `chmod ug=rwx,o=x file`即`chmod 771 file`
  - 若用`chmod 4755 filename`可使此程序具有root的权限

## cp

 Copy file 将源文件或目录复制到目标文件或目录中

### 语法

```shell
cp [options] 源 目标
```

- `-a`：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于-dpR参数组合。
- `-d`：复制时保留链接，相当于Windows系统中的快捷方式。
- `-f`：覆盖已经存在的目标文件而不给出提示。
- `-i`：与-f选项相反，在覆盖目标文件之前给出提示，要求用户确认是否覆盖，回答"y"时目标文件将被覆盖。
- `-p`：除复制文件的内容外，还把修改时间和访问权限也复制到新文件中。
- `-r`：若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件。
- `-l`：不复制文件，只是生成链接文件。

### 实例

- 将文件file1复制为file2，即会将一个已经存在的文件file1复制并重命名为file2  
   ```shell
   cp file1 file2
   ```
- 使用指令"cp"将当前目录"test/"下的所有文件复制到新目录"newtest"下：
   - 注意：用户使用该指令复制目录时，必须使用参数"-r"或者"-R"  
  ```shell
  cp –r test/ newtest  
  ```
- 将一个路径下的多个文件复制到另一路径
   ```shell
   cp C2v/{7_C2v.run, adf17.sub} ........
   ```
- 交互式地将目录/usr/men中的以m*.c文件复制到目录/usr/zh中
  ```shell
  cp -i /usr/men m*.c /usr/zh
  ```

## find

用来在指定目录下查找文件。

### 语法

```shell
find   path   -option   [expression]   [-exec  -ok  command]   {} \;
```

- path：
  - 任何位于参数之前的字符串都将被视为欲查找的目录名
  - 不设置时将在当前目录下查找子目录与文件
- -option：
  - `-name name`文件名称符合 name 的文件。`-iname`会忽略大小写
  - `-path p`路径名称符合 p 的文件，`-ipath`会忽略大小写
  - -`regex`基于正则表达式匹配文件路径，`-iregex`忽略大小写
  - 
  - `-type x`：文件类型是X的文件，X可以是`b` 块设备，`c` 字符设备，`d`目录，`f`一般文件，`l` 符号连接，`s` 套接字，`p` Fifo
  - `-maxdepth`设置最大目录层级；`-mindepth`设置最小目录层级
  - 
  - `-amin`，`-atime`分别表示在过去 n 分钟或n天内内被读取过。`+n`，`-n`，`n`分别代表大于，小于和等于。
  - `-cmin`，`-ctime`分别表示在过去 n 分钟或n天内被修改过的文件
  - `-mmin`和`-mtime`分别表示在过去 n 分钟或n天内被更改过的文件或目录（比如权限）
  - `-anewer`,`-cnewer`,`-mnewer`与文件和目录的时间相比更新的
  - 
  - `-size`查找符合指定的文件大小的文件，`b`代表512字节，`c`是字节，`w`是字（2字节），`k`是千字节，`M`是兆字节，`G`是吉字节。
  - `-empty`寻找文件大小为0 Byte的文件，或目录下没有任何子目录或文件的空目录；
  - 
  - `-perm`查找符合指定的权限数值的文件或目录
  - `-user`，`-group`查找符和指定的拥有者名称的文件或目录
  - 
  - `-exec`假设find指令的回传值为True，就执行该指令。可以用`{}`来表示find匹配的结果。
  - `-ok`在执行指令之前会先询问用户，若回答“y”或“Y”，则放弃执行命令
  - 
  - 以使用 ( ) 将运算式分隔，并使用下列运算：
    - exp1 -and exp2
    - ! expr
    - -not expr
    - exp1 -or exp2
    - exp1, exp2
  - `-prune`跳过指定目录
- expression：
  - 默认是`-print`，将文件或目录名称列出到标准输出。格式为每列一个名称，每个名称前皆有“./”字符串；
  - `-print0`将文件或目录名称列出到标准输出。格式为全部的名称皆在同一行；
  - `-printf<输出格式>`将文件或目录名称列出到标准输出。格式可以自行指定；
  - `-delete`删除

### 实例

#### 匹配名字

- 将目前目录及其子目录下所有名字为*.c的文件列出来
  ```shell
  find . -name "*.c" 
  find . -iname "*.c" #不区分大小写
  ```
- 匹配文件路径或者文件
  ```shell
  find /usr/ -path "*local*"
  ```
- 基于正则表达式匹配文件路径
  ```shell
  find . -regex ".*\(\.txt\|\.pdf\)$"
  ```
- 否定：找出/home下不是以.txt结尾的文件
  ```shell
  find /home ! -name "*.txt"
  ```
- 查找当前目录或者子目录下所有.txt文件，但是跳过子目录sk  
  ```shell
  find . -path "./sk" -prune -o -name "*.txt" -print
  ```

#### 根据文件类型  

- 将目前目录其其下子目录中所有一般文件列出：
  ```shell
  find . -type f
  ```

#### 根据目录深度

- 向下最大深度限制为3
  ```shell
  find . -maxdepth 3 -type f
  ```
- 搜索出深度距离当前目录至少2个子目录的所有文件
  ```shell
  find . -mindepth 2 -type f
  ```

#### 根据时间戳

- 搜索最近七天内被访问过的所有文件：
  ```shell
  find . -type f -atime -7
  ```
- 将目前目录及其子目录下所有超过 20 天更新过的文件列出
  ```shell
  find . -ctime -20
  ```
- 找出比file.log修改时间更长的所有文件
  ```shell
  find . -type f -newer file.log
  ```

#### 根据文件大小

- 查找系统中所有文件大于10KB的文件，并列出它们的完整路径
  ```shell
  find / -type f -size +10k -exec ls -l {} \;
  ```

#### 删除匹配文件

```shell
find . -type f -name "*.txt" -delete
```

#### 根据文件权限/所有权进行匹配

- 查找前目录中文件属主具有读、写权限，并且文件所属组的用户和其他用户具有读权限的文件
  ```shell
  find . -type f -perm 644 -exec ls -l {} \;
  ```
- 找出当前目录用户tom拥有的所有文件
  ```shell
  find . -type f -user tom
  ```

#### 结合其他命令

- 查找/var/log目录中更改时间在7日以前的普通文件，并在删除之前询问它们
  ```shell
  find /var/log -type f -mtime +7 -ok rm {} \;
  ```
- 查找当前目录下所有.txt文件并把他们拼接起来写入到all.txt文件中
  ```shell
  find . -type f -name "*.txt" -exec cat {} \;> all.txt
  ```
- 将30天前的.log文件移动到old目录中
  ```shell
  find . -type f -mtime +30 -name "*.log" -exec cp {} old \;
  ```
- 找出当前目录下所有.txt文件并以“File:文件名”的形式打印出来
  ```shell
  find . -type f -name "*.txt" -exec printf "File: %s\n" {} \;
  ```
- 查找名字是Rn*的文件，并将名字中Rn的文件替换成Xe，加-type d表示修改目录
  ```shell
  find ./ -name "Rn*" -exec rename Rn Xe {} \;
  find . -type d -name "Rn*" -exec rename Rn Xe {} \;
  ```
- 删除除了名字为*run或者adf*的其他一般文件  
  ```shell
  find . -type f -not \( -name "*run" -or -name "adf*" \) -delete
  ```
- 将目录下所有一般文件中的\_NR换成\_SR，也可以用for循环
  ```shell
  find . -type f | xargs perl -pi -e 's|_NR|_SR|g'

  for i in `find . -type f`
  do
    sed -i 's/_NR/_SR/g' $i
  done
  ```
- 将目录下所有一般文件中某一句后面加上一句
  ```shell
  for i in `find ./$path -type f`
  do
   sed -i '/NUCLEARMODEL gaussian/arelativistic scalar zora' $i
  done
  ```




































# 文档编辑



# 文件传输





# 磁盘管理





# 磁盘维护





# 网络通讯





# 系统管理







# 系统设置



# 备份压缩





# 设备管理





# 其他命令






  ```

  ```