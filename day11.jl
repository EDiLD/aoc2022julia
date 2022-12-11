include("utils.jl")

input = get_data(11)

# input = "Monkey 0:
#   Starting items: 79, 98
#   Operation: new = old * 19
#   Test: divisible by 23
#     If true: throw to monkey 2
#     If false: throw to monkey 3

# Monkey 1:
#   Starting items: 54, 65, 75, 74
#   Operation: new = old + 6
#   Test: divisible by 19
#     If true: throw to monkey 2
#     If false: throw to monkey 0

# Monkey 2:
#   Starting items: 79, 60, 97
#   Operation: new = old * old
#   Test: divisible by 13
#     If true: throw to monkey 1
#     If false: throw to monkey 3

# Monkey 3:
#   Starting items: 74
#   Operation: new = old + 3
#   Test: divisible by 17
#     If true: throw to monkey 0
#     If false: throw to monkey 1
# "


using Parameters
@with_kw mutable struct Monkey
    Items::Vector{Int} = []          # Vector of items
    Operation::Function = x -> x     # function to change Item level
    test::Int = 1             # factor used in testing
    if_true::String = "-1"          # receiving monkey
    if_false::String = "-1"           # receiving monkey
    inspections::Int = 0        # counter for inspections
end

function test(Monkey::Monkey, Item)
    mod(Item, Monkey.test) == 0
end


## Examples
Monkey()
m0 = Monkey([79, 98], x -> x * 19, 23, "2", "3", 0)
test(m0, 23)
m0.if_true
m0.if_false

function parse_monkey(input)
    lines = split(strip(input), "\n")
    monkeys = Dict()
    monkey = []
    for line in lines
        if startswith(line, "Monkey") # add monkey to dict
            monkey = replace(line, r"^Monkey (\d):$" => s"\1")
            push!(monkeys, monkey => Monkey())
        elseif startswith(line, "  Starting items: ")
            items = parse.(Int, split(replace(line, r"^  Starting items: (.*)$" => s"\1"), ", "))
            monkeys[monkey].Items = items
        elseif startswith(line, "  Operation: ")
            op = replace(line, r"^  Operation: new = old(.*)$" => s"\1")
            op = replace(op, "old" => "x")
            opp = Meta.parse("x -> x" * op)
            fnx = eval(opp)
            monkeys[monkey].Operation = fnx
        elseif startswith(line, "  Test: ")
            test = parse(Int, replace(line, r"^  Test: divisible by (.*)$" => s"\1"))
            monkeys[monkey].test = test
        elseif startswith(line, "    If true: ")
            if_true = replace(line, r"^    If true: throw to monkey (.*)$" => s"\1")
            monkeys[monkey].if_true = if_true
        elseif startswith(line, "    If false: ")
            if_false = replace(line, r"^    If false: throw to monkey (.*)$" => s"\1")
            monkeys[monkey].if_false = if_false
        end
    end
    return (sort(monkeys))
end
parse_monkey(input)

# function keep_away(input) 
#! Cand run this in a function because of some error
# "can't be run because different worlds?"
# = it has to do something with eval() [which is never nice - i know...]
    monkeys = parse_monkey(input)
    for round in 1:20
        for (key, val) in monkeys
            @debug "Monkey $key:"
            for item in collect(val.Items)
                @debug "    Monkey inspects an item with a worry level of $item"
                val.inspections += 1
                wl = val.Operation(item)
                @debug "        Worry level is multiplied by x to $wl."
                wl = floor(Int, wl / 3)
                @debug "        Monkey gets bored with item. Worry level is divided by 3 to $wl."
                if (test(val, wl))
                    @debug "        Test true"
                    to = String(val.if_true)
                    push!(monkeys[to].Items, wl)
                else
                    @debug "        Test false"
                    to = String(val.if_false)
                    push!(monkeys[to].Items, wl)
                end
                @debug "        Item with worry level $wl is thrown to monkey $to."
                deleteat!(val.Items, 1)
            end
        end
    end
    monkeys
    
    # return (monkeys)
# end

# using Logging
# global_logger(ConsoleLogger(Logging.Debug))

# play = keep_away(input)
inspections = [x.inspections for x in values(monkeys)]

@info "Monkey business: " prod(sort(inspections, rev =  true)[1:2])



monkeys = parse_monkey(input)
# monkey test by division. We don't need to store the actual worry level, but only if it's divisible
# A common multiple for the monkeys is given by the product (not necessarily the smalest multiple)
# we store the modulo instead (if it'S divisible it would be)
modulus = prod([x.test for x in values(monkeys)])
for round in 1:10000
    for (key, val) in monkeys
        @debug "Monkey $key:"
        for item in collect(val.Items)
            @debug "    Monkey inspects an item with a worry level of $item"
            val.inspections += 1
            wl = val.Operation(item)
            # replace wl with modulus instead of item to check for divisability
            wl = mod(wl, modulus)
            @debug "        Worry level is multiplied by x to $wl."
            if (test(val, wl))
                @debug "        Test true"
                to = String(val.if_true)
                push!(monkeys[to].Items, wl)
            else
                @debug "        Test false"
                to = String(val.if_false)
                push!(monkeys[to].Items, wl)
            end
            @debug "        Item with worry level $wl is thrown to monkey $to."
            deleteat!(val.Items, 1)
        end
    end
end
monkeys

inspections = [x.inspections for x in values(monkeys)]
sort(inspections, rev =  true)[1:2]
@info "Monkey business: " prod(sort(inspections, rev =  true)[1:2])
