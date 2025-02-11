CREATE TABLE [dbo].[SFSComments] (
    [SFS_CommentId] INT           IDENTITY (1, 1) NOT NULL,
    [Comment]       VARCHAR (500) NULL,
    [DateStamp]     DATETIME      NULL,
    [Barcode]       VARCHAR (25)  NULL,
    [UID]           INT           NULL,
    [SpecId]        INT           NULL,
    CONSTRAINT [PK_SFSComments] PRIMARY KEY CLUSTERED ([SFS_CommentId] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_SFSComments_QueryOptimization]
    ON [dbo].[SFSComments]([Barcode] ASC, [UID] ASC, [SFS_CommentId] ASC, [Comment] ASC, [DateStamp] ASC);

