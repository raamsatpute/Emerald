CREATE TABLE [dbo].[NonPCBItemTypes] (
    [PCBItemTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [ItemType]      VARCHAR (50) NULL,
    [Location]      INT          NULL,
    [IsDefault]     BIT          NULL,
    CONSTRAINT [PK_NonPCBItemTypes] PRIMARY KEY CLUSTERED ([PCBItemTypeID] ASC)
);

