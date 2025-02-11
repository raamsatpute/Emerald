CREATE TABLE [dbo].[ResponsibleTech] (
    [TechId]     INT          IDENTITY (1, 1) NOT NULL,
    [TechNumber] INT          NULL,
    [TechArea]   VARCHAR (15) NULL,
    [Location]   INT          CONSTRAINT [DF_ResponsibleTech_Location] DEFAULT ((0)) NULL,
    [Status]     BIT          CONSTRAINT [DF_ResponsibleTech_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ResponsibleTech] PRIMARY KEY CLUSTERED ([TechId] ASC)
);



