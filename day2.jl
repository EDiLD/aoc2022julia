include("utils.jl")

input = get_data(2)

function score(game)
    base = parse(Int, replace(game[2], "Rock" => 1, "Scissors" => 3, "Paper" => 2))

    wins = Dict("Rock" => "Scissors", "Scissors" => "Paper", "Paper" => "Rock")

    if (wins[game[2]] == game[1])
        outcome = 6
    elseif (game[1] == game[2])
        outcome = 3
    else
        outcome = 0
    end
    score = base + outcome
    return(score)
end

# strategy = [["A", "Y"], ["B","X"],["C","Z"]]
# strategy = replace.(strategy, 
#     "A" => "Rock", "B" => "Paper", "C" => "Scissors",  
#     "X" => "Rock", "Y" => "Paper", "Z" => "Scissors")
# strategy
# score.(strategy)

function part1(input)
    strategy = split.(split(strip(input), "\n"))
    strategy = replace.(strategy, 
        "A" => "Rock", "B" => "Paper", "C" => "Scissors",  
        "X" => "Rock", "Y" => "Paper", "Z" => "Scissors")
    sum(score.(strategy))
end    

@info part1(input)


function score2(game)
    # @info game
    wins = Dict("Rock" => "Scissors", "Scissors" => "Paper", "Paper" => "Rock")
    choices = Dict(values(wins) .=> keys(wins))

    if (game[2] == "draw")
        choice = game[1]
    elseif (game[2] == "win")
        choice = choices[game[1]]
    else
        choice = wins[game[1]]
    end
    choice = parse(Int, replace(choice, "Rock" => 1, "Scissors" => 3, "Paper" => 2))

    outcome = parse(Int, replace(game[2], "loose" => 0, "draw" => 3, "win" => 6))
    score = choice + outcome
    return(score)
end

# strategy = [["A", "Y"], ["B","X"],["C","Z"]]
# strategy = replace.(strategy, 
#     "A" => "Rock", "B" => "Paper", "C" => "Scissors",  
#     "X" => "loose", "Y" => "draw", "Z" => "win")
# strategy
# game = strategy[1]
# score2(game)
# score2.(strategy)

function part2(input)
    strategy = split.(split(strip(input), "\n"))
    strategy = replace.(strategy, 
        "A" => "Rock", "B" => "Paper", "C" => "Scissors",  
        "X" => "loose", "Y" => "draw", "Z" => "win")
    sum(score2.(strategy))
end   


@info part2(input)
