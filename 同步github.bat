
set MESSEGE=%date:~0,4%%date:~5,2%%date:~8,2%

cd "D:\10_Hexo_blog(502a+thuyun)\zhaojing629.github.io"
ren .deploy_git\.git .git1
git add .
git commit -m"updated: %MESSEGE%"
git push origin source
cmd /k