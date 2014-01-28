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
#' m, s = count(df, 0)

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
#' ss = sum(df)

function sum(adf::AbstractDataFrame)
	return Float64[]
end
