*** Settings ***
Documentation       Keywords reutilizáveis para os testes da API de Usuários.
Library             RequestsLibrary
Library             Collections
Library             String
# Faker com dados brasileiros
Library             FakerLibrary    locale=pt_BR
Resource    ../resources/variables.robot
Resource    ../resources/mensagens_sucesso.robot
Resource    ../resources/mensagens_erro.robot

*** Keywords ***
Iniciar Sessão na API
    [Documentation]     Cria a sessão na API, define headers padrão e desabilita a verificação SSL.
    &{headers}=         Create Dictionary
    ...                 Content-Type=application/json
    ...                 Accept=application/json
    ...                 Auth-Token=${AUTH_TOKEN}
    Create Session      alias=api_sigom     url=${BASE_URL}     headers=&{headers}     verify=${False}

Gerar Payload de Usuário Válido e Dinâmico
    [Documentation]     Cria um dicionário (payload) com dados de usuário gerados dinamicamente.
    # Usando a FakerLibrary para gerar dados brasileiros
    ${nome_completo_faker}=       Name
    ${nome_abreviado_faker}=      First Name
    ${cpf_dinamico_faker}=        Cpf
    ${rg_dinamico_faker}=         Rg
    ${telefone_dinamico_faker}=   Phone Number
    ${email_dinamico_faker}=      Email
    ${cidade_dinamica_faker}=     City
    ${cep_dinamico_faker}=        Postcode
    ${bairro_dinamico_faker}=     Bairro
    ${matricula_dinamica_faker}=  License Plate

    # Montando o payload com os dados que acabamos de gerar
    &{payload}=     Create Dictionary
    ...     matricula=${matricula_dinamica_faker}
    ...     nome=${nome_completo_faker}
    ...     abreviaturaNome=${nome_abreviado_faker}
    ...     dataNascimento=01/01/1980
    ...     categoria=1
    ...     entidadeId=1
    ...     telefone=${telefone_dinamico_faker}
    ...     cpf=${cpf_dinamico_faker}
    ...     rg=${rg_dinamico_faker}
    ...     endereco=Rua Gerada Dinamicamente
    ...     numeroEndereco=500
    ...     complementoEndereco=Bloco A
    ...     bairro=${bairro_dinamico_faker}
    ...     cidade=${cidade_dinamica_faker}
    ...     cep=${cep_dinamico_faker}
    ...     uf=MG
    ...     nomeMae=Maria Gerada Dinamicamente
    ...     curso=Ciência da Computação
    ...     grau=Superior
    ...     serie=3º Período
    ...     carteiraEstudante=2025998877
    ...     carteiraProfissional=
    ...     observacao=usuario_dinamico_criado_pela_automacao_de_testes.
    ...     integraBU=1


    RETURN        &{payload}  # Retorna o dicionário completo

Criar um novo usuário via API
    [Arguments]     ${payload_usuario}
    [Documentation]     Envia uma requisição POST para criar um novo usuário.
    ${resposta}=        POST On Session
    ...                 alias=api_sigom
    ...                 url=${ENDPOINT_USUARIO}
    ...                 json=${payload_usuario}
    ...                 expected_status=any
    RETURN        ${resposta}

A resposta deve indicar sucesso na criação
    [Arguments]     ${resposta}
    Should Be Equal As Strings      ${resposta.status_code}     201

O corpo da resposta deve conter os dados do usuário enviado
    [Arguments]     ${resposta}     ${payload_enviado}
     # Use o método .json() do objeto de resposta
    ${corpo_resposta}=      Set Variable    ${resposta.json()}
    Should Be Equal As Strings      ${corpo_resposta['mensagem']}            ${MENSAGEM_SUCESSO_CADASTRO_USUARIO}
    Dictionary Should Contain Key       ${corpo_resposta}       usuarioId 


*** Keywords ***
Validar resposta de erro da API
    [Arguments]    ${resposta}    ${status_code_esperado}    ${mensagem_esperada}=${None}
    [Documentation]    Valida o status da resposta e, opcionalmente, o conteúdo JSON.

    # 1. Valida o código de status HTTP da resposta.
    # O comando é simples: o que é igual ao que é esperado.
    Should Be Equal As Strings    ${resposta.status_code}    ${status_code_esperado}

    # 2. Tenta converter o corpo da resposta para JSON.
    # A palavra-chave Run Keyword And Return Status retorna True/False e o valor.
    ${status_conversao}    ${corpo_json} =    Run Keyword And Return Status    Set Variable    ${resposta.json()}

    # 3. Se a conversão foi bem-sucedida E uma mensagem foi fornecida para validação...
    Run Keyword If    ${status_conversao} and '${mensagem_esperada}' != 'None'
    ...    Validar conteúdo de erro JSON    ${corpo_json}    ${mensagem_esperada}

