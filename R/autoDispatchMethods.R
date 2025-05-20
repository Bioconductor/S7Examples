library(S7)
library(IRanges)

MyIRangesS7 <- new_class(
    "MyIRangesS7",
    properties = list(parent = class_any)
)

S4_register(MyIRangesS7)
dispatch_S4_to_S7 <- function(s4_class, s7_class) {
    raw <- showMethods(classes=s4_class, printTo=FALSE)
    generic_lines <- grep("^Function:", raw, value = TRUE)
    extract_generic_name <- function(line) sub("Function: ([^ ]+).*", "\\1", line)
    method_names <- unique(vapply(generic_lines, extract_generic_name, character(1)))
    skip <- c("coerce", "names<-", "initialize", "parallel_slot_names", "width", "end")
    method_names <- setdiff(method_names, skip)
    skipped_methods <- character(0)
    for (meth in method_names) {
        tryCatch({
            if (!exists(meth, mode = "function")) {
                assign(meth, new_generic(meth, "x"), envir = .GlobalEnv)
            }
            `method<-`(
                get(meth, envir = .GlobalEnv),
                s7_class,
                eval(bquote(
                    function(x, ...) .(as.name(meth))(x@parent, ...)
                ))
            )
        }, error = function(e) {
            skipped_methods <<- c(skipped_methods, meth)
        })
    }
    if (length(skipped_methods) > 0) {
        message("Skipped methods (not delegated): ", paste(skipped_methods, collapse = ", "))
    } else {
        message("All methods delegated successfully!")
    }
}

dispatch_S4_to_S7("IRanges", MyIRangesS7)

if (!exists("width", mode = "function")) width <- new_generic("width", "x")
if (!exists("end", mode = "function"))   end   <- new_generic("end", "x")
if (!exists("as.data.frame", mode = "function"))   end   <- new_generic("as.data.frame", "x")

method(width, MyIRangesS7) <- function(x) width(x@parent)
method(end, MyIRangesS7)   <- function(x) end(x@parent)
method(as.data.frame, MyIRangesS7)   <- function(x) as.data.frame(x@parent)


ir <- IRanges(start = c(1,5,10), width = 3)
obj <- MyIRangesS7(parent = ir)
print(obj)
length(obj)        # 3
start(obj)         # 1 5 10
end(obj)           # 3 7 12
width(obj)         # 3 3 3
as.data.frame(obj) # dataframe of ranges


# ---------------------- Approach 2!!!

auto_delegate_method <- function(meth, s7_class) {
    if (!exists(meth, mode = "function")) {
        assign(meth, new_generic(meth, "x"), envir = .GlobalEnv)
    }
    method(get(meth, envir = .GlobalEnv), s7_class) <-
        eval(bquote(
            function(x, ...) .(as.name(meth))(x@parent, ...)
        ))
}
dispatch_all_methods_S4_to_S7 <- function(s4_class, s7_class, skip = c()) {
    raw <- showMethods(classes = s4_class, printTo = FALSE)
    generic_lines <- grep("^Function:", raw, value = TRUE)
    extract_generic_name <- function(line) sub("Function: ([^ ]+).*", "\\1", line)
    method_names <- unique(vapply(generic_lines, extract_generic_name, character(1)))
    method_names <- setdiff(method_names, c(skip, "coerce", "names<-", "initialize"))
    skipped_methods <- character(0)
    for (meth in method_names) {
        # some methods give error because they are not generics or an extension
        # of a base method. Needs some adjustment
        tryCatch(
            auto_delegate_method(meth, s7_class),
            error = function(e) skipped_methods <<- c(skipped_methods, meth)
        )
    }
    if (length(skipped_methods) > 0) {
        message("Skipped methods (not delegated): ", paste(skipped_methods, collapse = ", "))
    } else {
        message("All methods delegated successfully!")
    }
}

library(S7)
library(IRanges)

# S7 class che "wraps" IRanges
MyIRangesS7 <- new_class(
    "MyIRangesS7",
    properties = list(parent = class_any)
)
S4_register(MyIRangesS7) #required by S7

dispatch_all_methods_S4_to_S7("IRanges", MyIRangesS7, skip = c("width", "end")) # width/end a mano sotto

# Test
ir <- IRanges(start = c(1,5,10), width = 3)

obj <- MyIRangesS7(parent = ir)
length(obj)        # 3
start(obj)         # 1 5 10
end(obj)           # 3 7 12
width(obj)         # 3 3 3
as.data.frame(obj) # dataframe of ranges

start(ir) <- c(2,3,5) # working
start(obj) <- c(2,3,5) # not working


