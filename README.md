## 简介
本项目为《Lua解释器构建：从虚拟机到编译器》的随书源码。前5章的代码，均在windows平台和linux平台下通过测试。第6章的工程，为使用本书构建的Lua解释器开发的俄罗斯方块小游戏，只支持在windows系统下编译与运行。欢迎大家加群讨论QQ：185017593。  

书籍已经正式上市，可以点击[官方正版链接](https://item.m.jd.com/product/13807126.html?gx=RnExlzJaOzKPydRP--twWzz4fQ1sgoXIajtG&ad_od=share&utm_source=androidapp&utm_medium=appshare&utm_campaign=t_335139774&utm_term=Wxfriends)购买，感谢支持。  

![image](https://raw.githubusercontent.com/Manistein/Photos/master/DailyUse/Lua/cover.png)

## 编译环境
windows系统：所有用例均在Visual Studio 2017上通过编译和运行。  
linux系统：在ubuntu18.04和centos7上，使用gcc 6.5.0通过编译，并运行。第6章的工程只能在windows平台下编译与运行。

## 工程构建与编译
随书源码使用cmake来构建工程，构建编译流程如下所示：
#### windows环境的构建流程
* 下载：通过git clone命令，clone仓库：git clone https://github.com/Manistein/let-us-build-a-lua-interpreter.git 或 直接点击[这里](https://github.com/Manistein/let-us-build-a-lua-interpreter/archive/refs/heads/main.zip)进行下载。
* 使用cmake工具，构建Visual Studio工程。比如要对C02/dummylua-2-1构建工程，那么需要创建目录C02/dummylua-2-1/build，并将工程构建在这个目录下。
* 进入build目录，打开Visual Studio工程，编译并运行。
* 第6章的工程只能在windows系统下进行构建，首先要先后在C06/tetris/3rd/d2d/build、C06/tetris/dummylua/build和C06/tetris/game/build目录下，分别构建d2d、dummylua和game工程。然后先编译3rd库，再编译dummylua库，最后编译和运行game库。

#### linux环境下的构建流程
* 下载：通过git clone命令，clone仓库：git clone https://github.com/Manistein/let-us-build-a-lua-interpreter.git 或通过wget指令获取压缩包：wget https://github.com/Manistein/let-us-build-a-lua-interpreter/archive/refs/heads/main.zip
* 使用cmake构建makefile文件，比如要对C02/dummylua-2-1构建工程，那么首先需要创建目录C02/dummylua-2-1/build，通过cd命令，进入build目录。输入指令
  ```
  cmake ..
  ```  
  尔后会生成makefile文件，使用make指令生成可执行文件。
* 第6章的工程，不支持在非windows平台下构建和运行。

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Manistein/let-us-build-a-lua-interpreter&type=Date)](https://star-history.com/#Manistein/let-us-build-a-lua-interpreter&Date)
