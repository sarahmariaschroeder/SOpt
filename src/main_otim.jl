#
# Função principal por enquanto pra rodarmos os Testes
#
# arquivo <- yaml com os dados da malha
# n_r     <- número de realizações
#
function main_otim(arquivo,nr=100_000)

    # Define o arquivo
    malha = LFrame.Le_YAML(arquivo)

    # Número de elementos na malha
    ne = malha.ne

    # Vetor de variáveis de projeto  
    ρ0 = ones(ne)

    # Recupera as intensidades originais das forças, conforme informado no yaml
    forcas0 = malha.loads[:,3]

    # Vamos gerar as realizações para utilizar ao longo da otimização 
    # matriz com nforcas × nr
    realizacoes = gera_distribuicoesforcas(malha,forcas0,nr)

    # Grava as realizações para estudo posterior
    writedlm("realizacoes.txt", realizacoes)

    # Número de amostras por variável (força)
    n_amostras = 5

    # Forma um vetor com os numeros de bins de cada variavel
    Nb = [n_amostras for i=1:size(realizacoes,1)] 
    
    # Gera bins
    bins = Generate_bins(realizacoes, Nb)

    # Podemos gerar o "driver" 
    g(ρ) = Driver(ρ,bins, malha, "g")

    # Chama o driver
    @show g(ρ0)
   
    @show g(rand(ne))

end
