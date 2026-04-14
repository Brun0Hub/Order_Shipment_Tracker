/* ============ Populating Tables with Sample Data ============ */


INSERT INTO dbo.Clients (ClientName, Segment, Country) VALUES
(N'Alpha Retail', N'Retail', N'Brazil'),
(N'Beta Pharma', N'Healthcare', N'Brazil'),
(N'Gamma Tech', N'Technology', N'Brazil');

INSERT INTO dbo.Carriers (CarrierName, Mode, ServiceLevel) VALUES
(N'FastRoad', N'ROAD', N'STANDARD'),
(N'SkyLift', N'AIR',  N'EXPRESS'),
(N'BlueOcean', N'OCEAN', N'ECONOMY');

INSERT INTO dbo.Products (ProductName, Category, UnitPrice) VALUES
(N'Laptop 14"', N'Electronics', 4500.00),
(N'Medical Kit', N'Healthcare', 280.00),
(N'Smartphone', N'Electronics', 3200.00);

INSERT INTO dbo.Orders (ClientId, OrderDate, PromisedDeliveryDate, OriginCity, DestinationCity, Priority, OrderStatus)
VALUES
(1, '2026-03-01', '2026-03-06', N'São Paulo', N'Rio de Janeiro', N'HIGH',   N'SHIPPED'),
(2, '2026-03-02', '2026-03-05', N'Campinas',  N'Belo Horizonte', N'NORMAL', N'DELIVERED'),
(3, '2026-03-03', '2026-03-10', N'Rio de Janeiro', N'Curitiba',  N'NORMAL', N'CREATED');

INSERT INTO dbo.OrderItems (OrderId, ProductId, Quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 10);

INSERT INTO dbo.Shipments (OrderId, CarrierId, ShippedDate, DeliveredDate, FreightCost, TrackingNumber, ShipmentStatus)
VALUES
(1, 1, '2026-03-02', NULL,        350.00, N'FR123456', N'IN_TRANSIT'),
(2, 2, '2026-03-02', '2026-03-04', 900.00, N'SL999888', N'DELIVERED');

-- Eventos de tracking (exemplo)
INSERT INTO dbo.ShipmentEvents (ShipmentId, EventTime, EventStatus, [Location], Notes) VALUES
(1, '2026-03-02 10:00:00', 'PICKED_UP',        N'São Paulo', N'Pickup confirmed'),
(1, '2026-03-03 09:10:00', 'AT_HUB',           N'Resende',   N'Arrived at hub'),
(1, '2026-03-03 12:40:00', 'IN_TRANSIT',       N'RJ',        N'Linehaul'),
(2, '2026-03-02 15:00:00', 'PICKED_UP',        N'Campinas',  N'Pickup'),
(2, '2026-03-03 08:30:00', 'OUT_FOR_DELIVERY', N'BH',        N'Last mile'),
(2, '2026-03-04 11:20:00', 'DELIVERED',        N'BH',        N'Delivered OK');

