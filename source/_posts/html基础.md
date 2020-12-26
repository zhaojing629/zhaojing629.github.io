---
layout: psot
title: html基础
date: 2020-12-25 16:40:53
updated: 
description: 关于Html的基础内容学习
tags: [html]
categories: 网站
typora-root-url: html基础
---

# HTML简介

- HTML 不是一种编程语言，指的是超文本标记语言 (**H**yper **T**ext **M**arkup **L**anguage)。标记语言是一套标记标签 (markup tag)，即使用标记标签来描述网页
- 保存 HTML 文件时，既可以使用 `.htm` 也可以使用 `.html` 扩展名。两者没有区别'
- HTML文档也叫做 web 页面

# HTML基本结构

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>网页的标题</title>
	</head>
	<body>
 		<h1>我的第一个标题</h1>
 		<p>我的第一个段落。</p>
 	</body>
</html>
```

## `<!DOCTYPE>`

- 用于声明网页版本，不区分大小写
- `<!DOCTYPE>` 声明位于文档中的最前面的位置，处于` <html> `标签之前。

- HTML5（2012年发布）

  ```html
  <!DOCTYPE html>
  ```

- HTML 4.01（1999年发布）

  ```html
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
  ```

- XHTML 1.0（2020年发布）

  ```html
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  ```

## `<html>` 

- HTML页面的根元素，`<html>` 标签告知浏览器这是一个 HTML 文档。
- 是 HTML 文档中最外层的元素。
- 是所有其他 HTML 元素（除了 <!DOCTYPE> 标签）的容器。

### `<head>` 

- `<head>` 元素包含了所有的头部标签元素。在 `<head>`元素中你可以插入脚本（scripts）, 样式文件（CSS），及各种meta信息。
- 可以添加在头部区域的元素标签为: `<title>`, `<style>`, `<meta>`, `<link>`, `<script>`, `<noscript>` 和 `<base>`。

#### `<meta>`

- 描述了一些基本的元数据。元数据也不显示在页面上，但会被浏览器解析。
- 通常用于指定网页的描述，关键词，文件的最后修改时间，作者，和其他元数据。
- 元数据可以使用于浏览器（如何显示内容或重新加载页面），搜索引擎（关键词），或其他Web服务。

- 对于中文网页需要使用 `<meta charset="utf-8">` 定义网页编码格式为 utf-8，否则会出现乱码。

- 有些浏览器会设置 GBK 为默认编码，则需要设置为 `<meta charset="gbk">`

- 为搜索引擎定义关键词:

  ```html
  <meta name="keywords" content="HTML, CSS, XML, XHTML, JavaScript">
  ```

- 为网页定义描述内容：

  ```html
  <meta name="description" content="免费 Web & 编程 教程">
  ```

- 定义网页作者：

  ```html
  <meta name="author" content="Runoob">
  ```

- 每30秒钟刷新当前页面:

  ```html
  <meta http-equiv="refresh" content="30">
  ```

#### `<title>` 

- 描述了文档的标题，是不可少的
- 当网页添加到收藏夹时，显示在收藏夹中的标题
- 显示在搜索引擎结果页面的标题

#### ` <base>`

- 描述了基本的链接地址/链接目标，该标签作为HTML文档中所有的链接标签的默认链接

  ```html
  <head>
  <base href="http://www.runoob.com/images/" target="_blank">
  </head>
  ```

#### `<link> `

- 定义了文档与外部资源之间的关系，通常用于链接到样式表

  ```html
  <head>
  <link rel="stylesheet" type="text/css" href="mystyle.css">
  </head>
  ```

#### ` <style> `

- 定义了HTML文档的样式文件引用地址

- 也可以直接添加样式来渲染 HTML 文档

  ```html
  <head>
  <style type="text/css">
  body {background-color:yellow}
  p {color:blue}
  </style>
  </head>
  ```

#### `<script> `

- 用于加载脚本文件，如： JavaScript。

### `<body>` 

包含可见的页面内容，只有` <body> `部分才会在浏览器中显示。

# HTML标签

## 语法

- HTML标签是由尖括号包围的关键词，通常是成对出现的。标签对中的第一个标签是开始标签，第二个标签是结束标签。

  ```html
  <标签>内容</标签>
  ```

  - 开始标签常被称为起始标签（opening tag）
  - 结束标签常称为闭合标签（closing tag）

- HTML 标签=HTML 元素，但是严格来讲, 一个HTML元素包含了开始标签、内容和结束标签。


- 没有内容的 HTML 元素被称为空元素，不需要闭合标签，但是最好在开始标签中关闭空元素，用`< />`封装。
- HTML标签对大小写不敏感，但是最好用小写。
- 大多数HTML元素可以嵌套（HTML元素可以包含其他 HTML 元素）。

## 基本标签

### 标题

- 通过 `<h1>` - `<h6>` 标签进行定义，由大到小，字体会加粗，大小也会由大到小。但是不要为了生成粗体或大号的文本而使用标题，因为搜索引擎会使用标题为网页的结构和内容编制索引。

- 浏览器会自动地在标题的前后添加空行。

  ```html
  <h1>这是一个标题</h1>
  <h2>这是一个标题</h2>
  <h3>这是一个标题</h3>
  ```

### 段落

- 通过`<p>`定义HTML 文档中的一个段落。

- 浏览器会自动地在段落的前后添加空行。（`</p>` 是块级元素）

  ```html
  <p>这是一个段落。</p>
  <p>这是另外一个段落。</p>
  ```

- 无法通过在HTML元素的内容中添加额外的空格或换行来改变输出的效果。

  - 当显示页面时，浏览器会移除源代码中多余的空格和空行。所有连续的空格或空行都会被算作一个空格。

  - 所有连续的空行（换行）也被显示为一个空格。如果需要换行，需要用`<br>`。

    ```html
    <p>这个<br>段落<br>演示了分行的效果</p>
    ```

  - 如果需要控制空行和空格，也可以使用定义预格式文本的标签`<pre>`

    ```html
    <pre>
    使用 pre 标签
    对空行和    空格
    进行控制
    </pre>
    ```

#### 换行

- 可以在不产生一个新段落的情况下进行换行，即和上一行之间不会有空行。

  ```html
  <!-- 没有关闭标签的空元素 -->
  <br>
  <!-- 关闭空元素 -->
  <br />
  ```

#### 分割线

- 可用于分隔内容

  ```html
  <p>这是一个段落。</p>
  <hr>
  <p>这是一个段落。</p>
  <hr>
  <p>这是一个段落。</p>
  ```

### 链接

- 通过`a`来定义HTML链接，超链接可以是一个字，一个词，或者一组词，也可以是一幅图像，您可以点击这些内容来跳转到新的文档或者当前文档中的某个部分。

- 链接的地址在`href`属性中指定：

  ```html
  <a href="https://www.runoob.com">这是一个链接</a>
  ```

- 如果希望链接在新窗口打开，则可以将 target 属性设置为 "_blank"：

  ```html
  <a href="https://www.runoob.com/" target="_blank" rel="noopener noreferrer">访问菜鸟教程!</a>
  ```

- 如果在当前页面链接到指定位置，则可以使用`id`属性

  - 首先给要访问的地方加一个属性

    ```html
    <a id="tips">有用的提示部分</a>
    ```

  - 在HTML文档中创建一个链接到此处

    ```html
    <a href="#tips">访问有用的提示部分</a>
    ```

  - 也可以访问另一个网页中的部分

    ```html
    <a href="https://www.runoob.com/html/html-links.html#tips">
    访问有用的提示部分</a>
    ```

- 发送邮件

  - `Subject`后面跟的是邮件的主题

  - 单词之间的空格使用`%20`代替，以确保浏览器可以正常显示文本。

    ```html
    <p>
    这是一个电子邮件链接：
    <a href="mailto:someone@example.com?Subject=Hello%20again" target="_top">
    发送邮件</a>
    </p>
    ```

  - `cc`后面跟的是抄送地址

  - `bcc`后面跟的是密件抄送

  - `body`后面跟的是邮件内容

    ```html
    <p>
    这是另一个电子邮件链接：
    <a href="mailto:someone@example.com?cc=someoneelse@example.com&bcc=andsomeoneelse@example.com&subject=Summer%20Party&body=You%20are%20invited%20to%20a%20big%20summer%20party!" target="_top">发送邮件!</a>
    </p>
    <p>
    <b>注意:</b> 单词之间的空格使用 %20 代替，以确保浏览器可以正常显示文本。
    </p>
    ```

    

### 图像

- 通过标签`img`来定义

-  图像的名称和尺寸是以属性的形式提供的

  ```html
  <img loading="lazy" src="/images/logo.png" width="258" height="39" />
  ```

### 注释

- 浏览器会忽略注释，也不会显示它们。开始括号之后（左边的括号）需要紧跟一个叹号，结束括号之前（右边的括号）不需要。

  ```html
  <!-- 这是一个注释 -->
  ```

# HTML属性

## 语法

- 属性值应该始终被包括在引号内，一般放在开始标签中，形式一般是`name=“value”`，

- 单引号也可以，如果属性值本身就含有双引号，必须使用单引号：

  ```html
  name='John "ShotGun" Nelson'
  ```

- 属性和属性值对大小写不敏感，最好小写。

## 基本属性

- class：为html元素定义一个或多个类名（classname）(类名从样式文件引入)
- id：定义元素的唯一id
- style：规定元素的行内样式（inline style）
- title：描述了元素的额外信息 (作为工具条使用)

# HTML文本格式化

## 粗体和斜体

- HTML使用标签 `<b>`(bold) 与 `<i>`(italic) 对文本加粗和斜体

```html
<b>加粗文本</b><br><br>
<i>斜体文本</i><br><br>
```

- 也可以用标签 `<strong>` , `<em>` 来加粗和斜体，这两个标签除了对文本格式化，还表示文本是重要的，所以要突出显示。

## 上下标

```html
<sub> 下标</sub>
<sup> 上标</sup>
```

## 大小

- `<small>`定义小号字
- `<big>`定义大号字

```html
<big>这个文本字体放大</big>
<small>这个文本是缩小的</small>
```

## 计算机/编程代码

- `<code>`定义计算机代码
- `<kbd>`定义键盘码
- `<samp>`定义计算机代码样本
- `<var>`定义变量

```html
<code>计算机输出</code>
<br />
<kbd>键盘输入</kbd>
<br />
<tt>打字机文本</tt>
<br />
<samp>计算机代码样本</samp>
<br />
<var>计算机变量</var>
<br />
```

## 地址

- `<address>`定义地址

```html
<address>
Written by <a href="mailto:webmaster@example.com">Jon Doe</a>.<br> 
Visit us at:<br>
Example.com<br>
Box 564, Disneyland<br>
USA
</address>
```

## 文字方向

- `<bdo>`定义文字方向

```html
<p><bdo dir="rtl">该段落文字从右到左显示。</bdo></p> 
```

## 块引用

- `<blockquote>`定义长的引用
- `<q>`定义短的引用
- `<cite>`定义引用、引证
- `<dfn>`定义一个定义项目。

```html
<p>WWF's goal is to: 
<q>Build a future where people live in harmony with nature.</q>
We hope they succeed.</p>
```

## 删除和插入

```html
<p>My favorite color is <del>blue</del> <ins>red</ins>!</p>
```

# HTML CSS

