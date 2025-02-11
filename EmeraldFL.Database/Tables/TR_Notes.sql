CREATE TABLE [dbo].[TR_Notes] (
    [NoteId]    INT           IDENTITY (1, 1) NOT NULL,
    [UserId]    INT           NULL,
    [RequestId] INT           NULL,
    [DateStamp] DATETIME      CONSTRAINT [DF_TWO_NOTES_DATEADDED] DEFAULT (getdate()) NULL,
    [Note]      VARCHAR (500) NULL,
    CONSTRAINT [PK_TR_Notes] PRIMARY KEY CLUSTERED ([NoteId] ASC)
);

