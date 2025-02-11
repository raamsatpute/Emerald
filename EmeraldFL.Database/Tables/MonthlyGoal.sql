CREATE TABLE [dbo].[MonthlyGoal] (
    [MonthlyGoalID] INT         IDENTITY (1, 1) NOT NULL,
    [MonthlyGoal]   FLOAT (53)  NULL,
    [nMonth]        VARCHAR (2) NULL,
    [JobType]       VARCHAR (2) NULL,
    [nYear]         VARCHAR (4) NULL,
    CONSTRAINT [PK_MonthlyGoal] PRIMARY KEY CLUSTERED ([MonthlyGoalID] ASC)
);

