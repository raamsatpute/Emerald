CREATE TABLE [dbo].[MaterialTypes] (
    [MaterialTypeId] INT          IDENTITY (1, 1) NOT NULL,
    [MaterialType]   VARCHAR (50) NULL,
    CONSTRAINT [PK_MaterialTypes] PRIMARY KEY CLUSTERED ([MaterialTypeId] ASC)
);

