CREATE TABLE [dbo].[UnitLocations] (
    [UnitLocationId] INT          IDENTITY (1, 1) NOT NULL,
    [Location]       VARCHAR (50) NULL,
    CONSTRAINT [PK_UnitLocations] PRIMARY KEY CLUSTERED ([UnitLocationId] ASC)
);

