CREATE TABLE [dbo].[Trailers] (
    [TrailerId]     INT          IDENTITY (1, 1) NOT NULL,
    [TrailerNumber] VARCHAR (6)  NULL,
    [TrailerType]   VARCHAR (50) NULL,
    [Status]        BIT          CONSTRAINT [DF_Trailers_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Trailers] PRIMARY KEY CLUSTERED ([TrailerId] ASC)
);

