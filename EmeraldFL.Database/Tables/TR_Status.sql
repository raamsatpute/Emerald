CREATE TABLE [dbo].[TR_Status] (
    [StatusId]   INT          IDENTITY (1, 1) NOT NULL,
    [StatusName] VARCHAR (50) NULL,
    [LocationId] INT          NULL,
    [Status]     BIT          CONSTRAINT [DF_TR_Status_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_TR_Status] PRIMARY KEY CLUSTERED ([StatusId] ASC)
);

