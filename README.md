# Projeto de Automação com Robot Framework - Testes API Usuário

## 📁 Estrutura do Projeto

- `tests/` — Scripts de teste Robot Framework (`.robot`)
- `resources/variables.robot` — Variáveis globais, como URLs e tokens
- `resources/api_keywords.robot` — Keywords reutilizáveis para os testes
- `resources/mensagens_erro.robot` — Mensagens de erro esperadas
- `resources/mensagens_sucesso.robot` — Mensagens de sucesso esperadas
- `requirements.txt` — Lista de pacotes Python necessários para o projeto
- `results/` — Diretório onde são gerados os relatórios dos testes (`log.html`, `report.html`, `output.xml`)

---

## 🖥️ Pré-requisitos

- Python 3.10 ou superior instalado
- Editor de código (recomendado: Visual Studio Code)

---

## 🛠️ Montagem do Ambiente

### O que é um ambiente virtual Python?

Um ambiente virtual é uma área isolada no seu computador onde você instala as dependências de um projeto Python, sem afetar outros projetos ou o sistema operacional.  
Isso evita conflitos de versões e garante melhor rastreabilidade da execução dos testes.

---

> **IMPORTANTE:**  
> Sempre abra o Visual Studio Code (ou outro editor) diretamente na pasta raiz do projeto.  
> Isso garante que os caminhos relativos dos arquivos funcionem corretamente.

### 1. Crie um ambiente virtual Python

No terminal, execute:
```bash
python -m venv .venv
```

### 2. Ative o ambiente virtual

- **Windows (Prompt de Comando):**
  ```
  .venv\Scripts\activate
  ```
- **Windows (PowerShell):**
  ```
  .venv\Scripts\Activate.ps1
  ```
- **Linux/macOS:**
  ```
  source .venv/bin/activate
  ```

Quando o ambiente virtual está ativo, o terminal mostra o nome dele no início da linha, por exemplo:  
`(.venv) C:\Users\seu_usuario\seu_projeto>`

### 3. Instale as dependências do projeto

```bash
pip install -r requirements.txt
```

---

## 🧪 Como rodar os testes

1. Certifique-se de que o ambiente virtual está ativado.
2. Execute todos os testes da pasta `tests`:
   ```bash
   robot -d results tests/
   ```
3. Abra os relatórios gerados:
   - `results/log.html` — Log detalhado dos testes
   - `results/report.html` — Resumo dos resultados

---

## ⚙️ Dicas sobre Ambiente Virtual e VS Code

- **Sempre ative o ambiente virtual antes de instalar pacotes ou rodar os testes.**
- No VS Code, selecione o Python do ambiente virtual:
  - Pressione `Ctrl+Shift+P`, digite **Python: Select Interpreter** e escolha o Python dentro da pasta `.venv` (exemplo: `.venv\Scripts\python.exe`).
- Se aparecerem erros como `ModuleNotFoundError` ou problemas para importar bibliotecas (ex: `FakerLibrary`), provavelmente o ambiente virtual não está ativado ou está corrompido.
- **Como corrigir problemas no ambiente virtual:**
  1. Desative o ambiente virtual (se estiver ativo) com:
     ```
     deactivate
     ```
  2. Exclua a pasta do ambiente virtual (ex: `.venv`).
  3. Crie um novo ambiente virtual:
     ```
     python -m venv .venv
     ```
  4. Ative o novo ambiente virtual:
     - No PowerShell:
       ```
       .\.venv\Scripts\Activate.ps1
       ```
     - No Prompt de Comando:
       ```
       .venv\Scripts\activate
       ```
     - No Linux/macOS:
       ```
       source .venv/bin/activate
       ```
  5. Instale novamente as dependências:
     ```
     pip install -r requirements.txt
     ```

---

## ⚠️ Observações importantes

- Variáveis como `${AUTH_TOKEN}` e `${BASE_URL}` estão definidas em `resources/variables.robot`.  
  **Nunca compartilhe tokens reais publicamente.**  
  Atualize o token conforme necessário para garantir o funcionamento dos testes.
- Os testes cobrem cenários positivos, negativos, de borda e performance.
- Leia os comentários nos arquivos `.robot` para entender cada passo dos testes e keywords.
- Sempre ative o ambiente virtual antes de instalar pacotes ou rodar testes.

---

## 💡 Dicas para QAs

- Se abrir o projeto em outro computador, repita o processo de ambiente virtual e instalação de dependências.
- Explore os arquivos em `resources/` para entender como as keywords e variáveis são organizadas.
- Use os relatórios HTML para analisar os resultados dos testes e identificar possíveis falhas.

---

**Odair Moises de Oliveira - Empresa1**
