 CREATE TABLE [dbo].[State] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [Code]          NCHAR (2)      NOT NULL,
    [Name]          NVARCHAR (128) NOT NULL,
    [LastUpdatedBy] VARCHAR (50)   NULL,
    [LastUpdatedOn] DATETIME       NULL,
    CONSTRAINT [PK_state] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

