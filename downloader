#downloader
library(downloader)
#示例
download("https://github.com/wch/downloader/zipball/master",
         "downloader.zip", mode = "wb") 
#method： wininet internal libcurl curl lynx wget 


#下载上海期货交易所会员成交及持仓排名表数据
download("http://www.shfe.com.cn/data/dailydata/kx/pm20190603.dat","1.json")
#处理json格式
library(rjson)
result=fromJSON(file = "1.json")
result$o_cursor[[3]]

#下载郑商所仓单日报
#以二进制下载,不然不指定mode= "wb"下载下来的xls打不开
download.file("http://www.czce.com.cn/cn/DFSStaticFiles/Future/2019/20190604/FutureDataWhsheet.xls",
              destfile="1.xls",method="wininet", mode = "wb") 
#也可以直接下载csv格式，尽管会提示格式不符可能有错
download.file("http://www.czce.com.cn/cn/DFSStaticFiles/Future/2019/20190604/FutureDataWhsheet.xls",
              destfile="1.csv",method="wininet", mode ="wb") 
