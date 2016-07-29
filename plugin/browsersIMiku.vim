"=============================================================================
"     FileName: browsersIMiku.vim
"         Desc:    
"       Author: Ryu
"        Email: neko@imiku.com
"     HomePage: http://www.imiku.com/
"      Version: 0.0.1
"   LastChange: 2014-04-06 20:45:18
"      History:
"      auto load *.lnk files and map
"=============================================================================

if exists('*mkdir') && !isdirectory($BROWSERS) || exists("*GetLnk")

	finish
endif

"加载浏览器快捷方式列表
let g:my_browsers = {} 
" 获取当前路径下的所有文件
let s:links = glob($BROWSERS.'/*.lnk')
" 使用换行符作为分隔符，将所有路径转换成列表
let s:linklist = split(s:links, "\<NL>")
" 在列表中循环处理
for linkstr in s:linklist
	" 获取快捷方式的主文件名
	let s:substr = matchstr(linkstr, '\w\+\.lnk')
	" 去掉住文件名中包含的扩展名
	let s:mainname = strpart(s:substr, 0, strlen(s:substr)-4)
    let g:my_browsers[s:mainname] = linkstr
	exec ":map <silent><leader>".s:mainname." <esc>:call g:GetLnk('".s:mainname."')<cr>"
endfor

"获取指定目录的快捷方式的程序"
func! g:GetLnk(name)
	if !has_key(g:my_browsers,a:name)
		echo "找不到文件: ".$BROWSERS."\\".a:name.".Lnk  m(_ _)m"
		return
	endif
	let s:link = g:my_browsers[a:name]
    if empty(s:link)
        echo "找不到快捷方式文件： ".a:name.".Lnk m(_ _)m"
        return
    endif
	"获取快捷方式指向的真实地址
	let s:path = resolve(s:link)
	" 如果程序不存在
	if s:path == s:link
		echo "找不到浏览器! m(_ _)m"
		return
	else
		call s:ViewInBrowser(s:path) 
	endif
endfunc

"在浏览器预览 for win32 
function! s:ViewInBrowser(b_path) 
    let file = expand("%:p") 
    exec ":update " . file 
    let file = substitute(file,'\\','\/',"g")
    let htdoc = ""
    let servurl = ""

    let s:i = 0
    for key in g:htdocs
        let key = substitute(key,'\\','\/',"g")
        let strpos = stridx(file,key) 
        if strpos >-1
            let strpo = strpos
            let htdoc = key
            let servurl = g:servurls[s:i] 
            break
        endif
        let s:i = s:i + 1
    endfor

    " can not Edit
    let s:bstr = a:b_path
    let s:bstr = substitute(s:bstr,"-\.\*","","e")
    let s:bstr = substitute(s:bstr,"\s$","","e")
    if executable(s:bstr) 
        if g:htdoc_f5_open == 1
            let isf5 = confirm("选择使用的服务器:","&F5\n&APM\n&EXIT",2)
            if isf5 ==1
                echo "请稍后，系统正在努力地打开文件...(＞д＜)"
                let g:htdoc_f5[0] = substitute(g:htdoc_f5[0],'\\','\/',"g")
                let file = substitute(file,g:htdoc_f5[0],g:htdoc_f5[1],"g") 
                exec ":silent !start ".s:bstr file 
            elseif isf5==2 
                echo "请稍后，系统正在努力地打开文件...(＞д＜)"
                if strpos == -1 
                    exec ":silent !start \"".s:bstr."\" \"file:///".file."\"" 
                else 
                    let file = substitute(file,htdoc,servurl,"g") 
                    exec ":silent !start ".s:bstr file 
                endif
            endif
        else
            echo "请稍后，系统正在努力地打开文件...(＞д＜)"
            if strpos == -1 
                exec ":silent !start \"".s:bstr."\" \"file:///".file."\"" 
            else 
                let file = substitute(file,htdoc,servurl,"g") 
                exec ":silent !start ".s:bstr file 
            endif
        endif
    else
		echo "找不到浏览器：".s:bstr." m(_ _)m"
    endif
endf
