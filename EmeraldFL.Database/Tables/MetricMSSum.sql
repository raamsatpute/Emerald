CREATE TABLE [dbo].[MetricMSSum] (
    [MetricMSSumId]   INT          IDENTITY (1, 1) NOT NULL,
    [Count]           INT          NULL,
    [Job Type]        VARCHAR (10) NULL,
    [Date]            DATETIME     NULL,
    [ReceivedToTest]  FLOAT (53)   NULL,
    [ReceivedToPaint] FLOAT (53)   NULL,
    [ReceivedToShip]  FLOAT (53)   NULL,
    [TestToPaint]     FLOAT (53)   NULL,
    [PaintToShip]     FLOAT (53)   NULL,
    CONSTRAINT [PK_MetricMSSum] PRIMARY KEY CLUSTERED ([MetricMSSumId] ASC)
);

