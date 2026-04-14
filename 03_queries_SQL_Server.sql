/* 03_queries.sql - SQL Server */

-- A) SLA — Delivered Orders with Delay (Days of Delay)”

SELECT
    o.OrderId,
    c.ClientName,
    o.PromisedDeliveryDate,
    s.DeliveredDate,
    DATEDIFF(DAY, o.PromisedDeliveryDate, s.DeliveredDate) AS DelayDays
FROM dbo.Orders o
JOIN dbo.Clients c   ON c.ClientId = o.ClientId
JOIN dbo.Shipments s ON s.OrderId = o.OrderId
WHERE s.DeliveredDate IS NOT NULL
  AND s.DeliveredDate > o.PromisedDeliveryDate
ORDER BY DelayDays DESC;

-- B) OTIF (On-time) by client
SELECT
    c.ClientName,
    COUNT(*) AS TotalDeliveredOrders,
    SUM(CASE WHEN s.DeliveredDate <= o.PromisedDeliveryDate THEN 1 ELSE 0 END) AS OnTime,
    CAST(100.0 * SUM(CASE WHEN s.DeliveredDate <= o.PromisedDeliveryDate THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS OnTimePct
FROM dbo.Orders o
JOIN dbo.Clients c   ON c.ClientId = o.ClientId
JOIN dbo.Shipments s ON s.OrderId = o.OrderId
WHERE s.DeliveredDate IS NOT NULL
GROUP BY c.ClientName
ORDER BY OnTimePct DESC;

-- C) Lead time (Ordered → Delivered) by carrier
SELECT
    ca.CarrierName,
    CAST(AVG(CAST(DATEDIFF(DAY, o.OrderDate, s.DeliveredDate) AS FLOAT)) AS DECIMAL(10,2)) AS AvgOrderToDeliveryDays
FROM dbo.Shipments s
JOIN dbo.Orders o     ON o.OrderId = s.OrderId
JOIN dbo.Carriers ca  ON ca.CarrierId = s.CarrierId
WHERE s.DeliveredDate IS NOT NULL
GROUP BY ca.CarrierName
ORDER BY AvgOrderToDeliveryDays;

-- D) Order Value + Freight-to-Value %

WITH OrderValue AS (
    SELECT
        oi.OrderId,
        SUM(oi.Quantity * p.UnitPrice) AS OrderTotal
    FROM dbo.OrderItems oi
    JOIN dbo.Products p ON p.ProductId = oi.ProductId
    GROUP BY oi.OrderId
)
SELECT
    o.OrderId,
    ov.OrderTotal,
    s.FreightCost,
    CAST(100.0 * s.FreightCost / NULLIF(ov.OrderTotal, 0) AS DECIMAL(10,2)) AS FreightPct
FROM dbo.Orders o
JOIN OrderValue ov ON ov.OrderId = o.OrderId
JOIN dbo.Shipments s ON s.OrderId = o.OrderId
ORDER BY FreightPct DESC;

-- E) Bottleneck Point: Last Event Before DELIVERED (Window Function)
WITH LastEventBeforeDelivered AS (
    SELECT
        se.ShipmentId,
        se.EventStatus,
        se.EventTime,
        ROW_NUMBER() OVER (PARTITION BY se.ShipmentId ORDER BY se.EventTime DESC) AS rn
    FROM dbo.ShipmentEvents se
    WHERE se.EventStatus <> 'DELIVERED'
)
SELECT
    EventStatus,
    COUNT(*) AS Occurrences
FROM LastEventBeforeDelivered
WHERE rn = 1
GROUP BY EventStatus
ORDER BY Occurrences DESC;

-- F) Open Orders (No Delivery Recorded))
SELECT
    o.OrderId,
    c.ClientName,
    o.OrderDate,
    o.PromisedDeliveryDate,
    s.ShipmentStatus,
    s.ShippedDate,
    s.DeliveredDate
FROM dbo.Orders o
JOIN dbo.Clients c ON c.ClientId = o.ClientId
LEFT JOIN dbo.Shipments s ON s.OrderId = o.OrderId
WHERE s.DeliveredDate IS NULL;



