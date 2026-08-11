---
title: Claude Code + VS code 安装教程
date: 2026-07-07 19:01:00
updated:
tags: [Claude, vscode, deepseek]
categories: [办公, 软件]
typora-root-url: Claude Code + VS code 安装教程
description: 通过npm安装Claude和使用Vscode使用
---
# 安装Claude
参考来源：https://zhuanlan.zhihu.com/p/2004150496781410721
1. 首先安装好Git和Node.js（见<a href="{% post_path '搭建网站教程' %}#搭建">下载Git和Node.js</a>）
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
	```json
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