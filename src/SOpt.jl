module SOpt

    # Carrega as dependencias
    using LFrame
    using Distributions
    using LinearAlgebra
    using Test
    using OrderedCollections
    using Lgmsh
    using YAML


    # Carrega os modulos
    include("main.jl")
    include("LASS/lass.jl")
    include("auxiliar.jl")
    include("tensao.jl")
    #include("runtest.jl")



end 