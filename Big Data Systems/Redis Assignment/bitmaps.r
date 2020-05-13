# Install the redux package if you haven't done so already
# install.packages("redux")

# Load the library
library("redux")

# Create a connection to the local instance of REDIS
r <- redux::hiredis(
  redux::redis_config(
    host = "127.0.0.1", 
    port = "6379"))

# How to create the SeptemberSales Bitmap: |1|1|0|0|1|1|0|0|
r$SETBIT("SeptemberSales","0","1")
r$SETBIT("SeptemberSales","1","1")
r$SETBIT("SeptemberSales","4","1")
r$SETBIT("SeptemberSales","5","1")

# How to create the AugustSales Bitmap: |0|1|1|0|1|0|0|0|
r$SETBIT("AugustSales","1","1")
r$SETBIT("AugustSales","2","1")
r$SETBIT("AugustSales","4","1")

# How to calculate total September Sales
r$BITCOUNT("SeptemberSales")

# How to perform a bitwise AND operation
r$BITOP("AND","results",c("SeptemberSales","AugustSales"))

# How to display the results of the bitwise AND operation
r$BITCOUNT("results")

# Clear everything stored inside REDIS
r$FLUSHALL()
