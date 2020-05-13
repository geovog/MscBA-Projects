#----------------------------------Assignment in Big Data Systems-------------------------------------#
#-------------------------------------------- REDIS/TASK 1-------------------------------------------#

# Read the data files

listings<-read.csv("C:\\Users\\myrsi\\OneDrive\\Desktop\\Master\\BigDataSystems\\Redis-Mongo Assignment\\RECORDED_ACTIONS\\modified_listings.csv")
emails<-read.csv("C:\\Users\\myrsi\\OneDrive\\Desktop\\Master\\BigDataSystems\\Redis-Mongo Assignment\\RECORDED_ACTIONS\\emails_sent.csv")

# Loading the libraries we need 
library("redux")
library(dplyr)

# Create the connection with the local instance of REDIS
r <- redux::hiredis(
  redux::redis_config(
    host = "127.0.0.1", 
    port = "6379"))

# Question 1.1
# appropriate data sets
listing_jan<-listings[which(listings$MonthID==1),]
listing_feb<-listings[which(listings$MonthID==2),]
listing_mar<-listings[which(listings$MonthID==3),]
# We used the January listings in order to find the users who modified their listing in January.
# Redis set 1 if a user modified his listing and 0 if not.

for (i in 1:dim(listing_jan)[1]){
  if (listing_jan$ModifiedListing[i] == 1) {
    r$SETBIT("ModificationsJanuary", i,"1")
  }
}
r$BITCOUNT("ModificationsJanuary")

# Question 1.2
# We calculate the users which characterized as 0 in the previous question.
r$BITOP("NOT","NotModificationsJanuary","ModificationsJanuary")
r$BITCOUNT("NotModificationsJanuary")

# if we sum the above results we do not have 19999 but 20000. So we have one user more. 8 bit is 1 byte. 19999 user 
# so to make the last eight values add one more number this is the reason why we have one more observation.

# Question 1.3
# In order to answer this question we create new datasets which give the total number of email that a user received by month
email_jan<-as.data.frame(table(emails$UserID[emails$MonthID==1])) 
email_feb<-as.data.frame(table(emails$UserID[emails$MonthID==2])) 
email_mar<-as.data.frame(table(emails$UserID[emails$MonthID==3]))
colnames(email_jan)<-c("user_id","received_email_jan")
colnames(email_feb)<-c("user_id","received_email_feb")
colnames(email_mar)<-c("user_id","received_email_mar")
monthly_email<-merge(email_mar,merge(email_jan,email_feb,by="user_id",all.x=T),by="user_id",all.x = T)
monthly_email[is.na(monthly_email)]<-0

# Redis set 1 in the positions that a user received at least one email at January. The same for the rest months.
for(i in 1:dim(monthly_email)[1]) {
  if (monthly_email$received_email_jan[i]>0){
    r$SETBIT ("EmailsJanuary",i, "1")}
}
for(i in 1:dim(monthly_email)[1]) {
  if (monthly_email$received_email_feb[i]>0){
    r$SETBIT ("EmailsFebruary",i, "1")}
}
for(i in 1:dim(monthly_email)[1]) {
  if (monthly_email$received_email_mar[i]>0){
    r$SETBIT ("EmailsMarch",i, "1")}
}
# We want the sum of the users which received at one email in January, February and March. So, we use BITOP AND to find it.
r$BITOP("AND","Át_least_one_email",c("EmailsJanuary","EmailsFebruary","EmailsMarch"))
r$BITCOUNT("Át_least_one_email")

# Question 1.4
# We calculate the users which do not receive email at February and we join the result with the users which received email in January and March

r$BITOP("NOT","NotEmailsFebruary","EmailsFebruary")
r$BITOP("AND","NotFebruary",c("EmailsJanuary","NotEmailsFebruary","EmailsMarch"))
r$BITCOUNT("NotFebruary")

# We make a new dataset that contains the information about the user id, month, the number of email which received and opened.

