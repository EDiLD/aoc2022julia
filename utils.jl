using HTTP
using DotEnv
DotEnv.config()

function get_data(day::Integer, cookie::AbstractString = ENV["AOC"])
    cookies = Dict("session" => cookie)
    r = HTTP.get("https://adventofcode.com/2022/day/$day/input", cookies = cookies)
    String(r.body)
end
