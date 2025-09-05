#
#             Driver para receber um conjunto de variáveis de projeto e devolver o objetivo e a restrição global de tensões
#
#
# ρ -> vetor com ne variáveis de projeto
#
# bins <- Generate_bins(realizacoes, Nb) <-  realizacoes <- gera_distribuicoesforcas(malha, n_r=100, σ2=0.4)
#
# 
#

# 
#
function Driver(ρ, bins, malha, opcao::String)

    # Dada a distribuição das variáveis de projeto, calcula a resposta da 
    # tensão equivalente com o LASS
    Eσe, Varσe = Lass(bins, x -> Realiza_norma_σe(x, malha, ρ))  



end




# Função que devolve a norma p das σe
function Realiza_norma_σe(x::Vector,  malha, ρ::Vector, P=8.0)

    # Aplica as forças
    aplica_loads!(malha, x)

    # Calcula a resposta da estrutura
    U,_ = Analise3D(malha,false;ρ0=ρ)

    # Calcula tensoes equivalentes
    σe = tensao_equivalente(U, malha)

    # Calcula norma P
    norma = norm(σe,P) # sum((σ^P))^(1/P)

    # Devolve
    return norma

end





# Função que devolve a derivada da norma p das σe
function Realiza_derivada_norma_σe(x::Vector,  malha, ρ::Vector, P=8.0)

    # Aplica as forças
    aplica_loads!(malha, x)

    # Calcula a resposta da estrutura
    U,_ = Analise3D(malha,false;ρ0=ρ)

    # Monta o vetor de carregamento adjunto e também o vetor das derivadas
    # parciais da norma em relação as variáveis de projeto
    #
    # Fλ, D <- .....
    # 
    #

    # Soluciona o problema adjunto 
    #
    # λ <- solução de K λ = Fλ
    #

    # Ultimos calculos e devolve a derivada

    # Calcula tensoes equivalentes
    #σe = tensao_equivalente(U, malha)

    # Calcula norma P
    #norma = norm(σe,P) # sum((σ^P))^(1/P)

    # Devolve
    return Dnorma

end


