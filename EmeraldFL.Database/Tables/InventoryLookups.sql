CREATE TABLE [dbo].[InventoryLookups] (
    [ID]                INT          IDENTITY (1, 1) NOT NULL,
    [Field]             VARCHAR (15) NULL,
    [Value]             VARCHAR (50) NULL,
    [Found]             BIT          CONSTRAINT [DF_UnitLookup_Found] DEFAULT ((0)) NULL,
    [datestamp]         DATETIME     CONSTRAINT [DF_UnitLookup_datestamp] DEFAULT (getdate()) NULL,
    [InventoryLocation] INT          CONSTRAINT [DF_InventoryLookups_InventoryLocation] DEFAULT ((0)) NULL,
    [Attempts]          INT          CONSTRAINT [DF_InventoryLookups_Attempts] DEFAULT ((0)) NULL,
    [LastAttempt]       DATETIME     CONSTRAINT [DF_InventoryLookups_LastAttempt] DEFAULT (getdate()) NULL
);

