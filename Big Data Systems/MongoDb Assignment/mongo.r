# Install the mongolite driver
# install.packages("mongolite")

# Load mongolite
library("mongolite")

# Open a connection to MongoDB
m <- mongo(collection = "mycol",  db = "mydb", url = "mongodb://localhost")

# Insert one document
m$insert('{"first_name":"Spiros","last_name":"Safras","age":30}')

# Insert many documents (Nice idea. Do it this way. You don't want to insert ~30K records one by one.)
m$insert(c('{"first_name":"Michael","last_name":"Burnham","age":34}','{"first_name":"Saru","last_name":"Kelpien","age":225}'))

# Find records with age >= 30
m$find('{"age": { "$gte": 30 }}')

# Find records with age >= 30 and return only the first name
m$find('{"age": { "$gte": 30 }}','{ "first_name": 1, "_id": 0 }')

# Insert some more data
m$insert(c('{"first_name":"Michael","last_name":"Scott","age":48}','{"first_name":"Michael","last_name":"Jackson","age":55}'))

# Calculate the AVG age and COUNT of all the entries, grouped by the first name
m$aggregate('[{"$group":{"_id":"$first_name", "avg_age": {"$avg":"$age"}, "count": {"$sum":1}}}]')

# The rest is described in the documentation:
# How to query data: https://jeroen.github.io/mongolite/query-data.html#query-syntax
# How to Insert / Update / Delete: https://jeroen.github.io/mongolite/manipulate-data.html
# How to do aggregations: https://jeroen.github.io/mongolite/calculation.html

# How to load json files

# Install the jsonlite package
# install.packages("jsonlite")

# Load jsonlite
library("jsonlite")

# Save JSON to a variable
json_data <- fromJSON(readLines("C:\\Users\\Spiros\\Desktop\\Redis-Mongo Assignment\\tmp\\20156358.json", encoding="UTF-8"))

# Have a look at the data
json_data

# Get the Mileage
json_data$ad_data$Mileage

# Change the Mileage
json_data$ad_data$Mileage <- gsub(" km", "", json_data$ad_data$Mileage)
json_data$ad_data$Mileage <- gsub(",", "", json_data$ad_data$Mileage)

# Get the updated Mileage
json_data$ad_data$Mileage

# Convert the r object back to JSON format
json_data <- toJSON(json_data, auto_unbox = TRUE)

# Have a look at the JSON string
json_data

# Open a connection to MongoDB
m <- mongo(collection = "ads",  db = "mydb", url = "mongodb://localhost")

# Insert this JSON object to MongoDB
m$insert(json_data)

# Check if it has been inserted
m$find('{}')

# For more information: https://cran.r-project.org/web/packages/jsonlite/jsonlite.pdf