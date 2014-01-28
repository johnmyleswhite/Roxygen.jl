function lex(text::Vector{Char})
    nchars = length(text)

    if nchars < 1
        error("No text available for lexing")
    end

    index = 1
    c = text[index]

    state = WHITESPACE

    buffer = IOBuffer()

    tokens = Array(Token, 0)

    while index <= nchars
        if state == WHITESPACE
            # Continue to end of token
            while isspace(c) && index <= nchars
                write(buffer, c)
                index += 1
                if index <= nchars
                    c = text[index]
                end
            end

            # Store token
            contents = bytestring(buffer)
            truncate(buffer, 0)
            token = Token(WHITESPACE, contents)
            push!(tokens, token)

            # Transition into the next state
            if c == '@'
                # Check if directive
                write(buffer, '@')
                index += 1
                if index <= nchars
                    c = text[index]
                end
                if c == '@'
                    state = DIRECTIVE
                    write(buffer, '@')
                    index += 1
                    if index <= nchars
                        c = text[index]
                    end
                elseif c == ' '
                    error("Invalid @ encountered")
                else
                    state = TEXT
                    write(buffer, c)
                    index += 1
                    if index <= nchars
                        c = text[index]
                    end
                end
            else
                state = TEXT
                write(buffer, c)
                index += 1
                if index <= nchars
                    c = text[index]
                end
            end
        elseif state == DIRECTIVE
            # Continue to end of token
            while isalpha(c) && index <= nchars
                write(buffer, c)
                index += 1
                if index <= nchars
                    c = text[index]
                end
            end

            # Store token
            contents = bytestring(buffer)
            truncate(buffer, 0)
            token = Token(DIRECTIVE, contents)
            push!(tokens, token)

            # Transition into the next state
            if isspace(c)
                state = WHITESPACE
            else
                state = TEXT
            end
        elseif state == TEXT
            # Continue to end of token
            while !isspace(c) && index <= nchars
                write(buffer, c)
                index += 1
                if index <= nchars
                    c = text[index]
                end
            end

            # Store token
            contents = bytestring(buffer)
            truncate(buffer, 0)
            token = Token(TEXT, contents)
            push!(tokens, token)

            # Transition into the next state
            state = WHITESPACE
        end
    end

    token = Token(state, bytestring(buffer))
    push!(tokens, token)

    return tokens
end
