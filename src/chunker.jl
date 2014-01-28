function extractdocs(path::String)
    io = open(path, "r")

    inchunk = false
    chunks = Array(Vector{Char}, 0)
    i = 1

    c = '\0'
    while !eof(io)
        c = read(io, Char)
        if !inchunk
            if c == '#'
                if !eof(io)
                    c = read(io, Char)
                    if c == '\''
                        inchunk = true
                        push!(chunks, Array(Char, 0))
                    end
                end
            end
        else
            if c != '\n'
                push!(chunks[i], c)
            else
                push!(chunks[i], c)
                c = read(io, Char)
                while !eof(io) && (c == ' ' || c == '\t')
                    c = read(io, Char)
                end
                if c != '#'
                    # Exit chunk
                    i += 1
                    inchunk = false
                else
                    if !eof(io)
                        c = read(io, Char)
                        if c != '\''
                            # Exit chunk
                            i += 1
                            inchunk = false
                        end
                    end
                end
            end
        end
    end

    close(io)

    return chunks
end
