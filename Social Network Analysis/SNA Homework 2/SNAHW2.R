library(dplyr)
library(igraph)
library(ggplot2)
library(gridExtra)

system("python \"scriptSna.py\"")

df1<-read.csv("outf1.csv",header = TRUE,quote = "",sep = '\t')
df2<-read.csv("outf2.csv",header = TRUE,quote = "",sep = '\t')
df3<-read.csv("outf3.csv",header = TRUE,quote = "",sep = '\t')
df4<-read.csv("outf4.csv",header = TRUE,quote = "",sep = '\t')
df5<-read.csv("outf5.csv",header = TRUE,quote = "",sep = '\t')

fdf1<-count(df1, user, mention, name = "weight")
fdf2<-count(df2, user, mention, name = "weight")
fdf3<-count(df3, user, mention, name = "weight")
fdf4<-count(df4, user, mention, name = "weight")
fdf5<-count(df5, user, mention, name = "weight")

write.csv(fdf1, file = "july012009.csv",row.names=FALSE)
write.csv(fdf2, file = "july022009.csv",row.names=FALSE)
write.csv(fdf3, file = "july032009.csv",row.names=FALSE)
write.csv(fdf4, file = "july042009.csv",row.names=FALSE)
write.csv(fdf5, file = "july052009.csv",row.names=FALSE)

rm('df1','df2','df3','df4','df5','fdf1','fdf2','fdf3','fdf4','fdf5')

if (file.exists("outf1.csv"))
  file.remove("outf1.csv")
if (file.exists("outf2.csv"))
  file.remove("outf2.csv")
if (file.exists("outf3.csv"))
  file.remove("outf3.csv")
if (file.exists("outf4.csv"))
  file.remove("outf4.csv")
if (file.exists("outf5.csv"))
  file.remove("outf5.csv")

july1<-read.csv('july012009.csv')
july2<-read.csv('july022009.csv')
july3<-read.csv('july032009.csv')
july4<-read.csv('july042009.csv')
july5<-read.csv('july052009.csv')

jul1<-graph_from_data_frame(july1, directed=TRUE)
jul2<-graph_from_data_frame(july2, directed=TRUE)
jul3<-graph_from_data_frame(july3, directed=TRUE)
jul4<-graph_from_data_frame(july4, directed=TRUE)
jul5<-graph_from_data_frame(july5, directed=TRUE)

# NR OF VERTICES
g1<-gorder(jul1)
g2<-gorder(jul2)
g3<-gorder(jul3)
g4<-gorder(jul4)
g5<-gorder(jul5)
Dates<-c("2009-07-01","2009-07-02","2009-07-03","2009-07-04","2009-07-05")
Vertices<-c(g1,g2,g3,g4,g5)
vert<-as.data.frame(cbind(Dates,Vertices))

plot1<-ggplot(data=vert, aes(x=Dates, y=Vertices, fill=Dates),xlab=("Date"),ylab=("Vertices")) +
  geom_bar(colour="black", stat="identity") +
  guides(fill=FALSE)+ggtitle("5 Day Evolution of Vertices")
plot2<-ggplot(data=vert, aes(x=Dates,xlab=("Date"),ylab=("Vertices") ,y=Vertices, group=1)) +
  geom_line()+
  geom_point()+
  ggtitle("5 Day Evolution of Vertices")
grid.arrange(plot1, plot2, ncol=2)  

#number of edges 
edgescount<-c(gsize(jul1),
              gsize(jul2),
              gsize(jul3),
              gsize(jul4),
              gsize(jul5))
edges<-as.data.frame(cbind(edgescount,Dates))
plot3<-ggplot(data=edges, aes(x=Dates, y=edgescount, fill=Dates),xlab=("Date"),ylab=("Edges")) +
  geom_bar(colour="black", stat="identity") +
  guides(fill=FALSE)+ggtitle("5 Day Evolution of Edges")

plot4<-ggplot(data=edges, aes(x=Dates,xlab=("Date"),ylab=("Edges") ,y=edgescount, group=1)) +
  geom_line()+
  geom_point()+
  ggtitle("5 Day Evolution of Edges")
