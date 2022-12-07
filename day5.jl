include("utils.jl")

input = get_data(5)

# input = "    [D]    
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 

# move 1 from 2 to 1
# move 3 from 1 to 3
# move 2 from 2 to 1
# move 1 from 1 to 2
# "

function parse_input(input)
    lines = split(input, "\n")[1:end-1]
    order_begin = minimum(findall(contains.(lines, "move")))
    
    instructionsdata = lines[order_begin:end]
    instructions = [parse.(Int, match.(r"^move (\d+) from (\d+) to (\d+)", move).captures) for move in instructionsdata]
    
    
    stacksdata = lines[1:order_begin-2]
    stack_id = split(stacksdata[end])
    content = hcat(split.(stacksdata[1:end-1], "")...)[2:4:end+1, 1:end]
    stacks = [filter!(x->x != " ", content[row, :]) for row in 1:size(content, 1)]
    return stacks, instructions
end

stacks, instructions = parse_input(input)

function CrateMover9000(stacks, instructions)
    for i in instructions
        # @info i
        # @info stacks
        n = i[1]
        from = i[2]
        to = i[3] 
        take = stacks[from][1:n]
        stacks[from] = stacks[from][n+1:end]
        stacks[to] = append!(reverse(take), stacks[to])
        # @info stacks
    end
    out = string(String.([x[1] for x in stacks])...)
    return out
end


@info CrateMover9000(stacks, instructions)

function CrateMover9001(stacks, instructions)
    for i in instructions
        # @info i
        # @info stacks
        n = i[1]
        from = i[2]
        to = i[3] 
        take = stacks[from][1:n]
        stacks[from] = stacks[from][n+1:end]
        stacks[to] = append!(take, stacks[to])
        # @info stacks
    end
    out = string(String.([x[1] for x in stacks])...)
    return out
end

@info CrateMover9001(stacks, instructions)
