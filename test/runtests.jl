#| Based on TriadicMemory/triadicmemory.c by Peter Overmann

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the “Software”), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.

# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


using TriadicMemory
using Test


function timing_test()

    N = 1000
    P = 10
    
    CYCLES = 10000
    println("Timing for memorizing & querying $CYCLES vectors")
    w = @elapsed begin
        global CYCLES 
        mem = SDRMemory(N,P)

        # prepare test vectors
        x_input = zeros(Int64,CYCLES,P)
        y_input = zeros(Int64,CYCLES,P)
        z_input = zeros(Int64,CYCLES,P)

        for i in 1:CYCLES
            # ceil will make sure that the smallest number is 1 
            x_input[i,:] = sort(ceil.(Int,rand(P)*N))
            y_input[i,:] = sort(ceil.(Int,rand(P)*N))
            z_input[i,:] = sort(ceil.(Int,rand(P)*N))
        end 
    
        # check that the vectors dont have identical numbers 

        while true 
            redo = false
            for i in 1:CYCLES
                for k in 1:P-1
                    if x_input[i,k] == x_input[i,k+1]
                        x_input[i,k+1] = ceil(Int,rand()*N)
                        x_input[i,:] = sort(x_input[i,:])
                        redo = true
                        break
                    end
                    if y_input[i,k] == y_input[i,k+1]
                        y_input[i,k+1] = ceil(Int,rand()*N)
                        y_input[i,:] = sort(y_input[i,:])
                        redo = true
                        break
                    end
                    if z_input[i,k] == z_input[i,k+1]
                        z_input[i,k+1] = ceil(Int,rand()*N)
                        z_input[i,:] = sort(z_input[i,:])
                        redo = true
                        break
                    end
                end
            end
            redo || break
        end
    end
    speed = round(CYCLES/w, digits=2)
    println("preparing $CYCLES vectors took $w seconds: $speed per sec")
    w = @elapsed  for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        memorize!(mem,x,y,z)
    end
    speed = round(CYCLES/w, digits=2)
    println("Memorizing $CYCLES vectors took $w seconds: $speed per sec")


    # Query Z given x,y
    ####################
    errors = 0
    @time w = @elapsed for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        qz = query!(mem,x,y,missing)
         if  qz != z
            errors += 1
        end
    end
    speed = round(CYCLES/w, digits=2)
    println("querying z $CYCLES vectors took $w seconds: $speed per sec, $errors errors")

    
    # Query Y  given x,z
    ####################
    errors = 0
    @time w = @elapsed for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        qy = query!(mem,x,missing,z)
         if  qy != y
            errors += 1
        end
    end
    speed = round(CYCLES/w, digits=2)
    println("querying y $CYCLES vectors took $w seconds: $speed per sec, $errors errors")

    # Query X given z,y
    ####################
    errors = 0
    @time w = @elapsed for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        qx = query!(mem,missing,y,z)
         if  qx != x
             errors += 1
        end
    end
    speed = round(CYCLES/w, digits=2)
    println("querying x $CYCLES vectors took $w seconds: $speed per sec, $errors errors")
    return errors
end 

function memory_errors()

    N = 1000
    P = 10
    
    CYCLES = 100
    println("testing $CYCLES vectors memory operations")
    begin
        global CYCLES 
        mem = SDRMemory(N,P)

        # prepare test vectors
        x_input = zeros(Int64,CYCLES,P)
        y_input = zeros(Int64,CYCLES,P)
        z_input = zeros(Int64,CYCLES,P)

        for i in 1:CYCLES
            # ceil will make sure that the smallest number is 1 
            x_input[i,:] = sort(ceil.(Int,rand(P)*N))
            y_input[i,:] = sort(ceil.(Int,rand(P)*N))
            z_input[i,:] = sort(ceil.(Int,rand(P)*N))
        end 
    
        # check that the vectors dont have identical numbers 

        while true 
            redo = false
            for i in 1:CYCLES
                for k in 1:P-1
                    if x_input[i,k] == x_input[i,k+1]
                        x_input[i,k+1] = ceil(Int,rand()*N)
                        x_input[i,:] = sort(x_input[i,:])
                        redo = true
                        break
                    end
                    if y_input[i,k] == y_input[i,k+1]
                        y_input[i,k+1] = ceil(Int,rand()*N)
                        y_input[i,:] = sort(y_input[i,:])
                        redo = true
                        break
                    end
                    if z_input[i,k] == z_input[i,k+1]
                        z_input[i,k+1] = ceil(Int,rand()*N)
                        z_input[i,:] = sort(z_input[i,:])
                        redo = true
                        break
                    end
                end
            end
            redo || break
        end
    end
    for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        memorize!(mem,x,y,z)
    end
 

    # Query Z given x,y
    ####################
    errors = 0
    for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        qz = query!(mem,x,y,missing)
         if  qz != z
            errors += 1
        end
    end
    #println("querying z $CYCLES vectors took $w seconds: $speed per sec, $errors errors")

    
    # Query Y  given x,z
    ####################
    errors = 0
    for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        qy = query!(mem,x,missing,z)
         if  qy != y
            errors += 1
        end
    end
    #println("querying y $CYCLES vectors took $w seconds: $speed per sec, $errors errors")

    # Query X given z,y
    ####################
    errors = 0
    for i in 1:CYCLES
        x = x_input[i,:]
        y = y_input[i,:]
        z = z_input[i,:]
        qx = query!(mem,missing,y,z)
         if  qx != x
             errors += 1
        end
    end
    #println("querying x $CYCLES vectors took $w seconds: $speed per sec, $errors errors")
    return errors
end 


@testset "TriadicMemory.jl" begin
    @test timing_test() == 0   
    @test memory_errors() == 0   
end
