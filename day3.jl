include("utils.jl")

input = get_data(3)

# input = "vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw"

"""
    get_points(x)

Convert a string to points

# Examples
```julia-repl
julia> get_points('r')
18
```

"""
function get_points(x::Char)
    points = merge(Dict(zip('a':'z', 1:26)), Dict(zip('A':'Z', 27:52)))
    total = sum(map(x -> points[collect(x)[1]], x))
end

function item(rucksack)
    items = split(rucksack, "")
    comp1 = items[1:convert(Int, length(items)/2)]
    comp2 = items[convert(Int, length(items)/2) + 1:length(items)]
    # matches = unique(comp1[findall(map(x -> x in comp2, comp1))])
    matches = intersect(comp1, comp2)
end

function part1(input)
    rucksacks = split(strip(input), "\n")
    sum(get_points.(item.(rucksacks)))
end


@time @info part1(input)

function part1_alt(input)
    rucksacks = split(strip(input), "\n")
    common =  [intersect(rucksack[1:convert(Int, length(rucksack)/2)], rucksack[convert(Int, length(rucksack)/2)+1:end]) for rucksack in rucksacks]
    sum(get_points.(common))
end

@time @info part1_alt(input)



function part2(input)
    rucksacks = split(strip(input), "\n")
    badges = [intersect(rucksacks[i:i+2]...) for i in 1:3:length(rucksacks)]
    sum(get_points.(badges))
end
@time @info part2_alt(input)
