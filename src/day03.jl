import Pkg
Pkg.activate(".")
basedir = "./"
Pkg.add("BenchmarkTools")
using BenchmarkTools

input = readlines(basedir*"data/input_03.txt")

# Part 1
function mskstrip_symbols(input)
    charvec = collect(input)
    mskdigit = isdigit.(charvec)
    msksymbol = .!mskdigit .& (charvec.!='.')
    return mskdigit, msksymbol
end

function get_number(start_indx,lencol,digit_col)
    end_indx = start_indx
    for i=start_indx+1:lencol
        if digit_col[i]
            end_indx = i
        else
            break
        end 
    end
    return start_indx, end_indx
end

function pass_condition(start_indx,end_indx,colindx,lencol,numsamp,msksymbolmat)
    min_indx = maximum([1,start_indx-1])
    max_indx = minimum([lencol,end_indx+1])
    mincol = maximum([1,colindx-1])
    maxcol = minimum([numsamp,colindx+1])
    return any(msksymbolmat[min_indx:max_indx,mincol:maxcol])
end

function get_part_number_sum(input)
    pout = mskstrip_symbols.(input)
    mskdigitmat = hcat(map(x->x[1],pout)...)
    msksymbolmat = hcat(map(x->x[2],pout)...)
    (lencol,numsamp) = size(mskdigitmat)

    outsum = 0
    for colindx = 1:numsamp
        digit_col = mskdigitmat[:,colindx]
        digit_indxs = findall(digit_col)
        last_position = 0
        for digit_indx in digit_indxs
            if digit_indx > last_position
                start_indx, end_indx = get_number(digit_indx,lencol,digit_col)
                last_position = end_indx
                if pass_condition(start_indx,end_indx,colindx,lencol,numsamp,msksymbolmat)
                    outsum += parse(Int,chop(input[colindx], head = start_indx-1, tail = lencol-end_indx))
                end
            end
        end
    end
    return outsum
end

get_part_number_sum(input)

@benchmark get_part_number_sum(input)

# Part 2
function mskstripstar(input)
    charvec = collect(input)
    mskdigit = isdigit.(charvec)
    mskstar = (charvec.=='*')
    return mskdigit, mskstar
end

pout = mskstripstar.(input)
mskdigitmat = hcat(map(x->x[1],pout)...)
mskstarmat = hcat(map(x->x[2],pout)...)
(lencol,numsamp) = size(mskdigitmat)

colindx
star_col = mskstarmat[:,colindx]
star_indxs = findall(star_col)

function gear_ratio_condition(star_indx,colindx,lencol,numsamp,mskdigitmat)
    min_indx = maximum([1,star_indx-1])
    max_indx = minimum([lencol,star_indx+1])
    mincol = maximum([1,colindx-1])
    maxcol = minimum([numsamp,colindx+1])
    submat = mskdigitmat[min_indx:max_indx,mincol:maxcol]
    # println(submat)
    if count(mskdigitmat[min_indx:max_indx,mincol:maxcol]) > 1 #this does not implement "exactly 2", but I don't see any cases that are more than 2.
        realstar_indxs = sort(map(x->(x[1]+min_indx-1,x[2]+mincol-1), findall(submat)), by=last, rev=true)
        # println(realstar_indxs)
        if realstar_indxs[1][2] != realstar_indxs[end][2]
            return true, realstar_indxs
        elseif (length(realstar_indxs) == 2) & (abs(realstar_indxs[1][1] - realstar_indxs[end][1]) == 2)
            return true, realstar_indxs
        else
            return false, []
        end
    else
        return false, []
    end
end

function get_number_sym(start_indx,colindx,lencol)
    digit_col = mskdigitmat[:,colindx]
    end_indx = start_indx
    for i=start_indx+1:lencol
        if digit_col[i]
            end_indx = i
        else
            break
        end 
    end
    for i=end_indx-1:-1:1
        if digit_col[i]
            start_indx = i
        else
            break
        end 
    end
    return start_indx, end_indx
end

function get_gear_ratios(input)
    pout = mskstripstar.(input)
    mskdigitmat = hcat(map(x->x[1],pout)...)
    mskstarmat = hcat(map(x->x[2],pout)...)
    (lencol,numsamp) = size(mskdigitmat)

    outsum = 0
    for colindx = 1:numsamp
        star_col = mskstarmat[:,colindx]
        star_indxs = findall(star_col)
        last_position = 0
        for star_indx in star_indxs
            pass, pix2check = gear_ratio_condition(star_indx,colindx,lencol,numsamp,mskdigitmat)
            # println((colindx,star_indx,pass,pix2check))
            if pass
                pix1 = pix2check[1]
                start_indx1, end_indx1 = get_number_sym(pix1[1],pix1[2],lencol)
                num1 = parse(Int,chop(input[pix1[2]], head = start_indx1-1, tail = lencol-end_indx1))
                pix2 = pix2check[end]
                start_indx2, end_indx2 = get_number_sym(pix2[1],pix2[2],lencol)
                num2 = parse(Int,chop(input[pix2[2]], head = start_indx2-1, tail = lencol-end_indx2))
                outsum += num1*num2
                # println((colindx,star_indx,pass,pix2check,num1,num2))
            end
        end
    end
    return outsum
end

get_gear_ratios(input)