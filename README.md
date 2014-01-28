Roxygen.jl
==========

A draft implementation of a Roxygen-like package for automatically
generating documentation from Julia source files.

# Basic Format

The following file shows how a Julia file can use Roxygen through specially
formatted comments:

```
#' @@name count
#'
#' @@description
#'
#' Count the number of missing values in every column of an
#' AbstractDataFrame.
#'
#' @@arg adf::AbstractDataFrame An AbstractDataFrame.
#' @@arg skip::Int The index of a column to skip.
#'
#' @@return missing::Vector{Int} The number of missing values in each column.
#' @@return success::Bool Did the operation complete successfully?
#'
#' @@examples
#'
#' df = DataFrame(A = 1:3, B = ["x", "y", "z"])
#' count(df)

function count(adf::AbstractDataFrame, skip::Int)
	return Int[], false
end

#' @@name sum
#'
#' @@description
#'
#' Sum the elements of each column of an AbstractDataFrame.
#'
#' @@arg adf::AbstractDataFrame An AbstractDataFrame.
#'
#' @@return sums::Vector{Float64} The sums of each column's entries.
#'
#' @@examples
#'
#' df = DataFrame(A = 1:3, B = ["x", "y", "z"])
#' sum(df)

function sum(adf::AbstractDataFrame)
	return Float64[]
end
```

This file contains Julia code as well as comments that use a set of
**directives**, like `@@arg` and `@@return`` to describe properties of the
function being documented. The valid directives and requirements for their
use are described below:

* `@@name`: The name of the function. A name directive usage must look like
  `@@name NAME` with whitespace after the directive and a single name after
  the initial whitespace.
* `@@exported`: Is the function exported by the package being documented?
* `@@description`: A short summary of the use and purpose of the function.
* `@@arg`: A summary of each argument of a function in the order required
   by the function. Must contain argument name, argument type and a
   short verbal description.
* `@@field`: A summary of each field of a composite type in the order required
   by the type's constructor. Must contain field name, field type and a
   short verbal description.
* `@@return`: A summary of each return value of a function in the order
   returned by the function. Must contain value name, value type and a
   short verbal description.
* `@@examples`: A free-form set of examples of the function or type's use.

# Usage Example

To generate documentation for all `.jl` files in the `src` directory and place
this documentation in the `doc` directory, run the following command:

```
using Roxygen
roxygenize("src", "doc")
```

Only files from the source directory that contained Roxygen documentation
will give rise to files in the output directory.
