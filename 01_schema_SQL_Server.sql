/* 01_schema.sql - SQL Server */

-- CREATE DATABASE PortfolioLogistics;
-- GO
-- USE PortfolioLogistics;
-- GO

CREATE DATABASE PortfolioLogistics
GO

USE PortfolioLogistics;
GO

/* ============ Creating the Master Tables ============ */

CREATE TABLE dbo.Clients (
    ClientId     INT IDENTITY(1,1) CONSTRAINT PK_Clients PRIMARY KEY,
    ClientName   NVARCHAR(120) NOT NULL,
    Segment      NVARCHAR(50)  NULL,
    Country      NVARCHAR(60)  NOT NULL CONSTRAINT DF_Clients_Country DEFAULT ('Brazil')
);

CREATE TABLE dbo.Carriers (
    CarrierId     INT IDENTITY(1,1) CONSTRAINT PK_Carriers PRIMARY KEY,
    CarrierName   NVARCHAR(120) NOT NULL,
    Mode          NVARCHAR(20)  NOT NULL,
    ServiceLevel  NVARCHAR(30)  NOT NULL,
    CONSTRAINT CK_Carriers_Mode CHECK (Mode IN ('AIR','OCEAN','ROAD','RAIL')),
    CONSTRAINT CK_Carriers_Service CHECK (ServiceLevel IN ('ECONOMY','STANDARD','EXPRESS'))
);

CREATE TABLE dbo.Products (
    ProductId    INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
    ProductName  NVARCHAR(120) NOT NULL,
    Category     NVARCHAR(60) NULL,
    UnitPrice    DECIMAL(12,2) NOT NULL,
    CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0)
);

/* ============ Orders and Items tables ============ */

CREATE TABLE dbo.Orders (
    OrderId               INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    ClientId              INT NOT NULL,
    OrderDate             DATE NOT NULL,
    PromisedDeliveryDate  DATE NOT NULL,
    OriginCity            NVARCHAR(80) NULL,
    DestinationCity       NVARCHAR(80) NULL,
    Priority              NVARCHAR(10) NOT NULL CONSTRAINT DF_Orders_Priority DEFAULT ('NORMAL'),
    OrderStatus           NVARCHAR(20) NOT NULL CONSTRAINT DF_Orders_Status DEFAULT ('CREATED'),

    CONSTRAINT FK_Orders_Clients FOREIGN KEY (ClientId) REFERENCES dbo.Clients(ClientId),
    CONSTRAINT CK_Orders_Priority CHECK (Priority IN ('LOW','NORMAL','HIGH')),
    CONSTRAINT CK_Orders_Status CHECK (OrderStatus IN ('CREATED','ALLOCATED','SHIPPED','DELIVERED','CANCELLED')),
    CONSTRAINT CK_Orders_Dates CHECK (PromisedDeliveryDate >= OrderDate)
);
CREATE TABLE dbo.OrderItems (
    OrderItemId  INT IDENTITY(1,1) CONSTRAINT PK_OrderItems PRIMARY KEY,
    OrderId      INT NOT NULL,
    ProductId    INT NOT NULL,
    Quantity     INT NOT NULL,

    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders(OrderId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId)
        REFERENCES dbo.Products(ProductId),
    CONSTRAINT CK_OrderItems_Qty CHECK (Quantity > 0)
);

/* ============ Shipment and Tracking tables ============ */

CREATE TABLE dbo.Shipments (
    ShipmentId      INT IDENTITY(1,1) CONSTRAINT PK_Shipments PRIMARY KEY,
    OrderId         INT NOT NULL,
    CarrierId       INT NOT NULL,
    ShippedDate     DATE NULL,
    DeliveredDate   DATE NULL,
    FreightCost     DECIMAL(12,2) NOT NULL CONSTRAINT DF_Shipments_Freight DEFAULT (0),
    TrackingNumber  NVARCHAR(40) NULL,
    ShipmentStatus  NVARCHAR(20) NOT NULL CONSTRAINT DF_Shipments_Status DEFAULT ('PLANNED'),

    CONSTRAINT FK_Shipments_Orders FOREIGN KEY (OrderId)
        REFERENCES dbo.Orders(OrderId) ON DELETE CASCADE,
    CONSTRAINT FK_Shipments_Carriers FOREIGN KEY (CarrierId)
        REFERENCES dbo.Carriers(CarrierId),

    CONSTRAINT UQ_Shipments_Tracking UNIQUE (TrackingNumber),
    CONSTRAINT CK_Shipments_Freight CHECK (FreightCost >= 0),
    CONSTRAINT CK_Shipments_Status CHECK (ShipmentStatus IN ('PLANNED','IN_TRANSIT','DELIVERED','EXCEPTION','CANCELLED')),
    CONSTRAINT CK_Shipments_Dates CHECK (
        (ShippedDate IS NULL OR DeliveredDate IS NULL) OR (DeliveredDate >= ShippedDate)
    )
);

CREATE TABLE dbo.ShipmentEvents (
    EventId      INT IDENTITY(1,1) CONSTRAINT PK_ShipmentEvents PRIMARY KEY,
    ShipmentId   INT NOT NULL,
    EventTime    DATETIME2(0) NOT NULL,
    EventStatus  NVARCHAR(25) NOT NULL,
    [Location]   NVARCHAR(120) NULL,
    Notes        NVARCHAR(250) NULL,

    CONSTRAINT FK_ShipmentEvents_Shipments FOREIGN KEY (ShipmentId)
        REFERENCES dbo.Shipments(ShipmentId) ON DELETE CASCADE,
    CONSTRAINT CK_ShipmentEvents_Status CHECK (
        EventStatus IN ('PICKED_UP','IN_TRANSIT','AT_HUB','CUSTOMS','OUT_FOR_DELIVERY','DELIVERED','DELAYED','EXCEPTION')
    )
);

/* ============ Index (performance improvement) ============ */
CREATE INDEX IX_Orders_Client_OrderDate ON dbo.Orders (ClientId, OrderDate);
CREATE INDEX IX_Shipments_OrderId ON dbo.Shipments (OrderId);
CREATE INDEX IX_Events_ShipmentId_EventTime ON dbo.ShipmentEvents (ShipmentId, EventTime);
/* ============ Index (performance improvement) ============ */


                

