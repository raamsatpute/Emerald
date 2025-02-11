CREATE TABLE [dbo].[InProcessStatus] (
    [StatusID]    INT          IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50) NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_InProcessStatus] PRIMARY KEY CLUSTERED ([StatusID] ASC)
);

