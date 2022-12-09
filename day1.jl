include("utils.jl")

input = get_data(1)

function part_1(input)
    elves = split.(split(input, "\n\n"))
    calories = [sum(parse.(Int, elve)) for elve in elves]
    sort(calories, rev = true)
end
@info part_1(input)[1]

function part_2(calories, top = 3)
    sum(calories[1:top])
end
@info part_2(part_1(input))
