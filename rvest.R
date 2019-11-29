# rvest包
#用chrome 的Selector Gadget插件
# 教程 http://www.ituring.com.cn/article/465317
library(xml2)
library(rvest)

url <- 'https://www.imdb.com/search/title?%20count=100&release_date=2016,2016&title_type=feature'
# 从网页读取html代码
webpage <- read_html(url)
# 用CSS选择器获取排名部分
rank_data_html <- html_nodes(webpage,'.text-muted+ p , .text-muted')
# 把排名转换为文本
rank_data <- html_text(rank_data_html)
description_data<-gsub("\n","",rank_data)
description_data<-gsub(" ","",rank_data)
# 再检查一下
head(description_data)
# 爬取revenue section
gross_data_html <- html_nodes(webpage,'.ghost~ .text-muted+ span')
# 转为文本
gross_data <- html_text(gross_data_html)
# 检查一下
head(gross_data)
# 去除'$' 和 'M' 标记
gross_data <- gsub("M", "", gross_data)
gross_data <- substring(gross_data, 2, 6)
# 检查长度
length(gross_data)
# 填充缺失值
for (i in c(17,39)){
  a <- gross_data[1:(i-1)]
  b <- gross_data[i:length(gross_data)]
  gross_data <- append(a, list("NA"))
  gross_data <- append(gross_data, b)
}
# 转为数值
gross_data<-as.numeric(gross_data)
# 再次检查长度
length(gross_data)


#2019.11.29学习笔记
#  https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb 
# 安装SelectorGadget插件
library(rvest)
library(magrittr)
#文本提取
site_1 <- "https://www.zhipin.com/job_detail/?query=%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90&scity=100010000&industry=&position="
web_1 <- read_html(x = site_1)  
tag_job <- ".info-primary .name .job-title" # 岗位名字
tag_rev <- ".info-primary .name .red"  # 薪水
tag_com <- ".info-company .company-text .name" # 公司名字
# 开始抓取
job_1 <- html_nodes(x = web_1, css = tag_job)
rev_1 <- html_nodes(x = web_1, css = tag_rev)
com_1 <- html_nodes(x = web_1, css = tag_com)
# 从tags中提取文本内容
job_1 %<>% html_text()
rev_1 %<>% html_text()
com_1 %<>% html_text()
# 合并向量为数据框
job_com <- data.frame(job = job_1,
                      revenue = rev_1,
                      company = com_1,
                      stringsAsFactors = FALSE)
head(job_com)
rm(site_1, web_1, job_1, com_1) #删除变量
url_begin <- "https://www.zhipin.com/c100010000/?query=%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90&page="
for (n in 2:10) {
  myurl <- paste0(url_begin, n)
  page_n <- read_html(x = myurl)   
  # 开始抓取
  job_n <- html_nodes(x = page_n, css = tag_job) %>% html_text()
  rev_n <- html_nodes(x = page_n, css = tag_rev) %>% html_text()
  com_n <- html_nodes(x = page_n, css = tag_com) %>% html_text()
    # 合并向量为数据框
  job_com_n <- data.frame(job = job_n,
                          revenue = rev_n,
                          company = com_n,
                          stringsAsFactors = FALSE)
  
  job_com <- rbind(job_com, job_com_n) # 添加到job_com内
}

rm(job_n, rev_n, com_n, job_com_n)
str(job_com)
library(DT)
DT::datatable(job_com) 
#表格提取
#通过“检查”来查找所属元素
city_name <- c("beijing", "shanghai", "guangzhou", "shenzhen", "hangzhou", 
                              "tianjin", "chengdu", "nanjing", "xian", "wuhan")
url_cites <- paste0("http://www.pm25.in/", city_name)
for (n in 1:length(city_name)) {
    # 提取表格
    pm_city <- read_html(x = url_cites[n]) %>% 
        #html_nodes(css = ".aqis_live_data .container .table") %>% 
      html_nodes(css = ".table") %>%
        .[[2]] %>% # 注意这里的点
        html_table()  
    # 批量生成变量
    assign(x = paste0("pm_", city_name[n]), value = pm_city) 
  
  }
rm(url_cites, pm_city)
DT::datatable(pm_chengdu)
DT::datatable(pm_beijing)
#图片提取
url_first <- "http://www.51yuansu.com/search/hua-40-0-0-0-1/"
flower_nodes <- read_html(x = url_first)  %>%
    html_nodes(css = ".img-wrap")
flower_nodes[[1]]
library(stringr)
library(rlist)
flower_nodes %<>%#再将其重新赋值给原向量 
    str_extract_all(pattern = "http.*\\.html") %>% # .*表示任何字符串，以http开头，.html结束
    unlist()#解除列表
flower_nodes[1]
image_url <- vector() # 生成空向量
#提取图片的url
for (n in 1:length(flower_nodes)) {
    image_url[n] <- read_html(x = flower_nodes[n]) %>%
        html_nodes(css = ".img-wrap .show-image") %>%
       str_extract_all(pattern = "http.*\\.jpg") %>%
        unlist()
  #可能会报错，爬取一部分
  }
image_url[1]
library(magick)
file_path <- "C:\\"
for (n in 1:length(image_url)) {
    image_read(path = image_url[n]) %>%  # 读取url图片
        image_write(path = paste0(file_path, n, ".jpg")) # 保存图片
}
file_path1 <- "C:\\"
# 动画展示保存到文件夹中的图片
image_animate(image =  
                image_read(path = paste0(file_path1, as.character(1:length(image_url)),".jpg"))) 
#若路径是中文会报错
rm(list = ls()); gc() # 清空内存
u <- "https://movie.douban.com/"
session <- html_session(u) # 创建会话
forms <- session %>% html_form()
form <- forms[[1]] # forms 中的第一个列表是我们的目标列表
filled_form <- set_values(form, search_text = "流浪地球") # 填写表单
session2 <- submit_form(session, form = filled_form) # 提交表单
session2$url # 查看提交表单后，返回的新会话 session2 的 url
iconv(URLdecode(session2$url), "UTF8") # 重新编码
url_movie <- "https://movie.douban.com/subject/26266893/comments?sort=new_score&status=P"
path_comments <- paste0("#comments > div:nth-child(", 
                  as.character(1:20), 
                        ") > div.comment > p > span")
text_comments <- vector() # 创建空向量
# 爬取第一页的评论
for (n in 1:20) {   # 1页20个评论
  comments_n <- read_html(x = url_movie) %>%
  html_nodes(css = path_comments[n]) %>% 
    html_text() %>% 
    unlist()
  text_comments[n] <- comments_n
}
print(text_comments[1])
url_pages <- paste0("https://movie.douban.com/subject/26266893/comments?start=",
                             as.character(seq(from = 20, to = 200, by = 20)),
                              "&limit=20&sort=new_score&status=P&percent_type=")
for (m in 1:length(url_pages)) {  
      for (n in 1:20) {   # 1页20个评论
          comments_mn <- read_html(x = url_pages[m]) %>%
            html_nodes(css = path_comments[n]) %>% 
              html_text() %>% 
              unlist()
  
        text_comments[m*20 + n] <- comments_mn 
      }
      Sys.sleep(3) # 延迟时间,避免豆瓣IP异常
    }
# 保存为txt文件
write.table(x = text_comments, 
             file = "C:\\流浪地球-豆瓣评论.txt",
             quote = FALSE, sep = "\n", row.names = TRUE,  
         qmethod = "double", fileEncoding = "UTF-8")

