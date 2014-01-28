function markdown(doc::DocumentationChunk)
	io = IOBuffer()

	if doc.exported
		@printf(io, "**Exported**\n\n")
	end

	if !isempty(doc.name)
		@printf(io, "**Name**: %s\n\n", doc.name)
	end

	if !isempty(doc.description)
		@printf(io, "**Description**: %s\n\n", doc.description)
	end

	if !isempty(doc.args)
		@printf(io, "**Arguments**:\n\n")
		for arg in doc.args
			@printf(io,
				    "* %s::%s: %s\n",
				    arg.varname,
				    arg.vartype,
				    arg.description)
		end
		@printf(io, "\n")
	end

	if !isempty(doc.fields)
		@printf(io, "**Fields**:\n\n")
		for field in doc.fields
			@printf(io,
				    " * %s::%s: %s\n",
				    field.varname,
				    field.vartype,
				    field.description)
		end
		@printf(io, "\n")
	end

	if !isempty(doc.returns)
		@printf io "**Return Values**:\n\n"
		for retval in doc.returns
			@printf(io,
				    "* %s::%s: %s\n",
				    retval.varname,
				    retval.vartype,
				    retval.description)
		end
		@printf(io, "\n")
	end

	if !isempty(doc.examples)
		@printf(io,
			    "**Examples**:\n\n```%s```\n",
			    replace(replace(doc.examples, r"^\n+", "\n"),
			    	    r"\n+$", "\n"))
	end

    return bytestring(io)
end
