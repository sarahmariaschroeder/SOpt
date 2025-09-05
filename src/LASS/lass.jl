# Código que define uma subrotina que recebe o vetor x com os valores
# que serão utilizadas para descrever o carregamento. Pega esse vetor e a 
# estrutura de malha, roda a análise, calcula o vetor de tensões, a norma e devolve



# Função para extrair os nos e gdls do carregamento ignorando a magnitude 
# (vai ser definida pelo vetor x)
function extrai_loads(malha)

    # Cria um vetor de Tuples
    locais = Tuple{Int64,Int64}[]

    # Loop pelas linhas de malha.loads,
    # pegando só o nó e a direção
    for (no, gdl, _) in malha.loads
        push!(locais, (no, gdl))
    end

    # Retorna o vetor de tuples
    return locais 

end

# Função para aplicar esse carregamento desse vetor
#
# x é um vetor com as variáveis aleatórias ( magnitude
# das forças )
#
function aplica_loads!(malha, x::Vector)

    # Pega os loads que foram extraídos
    # locais = extrai_loads(malha)

    # Teste dimensao
    if size(malha.loads,1) != length(x)
        error("Dimensao de malha.loads tem que ser o mesmo de x")
    end

    # Aplica os carregamentos com os valores do vetor x
    for i in 1:length(x)
        malha.loads[i,3] = x[i]
    end

end

# Função que devolve a norma p
function Realiza_norma(x::Vector,  malha, P=8.0)

    # Aplica as forças
    aplica_loads!(malha, x)

    # Calcula a resposta da estrutura
    U,_ = Analise3D(malha,false)

    # Calcula tensoes equivalentes
    σ = tensao_equivalente(U, malha)

    # Calcula norma P
    norma = norm(σ,P) # sum((σ^P))^(1/P)

    # Devolve
    return norma

end


#
# Gera todas as realizações de forças para usar no LASS
#
function gera_distribuicoesforcas(malha, n_r=100, σ2=0.4)

    # Número de forças 
    nload = size(malha.loads,1)

    # Matriz n_load × n_r com as realizações 
    realiza = zeros(nload,n_r)
    
    # Loop pelas magnitudes da malha
    for i = 1:nload
        magn  = malha.loads[i,3]
        media = magn               # média é a magnitude que tá na malha
        desvio = sqrt(abs(σ2*media))         # como definir e onde?     
        realiza[i,:] .= rand(Normal(media, desvio),n_r) 
    end

    # Retorna a matriz com todas as realizações
    return realiza

end


# Função que ve o efeito das incertezas nas forças nas tensões
function distribui_tensoes(malha, realizacoes)

    # numero de elementos
    nele = malha.ne

    # Número de realizações
    n_r = size(realizacoes, 2)

    # Gera um vetor que guarda essas informações
    #
    # Eu entendo que aqui são as tensões equivalentes (escalar)
    #
    tensoes = zeros(4*nele, n_r) 

    # Pega os pares (nó, gdl) da malha — onde aplicar cada força
    # locais = [(linha[1], linha[2]) for linha in eachrow(malha.loads)]

    #@show locais 

    # Loop por cada realização de forças (cada vetor x)
    for j in 1:n_r

        # Aplica a realização j das forças
        for i in size(malha.loads,1) 
            valor_forca = realizacoes[i, j]
            malha.loads[i,3] = valor_forca
        end
        
        # Calcula a resposta da estrutura
        U,_ = Analise3D(malha,false)

        # Calcula as tensões equivalentes pra essa realização
        σ_eq = tensao_equivalente(U, malha)

        # Salva o resultado da tensão dessa realização na matriz
        tensoes[:, j] .= σ_eq
    end

    # Retorna a matriz com todas as tensões por elemento e realização
    return tensoes
end


# --- LASS EM AÇÃO :))))
function roda_lass(malha,n_r)

    # Define distribuições das forças 
    dists = gera_distribuicoesforcas(malha,n_r)

    # Grava as realizações 
    writedlm("realizaforcas.txt",dists)

    # Número de amostras por variável (força)
    n_amostras = 5

    # Forma um vetor com os numeros de bins de cada variavel
    Nb = [n_amostras for i=1:size(dists,1)]  # no exemplo validacao.yaml fica [50 50 50 50]
    
    # Gera bins
    bins = Generate_bins(dists, Nb)

    #@show bins

    # Roda LASS
    E, Var = Lass(bins, x -> Realiza_norma(x, malha))  

    println("Esperança da norma: $E")
    println("Variância da norma: $Var")

    return E, Var
end



