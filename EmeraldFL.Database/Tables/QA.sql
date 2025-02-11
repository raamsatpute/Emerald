CREATE TABLE [dbo].[QA] (
    [QAId]      INT          IDENTITY (1, 1) NOT NULL,
    [QQuestion] VARCHAR (25) NULL,
    [QAType]    VARCHAR (10) NULL,
    [Location]  INT          NULL,
    [Status]    BIT          CONSTRAINT [DF_QA_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_DockQA] PRIMARY KEY CLUSTERED ([QAId] ASC)
);

