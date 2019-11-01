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





















###########################################################################################################
library(rvest)
library(sqldf)
library(gsubfn)
library(proto)
#creat a function
extrafun <- function(i,non_pn_url){
  url <- paste0(non_pn_url,i)
  web <- read_html(url)
  papername<- web %>% html_nodes("dl.bbda dt.xs2 a") %>% html_text()%>% .[c(seq(2,20,2))] %>% as.character()
  paperlink<-gsub("\\?source\\=search","",web %>% html_nodes("dl.bbda dt.xs2 a") %>% html_attr("href"))%>% .[c(seq(2,20,2))]
  paperlink <- paste0("http://blog.sciencenet.cn/",paperlink) %>% as.character()
  posttime <- web %>% html_nodes("dl.bbda dd span.xg1") %>% html_text() %>% as.Date()#这里取每篇文章的发布时间
  count_of_read <- web %>% html_nodes("dl.bbda dd.xg1 a") %>% html_text()
  count_of_read <- as.data.frame(count_of_read)
  count_of_read <- sqldf("select * from count_of_read where count_of_read like '%次阅读'")
  data.frame(papername,posttime,count_of_read,paperlink)
}
#crawl data
final <- data.frame()
url <- 'http://blog.sciencenet.cn/home.php?mod=space&uid=556556&do=blog&view=me&page='
for(i in 1:40){
  extrafun(i,url)  #自定义函数
  final <- rbind(final,extrafun(i,url))
}





















#   https://mp.weixin.qq.com/s/CI3TpgRNZNtBb_BqYxlAmA
#  https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb 安装SelectorGadget插件
library(rvest)
library(magrittr)



##################################################################################################文本提取
# 打开网页
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
