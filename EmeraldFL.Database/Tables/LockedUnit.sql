CREATE TABLE [dbo].[LockedUnit] (
    [LockedUnitId] INT          IDENTITY (1, 1) NOT NULL,
    [Barcode]      VARCHAR (25) NULL,
    [LockedStatus] BIT          CONSTRAINT [DF_LockedUnit_LockedStatus] DEFAULT ((1)) NULL,
    [UID]          INT          NULL,
    [datestamp]    DATETIME     CONSTRAINT [DF_LockedUnit_datestamp] DEFAULT (getdate()) NULL,
    [ExpiredDate] DATETIME NULL, 
    CONSTRAINT [PK_LockedUnit] PRIMARY KEY CLUSTERED ([LockedUnitId] ASC)
);

