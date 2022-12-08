include("utils.jl")

input = get_data(7)

# input = "\$ cd /
# \$ ls
# dir a
# 14848514 b.txt
# 8504156 c.dat
# dir d
# \$ cd a
# \$ ls
# dir e
# 29116 f
# 2557 g
# 62596 h.lst
# \$ cd e
# \$ ls
# 584 i
# \$ cd ..
# \$ cd ..
# \$ cd d
# \$ ls
# 4060174 j
# 8033020 d.log
# 5626152 d.ext
# 7214296 k
# "


# compute sum of directory-leafs
function dir_sizes(input)
    lines = split(strip(input), "\n")

    pwd = ""::String
    dirs = Dict("/"=> 0)
    
    for line in lines
        if line == "\$ ls"
            continue
        elseif line == "\$ cd /" # to root
            pwd = "/"
        elseif line == "\$ cd .." # out
            pwd = replace(pwd, r"^(.*/)(.*/)$" => s"\1")
        elseif startswith(line, "\$ cd") # in
            pwd = string(pwd, replace(line, r"^\$ cd (.*)$" => s"\1"), "/")
        elseif startswith(line, "dir")  # add directory to dir
            push!(dirs, string(pwd, replace(line, r"^dir (.*)$" => s"\1"), "/") => 0)
        else # add up
            dirs[pwd] += parse(Int, replace(line, r"^(\d+) .*$" => s"\1"))
        end
    end
    return dirs
end    

dirs = dir_sizes(input)
dirs

# sum up nested directories
function dir_sums(dirs)
    summed_dirs = copy(dirs)
    for dir in keys(summed_dirs)
        summed_dirs[dir] = sum(values(filter(((k, v), ) -> startswith(k, dir) == 1, dirs)))
    end
    return(summed_dirs)
end

dsums = dir_sums(dirs)

@info sum(values(filter(d -> d[2] < 100_000, dsums)))


function delmin(dsums)
    total = 70_000_000
    unused = total - dsums["/"]
    min = 30_000_000
    miss = min - unused
    
    candidates = filter(p -> p[2] > miss, dsums)
    findmin(candidates)[1]
end

@info delmin(dsums)
