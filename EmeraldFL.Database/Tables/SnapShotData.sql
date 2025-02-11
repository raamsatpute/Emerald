CREATE TABLE [dbo].[SnapShotData] (
    [DataId]  INT          IDENTITY (1, 1) NOT NULL,
    [SnapId]  INT          NULL,
    [JobType] VARCHAR (50) NULL,
    [Count]   INT          NULL,
    [KVA]     FLOAT (53)   NULL,
    [AMPS]    FLOAT (53)   NULL,
    CONSTRAINT [PK_SnapShotData] PRIMARY KEY CLUSTERED ([DataId] ASC)
);

