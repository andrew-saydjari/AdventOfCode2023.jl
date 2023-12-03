import Pkg
Pkg.activate(".")
basedir = "./"
using BenchmarkTools
Pkg.add("ReadableRegex")
using ReadableRegex

input = readlines(basedir*"data/input_02.txt")

# Part 1
regex_green = @compile look_for(one_or_more(DIGIT),
    before = " green")
regex_red = @compile look_for(one_or_more(DIGIT),
    before = " red")
regex_blue = @compile look_for(one_or_more(DIGIT),
    before = " blue")

function get_color(draw,regex)
    m = eachmatch(regex,draw)
    words = getfield.(m, :match)
    if length(words) == 0
        return 0
    else
        return parse(Int,words[1])
    end
end

function get_draw_lsts(input)
    colonsplit = split(input,": ")
    game = parse(Int,filter(isdigit,colonsplit[1]))
    draws = split(colonsplit[2],"; ")
    red = get_color.(draws,Ref(regex_red))
    green = get_color.(draws,Ref(regex_green))
    blue = get_color.(draws,Ref(regex_blue))
    return game, red, green, blue
end

function possible_condition(input,red_max=12,green_max=13,blue_max=14)
    game, red, green, blue = get_draw_lsts(input)
    pass = (maximum(green) <= green_max) & (maximum(red) <= red_max) & (maximum(blue) <= blue_max)
    if pass
        return game
    else
        return 0
    end
end

get_draw_lsts(input[1])
possible_condition(input[1])

get_draw_lsts(input[2])
possible_condition(input[2])

function solution(input)
    return sum(possible_condition.(input))
end

solution(input)

@benchmark solution(input)

# Part 2

function get_power(input)
    game, red, green, blue = get_draw_lsts(input)
    return maximum(red)*maximum(green)*maximum(blue)
end

function solution_final(input)
    return sum(get_power.(input))
end

solution_final(input)

@benchmark solution_final(input)