CREATE TABLE [dbo].[KVAPrice] (
    [KvaPriceId]     INT          IDENTITY (1, 1) NOT NULL,
    [CustomerNumber] VARCHAR (10) NULL,
    [Price]          FLOAT (53)   NULL,
    [DateAdded]      DATETIME     CONSTRAINT [DF_Table_1_DateStamp] DEFAULT (getdate()) NULL,
    [AddedByUser]    INT          NULL,
    [LastUpdated]    DATETIME     CONSTRAINT [DF_KVAPrice_LastUpdated] DEFAULT (getdate()) NULL,
    [LastUpdatedBy]  INT          NULL,
    [JobType]        INT          NULL,
    CONSTRAINT [PK_KVAPrice] PRIMARY KEY CLUSTERED ([KvaPriceId] ASC)
);

