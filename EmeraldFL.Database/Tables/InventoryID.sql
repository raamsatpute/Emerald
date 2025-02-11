CREATE TABLE [dbo].[InventoryID] (
    [ID]                  INT          IDENTITY (1, 1) NOT NULL,
    [InventoryID]         VARCHAR (50) NULL,
    [DateBegin]           DATETIME     NULL,
    [DateEnd]             DATETIME     NULL,
    [Complete]            BIT          CONSTRAINT [DF_InventoryID_Complete] DEFAULT ((0)) NULL,
    [ApprovedBy]          INT          NULL,
    [DateStamp]           DATETIME     CONSTRAINT [DF_InventoryID_DateStamp] DEFAULT (getdate()) NULL,
    [InventoryLocationID] INT          NULL
);

