include("utils.jl")
# using Pkg; Pkg.add("StatsBase")
using StatsBase

input = get_data(6)

# input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

function find_marker(;input::String, width::Base.Int64 = 4)::Int
    chars = split(input, "")
    
    for i in 1:length(chars)-width+1
        window = chars[i:i+width-1]
        table = StatsBase.countmap(window)
        if (!any(values(table) .> 1))
            return(i+width-1)
        else
            skip
        end
    end
end

@info find_marker(input)

find_marker(input, width = 14)
