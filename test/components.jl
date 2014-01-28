module TestComponents
	using Roxygen

	srcpath = "test/example.jl"

	chunks = Roxygen.extractdocs(srcpath)

	lexemes = Roxygen.lex(chunks[1])
	doc = Roxygen.parse_plus_semantics(lexemes)
	summary = Roxygen.markdown(doc)

	# For debugging, set io = STDOUT
	io = IOBuffer()
	print(io, CharString(chunks[1]))
	print(io, summary)

	lexemes = Roxygen.lex(chunks[2])
	doc = Roxygen.parse_plus_semantics(lexemes)
	summary = Roxygen.markdown(doc)

	# For debugging, set io = STDOUT
	io = IOBuffer()
	print(io, CharString(chunks[2]))
	print(io, summary)
end
