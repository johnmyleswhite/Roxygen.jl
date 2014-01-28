function process(srcpath::String)
	chunks = extractdocs(srcpath)
	n = length(chunks)
	summaries = Array(UTF8String, n)
	for i in 1:n
		lexemes = lex(chunks[i])
		doc = parse_plus_semantics(lexemes)
		summaries[i] = markdown(doc)
	end
	return summaries
end

function roxygenize(srcdir::String, destdir::String)
	srcpaths = readdir(srcdir)
	for srcpath in srcpaths
		if endswith(srcpath, ".jl")
			destpath = joinpath(destdir, replace(srcpath, ".jl", ".md"))
			summary = process(joinpath(srcdir, srcpath))
			if length(summary) > 0
				io = open(destpath, "w")
				print(io, join(summary, "\n---\n\n"))
				close(io)
			end
		end
	end
end
