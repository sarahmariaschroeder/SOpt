# runtest.jl


####################################################################################################
#                                                                                                  #
#        ROTINA QUE CALCULA OS TESTES DE VALIDAÇÃO PARA TENSÕES EM UM ELEMENTO DE PÓRTICO          #
#                        USANDO O LFRAME E AS NOSSAS ROTINAS INTERNAS                              #
#                                                                                                  #
####################################################################################################

# TESTE 1 -- EXAMPLES/VALIDACAO.YAML 

# TESTES NAS SEÇÕES DE INTERESSE: ENGASTE (NÓ 1), MEIO (NÓ 2) E PONTA (NÓ 3)

@testset "Validação das tensões internas" begin

    # Calcula pela função do main
    vetor_tensoes, vetor_tensoes_equivalentes = main()
    # @show vetor_tensoes #p debug
    @show vetor_tensoes_equivalentes #p debug

    # PARA O VETOR DAS TENSOES N T M

    # Para o elemento 1
    println("\n NÓ 1, pt 0 \n")
    σ_N_10 = vetor_tensoes[1]
    τ_10 = vetor_tensoes[2]
    σ_M10 = vetor_tensoes[3]

    # Compara com o isapprox
    @test isapprox(σ_N_10, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_10, 636619.77237, rtol = 1e-2)
    @test isapprox(σ_M10, 5439281.74, rtol = 1e-2)


    println("\n ELEMENTO 1, NÓ 1, pt 1 \n")
    σ_N_11 = vetor_tensoes[4]
    τ_11 = vetor_tensoes[5]
    σ_M11 = vetor_tensoes[6]

    # Compara com o isapprox
    @test isapprox(σ_N_11, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_11, 636619.77237, rtol = 1e-2) 
    @test isapprox(σ_M11, -5439281.74, rtol = 1e-2)

    println("\n ELEMENTO 1, NÓ 2, pt 0 \n")
    σ_N_20 = vetor_tensoes[7]
    τ_20 = vetor_tensoes[8]
    σ_M20 = vetor_tensoes[9]

    # Compara com o isapprox
    @test isapprox(σ_N_20, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_20,  636619.77237, rtol = 1e-2) # contando q o nó é imediatamente antes da aplicação do torque, que é a interpretação do lframe
    @test isapprox(σ_M20, 2546479.10, rtol = 1e-2)
    
    println("\n ELEMENTO 1, NÓ 2, pt 1 \n")
    σ_N_21 = vetor_tensoes[10]
    τ_21 = vetor_tensoes[11]
    σ_M21 = vetor_tensoes[12]

    # Compara com o isapprox
    @test isapprox(σ_N_21, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_21, 636619.77237, rtol = 1e-2) # contando q o nó é imediatamente antes da aplicação do torque, que é a interpretação do lframe
    @test isapprox(σ_M21, -2546479.10, rtol = 1e-2)

    println("\n ELEMENTO 2, NÓ 1, pto 0  \n")
    σ_N_30 = vetor_tensoes[13]
    τ_30 = vetor_tensoes[14]
    σ_M30 = vetor_tensoes[15]

    # Compara com o isapprox
    @test isapprox(σ_N_30, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_30, 0.00000, rtol = 1e-2)
    @test isapprox(σ_M30, 2546479.10, rtol = 1e-2)

    println("\n ELEMENTO 2, NÓ 1, pto 1  \n")
    σ_N_31 = vetor_tensoes[16]
    τ_31 = vetor_tensoes[17]
    σ_M31 = vetor_tensoes[18]

    # Compara com o isapprox
    @test isapprox(σ_N_31, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_31, 0.00000, rtol = 1e-2)
    @test isapprox(σ_M31, -2546479.10, rtol = 1e-2)

    println("\n ELEMENTO 2, NÓ 2, pto 0  \n")
    σ_N_40 = vetor_tensoes[19]
    τ_40 = vetor_tensoes[20]
    σ_M40 = vetor_tensoes[21]

    # Compara com o isapprox
    @test isapprox(σ_N_40, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_40, 0.00000, rtol = 1e-2)
    @test isapprox(σ_M40, 0.00000, rtol = 1e-2)

    println("\n ELEMENTO 2, NÓ 2, pto 1  \n")
    σ_N_41 = vetor_tensoes[22]
    τ_41 = vetor_tensoes[23]
    σ_M41 = vetor_tensoes[24]

    # Compara com o isapprox
    @test isapprox(σ_N_41, 31830.98862, rtol = 1e-2)
    @test isapprox(τ_41, 0.00000, rtol = 1e-2)
    @test isapprox(σ_M41, 0.00000, rtol = 1e-2)

    # AGORA PARA A TENSAO EQUIVALENTE 
    @testset "Validação das Tensões Equivalentes (Von Mises)" begin

        println("\n Tensão Equivalente - ELEMENTO 1, NÓ 1, pt 0 \n")
        σ_VM_10 = vetor_tensoes_equivalentes[1]
        @test isapprox(σ_VM_10, 5585587.89, rtol = 1e-2)

        # ELEMENTO 1, NÓ 1, PONTO 1 (NÓ 1, pt 1 do seu teste)
        println("\n Tensão Equivalente - ELEMENTO 1, NÓ 1, pt 1 \n")
        σ_VM_11 = vetor_tensoes_equivalentes[2]
        @test isapprox(σ_VM_11, 5518730.01, rtol = 1e-2)

        # ELEMENTO 1, NÓ 2, PONTO 0 (NÓ 2, pt 0 do seu teste)
        println("\n Tensão Equivalente - ELEMENTO 1, NÓ 2, pt 0 \n")
        σ_VM_20 = vetor_tensoes_equivalentes[3]
        @test isapprox(σ_VM_20, 2804213.84, rtol = 1e-2)

        # ELEMENTO 1, NÓ 2, PONTO 1 (NÓ 2, pt 1 do seu teste)
        println("\n Tensão Equivalente - ELEMENTO 1, NÓ 2, pt 1 \n")
        σ_VM_21 = vetor_tensoes_equivalentes[4]
        @test isapprox(σ_VM_21, 2745788.19, rtol = 1e-2)

        # ELEMENTO 2, NÓ 1, PONTO 0 (NÓ 3, pt 0 do seu teste)
        println("\n Tensão Equivalente - ELEMENTO 2, NÓ 1, pt 0 \n")
        σ_VM_30 = vetor_tensoes_equivalentes[5]
        @test isapprox(σ_VM_30, 2578310.09, rtol = 1e-2)

        # ELEMENTO 2, NÓ 1, PONTO 1 (NÓ 3, pt 1 do seu teste)
        println("\n Tensão Equivalente - ELEMENTO 2, NÓ 1, pt 1 \n")
        σ_VM_31 = vetor_tensoes_equivalentes[6]
        @test isapprox(σ_VM_31, 2514648.11, rtol = 1e-2)

        # ELEMENTO 2, NÓ 2, PONTO 0 (NÓ 4, pt 0 do seu teste)
        println("\n Tensão Equivalente - ELEMENTO 2, NÓ 2, pt 0 \n")
        σ_VM_40 = vetor_tensoes_equivalentes[7]
        @test isapprox(σ_VM_40, 31830.99, rtol = 1e-2)

        # ELEMENTO 2, NÓ 2, PONTO 1 (NÓ 4, pt 1 do seu teste)
        println("\n Tensão Equivalente - ELEMENTO 2, NÓ 2, pt 1 \n")
        σ_VM_41 = vetor_tensoes_equivalentes[8]
        @test isapprox(σ_VM_41, 31830.99, rtol = 1e-2)

    end # FIM TENSOES EQ



end # FIM TENSOES GERAL
