import Pkg
Pkg.activate("/uufs/chpc.utah.edu/common/home/u6039752/scratch/julia_env/adventOfCode_193")
basedir = "/uufs/chpc.utah.edu/common/home/sdss42/sdsswork/users/u6039752-1/software/AdventOfCode2023.jl/"
using BenchmarkTools

input = readlines(basedir*"data/input_02.txt")

# Part 1