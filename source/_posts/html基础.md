---
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

# HTML标签/元素

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

## 元素分类

### 块状元素

- `<div>`、`<p>`、`<h1>`、`<ol>`、`<ul>`、`<dl>`、`<table>`、`<address>`、`<blockquote>`, `<form>`
  - 每个块级元素都从新的一行开始，并且其后的元素也另起一行。
  - 元素的高度、宽度、行高以及顶和底边距都可设置。
  - 元素宽度在不设置的情况下，是它本身父容器的100%(和父元素的宽度一致），除非设定一个宽度。

### 内联元素(行内元素)

- `<a>`、`<span>`、`<br>`、`<i>`、`<em>`、`<strong>`、`<label>`、`<q>`、`<Var>`、`<cite>`、`<code>`
  - 和其他元素都在一行上。
  - 元素的高度、宽度及顶部和底部边距不可设置。
  - 元素的宽度就是它包含的文字或图片的宽度，不可改变。

### 内联块状元素

- `<img>`、`<input>`
  - 和其他元素都在一行上。
  - 元素的高度、宽度、行高以及顶和底边距都可设置。

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

- 空链接，点击空链接会返回顶部，实际上等于刷新了该页面

  ```html
  <a href="#">空链接</a>
  ```

- 如果在当前页面链接到指定位置，则可以使用`id`或者`name`属性

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

- 通过标签`img`来定义，`<img>` 是空标签，意思是说，它只包含属性，并且没有闭合标签。

- 要在页面上显示图像，你需要使用源属性（src）。src 指 "source"。源属性的值是图像的 URL 地址。语法：

  - URL 指存储图像的位置。加载页面时，要注意插入页面图像的路径，如果不能正确设置图像的位置，浏览器无法加载图片，图像标签就会显示一个破碎的图片。
  - alt 属性用来为图像定义一串预备的可替换的文本

  ```html
  <img src="url" alt="some_text">
  ```

- height（高度） 与 width（宽度）属性用于设置图像的高度与宽度。 指定图像的高度和宽度是一个很好的习惯。如果图像指定了高度宽度，页面加载时就会保留指定的尺寸。如果没有指定图片的大小，加载页面时有可能会破坏HTML页面的整体布局。

  - 为了防止更改图片的比例，可以只设定高度或者宽度

  ```html
  <img src="pulpit.jpg" alt="Pulpit rock" width="304" height="228">
  ```

- 图像的名称使用`tltle`定义

  ```html
  <img loading="lazy" src="/images/logo.png" width="258" height="39" />
  ```

- 排列图片，用`align`。在HTML 4中 align 属性已废弃，HTML5 已不支持该属性，可以使用 CSS 代替。

  ```html
  <h4>默认对齐的图像 (align="bottom"):</h4>
  <p>这是一些文本。 <img src="smiley.gif" alt="Smiley face" width="32" height="32"> 这是一些文本。</p>
  
  <h4>图片使用 align="middle":</h4>
  <p>这是一些文本。 <img src="smiley.gif" alt="Smiley face" align="middle" width="32" height="32">这是一些文本。</p>
  
  <h4>图片使用 align="top":</h4>
  <p>这是一些文本。 <img src="smiley.gif" alt="Smiley face" align="top" width="32" height="32">这是一些文本。</p>
  ```

- `border`设置图片边框

  ```html
  <p>创建图片链接:
  <a href="//www.runoob.com/html/html-tutorial.html">
  <img  border="10" src="smiley.gif" alt="HTML 教程" width="32" height="32"></a></p>
  ```

- 用`usemap`和`<map>`（定义图像地图）创建带有可供点击区域的图像地图。其中的每个区域都是一个超级链接。`<area>` 定义图像地图中的可点击区域。

  - `shape`指的是点击区域的形状，`coords`指链接区域在图片中的坐标（像素为单位）
    - `rect`：矩形，(左上角顶点坐标为(x1,y1)，右下角顶点坐标为(x2,y2))
    - `circle`：圆形：(圆心坐标为(X1,y1)，半径为r)
    - `poly`：多边形：(各顶点坐标依次为(x1,y1)、(x2,y2)、(x3,y3) ......)

  ```html
  <p>点击太阳或其他行星，注意变化：</p>
  
  <img src="planets.gif" width="145" height="126" alt="Planets" usemap="#planetmap">
  
  <map name="planetmap">
    <area shape="rect" coords="0,0,82,126" alt="Sun" href="sun.htm">
    <area shape="circle" coords="90,58,3" alt="Mercury" href="mercur.htm">
    <area shape="circle" coords="124,58,8" alt="Venus" href="venus.htm">
  </map>
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

# HTML表格

- 表格由 `<table>` 标签来定义。
- 每个表格均有若干行（由 `<tr>` 标签定义）
- 每行被分割为若干单元格（由 `<td>` 标签定义）。字母 td 指表格数据（table data），即数据单元格的内容。数据单元格可以包含文本、图片、列表、段落、表单、水平线、表格等等。

```html
<table border="1">
  <caption>Monthly savings</caption>
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>
  <tr>
    <td>January</td>
    <td>$100</td>
  </tr>
  <tr>
    <td>February</td>
    <td>$50</td>
  </tr>
</table>
```

- 表格和边框属性：如果不定义边框属性，表格将不显示边框，可以直接去掉`border`，也可以设置为`border="0"`

- 表格表头：使用 `<th>` 标签进行定义，大多数浏览器会把表头显示为粗体居中的文本。

  ```html
  <h4>水平标题:</h4>
  <table border="1">
  <tr>
    <th>Name</th>
    <th>Telephone</th>
    <th>Telephone</th>
  </tr>
  <tr>
    <td>Bill Gates</td>
    <td>555 77 854</td>
    <td>555 77 855</td>
  </tr>
  </table>
  
  <h4>垂直标题:</h4>
  <table border="1">
  <tr>
    <th>First Name:</th>
    <td>Bill Gates</td>
  </tr>
  <tr>
    <th>Telephone:</th>
    <td>555 77 854</td>
  </tr>
  <tr>
    <th>Telephone:</th>
    <td>555 77 855</td>
  </tr>
  </table>
  ```

- 表格标题用`<caption>`定义

- 定义跨行或跨列的表格单元格：

  ```html
  <h4>单元格跨两列:</h4>
  <table border="1">
  <tr>
    <th>Name</th>
    <th colspan="2">Telephone</th>
  </tr>
  <tr>
    <td>Bill Gates</td>
    <td>555 77 854</td>
    <td>555 77 855</td>
  </tr>
  </table>
  
  <h4>单元格跨两行:</h4>
  <table border="1">
  <tr>
    <th>First Name:</th>
    <td>Bill Gates</td>
  </tr>
  <tr>
    <th rowspan="2">Telephone:</th>
    <td>555 77 854</td>
  </tr>
  <tr>
    <td>555 77 855</td>
  </tr>
  </table>
  ```

- 在不同的表格元素内显示其他元素，比如：

  ```html
  <table border="1">
  <tr>
    <td>
     <p>这是一个段落</p>
     <p>这是另一个段落</p>
    </td>
    <td>这个单元格包含一个表格:
     <table border="1">
     <tr>
       <td>A</td>
       <td>B</td>
     </tr>
     <tr>
       <td>C</td>
       <td>D</td>
     </tr>
     </table>
    </td>
  </tr>
  <tr>
    <td>这个单元格包含一个列表
     <ul>
      <li>apples</li>
      <li>bananas</li>
      <li>pineapples</li>
     </ul>
    </td>
    <td>HELLO</td>
  </tr>
  </table>
  ```

- 设置单元格边距：

  ```html
  <table border="1" 
  cellpadding="10">
  <tr>
    <td>First</td>
    <td>Row</td>
  </tr>   
  <tr>
    <td>Second</td>
    <td>Row</td>
  </tr>
  </table>
  ```

- 设置单元格之间的间距，即边框的宽度

  ```html
  <table border="1" cellspacing="0">
  <tr>
    <td>First</td>
    <td>Row</td>
  </tr>
  <tr>
    <td>Second</td>
    <td>Row</td>
  </tr>
  </table>
  ```

- `<colgroup>`定义表格列的组，以便对其进行格式化。可以向整个列应用样式，而不需要重复为每个单元格或每一行设置样式。只能在 `<table>` 元素之内，在任何一个 `<caption>` 元素之后，在任何一个 `<thead>`、`<tbody>`、`<tfoot>`、`<tr>` 元素之前使用 。

  - `<col>`用于表格列的属性

  ```html
  <table border="1">
    <colgroup>
      <col span="2" style="background-color:red">
      <col style="background-color:yellow">
    </colgroup>
    <tr>
      <th>ISBN</th>
      <th>Title</th>
      <th>Price</th>
    </tr>
    <tr>
      <td>3476896</td>
      <td>My first HTML</td>
      <td>$53</td>
    </tr>
  </table>
  ```

-  thead, tbody, 和 tfoot 元素定义表格的页眉、主体、页脚。这些元素默认不会影响表格的布局。可以使用 CSS 来为这些元素定义样式，从而改变表格的外观。

# HTML列表

- 无序列表是一个项目的列表，此列项目使用粗体圆点（典型的小黑圆圈）进行标记。使用 `<ul>` 标签。

  - 可以通过`style`属性定义标记，但是在 HTML 4中 `ul` 属性已废弃，HTML5 已不支持该属性，可以使用 CSS 代替来定义：
    - "list-style-type:disc"是圆点列表
    - "list-style-type:circle"是圆圈列表
    - style="list-style-type:square"是正方形列表

  ```html
  <ul>
  <li>Coffee</li>
  <li>Milk</li>
  </ul>
  ```

- 有序列表使用数字进行标记。 有序列表始于 `<ol>` 标签。每个列表项始于 `<li>` 标签。

  - ol标签中可以增加`start`属性，表明数字从多少开始
  - `type`属性定义列表属性
    - "A"是大写字母列表
    - "a"是小写字母列表
    - "I"是罗马数字列表
    - "i"是小写罗马数字列表

  ```html
  <ol>
  <li>Coffee</li>
  <li>Milk</li>
  </ol>
  ```

- 自定义列表不仅仅是一列项目，而是项目及其注释的组合。自定义列表以 `<dl>` 标签开始。每个自定义列表项以 `<dt>` 开始。每个自定义列表项的定义以 `<dd>` 开始。

  ```html
  <dl>
  <dt>Coffee</dt>
  <dd>- black hot drink</dd>
  <dt>Milk</dt>
  <dd>- white cold drink</dd>
  </dl>
  ```

- 列表项内部可以使用段落、换行符、图片、链接以及其他列表等

  - 嵌套列表

    ```html
    <ul>
      <li>Coffee</li>
      <li>Tea
        <ul>
          <li>Black tea</li>
          <li>Green tea</li>
        </ul>
      </li>
      <li>Milk</li>
    </ul>
    ```

- 如果不想要列表前面的项目号，可以通过css在`li`的里面添加`list-style: none;`

# HTML` <div> `和`<span>`

## 块级元素和内联元素

- 块级元素在浏览器显示时，通常会以新行来开始（和结束）。比如`<h1>`, <p>, `<ul>`, `<table>`
- 内联元素在显示时通常不会以新行开始。比如`<b>`, `<td>`, `<a>`, `<img>`

## ` <div> `

- `<div> `元素没有特定的含义，可用于组合其他 HTML 元素的容器，成为块级元素。浏览器会在其前后显示折行。
- 如果与 CSS 一同使用，`<div>` 元素可用于对大的内容块设置样式属性。
- `<div> `元素的另一个常见的用途是文档布局。它取代了使用表格定义布局的老式方法。使用 `<table>` 元素进行文档布局不是表格的正确用法。`<table>` 元素的作用是显示表格化的数据。

## `<span>`

- ` <span> `没有特定的含义，是内联元素，可用作文本的容器。
- 当与 CSS 一同使用时，`<span>` 元素可用于为部分文本设置样式属性。