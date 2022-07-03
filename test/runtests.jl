using TriadicMemory
using Test


@testset "TriadicMemory.jl" begin
    @test timing_test() == 0   
    @test  memory_errors() == 0   
end
