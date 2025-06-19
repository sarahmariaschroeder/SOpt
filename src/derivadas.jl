# Rotina para calcular as derivadas que vao na função de lagrange aumentada
# seção Equação de Lagrange Aumentada no tcc

# A derivada da função de lagrange aumentada é
# dLA = V(ρ) + r <μ/r + c^(k-1)||vetor_σ_eq||/σ_lim-1> c/σ_lim dnorma_p

# A derivada da norma p é
# dnorma_p = 1/P ({soma em todos os pontos}σ_i^P)^(1/P-1)({soma em todos os pontos}P σ_i^(P-1)) dσ_i

# a derivada da tensao equivalente no ponto dσ_i é
# dσ_i = 1/2 (vecσ_i^T VM vecσ_i)^(1/2-1)(dvecσ_i VM vecσ_i + vecσ_i^T VM dvecσ_i) = 1/σ_i vecσ_i^T VM dvecσ_i

# A derivada do vetor de tensões equivalentes no elemento dvecσ_i é
# dvecσ_i = Pna * dN

# A derivada do vetor Ni que é uma função do vetor de esforços Ei é
# dN = D * dE

# A derivada do vetor de esforços internos é
# dE = Mn * dF


# Vem do LFrame: K, r, e os outros dados de sempre

# Define P da norma P
P = 8.0

# Monta a matriz VM (fixa, nao depende de elemento no e pto)
VM = Matriz_VM()

##### começo do looping

# Extraindo os esforços internos, as tensoes no ponto e o vetor de tensoes no elemento
σ_N;τ;σ_M, vecσ_i, Esforcos = Tensao_elemento_no_ponto(ele,no,pto,malha,U)

# Extrai a tensao equivalente de von-Mises
σ_eq = tensao_equivalente(arquivo)

# Pega a matriz Mn no nó 
Mn = Matriz_Mn(no)

# Guarda na derivada dos esforços dE
dE = Mn * dF

# Monta a matriz D (depende do nó)
D = Matriz_D()

# Guarda na derivada do vetor Ni, dN
dN = D * dE

# Guarda na soma de tensoes equivalentes
somaσ_eq = + σ_eq

# Monta a matriz Pna (depende de nó e ponto)
Pna = Matriz_Pna()

# Gurda na derivada do vetor de tensoes do elemento
dvecσ_i = Pna * dN

# Guarda na derivada da função equivalente
dσ_i = 1/σ_i * vecσ_i^T * VM * dvecσ_i

# Guarda na derivada da norma p
dnorma_p = 1/P * (somaσ_i^P)^(1/P-1)(P * somaσ_i^(P-1)) * dσ_i



##### fim do looping




