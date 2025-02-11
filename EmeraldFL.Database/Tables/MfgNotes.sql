CREATE TABLE [dbo].[MfgNotes] (
    [MfgNoteId]   INT            IDENTITY (1, 1) NOT NULL,
    [MFG]         VARCHAR (50)   NULL,
    [Notes]       VARCHAR (1000) NULL,
    [CreatedBy]   INT            NULL,
    [CreatedDate] DATETIME       NULL,
    CONSTRAINT [PK_MfgNotes] PRIMARY KEY CLUSTERED ([MfgNoteId] ASC)
);

