function extractdocs(path::String)
    io = open(path, "r")

    inchunk = false
    chunks = Array(Vector{Char}, 0)
    i = 0
    if !eof(io)
        c = read(io, Char)#; print(c)
    end

    while !eof(io)
        if !inchunk
            if c == '#' && !eof(io)
                c = read(io, Char)#; print(c)
                if c == '\'' && !eof(io)
                    c = read(io, Char)#; print(c)
                    if c == ' '
                        i += 1
                        inchunk = true
                        push!(chunks, Array(Char, 0))
                    end
                end
            end
            if !eof(io)
                c = read(io, Char)#; print(c)
            end
        else
            if c != '\n'
                push!(chunks[i], c)
                if !eof(io)
                    c = read(io, Char)#; print(c)
                end
            else
                push!(chunks[i], c)
                if !eof(io)
                    c = read(io, Char)#; print(c)
                end
                while isspace(c) && c != '\n' && !eof(io)
                    c = read(io, Char)#; print(c)
                end
                if c == '#' && !eof(io)
                    c = read(io, Char)#; print(c)
                    if c == '\'' && !eof(io)
                        c = read(io, Char)#; print(c)
                        if c == ' '
                            if !eof(io)
                                c = read(io, Char)#; print(c)
                            end
                        elseif c == '\n'
                            1 # NO-OP
                        else
                            inchunk = false
                            if !eof(io)
                                c = read(io, Char)#; print(c)
                            end
                        end
                    else
                        inchunk = false
                        if !eof(io)
                            c = read(io, Char)#; print(c)
                        end
                    end
                else
                    inchunk = false
                    if !eof(io)
                        c = read(io, Char)#; print(c)
                    end
                end
            end
        end
    end

    close(io)

    return chunks
end
