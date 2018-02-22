## 产品整体构想
web端打包成zip（也可以是其他压缩包），供APP（IOS，android）下载到本地解压使用。其中调用native提供的相关API完成工作

### IOS
1. 下载 / 解压 / 载入 zip 包内的HTML文件
2. JS 和 native之间的简单调用，其中使用key记录来进行JS调用了native之后调用自定义的回调函数使用

## todo
* native-js 使用注入模型形式来交互
* 完善native相关API：网络请求相关API，硬件配置相关API
* 构建web端打包工具
* 增加列表页： 下载指定的zip包，读取zip包版本号，更新指定zip包，清楚缓存。
