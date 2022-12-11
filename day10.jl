include("utils.jl")

input = get_data(10)

# input = "addx 15
# addx -11
# addx 6
# addx -3
# addx 5
# addx -1
# addx -8
# addx 13
# addx 4
# noop
# addx -1
# addx 5
# addx -1
# addx 5
# addx -1
# addx 5
# addx -1
# addx 5
# addx -1
# addx -35
# addx 1
# addx 24
# addx -19
# addx 1
# addx 16
# addx -11
# noop
# noop
# addx 21
# addx -15
# noop
# noop
# addx -3
# addx 9
# addx 1
# addx -3
# addx 8
# addx 1
# addx 5
# noop
# noop
# noop
# noop
# noop
# addx -36
# noop
# addx 1
# addx 7
# noop
# noop
# noop
# addx 2
# addx 6
# noop
# noop
# noop
# noop
# noop
# addx 1
# noop
# noop
# addx 7
# addx 1
# noop
# addx -13
# addx 13
# addx 7
# noop
# addx 1
# addx -33
# noop
# noop
# noop
# addx 2
# noop
# noop
# noop
# addx 8
# noop
# addx -1
# addx 2
# addx 1
# noop
# addx 17
# addx -9
# addx 1
# addx 1
# addx -3
# addx 11
# noop
# noop
# addx 1
# noop
# addx 1
# noop
# noop
# addx -13
# addx -19
# addx 1
# addx 3
# addx 26
# addx -30
# addx 12
# addx -1
# addx 3
# addx 1
# noop
# noop
# noop
# addx -9
# addx 18
# addx 1
# addx 2
# noop
# noop
# addx 9
# noop
# noop
# noop
# addx -1
# addx 2
# addx -37
# addx 1
# addx 3
# noop
# addx 15
# addx -21
# addx 22
# addx -6
# addx 1
# noop
# addx 2
# addx 1
# noop
# addx -10
# noop
# noop
# addx 20
# addx 1
# addx 2
# addx 2
# addx -6
# addx -11
# noop
# noop
# noop
# "

# input = "noop
# addx 3
# addx -5"

function parse_input(input)
    split.(split(strip(input), "\n"), " ")
end

parsed = parse_input(input)

function part1(input)
    cycle = 1
    X  = 1
    track = []
    push!(track, (cycle, X))
    for instruction in parsed
        if (instruction[1] == "noop")
            cycle += 1
            push!(track, (cycle, X))
        else
            cycle += 1
            push!(track, (cycle, X))
            X += parse(Int, instruction[2])
            cycle += 1
            push!(track, (cycle, X))
        end
    end

    return(track)
end

@info sum(map(x -> x[1] * x[2], part1(parsed)[20:40:end]))


### Part 2-------------------

history = part1(parsed)[1:end-1]

function part2(history, width = 40)
    chunks = [history[1+40*(t-1):40 + 40*(t-1)] for t in 1:convert(Int, length(history) / width)]
    chunks
    lines = String[]
    
    
    for chk in chunks
        line = ""
        for i in 1:40
            take = chk[i]
            if (i  ∈ [take[2], take[2] + 1, take[2] + 2])
                line = line * "#"
            else
                line = line * "."
            end
        end
        push!(lines, line)
    end
    lines
end

part2(history)