grid.arrange(plot3, plot4, ncol=2)  

#weighted diameter 
j1<-diameter(jul1, directed=TRUE, weights= E(jul1)$weight) 
j2<-diameter(jul2, directed=TRUE, weights= E(jul2)$weight) 
j3<-diameter(jul3, directed=TRUE, weights= E(jul3)$weight) 
j4<-diameter(jul4, directed=TRUE, weights= E(jul4)$weight) 
j5<-diameter(jul5, directed=TRUE, weights= E(jul5)$weight)

Diameter<-c(j1,j2,j3,j4,j5)

dmtr<-as.data.frame(cbind(Diameter,Dates))

plot5<-ggplot(data=dmtr, aes(x=Dates, y=Diameter, fill=Dates),xlab=("Date"),ylab=("Diameter")) +
  geom_bar(colour="black", stat="identity") +
  guides(fill=FALSE) +
  ggtitle("5 Day Evolution of weighted Diameter")

plot6<-ggplot(data=dmtr, aes(x=Dates,xlab=("Date"),ylab=("Diameter") ,y=Diameter, group=1)) +
  geom_line()+
  geom_point()+
  ggtitle("5 Day Evolution of weighted Diameter")
grid.arrange(plot5, plot6, ncol=2) 

#diameter without weights
jw1<-diameter(jul1, directed=TRUE, weights=NA) 
jw2<-diameter(jul2, directed=TRUE, weights=NA) 
jw3<-diameter(jul3, directed=TRUE, weights=NA) 
jw4<-diameter(jul4, directed=TRUE, weights=NA) 
jw5<-diameter(jul5, directed=TRUE, weights=NA) 

DiameterW<-c(jw1,jw2,jw3,jw4,jw5)

dmtrw<-as.data.frame(cbind(DiameterW,Dates))

plot7<-ggplot(data=dmtrw, aes(x=Dates, y=DiameterW, fill=Dates),xlab=("Date"),ylab=("Diameter")) +
  geom_bar(colour="black", stat="identity") +
  guides(fill=FALSE)+ggtitle("5 Day Evolution of Diameter")

plot8<-ggplot(data=dmtrw, aes(x=Dates,xlab=("Date"),ylab=("Diameter") ,y=DiameterW, group=1)) +
  geom_line()+
  geom_point()+
  ggtitle("5 Day Evolution of Diameter")
grid.arrange(plot7, plot8, ncol=2) 

#degree
In_Degree<-c(mean(degree(jul1, v = V(jul1), mode = c("in"),
                         loops = FALSE, normalized = FALSE)),
             mean(degree(jul2, v = V(jul2), mode = c("in"),
                         loops = FALSE, normalized = FALSE)),
             mean(degree(jul3, v = V(jul3), mode = c("in"),
                         loops = FALSE, normalized = FALSE)),
             mean(degree(jul4, v = V(jul4), mode = c("in"),
                         loops = FALSE, normalized = FALSE)),
             mean(degree(jul5, v = V(jul5), mode = c("in"),
                         loops = FALSE, normalized = FALSE)))

Out_Degree<-c(mean(degree(jul1, v = V(jul1), mode = c("out"),
                          loops = FALSE, normalized = FALSE)),
              mean(degree(jul2, v = V(jul2), mode = c("out"),
                          loops = FALSE, normalized = FALSE)),
              mean(degree(jul3, v = V(jul3), mode = c("out"),
                          loops = FALSE, normalized = FALSE)),
              mean(degree(jul4, v = V(jul4), mode = c("out"),
                          loops = FALSE, normalized = FALSE)),
              mean(degree(jul5, v = V(jul5), mode = c("out"),
                          loops = FALSE, normalized = FALSE)))

indg<-as.data.frame(cbind(In_Degree,Dates))
outdg<-as.data.frame(cbind(Out_Degree,Dates))

plot7<-ggplot(data=indg, aes(x=Dates, y=In_Degree, fill=Dates),xlab=("Date"),ylab=("In Degree")) +
  geom_bar(colour="black", stat="identity") +
  guides(fill=FALSE)+ggtitle("5 Day Evolution of Avg In Degree")

