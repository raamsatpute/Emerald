CREATE TABLE [dbo].[OrgCharts] (
    [OrgChartId] INT          IDENTITY (1, 1) NOT NULL,
    [Name]       VARCHAR (50) NULL,
    CONSTRAINT [PK_OrgCharts] PRIMARY KEY CLUSTERED ([OrgChartId] ASC)
);

