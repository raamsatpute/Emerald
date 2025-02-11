CREATE TABLE [dbo].[PCBItemTypes] (
    [PCBItemTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [ItemType]      VARCHAR (50) NULL,
    [Location]      INT          NULL,
    [IsDefault]     BIT          CONSTRAINT [DF_PCBItemTypes_IsCarcassType] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PCBItemTypes] PRIMARY KEY CLUSTERED ([PCBItemTypeID] ASC)
);

