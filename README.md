📦 Portfolio Logistics Database
Este projeto demonstra a modelagem e análise de dados logísticos em SQL Server, cobrindo desde a criação de tabelas normalizadas até consultas analíticas para indicadores de desempenho.

🎯 Objetivo

Construir um banco de dados relacional que simula operações de logística (clientes, pedidos, produtos, embarques e eventos de tracking), permitindo análises de SLA, OTIF, lead time e custos de frete.

📂 Estrutura do Projeto
• 01_schema.sql Define o esquema do banco de dados:
o Tabelas mestre: Clients, Carriers, Products
o Pedidos e itens: Orders, OrderItems
o Embarques e tracking: Shipments, ShipmentEvents
o Índices para performance
• 02_inserts_sample.sql Insere dados de exemplo para clientes, transportadoras, produtos, pedidos, embarques e eventos de rastreamento.
• 03_queries.sql Consultas analíticas para indicadores logísticos:
o A) SLA — pedidos entregues com atraso (dias de atraso)
o B) OTIF (On Time In Full) por cliente
o C) Lead time (pedido → entrega) por transportadora
o D) Order Value + % Freight-to-Value
o E) Bottleneck — último evento antes do DELIVERED (Window Function)
o F) Open Orders — pedidos sem entrega registrada

🚀 Como usar

1. Crie o banco de dados (opcional) e execute 01_schema.sql para estruturar as tabelas.
2. Execute 02_inserts_sample.sql para popular com dados de exemplo.
3. Rode as consultas em 03_queries.sql para gerar relatórios e indicadores.
4. Opcional: conecte o banco ao Power BI usando views para dashboards interativos.

📊 Indicadores disponíveis
• SLA: atraso em dias por pedido.
• OTIF: percentual de entregas no prazo por cliente.
• Lead Time: tempo médio entre pedido e entrega por transportadora.
• Freight Ratio: custo do frete em relação ao valor do pedido.
• Bottleneck Analysis: status mais frequente antes da entrega.
• Open Orders: pedidos ainda sem entrega registrada.
