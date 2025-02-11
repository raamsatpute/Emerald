CREATE TABLE [dbo].[OrgChartData] (
    [OrgID]       INT           IDENTITY (1, 1) NOT NULL,
    [OrgChartId]  INT           NULL,
    [Name]        VARCHAR (50)  NULL,
    [Parent]      VARCHAR (50)  NULL,
    [Description] VARCHAR (250) NULL,
    CONSTRAINT [PK_OrgChartData] PRIMARY KEY CLUSTERED ([OrgID] ASC)
);

