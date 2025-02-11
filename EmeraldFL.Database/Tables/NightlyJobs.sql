CREATE TABLE [dbo].[NightlyJobs] (
    [NightlyID] INT          IDENTITY (1, 1) NOT NULL,
    [Job]       VARCHAR (20) NULL,
    [Status]    VARCHAR (20) NULL,
    [Action]    VARCHAR (50) NULL,
    [DateStamp] DATETIME     CONSTRAINT [DF_NightlyJobs_DateStamp] DEFAULT (getdate()) NULL
);

