library(devtools)
load_all()
# Create an instance of the S7 class, embedding the S4 object
# ex <- sls7(parent=SimpleList())

sls7 <- SimpleListS7()

# Call the method
sls7 <- queueElem(sls7, 2)
sls7@parentList
sls7 <- queueElems(sls7,2,3,4,5,6)
getLen(sls7)

unlist(sls7@parentList)

median(unlist(sls7@parentList))





