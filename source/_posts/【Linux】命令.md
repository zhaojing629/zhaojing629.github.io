---
title: 【Linux】命令
typora-root-url: 【Linux】命令
date: 2019-09-25 
updated:
description: 常用的一些Linux命令
tags: Linux
categories: 系统
---

# 文件管理

## awk

### 语法

```shell
awk [options] 'script' var=value file(s)
awk [options] -f scriptfile var=value file(s)
```

- 常用选项：
  - `-F fs`：`fs`指定输入分隔符，fs可以是字符串或正则表达式，如`-F:`
  - `-v`：赋值一个用户定义变量。
- 内置变量：
  - `$n`：当前记录的第n个字段，比如n为1表示第一个字段，n为2表示第二个字段。 
  - `$NF`：一行中的最后一个字段，`$(NF-1)`则是打印倒数第二个字段，其他以此类推
  - `NR`：已经读出的记录数，就是行号，从1开始

### 例子

- 每行按空格或TAB分割，输出文本中的1、4项：

  ```shell
  #log.txt 内容
  2 this is a test
  3 Are you like awk
  
  $ awk '{print $1,$4}' log.txt
  2 a
  3 like
  ```

- awk运算与判断：将变量给igrid，然后将行号为igrid的第五个字段输出：

  ```shell
  awk -v igrid=$igrid '(NR == igrid){print $5}'
  ```

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

## cut

用于显示每行从开头算起 num1 到 num2 的文字。

### 语法

```
cut(选项)(参数)
```

选项：

- `-b` ：以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了 `-n` 标志。
- `-c` ：以字符为单位进行分割。
- `-d` ：自定义分隔符，默认为制表符。
- `-f` ：与-d一起使用，指定显示哪个区域。
- `-n` ：与-`b`选项连用，不分割多字节字符；
- `--complement`：补足被选择的字节、字符或字段；

配合-`b`，-`c`，-`f`指定字段的字符或者字节范围的方法：

- `N-`：从第N个字节、字符、字段到结尾；
- `N-M`：从第N个字节、字符、字段到第M个（包括M在内）字节、字符、字段；
- `-M`：从第1个字节、字符、字段到第M个（包括M在内）字节、字符、字段。
- `N`第N个

### 例子

test.txt为：

```
No Name Mark Percent
01 tom 69 91
02 jack 71 87
03 alex 68 98
```

- 提取指定字段：

  ```shell
  $ cut -f 1 test.txt 
  No
  01
  02
  03
  $ cut -f2,3 test.txt 
  Name Mark
  tom 69
  jack 71
  alex 68
  ```

- 提取指定字段之外的列（打印除了第二列之外的列）

  ```shell
  $ cut -f2 --complement test.txt 
  No Mark Percent
  01 69 91
  02 71 87
  03 68 98
  ```

- 指定字段分隔符，比如字段不是用空格分割，而是用的;分割，则可以用

  ```
  cut -f2 -d";" test2.txt 
  ```

- 打印第1个到第3个字符：

  ```
  cut -c1-3 test.txt 
  ```

- 打印前2个字符：

  ```
  cut -c-2 test.txt 
  ```

