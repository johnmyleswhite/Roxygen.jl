function parse_name!(lexemes::Vector{Token},
                     i::Integer,
                     doc::DocumentationChunk)
    if lexemes[i + 1].kind != WHITESPACE || lexemes[i + 2].kind != TEXT
        print(lexemes[i + 1].contents)
        println(lexemes[i + 2].contents)
        error("Proper format: @@name NAME")
    end

    doc.name = lexemes[i + 2].contents

    if lexemes[i + 3].kind != WHITESPACE || lexemes[i + 4].kind != DIRECTIVE
        print(lexemes[i + 3].contents)
        println(lexemes[i + 4].contents)
        error("Proper format: @@name NAME")
    end

    return i + 4
end

function parse_exported!(lexemes::Vector{Token},
                         i::Integer,
                         doc::DocumentationChunk)
    doc.exported = true

    while i <= length(lexemes) && lexemes[i].kind != DIRECTIVE
        i += 1
    end

    return i
end

function parse_description!(lexemes::Vector{Token},
                            i::Integer,
                            doc::DocumentationChunk)
    if lexemes[i + 1].kind != WHITESPACE ||
       lexemes[i + 2].kind != TEXT
        error("Proper format: @@description DESCRIPTION...")
    end

    io = IOBuffer()

    i = i + 2

    while i <= length(lexemes) && lexemes[i].kind != DIRECTIVE
        if lexemes[i].kind == TEXT
            print(io, lexemes[i].contents)
        else
            print(io, ' ')
        end
        i += 1
    end

    doc.description = bytestring(io)

    return i
end

function parse_arg!(lexemes::Vector{Token},
                      i::Integer,
                      doc::DocumentationChunk)
    if lexemes[i + 1].kind != WHITESPACE ||
       lexemes[i + 2].kind != TEXT ||
       lexemes[i + 3].kind != WHITESPACE
        error("Proper format: @@arg NAME::TYPE DESCRIPTION...")
    end

    varname, vartype = split(lexemes[i + 2].contents, "::")

    io = IOBuffer()

    i = i + 4

    while i <= length(lexemes) && lexemes[i].kind != DIRECTIVE
        if lexemes[i].kind == TEXT
            print(io, lexemes[i].contents)
        else
            print(io, ' ')
        end
        i += 1
    end

    push!(doc.args, Variable(varname, vartype, bytestring(io)))

    return i
end

function parse_field!(lexemes::Vector{Token},
                      i::Integer,
                      doc::DocumentationChunk)
    if lexemes[i + 1].kind != WHITESPACE ||
       lexemes[i + 2].kind != TEXT ||
       lexemes[i + 3].kind != WHITESPACE
        error("Proper format: @@field NAME::TYPE DESCRIPTION...")
    end

    varname, vartype = split(lexemes[i + 2].contents, "::")

    io = IOBuffer()

    i = i + 4

    while i <= length(lexemes) && lexemes[i].kind != DIRECTIVE
        if lexemes[i].kind == TEXT
            print(io, lexemes[i].contents)
        else
            print(io, ' ')
        end
        i += 1
    end

    push!(doc.fields, Variable(varname, vartype, bytestring(io)))

    return i
end

function parse_return!(lexemes::Vector{Token},
                       i::Integer,
                       doc::DocumentationChunk)
    if lexemes[i + 1].kind != WHITESPACE ||
       lexemes[i + 2].kind != TEXT ||
       lexemes[i + 3].kind != WHITESPACE
        error("Proper format: @@return NAME::TYPE DESCRIPTION...")
    end

    varname, vartype = split(lexemes[i + 2].contents, "::")

    io = IOBuffer()

    i = i + 4

    while i <= length(lexemes) && lexemes[i].kind != DIRECTIVE
        if lexemes[i].kind == TEXT
            print(io, lexemes[i].contents)
        else
            print(io, ' ')
        end
        i += 1
    end

    push!(doc.returns, Variable(varname, vartype, bytestring(io)))

    return i
end

function parse_examples!(lexemes::Vector{Token},
                         i::Integer,
                         doc::DocumentationChunk)
    io = IOBuffer()

    i += 1
    while i <= length(lexemes) && lexemes[i].kind != DIRECTIVE
        print(io, lexemes[i].contents)
        i += 1
    end

    doc.examples = bytestring(io)

    return i
end

function parse_directive!(lexemes::Vector{Token},
                          i::Integer,
                          doc::DocumentationChunk)
    parsers = ["@@name" => parse_name!,
               "@@exported" => parse_exported!,
               "@@description" => parse_description!,
               "@@arg" => parse_arg!,
               "@@field" => parse_field!,
               "@@return" => parse_return!,
               "@@examples" => parse_examples!]
    return parsers[lexemes[i].contents](lexemes, i, doc)
end

function parse_plus_semantics(lexemes::Vector{Token})
    chunk = DocumentationChunk()

    # Ignore everything before the first directive
    i = 1
    while lexemes[i].kind != 1 && i <= length(lexemes)
        i += 1
    end

    while i <= length(lexemes)
        if lexemes[i].kind == DIRECTIVE
            i = parse_directive!(lexemes, i, chunk)
        else
            i += 1
        end
    end

    if !isempty(chunk.args) && !isempty(chunk.fields)
        error("Types do not have args; functions do not have fields.")
    end

    return chunk
end
