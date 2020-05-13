library(igraph)
library(dplyr)

edges <- read.csv('asoiaf-all-edges.csv')

nodes <- read.csv('asoiaf-all-nodes.csv')

edges<-edges[,c(1,2,5)] 

gotGraph <- graph_from_data_frame(edges, directed=FALSE, vertices=nodes)

#number of vertices 796

gorder(gotGraph)

#number of edges 2823

gsize(gotGraph)

#diameter

get_diameter(gotGraph)

#triangles 5655

length(triangles(gotGraph))/3

#degree top10

tail(sort(degree(gotGraph,loops = FALSE)),10)

#weighted degree top 10 

tail(sort(strength(gotGraph, vids = V(gotGraph), mode = c("all"),
                   loops = FALSE, weights = E(gotGraph)$weights)),10)

#Network Plot

plot(gotGraph,vertex.label = NA,edge.width=0.9,vertex.color="#9999FF",edge.color="#003300", edge.arrow.width=1,vertex.size = 3.7, main = "A Song of Ice and Fire",xlab="Plot of the entire network")

# Calculate the edge density

edge_density(gotGraph)

#Network Plot with at least 10 connections

subGraph<-delete.vertices(gotGraph, 
                             V(gotGraph)[ degree(gotGraph) <= 10  ] )

plot(subGraph,vertex.label = NA,vertex.color="#CC00CC",vertex.shape="circle", edge.arrow.size = 0.5, edge.color="#A0A0A0", edge.width=0.4,vertex.size = 4, main = "A Song of Ice and Fire",xlab="Plot for vertices with >=10 connections")

# Calculate the edge density

edge_density(subGraph)

#Centrality    

tail(sort(betweenness(gotGraph, v = V(gotGraph),  weights = E(gotGraph)$weights, normalized = FALSE)),15)

tail(sort(closeness(gotGraph, vids= V(gotGraph), mode = c("all"), weights = E(gotGraph)$weights, normalized = FALSE)),15)

#PageRank    
rank<-page_rank(gotGraph, algo = "prpack", vids = V(gotGraph), directed = FALSE, damping = 0.85,
                personalized = NULL, weights = E(gotGraph)$weights)

plot(gotGraph,vertex.label = NA,vertex.color="#00CCCC",edge.color="#FFCCFF",edge.arrow.width=0.9,vertex.size=rank$vector*1000, xlab = "Node size based on PageRank value",main="A Song of Ice and Fire Network")
