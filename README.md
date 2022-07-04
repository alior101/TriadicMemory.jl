# TriadicMemory

[![Build Status](https://github.com/alior101/TriadicMemory.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/alior101/TriadicMemory.jl/actions/workflows/CI.yml?query=branch%3Amain)

Julia implementation based on https://github.com/PeterOvermann with optimization and improvements from https://github.com/rogerturner/TriadicMemory.

See PeterOverman github for detailed algorithm documentation.

Example:

```
julia> include("src/examples.jl")
Memorizing x=[1, 2, 3, 4],y=[5, 6, 7, 8], z=[9, 10, 11, 12]

Querying z given x,y
Querying with x=[1, 2, 3, 4],y=[5, 6, 7, 8], z=missing
Memorized z is Int16[9, 10, 11, 12]

Querying x given y,z
Querying with x=missing,y=[5, 6, 7, 8], z=[9, 10, 11, 12]
Memorized x is Int16[1, 2, 3, 4]

Querying y given x,z
Querying with x=[1, 2, 3, 4],y=missing, z=[9, 10, 11, 12]
Memorized y is Int16[5, 6, 7, 8]
```
