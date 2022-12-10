include("utils.jl")

input = get_data(9)

# input = "R 4
# U 4
# L 3
# D 1
# R 4
# D 1
# L 5
# R 2
# "

function parse_input(input)
    raw = split.(split(strip(input), "\n"), " ")
    [(row[1], parse(Int, row[2])) for row in raw]
end

function move_head(head, direction)
    head = copy(head)
    if (direction == "R")
        head[1] = head[1] + 1
    elseif (direction == "L")
        head[1] = head[1] - 1
    elseif (direction == "U")
        head[2] = head[2] + 1
    elseif (direction == "D")
        head[2] = head[2] - 1
    end

    return(head)
end


function move_tail(tail, head)
    tail = copy(tail)
    if (head[2] == tail[2]) # same row
        # only 1 appart, stay there
        if (abs(head[1] - tail[1]) > 1)
            dx = (head[1] > tail[1] ? 1 : -1)
            tail[1] += dx
        end
    elseif  (head[1] == tail[1]) # same column
        if (abs(head[2] - tail[2]) > 1)
            dy = (head[2] > tail[2] ? 1 : -1)
            tail[2] += dy
        end
    else
        if (abs(head[1] - tail[1]) > 1 ||  abs(head[2] - tail[2]) > 1)
            dx = (head[1] > tail[1] ? 1 : -1)
            dy = (head[2] > tail[2] ? 1 : -1)
            tail[1] += dx
            tail[2] += dy
        end
    end

    return(tail)
end

# start = [1,1]
# head = deepcopy(start)
# tail = deepcopy(start)
# head = move_head(head, "R")
# tail = move_tail(tail, head) # stay

parsed = parse_input(input)
start = [1,1]
head = deepcopy(start)
tail = deepcopy(start)
visited = Set{Tuple{Int, Int}}()

for (direction, steps) in parsed
    for step in 1:steps
        head = move_head(head, direction)
        tail = move_tail(tail, head)
        # @info "[TAIL] HEAD now at " string(head) ". TAIL at" string(tail)
        push!(visited, (tail[1], tail[2]))
    end
end
@info length(visited)


### part 2 -----------------------------------------------
# input = "R 5
# U 8
# L 8
# D 3
# R 17
# D 10
# L 25
# U 20"

# Idea 1 Head and 9 tails. For each tail the head is the previous tail.
# Previous code can be simplified
function part2(input)
    nknots = 10
    parsed = parse_input(input)
    tails = [[1, 1] for i in 1:nknots]
    visited = Set{Tuple{Int, Int}}()

    for (direction, steps) in parsed
        for step in 1:steps
            tails[1] = move_head(tails[1], direction)
            # @info "[HEAD]" tails[1]
            for i in 2:length(tails)
                tails[i] = move_tail(tails[i], tails[i-1])
            end
            push!(visited, (tails[end][1], tails[end][2]))
        end
    end
    visited
end

@info length(part2(input))
