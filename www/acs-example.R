library(RMonetDB)
al<-read.csv("ss10pal.csv")
monetdriver<-MonetDB(classPath="/usr/local/monetdb/share/monetdb/lib/monetdb-jdbc-2.4.jar")
monet<-dbConnect(monetdriver,"jdbc:monetdb://localhost/demo",user="monetdb",password="monetdb")
monet.read.csv(monet,"/Users/tlum005/ACS/ss10pal.csv","alabama",nrows=50000,locked=TRUE)
dbDisconnect(monet)


## potentially in another session
monetdriver<-MonetDB(classPath="/usr/local/monetdb/share/monetdb/lib/monetdb-jdbc-2.4.jar")
alacs<-sqlrepsurvey("pwgtp",paste("pwgtp",1:80,sep=""),scale=4/80,rscales=rep(1,80), mse=TRUE,database="jdbc:monetdb://localhost/demo", driver=monetdriver,key="idkey",user="monetdb",password="monetdb",table.name="alabama",check.factors=TRUE)

## totals by age and sex
svytotal(~sex,alacs)
svytotal(~cut(agep,c(4,9,14,19,24,34,44,54,59,64,74,84)),alacs)

## wage income by working hours
svyplot(wagp~wkhp,alacs, style="hex")
plot(svysmooth(wagp~wkhp,alacs, sample.bandwidth=5000))
svymean(~wagp,alacs,byvar=~sex)

## non-citizens more likely to be male
svytable(~sex+cit,alacs)
svychisq(~sex+cit,alacs)
