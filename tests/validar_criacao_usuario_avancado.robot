*** Settings ***
Documentation       Suite de testes avançados para o endpoint de criação de usuários.
Resource            ../resources/variables.robot
Resource            ../resources/api_keywords.robot
Test Setup          Iniciar Sessão na API

*** Test Cases ***
# Teste positivo: todos os campos opcionais preenchidos
Criar usuário com todos os campos opcionais preenchidos
    [Tags]    positivo    completo
    &{payload}=    Gerar Payload com Campos Opcionais
    Log To Console    Payload Enviado: ${payload}
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    A resposta deve indicar sucesso na criação    resposta=${resposta}

# Teste positivo: caracteres especiais
Criar usuário com caracteres especiais em campos de texto
    [Tags]    positivo    especial
    &{payload}=    Gerar Payload com Caracteres Especiais
    Log To Console    Payload Enviado: ${payload}
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    A resposta deve indicar sucesso na criação    resposta=${resposta}

# Teste positivo: nome com tamanho mínimo e máximo
Criar usuário com nome de tamanho mínimo permitido
    [Documentation]    Testa a criação de um usuário com o nome no tamanho mínimo permitido.
    [Tags]             positivo    borda    tamanho-minimo
    # Passo 1: Iniciar a sessão da API.
    Iniciar Sessão na API
    # Passo 2: Gerar um payload com o nome no tamanho mínimo (1 caractere).
    &{payload}=    Gerar Payload com Nome de Tamanho Limite    1
    Log To Console    Payload Mínimo: ${payload}
    # Passo 3: Enviar a requisição.
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    # Passo 4: Validar a resposta.
    A resposta deve indicar sucesso na criação    resposta=${resposta}
    O corpo da resposta deve conter os dados do usuário enviado    resposta=${resposta}    payload_enviado=${payload}

Criar usuário com nome de tamanho máximo permitido
    [Documentation]    Testa a criação de um usuário com o nome no tamanho máximo permitido.
    [Tags]             positivo    borda    tamanho-maximo
    # Passo 1: Iniciar a sessão da API.
    Iniciar Sessão na API
    # Passo 2: Gerar um payload com o nome no tamanho máximo (255 caracteres, por exemplo).
    &{payload}=    Gerar Payload com Nome de Tamanho Limite    255
    Log To Console    Payload Máximo: ${payload}
    # Passo 3: Enviar a requisição.
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    # Passo 4: Validar a resposta.
    A resposta deve indicar sucesso na criação    resposta=${resposta}
    O corpo da resposta deve conter os dados do usuário enviado    resposta=${resposta}    payload_enviado=${payload}

# Teste negativo: email inválido
Criar usuário com e-mail em formato inválido
    [Tags]    negativo    email
    &{payload}=    Gerar Payload com Email Inválido
    Log To Console    Payload Inválido: ${payload}
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    
    

# Teste negativo: CPF inválido
Criar usuário com CPF inválido
    [Tags]    negativo    cpf
    &{payload}=    Gerar Payload com CPF Inválido
    Log To Console    Payload Inválido: ${payload}
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    Validar resposta de erro da API    ${resposta}    status_code_esperado=400    mensagem_esperada=${MENSAGEM_ERRO_CPF_INVALIDO}

# Teste negativo: campo extra não esperado / TESTE ESTA PASSANDO

Criar usuário com campo extra não esperado 
    [Tags]    negativo    campoextra
    &{payload}=    Gerar Payload com Campo Extra
    Log To Console    Payload Inválido: ${payload}
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    Validar resposta de erro da API    resposta=${resposta}    status_code_esperado=400

# Teste negativo: sem autenticação
Criar usuário sem autenticação
    [Tags]    negativo    auth
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    Log To Console    Payload Enviado: ${payload}
    ${resposta}=    Criar Usuário Sem Token    ${payload}
    Validar resposta de erro da API    resposta=${resposta}    status_code_esperado=401

# Teste negativo: método HTTP incorreto
Criar usuário com método HTTP incorreto
    [Tags]    negativo    metodo
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    ${resposta}=    Criar Usuário Com Metodo Incorreto    ${payload}
    Validar resposta de erro da API    resposta=${resposta}    status_code_esperado=405

# Teste negativo: payload vazio
Criar usuário com payload vazio
    [Tags]    negativo    vazio
    ${resposta}=    Criar Usuário Com Payload Vazio
    Validar resposta de erro da API    resposta=${resposta}    status_code_esperado=400    mensagem_esperada=${MENSAGEM_ERRO_CAMPOS_OBRIGATORIOS}

# Teste negativo: JSON malformado
*** Test Cases ***
Criar usuário com JSON malformado
    [Tags]    negativo    malformado
    
    # A chamada da palavra-chave corrigida
    ${resposta}=    Criar Usuário Com Json Malformado
    
    # Valida a resposta da API, que deve ser um erro 400.
    Validar resposta de erro da API    
    ...    resposta=${resposta}
    ...    status_code_esperado=400
    
# Teste de performance: múltiplos usuários em sequência
Criar múltiplos usuários em sequência
    [Tags]    performance
    FOR    ${i}    IN RANGE    1    6
        ${payload}=    Gerar Payload de Usuário Válido e Dinâmico
        Log To Console    Payload ${i}: ${payload}
        ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
        A resposta deve indicar sucesso na criação    resposta=${resposta}
    END