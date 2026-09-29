# Relatório de Status do Legado e Matriz de Papéis

## Seção 1: Organograma Técnico e Participação da Equipe

| Aluno(a) | Papel Técnico | Participação Específica no Legado (Back-end) | Responsabilidade Principal neste Semestre (Projeto de Software) |
|---|---|---|---|
| Daniel | PO | Não atuou diretamente no legado (Back-end); acompanhou a evolução técnica como PO. | Coordenar o backlog de integração Front/Back, garantir alinhamento entre a equipe e o curso de Eletromecânica, e acompanhar prazos de entrega. |
| Victor | Back-end | Modelou o banco de dados: elaborou o DER, normalizou as tabelas e escreveu o script SQL de criação do banco. | Dar continuidade à manutenção e evolução do banco de dados, corrigir possíveis débitos técnicos que surgirem durante o desenvolvimento, apoiar o Luis na implementação e refinamento das regras de negócio, e atuar na segurança da aplicação, com foco em autenticação via JWT, mitigação de ataques DDoS e prevenção contra SQL Injection. |
| Luis | Back-end | Integrou o banco de dados com o back-end e implementou as regras de negócio da aplicação. | Continuar o desenvolvimento e a consolidação da API, garantindo que os endpoints estejam funcionais, testados e prontos para o consumo pela equipe de Front-end, e atuar em conjunto com o Victor na segurança da aplicação, com foco em autenticação via JWT, mitigação de ataques DDoS e prevenção contra SQL Injection. |
| Matheus | Front-end | Não atuou no legado (Back-end) neste período. | Consumir a API do back-end, desenvolver as telas do aplicativo em Flutter e ficar responsável pela integração e organização das rotas consumidas pelo Front-end. |
| Miguel | Front-end | Não atuou no legado (Back-end) neste período. | Consumir a API do back-end e desenvolver as telas do aplicativo em Flutter. |
| Maria Silva | Design / Scrum Master | Não atuou no legado (Back-end) neste período. | Revisar e adaptar os protótipos de UI/UX conforme as novas propostas de funcionalidades levantadas pela equipe, garantindo a responsividade e a adequação dos fluxos de tela para o ambiente mobile, e facilitar as cerimônias Scrum. |

---

## Seção 2: Diagnóstico Técnico do Back-end Existente

### Banco de Dados

O schema.sql está atualizado no GitHub e condizente com o banco local. O banco roda localmente sem erros, e as tabelas foram validadas quanto à normalização (Formas Normais), não sendo identificadas inconsistências. A conexão entre o back-end e o banco de dados também foi verificada e está funcionando corretamente.

### Rotas e Conexões

Todas as rotas (GET, POST, PUT, DELETE) foram testadas via Insomnia e estão funcionando corretamente, sem falhas identificadas.

### Débito Técnico

Com base na auditoria realizada (verificação do `schema.sql`, teste da conexão back-end/banco de dados e testes de todas as rotas via Insomnia), não foram identificados débitos técnicos críticos ou de refatoração urgente até o momento, considerando o escopo atual da aplicação. O principal ponto de atenção para este semestre é o incremento das regras de negócio que ainda estão pendentes de implementação, especialmente as voltadas à manutenção preventiva (planos, ordens de serviço e alertas).

---

## Seção 3: Planejamento de Integração (Próximos Passos)

### Como a interface do Front-end vai conversar com a API

O **Flutter** vai se comunicar com o **NestJS** usando o pacote **Dio**, enviando e recebendo os dados em **JSON**. A autenticação será feita com **JWT**.

### Plano de trabalho para manter o sincronismo técnico

A equipe manterá uma comunicação constante ao longo de todo o desenvolvimento, relatando qualquer problema ou progresso no projeto aos membros do grupo, com o objetivo de alinhar o progresso entre Front-end e Back-end e evitar divergências na integração. Para organização e acompanhamento das tarefas, vamos continuar utilizando o Trello, onde as atividades serão distribuídas e monitoradas conforme o andamento do projeto.

---

*Documento gerado como parte do checkpoint do nosso TCC: Aplicativo de Manutenção Preventiva*
