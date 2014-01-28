immutable Token
    kind::Int
    contents::UTF8String
end

immutable Variable
	varname::UTF8String
	vartype::UTF8String
	description::UTF8String
end

type DocumentationChunk
    name::UTF8String
    description::UTF8String
    args::Vector{Variable}
    fields::Vector{Variable}
    returns::Vector{Variable}
    examples::UTF8String
    exported::Bool
end

function DocumentationChunk()
    DocumentationChunk("",
    	               "",
					   Variable[],
					   Variable[],
					   Variable[],
					   "",
					   false)
end
