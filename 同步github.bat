cd "D:\10_Hexo_blog(502a+thuyun)\zhaojing629.github.io"
ren .deploy_git\.git .git1
git add .
git commit -m"3"
git push origin source
set MESSEGE=%date%
mkdir "%MESSEGE%"
cmd /k