CREATE TABLE [dbo].[InventoryResults] (
    [UnitId]              INT          NULL,
    [InventoryID]         VARCHAR (50) NULL,
    [DateStamp]           DATETIME     CONSTRAINT [DF_InventoryResults_DateStamp] DEFAULT (getdate()) NULL,
    [LocationDetail]      INT          NOT NULL,
    [PriorLocationDetail] INT          NOT NULL,
    [ID]                  INT          IDENTITY (1, 1) NOT NULL
);

