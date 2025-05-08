# 🚀 Transformação de Dados em Dashboards Power BI: Um Caso Prático de Análise de Atendimento ao Cliente ✨

Este projeto tem como objetivo criar uma solução automatizada de análise de dados a partir de um case operacional de atendimento ao cliente. O foco é transformar atividades manuais e complexas de análise em um processo claro, estruturado e automatizado usando ferramentas de banco de dados, modelagem de dados e visualização. Aqui está uma visão geral desse pipeline de solução:

### Tecnologias Utilizadas
- **SQL Server**: Para armazenamento e manipulação dos dados.
- **Power BI**: Para criar dashboards interativos e indicadores gerenciais.
- **Consumo de dados**: Processamento de uma base CSV para análise.

### Etapas do Processo

#### 1. Importação e armazenamento dos dados 📥
Inicialmente, o arquivo CSV chamado `BaseCasos.csv` foi importado para o banco de dados SQL Server. Para isso, criei uma tabela chamada `[histCasosTrabalhados]`, que recebeu toda a estrutura e os registros do arquivo. Essa etapa garante que os dados estejam centralizados, seguros e prontos para análises futuras.

#### 2. Criação de tabelas de dimensões 🗃️
Com a tabela principal criada, o próximo passo foi estabelecer tabelas de dimensões — estruturas essenciais em abordagens de modelagem analítica que facilitam análises e filtros mais eficientes. Para cada coluna relevante (ex: Data, Nome do funcionário, Motivo do atendimento, status, canal de entrada, país), criei uma tabela de dimensão correspondente (`dimCalendario`, `dimFuncionario`, etc.). Essas tabelas armazenam valores únicos de cada atributo, promovendo maior desempenho nas consultas e flexibilidade na construção dos dashboards.

#### 3. Criação da tabela fato 📊
A partir da tabela principal, construi uma tabela fato, que agrega informações essenciais para análise de desempenho. Essa tabela resume os dados agrupados por dimensões, eliminando valores redundantes e trazendo os indicadores de interesse. Os indicadores incluem:
- **Percentual de resolução**: proporção de casos resolvidos com sucesso.
- **Casos fechados e abertos**: contagem de atendimentos finalizados ou em andamento.
- **Tempos médios**: tempo médio para atualização e fechamento dos casos, medido em horas.

A tabela fato foi criada com uma operação de agrupamento (`GROUP BY`) para facilitar análises agregadas, sem precisar identificar cada caso individualmente.

#### 4. Automatização da atualização ⚙️
Para garantir que as informações estejam sempre atualizadas, desenvolvi uma procedure (rotina armazenada) que atualiza tanto as tabelas de dimensões quanto a tabela fato automaticamente. Assim, qualquer modificação na base original pode ser refletida no banco, mantendo os dados sempre consistentes e prontos para análise.

#### 5. Visualização em Power BI 📈
Por último, construí um dashboard usando Power BI, conectando-o ao banco de dados. Esse painel exibe os indicadores principais, permitindo uma visão clara e interativa do desempenho do atendimento. Assim, gestores podem monitorar facilmente a resolução de casos, tempos de atendimento e outros métricas importantes, baseando suas decisões em dados confiáveis e atualizados.

### Resumo ✨
Esse processo automatizado transforma uma base de dados inicial em uma solução de business intelligence completa, com armazenamento eficiente, modelagem analítica robusta e visualizações dinâmicas. Por meio dessa estrutura, é possível analisar o desempenho do atendimento, identificar melhorias e tomar decisões estratégicas de forma mais assertiva.
