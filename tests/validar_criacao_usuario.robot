*** Settings ***
Documentation       Suite de testes para o endpoint de criação de usuários com dados dinâmicos.
Resource            ../resources/variables.robot
Resource            ../resources/api_keywords.robot
Test Setup          Iniciar Sessão na API

*** Test Cases ***

*** Test Cases ***

Cenário 01: Criar um usuário com dados dinâmicos válidos
    [Tags]    Positivo    SmokeTest    Dinamico
    # Passo 1: Chamar a keyword para gerar nosso payload completo e dinâmico.
    # Veja como o caso de teste ficou mais limpo! A complexidade dos dados foi abstraída.
    &{payload_dinamico}=    Gerar Payload de Usuário Válido e Dinâmico

    # Loga o payload no console. Ótimo para depuração durante o treinamento.
    Log To Console    Payload Enviado: ${payload_dinamico}

    # Passo 2: Enviar a requisição para criar o usuário.
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload_dinamico}

    # Passo 3: Validar a resposta.
    A resposta deve indicar sucesso na criação    resposta=${resposta}
    O corpo da resposta deve conter os dados do usuário enviado    resposta=${resposta}    payload_enviado=${payload_dinamico}

Cenário 02: Tentar criar um usuário sem um campo obrigatório (CPF) usando dados dinâmicos
    [Tags]    Negativo    Dinamico
    # Passo 1: Geramos um payload válido primeiro.
    &{payload_dinamico}=    Gerar Payload de Usuário Válido e Dinâmico

    # Passo 2: Modificamos o payload para o nosso cenário de teste negativo.
    # A keyword 'Remove From Dictionary' da biblioteca Collections é perfeita para isso.
    Remove From Dictionary    ${payload_dinamico}    cpf

    Log To Console    Payload Inválido Enviado (sem CPF): ${payload_dinamico}

    # Passo 3: Enviamos a requisição com o payload modificado.
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload_dinamico}

    # Passo 4: Validamos se a API retornou o erro esperado.
    A resposta deve indicar um erro do cliente    resposta=${resposta}    status_code_esperado=400