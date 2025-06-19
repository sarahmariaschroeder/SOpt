####################################################################################################################
#                                      MAIN/DRIVER DO PROGRAMA PRINCIPAL                                           #
####################################################################################################################

using LinearAlgebra
using LFrame
using LASS
using Distributions
using DelimitedFiles
using Plots

include("tensao.jl")
include("LASS/lass.jl")


#
#
# x = readdlm("realiza.txt")
#
# histogram(x[1,:])
#
#


# Função principal por enquanto pra rodarmos os Testes
function main()
    #
    # Conecta com o LFrame
    #

    # Inclui as rotinas secundárias
    
    #include("src/auxiliar.jl")
    #include("src/derivadas.jl")



    # Define o arquivo
    arquivo = "examples/validacao.yaml"

    malha = LFrame.Le_YAML(arquivo)

    roda_lass(malha)

    # Soluciona o problema utilizando o LFrame
    #U, malha = Analise3D(arquivo)# ; ρ0) # deixando o rho pra depois

    # Mensagem
    #println("Iniciando o cálculo para validação das tensões presentes na estrutura descrita em $arquivo ...")

    # Pré-aloca os vetores
    #vetor_tensoes = Float64[]
    #vetor_tensoes_equivalentes = Float64[]


    # realiza um looping pelos elementos
    #=
    for ele=1: (malha.ne)
        for no=1:2
            for pto=0:1
                    println("ELEMENTO $ele, NÓ $no E PONTO $pto:")
                    Esforcos_internos, (σ_N, τ, σ_M), σ = Tensao_elemento_no_ponto(ele,no,pto,malha,U)

                    #@show Esforcos_internos, [σ_N;τ;σ_M], σ
                    #println("\n")
                    # Armazena os valores no vetor
                    push!(vetor_tensoes, σ_N)
                    push!(vetor_tensoes, τ)
                    push!(vetor_tensoes, σ_M)

                    push!(vetor_tensoes_equivalentes, σ)
            end
        end  
    end

    return vetor_tensoes, vetor_tensoes_equivalentes
  =#
end