received_email<-as.data.frame(table(emails$UserID,emails$MonthID))
colnames(received_email)<-c("user_id","month","received")
opened_email<-as.data.frame(table(emails$UserID[emails$EmailOpened==1],emails$MonthID[emails$EmailOpened==1]))
colnames(opened_email)<-c("user_id","month","opened")
total_emails<-merge(received_email,opened_email,by=c("user_id","month"),all.x=T)
length(which(is.na(total_emails$opened)))
total_emails<-total_emails[total_emails$received>0,]
total_emails$opened[is.na(total_emails$opened)]<-0
total_emails$opened_binary<-ifelse(total_emails$opened>0,1,0)

# Question 1.5
new_email_jan<-total_emails[total_emails$month==1,]
new_email_feb<-total_emails[total_emails$month==2,]
new_email_mar<-total_emails[total_emails$month==3,]

# For every user who received an email in January Redis set 1 if they opened at least one of them.

for (i in 1:dim(new_email_jan)[1]){
  if (new_email_jan$opened_binary[i]==1){
    r$SETBIT("EmailsOpenedJanuary", i, "1")
  }
}

r$BITOP("NOT","NotEmailsOpenedJanuary", "EmailsOpenedJanuary")
r$BITOP("AND","Not_open_Email_January_but_update", c("NotEmailsOpenedJanuary","ModificationsJanuary"))
r$BITCOUNT("Not_open_Email_January_but_update")

# Question 1.6
#For every user who received an email in February Redis set 1 if they opened at least one of them.
for (i in 1:dim(new_email_feb)[1]){
  if (new_email_feb$opened_binary[i]==1){
    r$SETBIT("EmailsOpenedFebruary", i, "1")
  }
}
r$BITOP("NOT","NotEmailsOpenedFebruary", "EmailsOpenedFebruary")

#For every user who received an email in March Redis set 1 if they opened at least one of them.
for (i in 1:dim(new_email_mar)[1]){
  if (new_email_mar$opened_binary[i]==1){
    r$SETBIT("EmailsOpenedMarch", i, "1")
  }
}
r$BITOP("NOT","NotEmailsOpenedMarch", "EmailsOpenedMarch")

# Modifications happened in February and March

for (i in 1:dim(listing_feb)[1]){
  if (listing_feb$ModifiedListing[i] == 1) {
    r$SETBIT("ModificationsFebruary", i,"1")
  }
}
for (i in 1:dim(listing_mar)[1]){
  if (listing_mar$ModifiedListing[i] == 1) {
    r$SETBIT("ModificationsMarch", i,"1")
  }
}

r$BITOP("AND","Not_open_Email_Feb_but_update", c("NotEmailsOpenedFebruary","ModificationsFebruary"))
r$BITCOUNT("Not_open_Email_Feb_but_update")
r$BITOP("AND","Not_open_Email_Mar_but_update", c("NotEmailsOpenedMarch", "ModificationsMarch"))
r$BITCOUNT("Not_open_Email_Mar_but_update")

r$BITOP("OR","Updatewithoutopen",c("Not_open_Email_Mar_but_update", "Not_open_Email_Feb_but_update","Not_open_Email_January_but_update"))
r$BITCOUNT("Updatewithoutopen")

# Question 1.7

r$BITOP("AND","open_Email_Jan_but_update", c("EmailsOpenedJanuary","ModificationsJanuary"))
r$BITCOUNT("open_Email_Jan_but_update")
r$BITOP("AND","open_Email_Feb_but_update", c("EmailsOpenedFebruary","ModificationsFebruary"))
r$BITCOUNT("open_Email_Feb_but_update")
r$BITOP("AND","open_Email_Mar_but_update", c("EmailsOpenedMarch", "ModificationsMarch"))
r$BITCOUNT("open_Email_Mar_but_update")
r$BITOP("OR","Updateandopen",c("open_Email_Jan_but_update", "open_Email_Feb_but_update","open_Email_Mar_but_update"))
r$BITCOUNT("Updateandopen")

# It make sense to keep sending email because appears that 4768 peaple upadate without open their email and 6247 appears to updated 
# after the opened their email.  

# Close Redis
r$FLUSHALL()


 
 
 
 