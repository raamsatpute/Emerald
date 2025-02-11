CREATE TABLE [dbo].[Labs] (
    [LabId]   INT           IDENTITY (1, 1) NOT NULL,
    [Name]    VARCHAR (100) NULL,
    [Status]  VARCHAR (1)   CONSTRAINT [DF_Labs_Status] DEFAULT ('A') NULL,
    [Address] VARCHAR (50)  NULL,
    [City]    VARCHAR (50)  NULL,
    [State]   VARCHAR (2)   NULL,
    [Zip]     VARCHAR (15)  NULL,
    CONSTRAINT [PK_Labs] PRIMARY KEY CLUSTERED ([LabId] ASC)
);

