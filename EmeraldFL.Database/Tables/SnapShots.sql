CREATE TABLE [dbo].[SnapShots] (
    [SnapId]            INT           IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (50)  NULL,
    [Datestamp]         DATETIME      CONSTRAINT [DF_SnapShots_Datestamp] DEFAULT (getdate()) NULL,
    [InventoryLocation] INT           NULL,
    [DeleteAllowed]     BIT           CONSTRAINT [[dbo]].[SnapShots]]DeleteAllowedDefault] DEFAULT ((1)) NULL,
    [FileName]          VARCHAR (150) NULL,
    CONSTRAINT [PK_SnapShots] PRIMARY KEY CLUSTERED ([SnapId] ASC)
);

