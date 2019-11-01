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

