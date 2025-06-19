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
    U,_ = Analise3D(malha)

    # Calcula tensoes equivalentes
    σ = tensao_equivalente(U, malha)

    # Calcula norma P
    norma = norm(σ,P) # sum((σ^P))^(1/P)

    # Devolve
    return norma

end


#
# Gera todas as realizações para usar no LASS
#
function gera_distribuicoes(malha, n_r=100, σ2=0.4)

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

# --- LASS EM AÇÃO :))))
function roda_lass(malha,n_r=100_000)

    # Define distribuições das forças 
    dists = gera_distribuicoes(malha,n_r)

    # Grava as realizações 
    writedlm("realiza.txt",dists)

    # Número de amostras por variável (força)
    n_amostras = 5

    # Forma um vetor com os numeros de bins de cada variavel
    Nb = [n_amostras for i=1:size(dists,1)]  # no exemplo validacao.yaml fica [50 50 50 50]
    
    # Gera bins
    bins = Generate_bins(dists, Nb)

    @show bins

    # Roda LASS
    E, Var = Lass(bins, x -> Realiza_norma(x, malha))  

    println("Esperança da norma: $E")
    println("Variância da norma: $Var")

    return E, Var
end

