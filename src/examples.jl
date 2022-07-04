using TriadicMemory

N = 1000
P = 4

mem = SDRMemory(N,P);

x = [1,2,3,4]
y = [5,6,7,8]
z = [9,10,11,12]
println("Memorizing x=$x,y=$y, z=$z")

memorize!(mem, x,y,z)

println("\nQuerying z given x,y")
z_query = missing
println("Querying with x=$x,y=$y, z=$z_query")
z_query = query!(mem,x,y,z_query)
println("Memorized z is $z_query")


println("\nQuerying x given y,z")
x_query = missing
println("Querying with x=$x_query,y=$y, z=$z")
x_query = query!(mem,x_query,y,z)
println("Memorized x is $x_query")

println("\nQuerying y given x,z")
y_query = missing
println("Querying with x=$x,y=$y_query, z=$z")
y_query = query!(mem,x,y_query,z)
println("Memorized y is $y_query")

