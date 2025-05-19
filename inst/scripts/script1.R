library(devtools)
load_all()
# Create an instance of the S7 class, embedding the S4 object
# ex <- sls7(parent=SimpleList())

# Creating the S7 class
sls7 <- SimpleListS7()

# Call the S7 method
sls7 <- queueElem(sls7, 2)
sls7@parentList
sls7 <- queueElems(sls7,2,3,4,5,6)
getLen(sls7)


## Because the @ is directly accessible, you can directly interact with S4 object and
## call S4 methods defined for it.

unlist(sls7@parentList)

median(unlist(sls7@parentList))