plot8<-ggplot(data=outdg, aes(x=Dates, y=Out_Degree, fill=Dates),xlab=("Date"),ylab=("Out Degree")) +
  geom_bar(colour="black", stat="identity") +
  guides(fill=FALSE)+ggtitle("5 Day Evolution of Avg Out Degree")
grid.arrange(plot7, plot8, ncol=2) 



#3
data.frame(in_degree_1=tail(sort(strength(jul1, vids = V(jul1), mode = c("in"),
                                          loops = FALSE, weights = E(jul1)$weight)),10))
data.frame(in_degree_2=tail(sort(strength(jul2, vids = V(jul2), mode = c("in"),
                                          loops = FALSE, weights = E(jul2)$weight)),10))
data.frame(in_degree_3=tail(sort(strength(jul3, vids = V(jul3), mode = c("in"),
                                          loops = FALSE, weights = E(jul3)$weight)),10))
data.frame(in_degree_4=tail(sort(strength(jul4, vids = V(jul4), mode = c("in"),
                                          loops = FALSE, weights = E(jul4)$weight)),10))
data.frame(in_degree_5=tail(sort(strength(jul5, vids = V(jul5), mode = c("in"),
                                          loops = FALSE, weights = E(jul5)$weight)),10))
data.frame(out_degree_1=tail(sort(strength(jul1, vids = V(jul1), mode = c("out"),
                                           loops = FALSE, weights = E(jul1)$weight)),10))
data.frame(out_degree_2=tail(sort(strength(jul2, vids = V(jul2), mode = c("out"),
                                           loops = FALSE, weights = E(jul2)$weight)),10))
data.frame(out_degree_3=tail(sort(strength(jul3, vids = V(jul3), mode = c("out"),
                                           loops = FALSE, weights = E(jul3)$weight)),10))
data.frame(out_degree_4=tail(sort(strength(jul4, vids = V(jul4), mode = c("out"),
                                           loops = FALSE, weights = E(jul4)$weight)),10))
data.frame(out_degree_5=tail(sort(strength(jul5, vids = V(jul5), mode = c("out"),
                                           loops = FALSE, weights = E(jul5)$weight)),10))

rank1<-page_rank(jul1, algo = "prpack",
                 vids = V(jul1), directed = TRUE, damping = 0.85,
                 personalized = NULL, weights = E(jul1)$weight)
rank2<-page_rank(jul2, algo = "prpack",
                 vids = V(jul2), directed = TRUE, damping = 0.85,
                 personalized = NULL, weights = E(jul2)$weight)
rank3<-page_rank(jul3, algo = "prpack",
                 vids = V(jul3), directed = TRUE, damping = 0.85,
                 personalized = NULL, weights = E(jul3)$weight)
rank4<-page_rank(jul4, algo = "prpack",
                 vids = V(jul4), directed = TRUE, damping = 0.85,
                 personalized = NULL, weights = E(jul4)$weight)
rank5<-page_rank(jul5, algo = "prpack",
                 vids = V(jul5), directed = TRUE, damping = 0.85,
                 personalized = NULL, weights = E(jul5)$weight)

data.frame(Rank=seq(from=10,to=1),
           Rank_day1=row.names(data.frame(Rank_day1=tail(sort(rank1$vector),10))),
           Rank_day2=row.names(data.frame(Rank_day2=tail(sort(rank2$vector),10))),
           Rank_day3=row.names(data.frame(Rank_day3=tail(sort(rank3$vector),10))),
           Rank_day4=row.names(data.frame(Rank_day4=tail(sort(rank4$vector),10))),
           Rank_day5=row.names(data.frame(Rank_day5=tail(sort(rank5$vector),10))))


#4

# Make retweet_graph undirected
jul1_undirected<- as.undirected(jul1)
jul2_undirected<- as.undirected(jul2)
jul3_undirected<- as.undirected(jul3)
jul4_undirected<- as.undirected(jul4)
jul5_undirected<- as.undirected(jul5)

# ... and again with louvain clustering
communities_louvain1 <- cluster_louvain(jul1_undirected)
communities_louvain2 <- cluster_louvain(jul2_undirected)
communities_louvain3 <- cluster_louvain(jul3_undirected)
communities_louvain4 <- cluster_louvain(jul4_undirected)
communities_louvain5 <- cluster_louvain(jul5_undirected)