- 打印从第5个字符开始到结尾：

  ```
  cut -c5- test.txt 
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

## mv

move file用来为文件或目录改名、或将文件或目录移入其它位置。

### 语法

```
mv(选项)(参数)
```

三种模式

- 将源文件名 source_file 改为目标文件名 dest_file

  ```
  mv source_file(文件) dest_file(文件)
  ```

- 将文件 source_file 移动到目标目录 dest_directory 中

  ```
  mv source_file(文件) dest_directory(目录)	
  ```

- 目录名 dest_directory 已存在，将 source_directory 移动到目录名 dest_directory 中；目录名 dest_directory 不存在则 source_directory 改名为目录名 dest_directory

  ```
  mv source_directory(目录) dest_directory(目录)
  ```

选项：

- `-i`：交互式操作，覆盖前先行询问用户，如果源文件与目标文件或目标目录中的文件同名，则询问用户是否覆盖目标文件。
- `-f`：若目标文件或目录与现有的文件或目录重复，则直接覆盖现有的文件或目录，不给任何指示

## rename

### 语法

不同Liunx下的语法不同，CentOS下的是：

```shell
rename [options] expression replacement file
```

- `-v`显示哪些文件被修改了
- 通配符：
  - `?` 可替代单个字符
  - `*`可替代多个字符
  - `[]`可替代[]中的任意单个字符

### 例子

- 将所有htm文件改成html文件
  ```shell
  rename .htm .html *.htm
  ```

## rm

Remove，用于删除一个文件或者目录。

### 语法

```
rm [options] name...
```

选项：

- `-i` 删除前逐一询问确认。
- `-f` 即使原档案属性设为唯读，亦直接删除，无需逐一确认。
- `-r` 将目录及以下之档案亦逐一删除。

### 例子

- 删除目录

  ```
  rm  -r  homework  
  ```

- 删除“路径”下名为“文件（夹）名”的文件（夹）。不需要确认

  ```
  rm -rf 路径/文件（夹）名
  ```

- 除了某个文件外的其他文件全部删除的命令：

  ```
  rm -rf !(keep) #删除keep文件之外的所有文件
  rm -rf !(keep1| keep2) #删除keep1和keep2文件之外的所有文件
  ```

- 删除前先询问，-i选项在使用文件扩展名字符删除多个文件时特别有用。使用这个选项，系统会要求你逐一确定是否要删除。这时，必须输入y并按Enter键，才能删除文件。如果仅按Enter键或其他字符，文件不会被删除。

  ```
  rm -i test example
  ```

## scp

用于 Linux 之间复制文件和目录。

### 语法

```
scp [可选参数] file_source file_target 
```

- `-P port`：注意是大写的P, port是指定数据传输用到的端口号
- `-r`：以递归方式复制。

### 例子

- 从远处复制文件到本地目录

  ```
  scp root@10.10.10.10:/opt/soft/nginx-0.5.38.tar.gz /opt/soft/
  ```

- 上传本地文件到远程机器指定目录

  ```
  scp -r（文件夹/）文件名 （用户名@）节点名:目录
  scp /opt/soft/nginx-0.5.38.tar.gz root@10.10.10.10:/opt/soft/scptest
  
  #表示将/home/Fermi/Test.xyz拷贝到Fermi2用户在node124节点的home目录下面
  scp -r /home/Fermi/Test.xyz Fermi2@node124
  ```

- 如果远程服务器防火墙有为scp命令设置了指定的端口，我们需要使用 -P 参数来设置命令的端口号:

  ```
  scp -P 4588 remote@www.runoob.com:/usr/local/sin.sh /home/administrator
  ```

# 文档编辑

## grep

用于查找文件里符合条件的字符串。

### 语法

- `-A<显示行数>` 或 `--after-context=<显示行数>` : 除了显示符合范本样式的那一列之外，并显示该行之后的内容。 
- `-B<显示行数>` 或 `--before-context=<显示行数>` : 除了显示符合样式的那一行之外，并显示该行之前的内容。 
- `-C<显示行数>` 或 `--context=<显示行数>或-<显示行数>` : 除了显示符合样式的那一行之外，并显示该行之前后的内容。 
- `-d <动作>` 或 `--directories=<动作>` : 当指定要查找的是目录而非文件时，必须使用这项参数，否则grep指令将回报信息并停止动作。
- `-i` 或 `--ignore-case` : 忽略字符大小写的差别。 同`-y` 。
- `-n` 或 `--line-number` : 在显示符合样式的那一行之前，标示出该行的列数编号。 
- `-o` 或 `--only-matching` : 只显示匹配PATTERN 部分。 
- `-r/R` 或 `--recursive` : 此参数的效果和指定"-d recurse"参数相同。 
- `-v` 或 `--revert-match` : 显示不包含匹配文本的所有行。 
- `-E` 或 `--extended-regexp` : 将样式为延伸的正则表达式来使用。 
- `-c` 或 `--count` : 计算符合样式的列数。
- `-b` 或 `--byte-offset` : 在显示符合样式的那一行之前，标示出该行第一个字符的编号。  
- `-l` 或 `--file-with-matches` : 列出文件内容符合指定的样式的文件名称。 
- `-L` 或 `--files-without-match` : 列出文件内容不符合指定的样式的文件名称。 
- `-e<范本样式>` 或 `--regexp=<范本样式>` : 指定字符串做为查找文件内容的样式。 

### 例子

- 在“路径”下，查找包含“xyz123”字段的文件，其中`-r`表示子文件夹也要搜索，`-i`表示不区分xyz的大小写

  ```
  grep -Ri xyz123 路径
  ```

- 输出包含匹配字符串的行数 -n 选项

  ```
  grep "text" -n file_name
  ```

- 显示匹配某个结果之后、之前、前后的3行

  ```
  grep "5" -A 3
  grep "5" -B 3
  grep "5" -C 3
  ```

- 输出除之外的所有行 -v 选项：

  ```
  grep -v "match_pattern" file_name
  ```

- 使用正则表达式：或者直接用`egrep`

  ```
  grep -E "[1-9]+"
  ```

- 只输出文件中匹配到的部分：

  ```
  grep -o -E "[a-z]+\."
  ```

- 统计文件或者文本中包含匹配字符串的行数

  ```
  grep -c "text" file_name
  ```

- 打印样式匹配所位于的字符或字节偏移（一行中字符串的字符便宜是从该行的第一个字符开始计算，起始值为0。选项 `-b -o` 一般总是配合使用。）：

  ```shell
  $ echo gun is not unix | grep -b -o "not"
  7:not
  ```

- 搜索多个文件并查找匹配文本在哪些文件中：

  ```
  grep -l "text" file1 file2 file3...
  ```

- 选项 -e 制动多个匹配样式：

  ```shell
  $ echo this is a text line | grep -e "is" -e "line" -o
  is
  line
  ```

- 在grep搜索结果中包括或者排除指定文件：

  ```
  grep "main()" . -r --include *.{php,html}
  grep "main()" . -r --exclude "README"
  #在搜索结果中排除filelist文件列表里的文件
  grep "main()" . -r --exclude-from filelist
  ```

## sed

Stream Editor利用脚本来处理文本文件。主要用来自动编辑一个或多个文件、简化对文件的反复操作、编写转换程序等。

### 语法

```
sed [options] 'command' file(s)
sed [options] -f scriptfile file(s)
```

- sed表达式可以使用单引号来引用，但是如果表达式内部包含变量字符串，就需要使用双引号。

-  / 在sed中作为定界符使用，也可以使用任意的定界符：但是定界符出现在样式内部时，需要进行转义

  ```
  sed 's:test:TEXT:g'
  sed 's|test|TEXT|g'
  sed 's/\/bin/\/usr\/local\/bin/g'
  ```

#### 选项

- `-e<script>`或`--expression=<script>` ：以选项中指定的script来处理输入的文本文件。允许在同一行里执行多条命令：
- `-f<script文件>`或`--file=<script文件>` ：直接将 sed 的动作写在一个文件内， -f filename 则可以运行 filename 内的 sed 动作
- `-h`或`--help` 显示帮助。
- `-n`或`--quiet`或`--silent` 仅显示script处理后的结果。
- `-V`或`--version` 显示版本信息。
- `-i`：直接编辑文件选项

#### sed元字符集

- `^` 匹配行开始。如：`/^sed/`匹配所有以sed开头的行。
- `$` 匹配行结束。如：`/sed$/`匹配所有以sed结尾的行。
- `.` 匹配一个非换行符的任意字符。如：`/s.d/`匹配s后接一个任意字符，最后是d。
- `*` 前面的字符重复0到多次，如：`/*sed/`匹配所有模板是一个或多个空格后紧跟sed的行。
- `[]` 匹配一个指定范围内的字符，如`/[ss]ed/`匹配sed和Sed。  
- `[^]` 匹配一个不在指定范围内的字符，如：`/[^A-RT-Z]ed/`匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行。
- `\(..\)` 匹配子串，保存匹配的字符，如`s/\(love\)able/\1rs`，loveable被替换成lovers。
- `&` 保存搜索字符用来替换其他字符，如`s/love/**&**/`，love这成`**love**`。
- `\<` 匹配单词的开始，如`/\<love/`匹配包含以love开头的单词的行。
- `\>`  匹配单词的结束，如`/love\>/`匹配包含以love结尾的单词的行。
- `x\{m\}` 重复字符x，m次，如：`/0\{5\}/`匹配包含5个0的行。
- `x\{m,\}` 重复字符x，至少m次，如：`/0\{5,\}/`匹配至少有5个0的行。
- `x\{m,n\}` 重复字符x，至少m次，不多于n次，如：`/0\{5,10\}/`匹配5~10个0的行。

#### 动作

- `a` ：在当前行下面插入文本。后面可以直接接字符串。
- `i`： 在当前行上面插入文本。
- `c` ：把选定的行改为新的文本
- `p`：打印模板块的行。通常会与参数 `sed -n` 一起
- `s`：替换指定字符 ，标记有：
  - `g` ：表示行内全面替换。 
  - `\1`：子串匹配标记
  - `&` ：已匹配字符串标记
  - `y` ：表示把一个字符翻译为另外的字符（但是不用于正则表达式）
  - `i·`：查找不区分大小写的
- `d`：删除，删除选择的行
- `r file`：从file中读行。
- `w file`：写并追加模板块到file末尾。  
- `n` ：读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。

### 例子

#### 替换操作

- 替换：

  ```
  sed 's/book/books/' file
  ```

- 打印那些发生替换的行：

  ```
  sed -n 's/test/TEST/p' file
  ```

- 直接编辑文件，当需要**从第N处匹配开始替换时**，可以使用 `/Ng`：

  - 省略g则默认是第一个

  ```
  sed -i 's/book/books/g' file
  ```

- 将第2-5行的内容取代成为『No 2-5 number』

  ```
  #将第2-5行的内容取代成为『No 2-5 number』
  sed '2,5c No 2-5 number' file
  ```

- 所有以192.168.0.1开头的行都会被替换成它自已加localhost：

  ```
  sed 's/^192.168.0.1/&localhost/' file
  ```

- `\n`表示匹配到的第几个

  ```shell
  $ echo aaa BBB | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
  BBB aaa
  $ echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
  this is 7 in a number
  ```

- 把1~10行内所有abcde转变为大写，注意，正则表达式元字符不能使用这个命令：

  ```
  sed '1,10y/abcde/ABCDE/' file
  ```

#### 删除操作

- 删除空白行：

  ```
  sed '/^$/d' file
  ```

- 删除文件的第2行：

  ```
  sed '2d' file
  ```

- 删除文件的第2行到末尾所有行：

  ```
  sed '2,$d' file
  ```

- 删除文件最后一行：

  ```
  sed '$d' file
  ```

- 删除文件中所有开头是test的行：

  ```
  sed '/^test/'d file
  ```

- 删除包含root的行：

  ```
  sed  '/root/d' file
  ```

#### 行

- 所有在模板test和check所确定的范围内的行都被打印：

  ```
  sed -n '/test/,/check/p' file
  ```

- 打印从第5行开始到第一个包含以test开始的行之间的所有行：

  ```
  sed -n '5,/^test/p' file
  ```

- 对于模板test和west之间的行，每行的末尾用字符串aaa bbb替换：

  ```
  sed '/test/,/west/s/$/aaa bbb/' file
  ```

- 删除两个模式匹配行之间的内容

  ```
  sed -i  '/aaa/,/bbb/{/aaa/!{/bbb/!d}}'   file
  ```

- 如果test被匹配，则移动到匹配行的下一行，替换这一行的aa，变为bb，并打印该行，然后继续：

  ```
  grep -A 1 SCC URFILE 
  sed '/test/{ n; s/aa/bb/; }' file
  ```

- 打印匹配字符串的下一行

  ```
  sed -n '/SCC/{n;p}' URFILE
  ```

- 打印奇数行或偶数行

  ```
  sed -n 'p;n' test.txt  #奇数行
  sed -n 'n;p' test.txt  #偶数行
  
  sed -n '1~2p' test.txt  #奇数行
  sed -n '2~2p' test.txt  #偶数行
  ```

#### 添加

- 添加到行后或者行前：如果增加的内容有好几行，则在行末加转移符号\n。

  ```
  sed '/^test/a\this is a test line' file
  sed '/^test/i\this is a test line' file
  ```

  匹配不区分大小写添加时，在最后直接加`i`不可行，可以使用

  ```
  sed -i 's/aaa/bbb\n&/i' filename
  ```

- 在 test.conf 文件第2行之后或第5行之前插入 this is a test line：

  ```
  sed -i '2a\this is a test line' test.conf
  sed -i '5i\this is a test line' test.conf
  ```

- 在testfile文件的第四行后添加一行，并将结果输出到标准输出：

  ```
  sed -e 4a\newLine testfile 
  ```

- `r`命令会把其后面的任何字符判读为文件名，直到回车符或是单引号，因此在某行后面添加文件是

  ```
  sed -i ‘/regex/r b.txt’ file
  ```

- 在a.txt的第88行插入文件b.txt

  ```
  sed -i '88 r b.txt' a.txt
  ```

- 在example中所有包含test的行都被写入file里：

  ```
  sed -n '/test/w file' example
  ```

#### 打印，搜索显示

- 列出文件内的第 5-7 行

  ```
  sed -n '5,7p' file
  ```

- 搜索有root关键字的行

  ```
  sed '/root/p' file
  ```

#### 多点编辑：e命令

- 执行多条命令：

  ```
  sed -e '1,5d' -e 's/test/check/' file
  ```

- 组合多个表达式

  ```
  sed '表达式' | sed '表达式'
  或
  sed '表达式; 表达式'
  ```

## perl -i

在命令行中修改文件内容

-  `-w`  ：打开警告。
- `-i`  ：在原文件中编辑（就地编辑）。
-  `-i.bak` 就地编辑，但是会备份原文件，并且以.bak为后缀，这个.bak可以修改成自己想要的任何符号。
- `-n`：使用<>将所有@ARGV参数当作文件来逐行运行,会将读入的内容隐式的逐一按行来遍历文件，每一行将缺省保存在 `$_`；意即会把输入的文件逐行的读取并保存在`$_`这个变量中，我们修改​`$_`相当于间接影响文件中的内容，这个工作其实是perl封装好了的，直接使用就好了；这个参数不会自动打印​`$_`。
-  `-p`：这个和-n类似，但是会打印`$_`。
-   `-e`：指定字符串用作脚本执行；通常后跟单引号，把需要执行的语句封装在其中。

### 例子

- 替换A为B

  ```
  perl  -i  -pe ‘s/old_str/new_str/g’  files
  ```

- 替换A为B并备份

  ```
  perl  -i.bak -pe  ‘s/old_str/new_str/g’ files
  ```

- 修改并输出到屏幕 此处修改后输出到屏幕，但并不会改变原文件。

  ```
  perl  -ne ‘s/old_str/new_str/g;print;’  files
  ```

- 搜索满足条件的行

  ```
   perl  -i  -ne ‘print  if /condition/’  files
  ```

- 在文件中插入行号

  ```
   perl  -i  -pe ‘$_ = sprintf “d %s”, $. , $_’  files
  ```

- 在匹配的某行行首添加字串

  ```
  perl  -i  -pe ‘print  “string” if  /condition/’  files
  ```

- 在匹配的某行行尾添加字串

  ```
  perl  -i  -pe ‘chomp; $_ = $_ . “string\n”  if /condition/’  files
  ```

- 在匹配的某行前增加一行

  ```
  perl  -i  -pe ‘print  “string\n” if  /condition/’  files
  ```

- 在匹配的某行后增加一行

  ```
  perl  -i  -pe ‘$_ = $_ . “string\n”  if /condition/’  files
  ```

# 文件传输





# 磁盘管理

## cd

Change directory，用于切换当前工作目录至

### 语法

```
cd [dirName]
```

dirName：

- 可为绝对路径或相对路径。
- 若目录名称省略，则变换至使用者的home directory。`~`也表示为home directory的意思
- `.`则是表示目前所在的目录
- `..`则表示目前目录位置的上一层目录。

## df

检查磁盘空间占用情况(并不能查看某个目录占用的磁盘大小)。

```
df [option]
```

- `-h`：以容易理解的格式(给人看的格式)输出文件系统分区使用情况，例如 10kB、10MB、10GB 等。
- `-k`，`-m`： 以 kB、 mB 为单位输出文件系统分区使用情况。
- `-a`：列出所有的文件系统分区，包含大小为 0 的文件系统分区。
- `-i`：列出文件系统分区的 inodes 信息。
- `-T`：显示磁盘分区的文件系统类型。

## du

用于显示目录或文件的大小。

### 语法

```
du [-abcDhHklmsSx][-L <符号连接>][-X <文件>][--block-size][--exclude=<目录或文件>][--max-depth=<目录层数>][--help][--version][目录或文件]
```

- `--max-depth=<目录层数>`： 超过指定层数的目录后，予以忽略。
- `-h`或`--human-readable`：以K，M，G为单位，提高信息的可读性。
- `-s`或`--summarize `：显示文件或整个目录的大小，默认单位为 kB。
- `--block-size=k`：以K，M或者G为单位

### 例子

- 显示当前目录的大小：

  ```
  du -hs
  ```

- 显示某个目录或文件的大小：

  ```
  du -hs nodedemo/
  du -hs ./*
  ```







## ll

用法与ls相同，但列出信息更详细，包括文件的创建时间、所属对象、权限等等信息

## ls

List files 于显示指定工作目录下之内容（列出目前工作目录所含之文件及子目录)。

### 语法

```
ls（选项）（参数）
```

选项：

- `-l`：以长格式显示目录下的内容列表。输出的信息从左到右依次包括文件名，文件类型、权限模式、硬连接数、所有者、组、文件大小和文件的最后修改时间等；
- `-t`：用文件和目录的更改时间排序；
- `-r`：以文件名反序排列并输出目录内容列表；
- `-R`：递归处理，将指定目录下的所有文件及子目录一并处理；
- `-a`：显示所有档案及目录，包括隐藏文件；
- `-A`：显示除影藏文件“.”和“..”以外的所有文件列表；
- `-F`：在每个输出项后追加文件的类型标识符，具体含义：“*”表示具有可执行权限的普通文件，“/”表示目录，“@”表示符号链接，“|”表示命令管道FIFO，“=”表示sockets套接字。当文件为普通文件时，不输出任何标识符；
- `-m`：用“,”号区隔每个文件和目录的名称；

### 例子

- 列出目前工作目录下所有名称是 s 开头的文件，越新的排越后面 :

  ```
  ls -ltr s*
  ```

- 将 /bin 目录以下所有目录及文件详细资料列出 :

  ```
  ls -lR /bin
  ```

- 列出目前工作目录下所有文件及目录；目录于名称后加 "/", 可执行档于名称后加 "*" :

  ```
  ls -AF   
  ```

- 水平输出文件列表

  ```
  $ ls -m
  bin, boot, data, dev, etc, home, lib, lost+found, media, misc, mnt, opt, proc, root, sbin, selinux, srv, sys, tmp, usr, vark
  ```

- 只列出文件夹

  ```
  ls -F | grep '/$'
  
  ls -d */
  ```

## mkdir

make directory用于创建目录。

### 语法

```
mkdir (选项)(参数)
```

选项：

- `-p`：确保目录名称存在，不存在的就建一个。

- `-m<目标属性>`或`--mode<目标属性>`建立目录的同时设置目录的权限；

### 例子

在目录`/usr/meng`下建立子目录[test](http://man.linuxde.net/test)，并且只有文件主有读、写和执行权限，其他人无权访问：

```
mkdir -m 700 /usr/meng/test
```

## pwd

print work directory 显示出当前工作目录的绝对路径

### 语法

```
pwd [--help][--version]
```

选项：

- `--help` 在线帮助。
- `--version` 显示版本信息。

## rmdir

Remove Directory从一个目录中删除一个或多个空的子目录

### 语法

```
rmdir [-p] dirName
```

选项：

- `-p` ：当子目录被删除后使它也成为空目录的话，则顺便一并删除。
- `-rf` ：强制删除

### 例子

在工作目录下的 BBB 目录中，删除名为 Test 的子目录。若 Test 删除后，BBB 目录成为空目录，则 BBB 亦予删除。

```
rmdir -p BBB/Test
```







# 磁盘维护





# 网络通讯





# 系统管理

## top

用于实时显示 process 的动态。更强大的是htop命令。

### 语法

```
top [-] [d delay] [q] [c] [S] [s] [i] [n] [b]
```

选项：

- `-n` : 更新的次数，完成后将会退出 top
- `-d`：改变显示的更新速度
- `-p<进程号>`：指定进程；
- `-u<用户名>`：指定用户名；

交互命令：

- `q` ：退出程序

- `1`：可监控每个逻辑CPU的状况
- `b`：高亮显示当前运行进程

### 例子

- 显示进程信息，查看该服务器当前有哪些计算进程，CPU占用率多大等等，按ctrl c退出。

  ```
  top
  ```
  - 会显示：
    - `top - 13:54:36`：当前时间；`363 days`：系统运行时间；`13 users`：登陆的用户数目；`load average:1.89, 2.12, 2.57`：系统负载，即任务队列的平均长度
    - `Tasks: 528 total`：总进程数；`1 running`：正在运行的进程数；`507 sleeping`：睡眠的进程数；`20 stopped`：停止的进程数；`0 zombie`：冻结进程数
    - `%Cpu(s):  0.5 us`：用户空间占用CPU百分比；`1.2 sy`  ：内核空间占用CPU百分比`0.0 ni`：用户进程空间内改变过优先级的进程占用CPU百分比；`94.4 id`：空闲CPU百分比；`3.9 wa`：等待输入输出的CPU时间百分比
    - `KiB Mem : 19649531+total`：物理内存总量；`2547788 free`：空闲内存总量；`9682144 used`：使用的物理内存总量；`18426537+buff/cache`：用作内核缓存的内存量；`KiB Swap: 32767996 total`：交换区总量
  ```
  top - 13:54:36 up 363 days,  1:51, 13 users,  load average: 1.89, 2.12, 2.57
  Tasks: 528 total,   1 running, 507 sleeping,  20 stopped,   0 zombie
  %Cpu(s):  0.5 us,  1.2 sy,  0.0 ni, 94.4 id,  3.9 wa,  0.0 hi,  0.1 si,  0.0 st
  KiB Mem : 19649531+total,  2547788 free,  9682144 used, 18426537+buff/cache
  KiB Swap: 32767996 total, 28063200 free,  4704796 used. 18375868+avail Mem
  ```


- 更新两次后终止更新显示

  ```
  top -n 2
  ```

- 更新周期为3秒

  ```
  top -d 3
  ```

- 显示进程号为139的进程信息，CPU、内存占用率等

  ```
  top -p 139
  ```

# 系统设置



# 备份压缩

## tar

Tape archive （磁带档案）。tar是用来建立，还原备份文件的工具程序，它可以加入，解开备份文件内的文件。

- 打包是指将一大堆文件或目录变成一个总的文件；压缩则是将一个大的文件通过一些压缩算法变成一个小文件。
- 利用tar命令，可以把一大堆的文件和目录全部打包成一个文件，这对于备份文件或将几个文件组合成为一个文件以便于网络传输是非常有用的。
- 打包成一个包后，再用压缩程序进行压缩（gzip bzip2命令）等。

### 语法

```
tar(选项)(参数)
```

选项：

- `-c`或`--create`：建立新的备份文件；
- `-f`：<备份文件>或--file=<备份文件> 指定备份文件。
- `-j`：支持bzip2解压文件；
- `-N<日期格式>`或`--newer=<日期时间>`：只将较指定日期更新的文件保存到备份文件里。
- `-p`或`--same-permissions`：用原来的文件权限还原文件；
- `-t`或`--list`：列出备份文件的内容。
- `-v`或`--verbose`：显示指令执行过程。
- `-x`或`--extract`或`--get`：从备份文件中还原文件；
- `-z`或`--gzip`或`--ungzip` ：通过gzip指令处理备份文件。
- `--exclude=<范本样式>`：排除符合范本样式的文件。

### 例子

#### 将文件全部打包成tar包

- 仅打包，不压缩。在选项`f`之后的文件档名是自己取的，习惯上都用 .tar 来作为辨识。 

  ```
  tar -cvf log.tar log2012.log
  ```

- <font color=red>打包后，以 gzip 压缩 </font>。如果加`z`选项，则以.tar.gz或.tgz来代表gzip压缩过的tar包

  ```
  tar -czvf log.tar.gz log2012.log
  ```

- 打包后，以 bzip2 压缩 ，如果加`j`选项，则以.tar.bz2来作为tar包名。

  ```
  tar -jcvf log.tar.bz2 log2012.log
  ```

- 文件备份下来，并且保存其权限：当要保留原本文件的属性，需要用`-P`

  ```
  tar -zcvpf log31.tar.gz log2014.log log2015.log log2016.log
  ```

- 在文件夹当中，比某个日期新的文件才备份

  ```
  tar -N "2012/11/13" -zcvf log17.tar.gz test
  ```

- 备份文件夹内容是排除部分文件

  ```
  tar --exclude scf/service -zcvf scf.tar.gz scf/*
  ```

#### 查阅tar包内有哪些文件

- <font color=red>查询</font>：使用gzip压缩的log.tar.gz，在查阅log.tar.gz包内的文件时，要加上`z`这个选项

  ```
  tar -tzvf log.tar.gz
  ```

#### 将tar包解压缩

- <font color=red>全部解压</font>

  ```
  tar -xzvf /opt/soft/test/log.tar.gz
  ```

- 只将tar内的部分文件解压出来

  ```
  tar -xzvf /opt/soft/test/log30.tar.gz log2013.log
  ```

# 设备管理





# 其他命令

## bc

任意精度计算器语言。bash内置了对整数四则运算的支持，但是并不支持浮点运算，而bc可以。

### 语法

```
bc(选项)(参数)
```

通常和管道符一起使用

### 例子

#### 运算

常用的运算

- `+`加法
- `-` 减法
- `*` 乘法
- `/` 除法
- `^` 指数
- `%` 余数

乘法：

```
$ echo "1.212*3" | bc 
3.636
```

计算平方和平方根：

```
echo "10^10" | bc
echo "sqrt(100)" | bc
```

#### 设定小数精度（数值范围）

参数`scale=2`是将bc输出结果的小数位设置为2位。

```shell
$ echo "scale=2;3/8" | bc
0.37
```

#### 进制转换：

- 将十进制转换成二进制：

  ```
  #!/bin/bash
  abc=192
  echo "obase=2;$abc" | bc
  ```

- 将二进制转换为十进制：

  ```
  #!/bin/bash
  abc=11000000
  echo "obase=10;ibase=2;$abc" | bc
  ```

## tail

用于查看输入文件中的尾部内容。tail命令默认在屏幕上显示指定文件的末尾10行。

### 语法

```
tail(选项)(参数)
```

参数：

- `-f` ：循环读取
- `-q` ：不显示处理信息
- `-v` ：显示详细的处理信息，当有多个文件参数时，总是输出各个文件名。
- `-q`或`--quiet`或`--silent`：当有多个文件参数时，不输出各个文件名；
- `-c<数目>` ：显示的字节数
- `-n<行数>` 或`——line=<N>`：显示文件的尾部 n 行内容
- `-s<秒数>`, `——sleep-interal=<秒数>` 与`-f`合用，指定监视文件变化时间隔的秒数。

### 例子

- 显示 notes.log 文件的最后 10 行：

  ```
  tail notes.log
  ```

- 跟踪名为 notes.log 的文件的增长情况，直到按下Ctrl+C组合键停止显示：

  ```
  tail -f notes.log
  ```

- 显示文件 notes.log 的内容，从第 20 行至文件末尾:

  ```
  tail +20 notes.log
  ```

- 显示文件 notes.log 的最后 10 个字符:

  ```
  tail -c 10 notes.log
  ```

## xargs

-  eXtended ARGuments，是给命令传递参数的一个过滤器，也是组合多个命令的一个工具。
- 它能够捕获一个命令的输出，然后传递给另外一个命令。

### 语法

- 一般是和管道一起使用。

```
somecommand |xargs -item  command
```

- xargs的默认命令是`echo`，空格是默认定界符。

### 例子

#### 格式化输入

- 将test文件中的多行变成一行：

  ```
  cat test.txt | xargs
  ```

- `-n` 选项多行输出，将test文件中的三个一行输出多

  ```
  cat test.txt | xargs -n3
  ```

- `-d` 选项可以自定义一个定界符：

  ```shell
  $ echo "nameXnameXnameXname" | xargs -dX
  name name name name
  
  $  echo "nameXnameXnameXname" | xargs -dX -n2
  name name
  name name
  ```

#### 替换字符串{}

- 复制所有图片文件到 /data/images 目录下：

  ```shell
  ls *.jpg | xargs -n1 -I cp {} /data/images
  ```

#### 结合find使用

- 删除文件

  ```
  find . -type f -name "*.log" -print0 | xargs -0 rm -f
  ```

- 统计一个源代码目录中所有 php 文件的行数：

  ```
  find . -type f -name "*.php" -print0 | xargs -0 wc -l
  ```

- 查找所有的 jpg 文件，并且压缩它们

  ```
  find . -type f -name "*.jpg" -print | xargs tar -czvf images.tar.gz
  ```

- 替换文件内容

  ```
  find . -type f | xargs perl -pi -e 's|_NR|_SR|g'
  ```

  

