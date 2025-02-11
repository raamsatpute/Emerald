CREATE TABLE [dbo].[ShippingLogDrivers] (
    [ShippingLogDriversId] INT          IDENTITY (1, 1) NOT NULL,
    [FirstName]            VARCHAR (25) NULL,
    [LastName]             VARCHAR (25) NULL,
    [Status]               BIT          CONSTRAINT [DF_ShippingLogDrivers_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ShippingLogDrivers] PRIMARY KEY CLUSTERED ([ShippingLogDriversId] ASC)
);

