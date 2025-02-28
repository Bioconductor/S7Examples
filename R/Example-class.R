#' SimpleListS7: An S7 Wrapper for SimpleList
#'
#' This class provides an S7 wrapper around the S4 `SimpleList` class
#' from the `S4Vectors` package. It allows seamless delegation of
#' `SimpleList` methods while maintaining S7 object-oriented behavior.
#' @author Dario Righelli
#' @section Properties:
#' - `parentList`: A `SimpleList` object that stores the underlying data.
#'
#' @section Constructor:
#' - `SimpleListS7(...)`: Creates an instance of `SimpleListS7`, initializing
#'   an empty `SimpleList` container.
#'
#' @section Methods:
#'
#' - `queueElem(x, elem)`: Adds a single element to the `SimpleListS7` object.
#' - `queueElems(x, ...)`: Adds multiple elements to the `SimpleListS7` object.
#' - `getLen(x)`: Returns the length (number of elements) in the `SimpleListS7` object.
#'
#' @examples
#' library(S7)
#' library(S4Vectors)
#'
#' # Create an instance of SimpleListS7
#' sls7 <- SimpleListS7()
#'
#' # Add a single element
#' sls7 <- queueElem(sls7, 10)
#'
#' # Add multiple elements
#' sls7 <- queueElems(sls7, 20, 30, 40)
#'
#' # Get the number of elements
#' getLen(sls7)  # Returns 4
#'
#' # Access the underlying SimpleList
#' sls7@parentList
#'
#' @seealso
#' - [S4Vectors::SimpleList] for the original S4 class.
#' - [S7::new_class] for creating S7 classes.
#'
#' @export
sls7 <- new_class("SimpleListS7",
                properties = list(
                    parentList = class_any
                ))




