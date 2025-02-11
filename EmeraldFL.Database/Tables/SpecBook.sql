CREATE TABLE [dbo].[SpecBook] (
    [SpecBookId]     INT          IDENTITY (1, 1) NOT NULL,
    [CustomerNumber] VARCHAR (10) NULL,
    [DateStamp]      DATETIME     CONSTRAINT [DF_SpecBook_DateStamp] DEFAULT (getdate()) NULL,
    [LastUpdated]    DATETIME     NULL,
    [LastUpdatedBy]  INT          NULL,
    [CreatedBy]      INT          NULL,
    [jobtype]        VARCHAR (5)  NULL,
    CONSTRAINT [PK_SpecBook] PRIMARY KEY CLUSTERED ([SpecBookId] ASC)
);

