import Pkg
basedir = "./software/AdventOfCode2023.jl/"
Pkg.activate(basedir)
using BenchmarkTools

input = readlines(basedir*"data/input_04.txt")

# Part 1
function get_num_lsts(input)
    colonsplit = split(input,": ")
    card = parse(Int,filter(isdigit,colonsplit[1]))
    draws = split(colonsplit[2]," | ")
    win_num = parse.(Int,split(draws[1],' ',keepempty=false))
    my_num = parse.(Int,split(draws[2],' ',keepempty=false))
    return card, win_num, my_num
end

function compute_value(win_num,my_num)
    nmatch = count(my_num .∈ [win_num])
    if nmatch == 0
        return 0
    else
        return 2^(nmatch-1)
    end
end

function get_value(input)
    card, win_num, my_num = get_num_lsts(input)
    return compute_value(win_num,my_num)
end

function solution(input)
    return sum(get_value.(input))
end

solution(input)
@benchmark solution(input)

# Part 2
function solution(input)
    numcardinit = length(input)
    card_vec = ones(Int,numcardinit)
    for i=1:numcardinit
        card, win_num, my_num = get_num_lsts(input[i])
        nmatch = count(my_num .∈ [win_num])
        if (nmatch !=0) & (i != numcardinit)
            max_indx = minimum([numcardinit,i+nmatch])
            card_vec[(i+1):max_indx].+=card_vec[i]
        end
    end
    return sum(card_vec)
end

solution(input)
@benchmark solution(input)