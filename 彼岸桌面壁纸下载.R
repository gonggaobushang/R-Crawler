#彼岸桌面 www.netbian.com 
#最高清的只能下载1920x1080的壁纸
library(rvest)
library(magick)
library(dplyr)
library(stringr)

t1=Sys.time()
sapply(6100:22000,function(i){
  tryCatch({
    url=paste0("http://www.netbian.com/desk/",i,"-1920x1080.htm")
    node <-read_html(x = url)%>%html_nodes(css = "img")
    node%>%str_extract_all(pattern = "http.*\\.jpg") %>%unlist->img
    image_read(path = img[2])->image
    image_write(image,path = paste0("E:\\壁纸\\", i,".jpg"))
  },error=function(e){cat("ERROR :",conditionMessage(e),"\n")})
  cat("运行到",i,"\n")
})
t2=Sys.time()
print(t2-t1)