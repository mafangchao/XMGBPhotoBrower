# XMGBPhotoBrower

## 网页图片浏览器

# How To Used

1. 首先导入`SDPhotoBrowser`和`SDWebImage`两个框架（如果有了就不需要了）
2. 拖入`XMGPhotoBrowerWebView`文件到项目中
3. 用`XMGPhotoBrowerWebView`替代`UIWebView`创建`webview`并设置`frame`
4. 如果想要监听`webview`的代理，必须用`webViewDelegate`代替`delegate`,并实现这个代理中的方法

![image](https://github.com/mafangchao/XMGBPhotoBrower/blob/master/photoBrower.gif)
