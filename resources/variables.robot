*** Settings ***
# A seção 'Settings' é usada para configurações gerais do arquivo.
Documentation    Arquivo para centralizar variáveis de ambiente, como URLs e tokens.
...              Manter variáveis aqui facilita a manutenção e a troca entre ambientes (DEV, STG, PROD).

*** Variables ***
# A seção 'Variables' é onde declaramos todas as nossas variáveis estáticas.
# Elas são definidas com a sintaxe ${NOME_DA_VARIAVEL}.

# A URL base da API. Colocamos aqui a parte que não muda entre os endpoints.
${BASE_URL}      https://10.90.60.45:8444
# O caminho específico para o recurso que estamos testando (o endpoint).
${ENDPOINT_USUARIO}    /server-sigom/rest/usuario

# O token de autenticação. Centralizar aqui evita que ele fique espalhado por vários testes.
# Em um projeto real, o ideal é carregar este valor de uma variável de ambiente por segurança.
${AUTH_TOKEN}    cmV2ZW5kYSBlbXByZXNhMSBzdGc1RFM=

