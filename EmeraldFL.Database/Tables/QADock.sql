CREATE TABLE [dbo].[QADock] (
    [ReadyToShipId]    INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]          VARCHAR (20) NULL,
    [ShipDate]         DATE         NULL,
    [PassedInspection] BIT          CONSTRAINT [DF_QADock_PassedInspection] DEFAULT ((0)) NULL,
    [UID]              INT          NULL,
    [ShippedBy]        INT          NULL,
    [Location]         INT          NULL,
    [DateStamp]        DATETIME     CONSTRAINT [DF_QADock_DateStamp] DEFAULT (getdate()) NULL,
    [ReadyToShip]      BIT          CONSTRAINT [DF_QADock_ReadyToShip] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ReadytoShip] PRIMARY KEY CLUSTERED ([ReadyToShipId] ASC)
);

