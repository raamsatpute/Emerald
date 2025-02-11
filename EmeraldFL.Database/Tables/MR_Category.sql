CREATE TABLE [dbo].[MR_Category] (
    [CategoryId]   INT          IDENTITY (1, 1) NOT NULL,
    [CategoryName] VARCHAR (50) NULL,
    [LocationId]   INT          NULL,
    [Status]       BIT          CONSTRAINT [DF_MR_Category_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_MR_Category] PRIMARY KEY CLUSTERED ([CategoryId] ASC)
);

