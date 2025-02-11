CREATE TABLE [dbo].[TR_Requests] (
    [RequestId]         INT            IDENTITY (1, 1) NOT NULL,
    [StatusId]          INT            NULL,
    [ReqDescription]    VARCHAR (1000) NULL,
    [Requestor]         INT            NULL,
    [DateStamp]         DATETIME       NULL,
    [DateCompleted]     DATETIME       NULL,
    [LastUpdated]       DATETIME       NULL,
    [PriorityId]        INT            NULL,
    [DateRequired]      DATETIME       NULL,
    [LocationId]        INT            NULL,
    [Title]             VARCHAR (250)  NULL,
    [MaterialsRequired] VARCHAR (500)  NULL,
    [ActionTaken]       VARCHAR (1000) NULL,
    [LastUpdatedBy]     INT            NULL,
    [CategoryId]        INT            NULL,
    [MarkedReadBy]      INT            NULL,
    [Department]        INT            NULL,
    [TechIssueTypeID]   INT            NULL,
    CONSTRAINT [PK_TR_Requests] PRIMARY KEY CLUSTERED ([RequestId] ASC)
);

