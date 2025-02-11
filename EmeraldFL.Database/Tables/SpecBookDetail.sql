CREATE TABLE [dbo].[SpecBookDetail] (
    [SpecBookDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [SpecBookId]       INT           NULL,
    [SpecBookItem]     VARCHAR (50)  NULL,
    [SpecBookDetail]   TEXT          NULL,
    [KVA]              VARCHAR (500) NULL,
    [PrimaryVoltage]   VARCHAR (500) NULL,
    [SecondaryVoltage] VARCHAR (500) NULL,
    [AMPS]             VARCHAR (500) NULL,
    [Type]             VARCHAR (500) NULL,
    [Manufacturer]     VARCHAR (500) NULL,
    [DateStamp]        DATETIME      CONSTRAINT [DF_SpecBookDetail_DateStamp] DEFAULT (getdate()) NULL,
    [LastUpdated]      DATETIME      NULL,
    [CreatedBy]        INT           NULL,
    [LastUpdatedBy]    INT           NULL,
    [JobType]          VARCHAR (2)   NULL,
    [SubCategory]      VARCHAR (25)  NULL,
    CONSTRAINT [PK_SpecBookDetail] PRIMARY KEY CLUSTERED ([SpecBookDetailID] ASC)
);