# Find communities with fast greedy clustering(code is commented for performance purposes)
#communities_fast_greedy1 <- cluster_fast_greedy(jul1_undirected)
#communities_fast_greedy2 <- cluster_fast_greedy(jul2_undirected)
#communities_fast_greedy3 <- cluster_fast_greedy(jul3_undirected)
#communities_fast_greedy4 <- cluster_fast_greedy(jul4_undirected)
#communities_fast_greedy5 <- cluster_fast_greedy(jul5_undirected)


# ... and again with infomap clustering(code is commented for performance purposes)
#communities_infomap1 <- cluster_infomap(jul1_undirected)
#communities_infomap2 <- cluster_infomap(jul2_undirected)
#communities_infomap3 <- cluster_infomap(jul3_undirected)
#communities_infomap4 <- cluster_infomap(jul4_undirected)
#communities_infomap5 <- cluster_infomap(jul5_undirected)

#1 user comparison for communities
membership(communities_louvain1)["mashable"]
membership(communities_louvain2)["mashable"]
membership(communities_louvain3)["mashable"]
membership(communities_louvain4)["mashable"]
membership(communities_louvain5)["mashable"]

#subgraph plot mid communities
V(jul1)$color <- factor(membership(communities_louvain1))
V(jul2)$color <- factor(membership(communities_louvain2))
V(jul3)$color <- factor(membership(communities_louvain3))
V(jul4)$color <- factor(membership(communities_louvain4))
V(jul5)$color <- factor(membership(communities_louvain5))

community_size1 <- sizes(communities_louvain1)
community_size2 <- sizes(communities_louvain2)
community_size3 <- sizes(communities_louvain3)
community_size4 <- sizes(communities_louvain4)
community_size5 <- sizes(communities_louvain5)

#Day 1 plot 
inMidCommunity1<-unlist(communities_louvain1[community_size1 > 40 & community_size1 < 80])
jul1Sbgrph <- induced.subgraph(jul1, inMidCommunity1)
plot(jul1Sbgrph, vertex.label = NA, edge.arrow.width = 0.8, edge.arrow.size = 0.2, 
     coords = layout_with_fr(jul1Sbgrph), margin = 0, vertex.size = 3)
#Day 2 plot
inMidCommunity2<-unlist(communities_louvain2[community_size2 > 40 & community_size2 < 90])
jul2Sbgrph<-induced.subgraph(jul2, inMidCommunity2)
plot(jul2Sbgrph, vertex.label = NA, edge.arrow.width = 0.8, edge.arrow.size = 0.2, 
     coords = layout_with_fr(jul2Sbgrph), margin = 0, vertex.size = 3)
#Day 3 plot
inMidCommunity3<-unlist(communities_louvain3[community_size3 > 30 & community_size3 < 100])
jul3Sbgrph<-induced.subgraph(jul3, inMidCommunity3)
plot(jul3Sbgrph, vertex.label = NA, edge.arrow.width = 0.8, edge.arrow.size = 0.2, 
     coords = layout_with_fr(jul3Sbgrph), margin = 0, vertex.size = 3)
#Day 4 plot
inMidCommunity4<-unlist(communities_louvain4[community_size4 > 30 & community_size4 < 100])
jul4Sbgrph<-induced.subgraph(jul4, inMidCommunity4)
plot(jul4Sbgrph, vertex.label = NA, edge.arrow.width = 0.8, edge.arrow.size = 0.2, 
     coords = layout_with_fr(jul4Sbgrph), margin = 0, vertex.size = 3)
#Day 5 plot
inMidCommunity5<-unlist(communities_louvain5[community_size5 > 40 & community_size5 < 100])
jul5Sbgrph<-induced.subgraph(jul5, inMidCommunity5)
plot(jul5Sbgrph, vertex.label = NA, edge.arrow.width = 0.8, edge.arrow.size = 0.2, 
     coords = layout_with_fr(jul5Sbgrph), margin = 0, vertex.size = 3)