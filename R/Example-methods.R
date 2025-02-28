
SimpleListS7 <- function(...) {

    obj <- sls7(parentList = SimpleList())
    ## here some additional code for the constructor
    return(obj)
}

queueElem <- new_generic("queueElem", "x")

method(queueElem, sls7) <-  function(x, elem)
{
    x@parentList <- c(x@parentList, elem)
    return(x)
}

queueElems <- new_generic("queueElems", "x")

method(queueElems, sls7) <-  function(x, ...)
{
    x@parentList <- c(x@parentList, ...)
    return(x)
}

getLen <- new_generic("genLen", "x")
method(getLen, sls7) <-  function(x)
{
    return(length(x@parentList))
}
