# 📦 Portfolio Logistics Database

Order Shipment Tracker is a SQL-based project designed to manage and monitor customer orders, shipments, and delivery statuses. It provides a structured schema, sample data inserts, and analytical queries to demonstrate how businesses can track logistics efficiently.

## 🎯 Objective

Build a relational database that simulates logistics operations (clients, orders, products, shipments, and tracking events), enabling analysis of SLA, OTIF, lead time, and freight cost ratios.

## 📂 Project Structure

- **01_schema.sql** → Defines the database schema:
  - Master tables: Clients, Carriers, Products
  - Orders and items: Orders, OrderItems
  - Shipments and tracking: Shipments, ShipmentEvents
  - Indexes for performance
- **02_inserts_sample.sql** → Inserts sample data for clients, carriers, products, orders, shipments, and tracking events.
- **03_queries.sql** → Analytical queries for logistics KPIs:
  - A) SLA — late deliveries (days of delay)
  - B) OTIF (On Time In Full) by client
  - C) Lead time (order → delivery) by carrier
  - D) Order Value + % Freight-to-Value
  - E) Bottleneck — last event before DELIVERED (Window Function)
  - F) Open Orders — orders without registered delivery

## 🚀 How to Use

1. Create the database (optional) and run `01_schema.sql` to structure the tables.
2. Run `02_inserts_sample.sql` to populate with sample data.
3. Execute queries in `03_queries.sql` to generate reports and KPIs.
4. Optional: connect the database to Power BI using views for interactive dashboards.

## 📊 Available Indicators

- **SLA**: delay in days per order.
- **OTIF**: percentage of on-time deliveries per client.
- **Lead Time**: average time between order and delivery per carrier.
- **Freight Ratio**: freight cost compared to order value.
- **Bottleneck Analysis**: most frequent status before delivery.
- **Open Orders**: orders without registered delivery.
