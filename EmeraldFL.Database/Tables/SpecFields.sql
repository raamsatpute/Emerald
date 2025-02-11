CREATE TABLE [dbo].[SpecFields] (
    [SpecFieldId] INT          IDENTITY (1, 1) NOT NULL,
    [SpecField]   VARCHAR (20) NULL,
    [SpecValue]   VARCHAR (15) NULL,
    [Status]      BIT          CONSTRAINT [DF_SpecFields_Status] DEFAULT ((0)) NULL,
    [Location]    INT          NULL,
    CONSTRAINT [PK_SpecFields] PRIMARY KEY CLUSTERED ([SpecFieldId] ASC)
);

