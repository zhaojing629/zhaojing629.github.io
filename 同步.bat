cd "D:\10_Hexo_blog(502a+thuyun)\zhaojing629.github.io"
ren .deploy_git\.git1 .git

ren .deploy_git\.git .git1
git add .
git commit --no-verify –m "更新" 
git push origin source
cmd \k