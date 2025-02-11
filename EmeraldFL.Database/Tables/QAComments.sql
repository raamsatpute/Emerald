CREATE TABLE [dbo].[QAComments] (
    [QAComId]   INT           IDENTITY (1, 1) NOT NULL,
    [UID]       INT           NULL,
    [Comment]   VARCHAR (500) NULL,
    [Barcode]   VARCHAR (20)  NULL,
    [Location]  INT           NULL,
    [DateStamp] DATETIME      CONSTRAINT [DF_QAComments_DateStamp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_DockQAComments] PRIMARY KEY CLUSTERED ([QAComId] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_QAComments]
    ON [dbo].[QAComments]([Barcode] ASC, [UID] ASC, [QAComId] ASC, [Comment] ASC, [DateStamp] ASC);

