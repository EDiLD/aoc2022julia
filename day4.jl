include("utils.jl")

input = get_data(4)

# input = "2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8\n"

function prep(pair)
    vecs = split.(pair, "-")
    vecs = [parse.(Int, String.(vec)) for vec in vecs]
    first = vecs[1][1]:vecs[1][2]
    second = vecs[2][1]:vecs[2][2]
    (first, second)
end

function include(pair)
    prepped = prep(pair)
    intersect(prepped[1],  prepped[2]) in (prepped[1],  prepped[2])
end

# pairs = split.(split(strip(input), "\n"), ",")
# prep(pairs[1])

# map vs comprehension vs broadcast
# map(include, pairs)
# include.(pairs)
# [include(pair) for pair in pairs]

function part1(input)
    pairs = split.(split(strip(input), "\n"), ",")
    sum(include.(pairs))
end

@info part1(input)



function overlap(pair)
    prepped = prep(pair)
    length(intersect(prepped[1],  prepped[2])) > 0
end

# pairs = split.(split(strip(input), "\n"), ",")
# overlap(pairs[1])

function part2(input)
    pairs = split.(split(strip(input), "\n"), ",")
    sum(overlap.(pairs))
end

@info part2(input)
