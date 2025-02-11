CREATE TABLE [dbo].[TR_Category] (
    [CategoryId]   INT          IDENTITY (1, 1) NOT NULL,
    [CategoryName] VARCHAR (50) NULL,
    [LocationId]   INT          NULL,
    [Status]       BIT          CONSTRAINT [DF_TR_Category_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_TR_Category] PRIMARY KEY CLUSTERED ([CategoryId] ASC)
);

