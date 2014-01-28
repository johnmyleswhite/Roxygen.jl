fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
anyerrors = false

using Base.Test
using Roxygen

my_tests = ["roxygenize.jl"]

println("Running tests:")

for my_test in my_tests
	mkdir(Pkg.dir("Roxygen", "output"))
    try
        include(Pkg.dir("Roxygen", "test", my_test))
        println("\t\033[1m\033[32mPASSED\033[0m: $(my_test)")
    catch
        anyerrors = true
        println("\t\033[1m\033[31mFAILED\033[0m: $(my_test)")
        if fatalerrors
            rethrow()
        end
    end
	rm(Pkg.dir("Roxygen", "output", "example.md"))
	rmdir(Pkg.dir("Roxygen", "output"))
end

if anyerrors
    throw("Tests failed")
end
