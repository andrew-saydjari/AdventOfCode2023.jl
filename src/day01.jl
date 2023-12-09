import Pkg
Pkg.activate(".")
basedir = "./"
using BenchmarkTools
using ReadableRegex

input = readlines(basedir*"data/input_01.txt")

# Part 1

function get_first_last(instring)
    diglst = filter(isdigit,instring)
    return diglst[1]*diglst[end]
end

function solution(input)
    numlst = get_first_last.(input)
    result = sum(parse.(Int,numlst))
    return result
end

get_first_last.(input)

solution(input)
@benchmark solution(input)

# Part 2

name2digit = Dict("one"=>"1","two"=>"2","three"=>"3","four"=>"4","five"=>"5","six"=>"6","seven"=>"7","eight"=>"8","nine"=>"9",
    "1"=>"1","2"=>"2","3"=>"3","4"=>"4","5"=>"5","6"=>"6","7"=>"7","8"=>"8","9"=>"9")

    
reg = @compile either(DIGIT,"one","two","three","four","five","six","seven","eight","nine")
regex = r"(?:(?:\d)|(?:one)|(?:two)|(?:three)|(?:four)|(?:five)|(?:six)|(?:seven)|(?:eight)|(?:nine))"

function get_first_last_new(instring)
    m = eachmatch(reg,instring,overlap=true)
    words = getfield.(m, :match)
    diglst = map(x->name2digit[x],words)
    return diglst[1]*diglst[end]
end

function solution_final(input)
    numlst = get_first_last_new.(input)
    result = sum(parse.(Int,numlst))
    return result
end

tstind = 17
input[tstind]
m = eachmatch(reg,input[tstind],overlap=true)
words = getfield.(m, :match)
diglst = map(x->name2digit[x],words)
get_first_last_new(input[tstind])
get_first_last_new.(input)

solution_final(input)
@benchmark solution_final(input)

# Test

inputtest = ["two1nine",
"eightwothree",
"abcone2threexyz",
"xtwone3four",
"4nineeightseven2",
"zoneight234",
"7pqrstsixteen"]

get_first_last_new.(inputtest)
solution_final(inputtest)

