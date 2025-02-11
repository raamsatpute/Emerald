CREATE TABLE [dbo].[MR_Status] (
    [StatusId]   INT          IDENTITY (1, 1) NOT NULL,
    [StatusName] VARCHAR (50) NULL,
    [LocationId] INT          NULL,
    [Status]     BIT          CONSTRAINT [DF_MR_Status_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_MR_Status] PRIMARY KEY CLUSTERED ([StatusId] ASC)
);

