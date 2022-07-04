module TriadicMemory
export memorize!
export query!
export SDRMemory

# create a triadic memory of size n 
# inserted vectors are dense vectors of size P integers of value of up to
# N - specifiying the non zero bit location in the sparse vector 

mutable struct SDRMemory
    N::Int
    P::Int
    mem::Array{UInt8, 3}


    function SDRMemory()
        N = 1000
        P = 10
        new(N,P,zeros(UInt8,N,N,N))
    end

    function SDRMemory(N::Int,P::Int)
        if P*10 > N 
            error("SDR Memory is not sparse enough: P should be less than or equal to N/10...")
        end
        new(N,P,zeros(UInt8,N,N,N))
    end

end


function binarize(x,r,N,P)
    sorted = sort(x)
    rankedmax = sorted[ N - P + 1]
    if rankedmax == 0
		rankedmax = 1
    end

	j=1
	for i = 1:N
        if x[i] >= rankedmax
            if (j<= P) 
                r[j] = i
            else
                println("Warning: j>P - rankedmax is $rankedmax,  retrieved vector is probably wrong")
            end
            j+=1
        end
    end
end


# we insert into memory in two diffferent column based order:
# once for a sequencial access and once for z. We use the fact that the high nibble
# of the memory content is mostly unused and can use it to store the second ordering count
# idea taken from Scheme implementation of Roger Turner
# https://github.com/rogerturner/TriadicMemory/blob/main/triadicmemory.ss

function memorize!(s::SDRMemory, xvec::Vector{Int64},yvec::Vector{Int64},zvec::Vector{Int64})
    P = ismissing(xvec) ? (ismissing(yvec) ? (ismissing(zvec) ? length(xvec) : length(zvec)) : length(yvec)) : length(xvec)
    if P != s.P
        error("wrong vector size to insert into memory")
    end

    for z in zvec
        for y in yvec
            for x in xvec
                s.mem[x,y,z] += 1
            end
        end
    end
    for x in xvec
        for y in yvec
            for z in zvec
                s.mem[z,y,x] += 16
            end
        end
    end
end 


function query!(s::SDRMemory,xvec,yvec,zvec)
    N = size(s.mem,1)
    P = ismissing(xvec) ? (ismissing(yvec) ? (ismissing(zvec) ? length(xvec) : length(zvec)) : length(yvec)) : length(xvec)
    if P != s.P
        error("wrong vector size to use for query memory")
    end

    temp_vec_N = zeros(Int16,N)
    ret_vec = zeros(Int16,P)
    
    # notice that z sequencial access is better done using 
    # the x "like" locations - just looking at the high nibble
    # this allows us to speed up memory access since Julia is storing
    # sequece in column order see https://discourse.numenta.org/t/triadic-memory-a-fundamental-algorithm-for-cognitive-computing/9763/73
    # for more details..
    if ismissing(zvec)
        for x in xvec
            @simd  for y in yvec
                @views temp_vec_N += (s.mem[:,y,x] .>> 4)               
            end
        end
    elseif  ismissing(xvec)
        for y in yvec
            @simd  for z in zvec
                @views temp_vec_N += (s.mem[:,y,z] .& 0x0f)
            end
        end
    elseif ismissing(yvec)
        for x in xvec
            @simd for z in zvec
                @views temp_vec_N += (s.mem[x,:,z] .& 0x0f)                
            end
        end
    end
    
    binarize(temp_vec_N,ret_vec, N,P)
    return ret_vec
end 

end
