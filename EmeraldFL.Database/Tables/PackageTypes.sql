CREATE TABLE [dbo].[PackageTypes] (
    [PackageTypeId] INT          IDENTITY (1, 1) NOT NULL,
    [PackageType]   VARCHAR (50) NULL,
    [PackageCost]   FLOAT (53)   CONSTRAINT [DF_PackageTypes_PackageCost] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PackageTypes] PRIMARY KEY CLUSTERED ([PackageTypeId] ASC)
);