Validar conteúdo de erro JSON
    [Arguments]    ${corpo_resposta_json}    ${mensagem_esperada}
    [Documentation]    Verifica se o corpo JSON de erro contém a mensagem esperada.

    Dictionary Should Contain Key    ${corpo_resposta_json}    mensagem
    Should Be Equal As Strings    ${corpo_resposta_json['mensagem']}    ${mensagem_esperada}

# Gera um payload com todos os campos opcionais preenchidos
Gerar Payload com Campos Opcionais
    [Documentation]     Gera um payload de usuário com todos os campos opcionais preenchidos, usando Faker para dados dinâmicos.
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    Set To Dictionary    ${payload}    complementoEndereco=Apto 101
    RETURN    &{payload}

# Gera um payload com caracteres especiais em nome e email
Gerar Payload com Caracteres Especiais
    [Documentation]     Gera um payload com caracteres especiais em nome e email.
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    Set To Dictionary    ${payload}    nome=José Áçêntô    email=josé!@teste.com
    RETURN    &{payload}

# Gera um payload com nome de tamanho definido
Gerar Payload com Nome de Tamanho Limite
    [Arguments]    ${tamanho}
    [Documentation]     Gera um payload com nome de tamanho definido.
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    ${nome_longo}=    Generate Random String    ${tamanho}
    Set To Dictionary    ${payload}    nome=${nome_longo}
    RETURN    &{payload}

# Gera um payload com email inválido
Gerar Payload com Email Inválido
    [Documentation]     Gera um payload com email em formato inválido.
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    Set To Dictionary    ${payload}    email=usuario@@dominio.com
    RETURN    &{payload}

# Gera um payload com CPF inválido
Gerar Payload com CPF Inválido
    [Documentation]     Gera um payload com CPF inválido.
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    Set To Dictionary    ${payload}    cpf=123
    RETURN    &{payload}

# Gera um payload com campo extra não esperado pela API
Gerar Payload com Campo Extra
    [Documentation]     Gera um payload com um campo não esperado pela API.
    &{payload}=    Gerar Payload de Usuário Válido e Dinâmico
    Set To Dictionary    ${payload}    campo_invalido=valor
    RETURN    &{payload}

# Gera um payload vazio
Gerar Payload Vazio
    [Documentation]     Retorna um dicionário vazio para simular payload vazio.
    &{payload}=    Create Dictionary
    RETURN    &{payload}

# Gera um JSON malformado (string)
Gerar Json Malformado
    [Documentation]     Retorna uma string JSON malformada.
    ${json}=    Set Variable    {"nome": "Teste", "cpf": 1234567890
    RETURN    ${json}

# Envia requisição sem o header de autenticação
Criar Usuário Sem Token
    [Arguments]    ${payload_usuario}
    [Documentation]     Envia requisição sem o header de autenticação.
    &{headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json    
    Create Session    alias=api_sem_token    url=${BASE_URL}    headers=&{headers}    verify=${False}
    ${resposta}=    POST On Session    alias=api_sem_token    url=${ENDPOINT_USUARIO}    json=${payload_usuario}    expected_status=any
    RETURN    ${resposta}

# Tenta criar usuário usando método GET (inválido)
Criar Usuário Com Metodo Incorreto
    [Arguments]    ${payload_usuario}
    [Documentation]     Tenta criar usuário usando método GET.
    ${resposta}=    GET On Session    alias=api_sigom    url=${ENDPOINT_USUARIO}    expected_status=any
    RETURN    ${resposta}

# Envia requisição com payload vazio
Criar Usuário Com Payload Vazio
    [Documentation]     Envia requisição com payload vazio.
    &{payload}=    Gerar Payload Vazio
    ${resposta}=    Criar um novo usuário via API    payload_usuario=${payload}
    RETURN    ${resposta}

# Envia requisição com JSON malformado
# Envia requisição com JSON malformado
Criar Usuário Com Json Malformado
    [Documentation]    Envia requisição com JSON malformado.
    # Gera a string JSON malformada
    ${json_malformado}=    Gerar Json Malformado
    # Define os headers. O Content-Type é crucial para a API saber o que está recebendo.
    &{headers}=    Create Dictionary    Content-Type=application/json
    # A requisição é feita usando o parâmetro 'data' para enviar a string malformada.
    ${resposta}=    POST On Session
    ...    alias=api_sigom
    ...    url=${ENDPOINT_USUARIO}
    ...    data=${json_malformado}
    ...    headers=&{headers}
    ...    expected_status=any
    
    RETURN    ${resposta}