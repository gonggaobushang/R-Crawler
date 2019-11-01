library(Rcrawler)

#install_browser()
browser_path()


DATA<-ContentScraper(Url="http://glofile.com/index.php/2017/06/08/taux-nette-detente/",
                     CssPatterns = c(".entry-title",".published",".entry-content"), astext = TRUE)

txthml<-"<html><title>blah</title><div><p>I m the content</p></div></html>"
DATA<-ContentScraper(HTmlText = txthml ,XpathPatterns = "//*/p")

DATA<-ContentScraper(Url ="http://glofile.com/index.php/2017/06/08/athletisme-m-a-rome/",
                     XpathPatterns=c("//head/title","//*/article"),PatternsName=c("title", "article"))


page<-LinkExtractor(url="http://www.glofile.com")


page<-LinkExtractor(url="http://www.glofile.com",
                    ExternalLInks = TRUE, #返回外部链接
                    Useragent = "Mozilla/5.0 (Windows NT 6.3; Win64; x64)",)

page<-LinkExtractor(url="http://www.glofile.com/404notfoundpage",
                    ExternalLInks = TRUE,
                    IndexErrPages = c(200,404)) #解析访问错误的网站

proxy<-httr::use_proxy("190.90.100.205",41000) #使用代理来检索网页
pageinfo<-LinkExtractor(url="http://glofile.com/index.php/2017/06/08/taux-nette-detente/",
                        use_proxy = proxy)


br <-run_browser()
page<-LinkExtractor(url="http://www.zhihu.com", 
                    Browser = br,
                    ExternalLInks = TRUE)
stop_browser(br)

#模拟登录界面
page<-LinkExtractor("http://glofile.com/index.php/2017/06/08/jcdecaux/")
#username : demo and password : rc@pass@r
br <-run_browser()
LS<-LoginSession(
  Browser = br, 
  LoginURL = 'http://glofile.com/wp-login.php',
  LoginCredentials = c('demo','rc@pass@r'),
  cssLoginFields =c('#user_login', '#user_pass'),
  cssLoginButton='#wp-submit' )
LS$session$getTitle()
LS$session$getUrl()
LS$session$takeScreenshot(file = 'sc.png')
#模拟会比较慢
page<-LinkExtractor(url='http://glofile.com/index.php/2017/06/08/jcdecaux/',Browser = LS)
stop_browser(LS)

page$InternalLinks
page$ExternalLinks
page$Info
page$Info$Url
page$Info$SumLinks
page$Info$Status_code
page$Info$Content_type
page$Info$Encoding
page$Info$Source_page
Page title
page$Info$Title
page$Info$Id
page$Info$Crawl_level,
page$Info$Crawl_status 



#将url正常化
links<-c("http://www.twitter.com/share?url=http://glofile.com/page.html",
         "/finance/banks/page-2017.html",
         "./section/subscription.php",
         "//section/",
         "www.glofile.com/home/",
         "IndexEn.aspx",
         "glofile.com/sport/foot/page.html",
         "sub.glofile.com/index.php",
         "http://glofile.com/page.html#1",
         "?tags%5B%5D=votingrights&amp;sort=popular"
)
links<-LinkNormalization(links,"http://glofile.com" )
links

#取出要素
Linkparameters("http://www.glogile.com/index.php?name=jake&age=23&template=2&filter=true")

#去除要素
url<-"http://www.glogile.com/index.php?name=jake&age=23&tmp=2&ord=1"
url<-Linkparamsfilter(url,c("ord","tmp"))
Linkparamsfilter(url,removeAllparams = TRUE)




br<- run_browser()
brs<-LoginSession(Browser = br, 
                  LoginURL = 'http://glofile.com/wp-login.php',
                  LoginCredentials = c('demo','rc@pass@r'),
                  cssLoginFields =c('#user_login', '#user_pass'),
                  cssLoginButton='#wp-submit' )
#如果成功登陆，那么会返回怎样的要素
brs$getUrl()

