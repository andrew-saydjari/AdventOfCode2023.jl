import Pkg
basedir = "./software/AdventOfCode2023.jl/"
Pkg.activate(basedir)
using BenchmarkTools

input = readlines(basedir*"data/input_05.txt")
input_test = readlines(basedir*"data/input_05t.txt")

# Part 1
function get_maps(input)
    map_splits = findall(input.=="")
    map_lsts = []
    for i=1:length(map_splits)
        if i < length(map_splits)
            push!(map_lsts,input[(map_splits[i]+2):(map_splits[i+1]-1)])
        else
            push!(map_lsts,input[(map_splits[i]+2):end])
        end
    end
    return map_lsts
end

function translate_map(old_prop_in,map_current)
    new_prop_out = copy(old_prop_in)
    for i=1:length(map_current)
        dest_start, source_start, rlen = parse.(Int,split(map_current[i]," "))
        msk = (source_start .<= old_prop_in .<= (source_start+rlen-1))
        if count(msk) != 0
            ind2change = findall(msk)
            for ind in ind2change
                refindx = findfirst((source_start:(source_start+rlen-1)).==old_prop_in[ind])
                new_prop_out[ind] = (dest_start:(dest_start+rlen-1))[refindx]
            end
        end 
    end
    return new_prop_out
end

function chain_translate(seeds,map_lsts)
    property_vec = []
    push!(property_vec,seeds)
    for (indx, map_current) in enumerate(map_lsts)
        push!(property_vec,translate_map(property_vec[indx],map_current))
    end
    return property_vec
end

seeds = parse.(Int,split(input_test[1]," ")[2:end])
map_lsts = get_maps(input_test)
property_vec = chain_translate(seeds,map_lsts)
minimum(property_vec[end])

seeds = parse.(Int,split(input[1]," ")[2:end])
map_lsts = get_maps(input)
property_vec = chain_translate(seeds,map_lsts)
minimum(property_vec[end])

function solution(input)
    seeds = parse.(Int,split(input[1]," ")[2:end])
    map_lsts = get_maps(input)
    property_vec = chain_translate(seeds,map_lsts)
    return minimum(property_vec[end])
end

solution(input)

# Part 2

# idea is to store as start and range and split if necessary
# transform tuple list at each row
# the biggest problem is the splitting

function make_seed_tuples(input)
    seeds = parse.(Int,split(input[1]," ")[2:end])
    seed_tuples = []
    for i=1:(length(seeds)÷2)
        push!(seed_tuples,(seeds[2*(i-1)+1],seeds[2*(i-1)+2]))
    end
    return seed_tuples
end

input_tup = make_seed_tuples(input_test)
map_lsts = get_maps(input_test)
dest_start, source_start, rlen = parse.(Int,split(map_lsts[1][1]," "))
sourcetup = (source_start,rlen)
desttup = (dest_start,rlen)
out_tup, offset_tup = transform_tuple(input_tup[1],maptup,desttup)

function transform_tuple(intup,sourcetup,desttup)
    out_lst = []
    if (sourcetup[1] <= intup[1]) & (intup[1]+intup[2]-1 <= sourcetup[1]+sourcetup[2]-1)
        low_end = maximum([sourcetup[1],intup[1]])
        low_offset = low_end - sourcetup[1]
        high_end = minimum([sourcetup[1]+sourcetup[2]-1,intup[1]+intup[2]-1])
        high_offset = high_end - (sourcetup[1]+sourcetup[2]-1)
        return (desttup[1]+low_offset, desttup[2]+high_offset)
    else
        return intup
    end
end

function translate_map(old_prop_in,map_current)
    new_prop_out = copy(old_prop_in)
    for i=1:length(map_current)
        dest_start, source_start, rlen = parse.(Int,split(map_current[i]," "))
        msk = (source_start .<= old_prop_in .<= (source_start+rlen-1))
        if count(msk) != 0
            ind2change = findall(msk)
            for ind in ind2change
                refindx = findfirst((source_start:(source_start+rlen-1)).==old_prop_in[ind])
                new_prop_out[ind] = (dest_start:(dest_start+rlen-1))[refindx]
            end
        end 
    end
    return new_prop_out
end