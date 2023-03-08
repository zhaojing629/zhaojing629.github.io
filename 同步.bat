cd "D:\10_Hexo_blog(502a+thuyun)\zhaojing629.github.io"
ren .deploy_git\.git1 .git
hexo g -d
ren .deploy_git\.git .git1
git add .
git commit -message
git push origin source
pause