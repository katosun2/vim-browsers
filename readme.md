### 仿IDE打开浏览器浏览页面的vim插件 For win

1、获取浏览器快捷方式，并绑定map快捷键

### 使用

定义变量 $BROWSERS 设置快捷方式目录

```
let $BROWSERS = $VIM . 'browsers'
if exists('*mkdir') && !isdirectory($BROWSERS)
    sil! cal mkdir($BROWSERS, 'p')
endif
let $BROWSERS = $BROWSERS
```
