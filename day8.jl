include("utils.jl")

input = get_data(8)

# input = "30373
# 25512
# 65332
# 33549
# 35390
# "

raw = split.(split(strip(input), "\n"), "")
parsed = [parse.(Int, row) for row in raw]
raster = transpose(reduce(hcat, parsed))
raster


edge = [raster[:, 1] ,
    raster[:, end],
    raster[1, 2:end-1],
    raster[end, 2:end-1]]

visible = []
for row in 2:size(raster, 1)-1
    for col in 2:size(raster, 2)-1
        vis_top = sum(raster[1:row-1, col] .< raster[row, col]) == row-1
        vis_bottom = sum(raster[row+1:end, col] .< raster[row, col]) == size(raster, 1)-row
        vis_left = sum(raster[row, 1:col-1] .< raster[row, col]) == col-1
        vis_right = sum(raster[row, col+1:end] .< raster[row, col]) == size(raster, 1)-col
        vis = vis_top | vis_bottom | vis_left | vis_right
        # @info row, col, vis, vis_top, vis_bottom, vis_left, vis_right
        if vis
            append!(visible, 1)
        end
    end
end

append!(visible, vcat(edge...))

@info size(visible, 1)


function dist(vec, thrs)
    higher = findall(x -> x .>= thrs, vec)
    if length(higher) == 0
        return(length(vec))
    else
        return(minimum(higher))
    end
end

max_score = 0
# edge will have a score of 0, consider only inner
for row in 2:size(raster, 1)-1
    for col in 2:size(raster, 2)-1
        height = raster[row, col]
        dist_top = dist(reverse(raster[1:row-1, col]), height)
        dist_left = dist(reverse(raster[row, 1:col-1]), height)
        dist_right = dist(raster[row, col+1:end], height)
        dist_bottom = dist(raster[row+1:end, col], height)
        score = dist_top * dist_bottom * dist_left * dist_right
        # @info row, col, max_score, score, dist_top, dist_bottom, dist_left, dist_right
        if score > max_score
            max_score = score
        end
    end
end

@info max_score
