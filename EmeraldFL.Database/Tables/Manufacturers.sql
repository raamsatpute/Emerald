CREATE TABLE [dbo].[Manufacturers] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [Manufacturer]      VARCHAR (250) NULL,
    [Status]            VARCHAR (1)   CONSTRAINT [DF_Manufacturers_Status] DEFAULT ('A') NULL,
    [InventoryLocation] INT           NULL
);

