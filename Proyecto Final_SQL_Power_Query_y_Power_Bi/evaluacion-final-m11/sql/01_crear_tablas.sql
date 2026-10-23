-- Evaluación Final - Data Analytics (Coderhouse) - SQL Server (SSMS)
-- 01. Creación de la base de datos y las tablas (DDL)
-- Dataset de la cátedra: Clientes 200 / Productos 25 / Ventas 3.000 (no incluido en este repositorio)

IF DB_ID('evaluacion_final') IS NOT NULL
BEGIN
    ALTER DATABASE evaluacion_final SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE evaluacion_final;
END
GO
CREATE DATABASE evaluacion_final;
GO
USE evaluacion_final;
GO

CREATE TABLE Clientes (
    CustomerID    VARCHAR(10)   NOT NULL PRIMARY KEY,
    Nombre        NVARCHAR(100) NOT NULL,
    Email         VARCHAR(150)  NULL,
    Pais          NVARCHAR(50)  NOT NULL,
    Ciudad        NVARCHAR(50)  NOT NULL,
    Segmento      NVARCHAR(20)  NOT NULL,
    FechaRegistro DATE          NOT NULL
);

CREATE TABLE Productos (
    ProductID       VARCHAR(10)   NOT NULL PRIMARY KEY,
    Nombre_Producto NVARCHAR(100) NOT NULL,
    Categoria       NVARCHAR(50)  NOT NULL,
    SubCategoria    NVARCHAR(50)  NOT NULL,
    PrecioUnitario  DECIMAL(10,2) NOT NULL
);

-- 5 TransactionID se repiten en ventas distintas (distinto cliente, producto o fecha),
-- por eso TransactionID no puede ser clave primaria. Se usa VentaID como clave sustituta.
CREATE TABLE Ventas (
    VentaID       INT           IDENTITY(1,1) PRIMARY KEY,
    TransactionID VARCHAR(15)   NOT NULL,
    CustomerID    VARCHAR(10)   NOT NULL REFERENCES Clientes(CustomerID),
    ProductID     VARCHAR(10)   NOT NULL REFERENCES Productos(ProductID),
    FechaCompra   DATE          NOT NULL,
    Cantidad      INT           NULL,
    MontoTotal    DECIMAL(12,2) NULL,
    MedioPago     NVARCHAR(30)  NOT NULL
);
CREATE INDEX ix_ventas_fecha ON Ventas(FechaCompra);
CREATE INDEX ix_ventas_txn   ON Ventas(TransactionID);
GO
