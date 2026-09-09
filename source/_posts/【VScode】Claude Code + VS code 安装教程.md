---
title: 【VScode】Claude Code + VS code 安装教程
date: 2026-07-07 19:01:00
updated:
tags: [Claude, vscode, deepseek]
categories: [办公, 软件]
typora-root-url: 【VScode】Claude Code + VS code 安装教程
description: 通过npm安装Claude和使用Vscode使用、一些vscode日常使用记录
---
# 安装Claude
参考来源：https://zhuanlan.zhihu.com/p/2004150496781410721
1. 首先安装好[Git](https://git-scm.com/)和[Node.js](https://nodejs.org/en/)

2. 使用npm全局安装：
	```
	npm install -g @anthropic-ai/claude-code
	```
	
3. 安装完成后验证：

   ```
   claude --version
   ```

# 安装VScode+Claude
参考来源：https://zhuanlan.zhihu.com/p/2038567190648074568
1. VScode官网下载安装即可

2. 在扩展里输入“Chinese”下载第一个更改语言

3. 在扩展里搜索“claude code”安装“claude code for vs code”

4. 进入“claude code for vs code”的设置界面，找到在 settings.json中编辑
	下面的json可从提示位置直接复制粘贴，注意代码中记得换上你自己申请的deepseek密钥。
	以下添加的配置本质就是更改了claude code的环境变量，让其调用deepseek-v4大模型。
	
	```
	{
	    "files.autoSave": "onWindowChange",
	    //"python.defaultInterpreterPath": "D:\\software\\anaconda3\\python.exe",
	    "notebook.output.textLineLimit": 50,
	    "notebook.output.linkifyFilePaths": false,
	    "workbench.editor.enablePreview": false,
	    "workbench.colorTheme": "One Dark Modern",
	    "vscode-office.pasterImgPath": "${fileName}.assets/${now}.png",
	    "comments.openView": "never",
	    "workbench.statusBar.visible": false,
	    "vscode-office.openOutline": false,
	    "chat.viewSessions.orientation": "stacked",
	    "claudeCode.enableNewConversationShortcut": true,
	
	
	//*************************上面的部分可根据自己需要保留配置，以下部分直接复制粘贴即可******************************
	    "claudeCode.environmentVariables": [
	        {
	            "name": "ANTHROPIC_BASE_URL",
	            "value": "https://api.deepseek.com/anthropic"
	        },
	        {
	            "name": "ANTHROPIC_AUTH_TOKEN",
	            "value": "xxxxxxxxxxxxxxxxxxxxxxxxxxx" //换上你自己申请的API 密钥*****************************************
	        },
	        {
	            "name": "API_TIMEOUT_MS",
	            "value": "600000"
	        },
	        {
	            "name": "ANTHROPIC_MODEL",
	            "value": "deepseek-v4-pro"
	        },
	        {
	            "name": "ANTHROPIC_SMALL_FAST_MODEL",
	            "value": "deepseek-v4-flash"
	        },
	        {
	            "name": "ANTHROPIC_DEFAULT_OPUS_MODEL",
	            "value": "deepseek-v4-pro"
	        },
	        {
	            "name": "ANTHROPIC_DEFAULT_SONNET_MODEL",
	            "value": "deepseek-v4-pro"
	        },
	        {
	            "name": "ANTHROPIC_DEFAULT_HAIKU_MODEL",
	            "value": "deepseek-v4-flash"
	        }
	  ]
	}
	```
	
	

# VS code插件等记录

## 修改settings.json

按Ctrl + Shift + P，然后输入：
`Preferences: Open User Settings (JSON)`
，点进去就会直接打开 `settings.json`。

如果是中文界面，可以搜：`首选项: 打开用户设置(JSON)`

## 修改资源管理器缩进

打开 `settings.json`，加入：

```
{
    "workbench.tree.indent": 20,
    "workbench.tree.renderIndentGuides": "always",
    "explorer.compactFolders": false
}
```

- `workbench.tree.indent`: 增大每一级目录的缩进。默认层级比较挤，改成 `18~24` 会明显很多。VS Code 官方支持这个设置。
- `workbench.tree.renderIndentGuides: "always"`：始终显示目录树的竖向层级线，而不是只有鼠标放上去时才显示。
- `explorer.compactFolders: false`：我非常建议你关闭。VS Code 默认会把只有一个子目录的连续目录压缩到一行，比如：

```
src/main/java/com/example
```

关闭以后会变成：

```
src
└─ main
   └─ java
      └─ com
         └─ example
```

层级会清楚很多。这个“Compact Folders”本来就是 VS Code 默认开启的。



## 终端美化

[Base16 Terminal Colors for Visual Studio Code](https://glitchbone.github.io/vscode-base16-term/#/)

把在里面复制的代码复制到 `settings.json`，

```
    "workbench.colorCustomizations": {
        "terminal.background":"#090300",
        "terminal.foreground":"#A5A2A2",
        "terminalCursor.background":"#A5A2A2",
        "terminalCursor.foreground":"#A5A2A2",
        "terminal.ansiBlack":"#090300",
        "terminal.ansiBlue":"#01A0E4",
        "terminal.ansiBrightBlack":"#5C5855",
        "terminal.ansiBrightBlue":"#01A0E4",
        "terminal.ansiBrightCyan":"#B5E4F4",
        "terminal.ansiBrightGreen":"#01A252",
        "terminal.ansiBrightMagenta":"#A16A94",
        "terminal.ansiBrightRed":"#DB2D20",
        "terminal.ansiBrightWhite":"#F7F7F7",
        "terminal.ansiBrightYellow":"#FDED02",
        "terminal.ansiCyan":"#B5E4F4",
        "terminal.ansiGreen":"#01A252",
        "terminal.ansiMagenta":"#A16A94",
        "terminal.ansiRed":"#DB2D20",
        "terminal.ansiWhite":"#A5A2A2",
        "terminal.ansiYellow":"#FDED02"      
    },
```





## 插件：Material Icon Theme

给不同类型的目录和文件加上明显不同的图标

安装好后：Ctrl + Shift + P，搜索 `Material Icons: Activate Icon Theme`就可以启用了。
