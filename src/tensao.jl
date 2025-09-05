#
# Ligando o LFRAME com a otimzização
#
using LFrame

function tensao_equivalente(U, malha)

    # Número de elementos na malha
    ne = malha.ne

    # Loop pelos elementos da malha, calculando as 
    # tensões ...
    σ_eq = zeros(4*ne) #Float64[]

    # Loops por elemento/nó/pto
    cont = 1
    for ele=1:ne
       for no=1:2
           for pto=0:1
               σe,_ =  Tensao_elemento_no_ponto(ele,no,pto,malha,U)    
               σ_eq[cont] = σe
               cont += 1
            end
        end  
    end

    return σ_eq

end

#
# Função que devolve o Vetor tensão em um elemento e (1/ne), nó n(1/2) e pto a (0/1)
# 

function Tensao_elemento_no_ponto(ele,no,pto,malha,U; verbose=false)

    # Testes de consistência
    no in [1;2]    || error("Tensao_elemento_no_ponto::nó deve ser 1 ou 2") 
    pto in [0;1]   || error("Tensao_elemento_no_ponto::pto deve ser 0 ou 1")

    # Obtem o vetor de forças nos nós do elemento 
    geo,Fe = Forcas_elemento(ele,malha,U)


    if verbose
        println("Debug no ELEMENTO $ele, NÓ $no, PONTO $pto")
        println("Vetor Fe (Forcas_elemento): $Fe") 
    end

    # Recupera as Proprieades do elemento 
    Ize, Iye, J0e, Ae, αe, Ee, Ge, geo = LFrame.Dados_fundamentais(ele, malha.dados_elementos, 
                                                                   malha.dicionario_materiais, 
                                                                   malha.dicionario_geometrias)
    
    if verbose 
        println("Ize do LFrame: $Ize")
        println("Iye do LFrame: $Iye")
        println("J0e do LFrame: $J0e")
        println("Ae do LFrame: $Ae")
    end
        
    # O raio externo pode ser obtido com 
    re = sqrt(J0e/Ae + Ae/(2*pi))
    if verbose
       println("re calculado: $re")
    end

    # Dependendo do nó, temos os esforços internos
    if no==1
       # Sinal negativo para o primeiro nó porque estamos trabalhando com esforços
       N  = -Fe[1]
       T  = -Fe[4] 
       My = -Fe[5]
       Mz = -Fe[6]
    else 
       N  =  Fe[7]
       T  =  Fe[10] 
       My =  Fe[11]
       Mz =  Fe[12]   
    end
    if verbose
       println("N (esforço interno): $N, T (esforço interno): $T, My (esforço interno): $My, Mz (esforço interno): $Mz")
    end

    # Monta o vetor de esforços internos 
    Esforcos_internos = [N; T; My; Mz]

    # O momento resultante é 
    Mr = sqrt(My^2 + Mz^2)

    if verbose
        println("Momento Resultante (Mr): $Mr")
    end

    # Podemos calcular as componentes de tensão diretamente:

    # Barra
    σ_N = N/Ae

    # Eixo
    τ = re*T/J0e

    # Flexão 
    σ_M = ((-1)^pto)*re*Mr/Ize
    
    if verbose 
        println("σ_N calculado (final): $σ_N")
        println("τ calculado (final): $τ")
        println("σ_M calculado (final): $σ_M")
        println("\n")
    end

    # Podemos calcular a tensão equivalente de von-Mises neste
    # ponto
    σe = sqrt( (σ_N+σ_M)^2 + 3*τ^2 )

    # Retorna o vetor com as tensões do ponto e 
    # também a tensão equivalente e os esforços internos
    return σe, Esforcos_internos, [σ_N;τ;σ_M]

end

