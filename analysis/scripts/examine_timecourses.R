library(tidyverse)

dir <- "/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest"
sess <- "140811CC"
seeds <- c("lh_sPCS","lh_midIFS","lh_iPCS","rh_sPCS","rh_midIFS","rh_iPCS")

data <- sapply(1:length(seeds), function(x) read.table(str_c(dir,"/",sess,"/seedTimeCourses/",seeds[x],".dat")))
df <- as.data.frame(data)
names(df)<-seeds
df$time <- seq(0,719,2)

ggplot(df, aes(x=time),group=names()) +
   geom_line(aes(y=lh_sPCS),color="green") + 
   geom_line(aes(y=lh_midIFS),color="red") +
   geom_line(aes(y=lh_iPCS),color="blue") +
   scale_color_discrete(name="Seed", labels=c("sPCS","midIFS","iPCS")) +
   ylab("signal intensity")

ggplot(df, aes(x=time),group=names()) +
  geom_line(aes(y=rh_sPCS),color="green") + 
  geom_line(aes(y=rh_midIFS),color="red") +
  geom_line(aes(y=rh_iPCS),color="blue") +
  scale_color_discrete(name="Seed", labels=c("sPCS","midIFS","iPCS")) +
  ylab("signal intensity")
