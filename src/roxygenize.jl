function process(srcpath::String, verbose::Bool = false)
	if verbose
		println("Extracting document chunks")
	end
	chunks = extractdocs(srcpath)

	n = length(chunks)

	summaries = Array(UTF8String, n)
	for i in 1:n
		if verbose
			println("Lexing document chunk $i")
		end
		lexemes = lex(chunks[i])

		if verbose
			println("Parsing document chunk $i")
		end
		doc = parse_plus_semantics(lexemes)

		if verbose
			println("Generating markdown for document $i")
		end
		summaries[i] = markdown(doc)
	end
	return summaries
end

function roxygenize(srcdir::String, destdir::String, verbose::Bool = false)
	srcpaths = readdir(srcdir)
	if !ispath(destdir)
		try
			mkdir(destdir)
		catch
			error("Failed to make directory $destdir")
		end
	end
	for srcpath in srcpaths
		if endswith(srcpath, ".jl")
			if verbose
				@printf("Processing file '%s'\n", srcpath)
			end
			destpath = joinpath(destdir, replace(srcpath, ".jl", ".md"))
			summary = process(joinpath(srcdir, srcpath), verbose)
			if length(summary) > 0
				io = open(destpath, "w")
				print(io, join(summary, "\n---\n\n"))
				close(io)
			end
		end
	end
end
