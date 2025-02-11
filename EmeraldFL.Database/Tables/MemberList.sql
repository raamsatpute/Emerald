CREATE TABLE [dbo].[MemberList] (
    [EmailMemberId] INT IDENTITY (1, 1) NOT NULL,
    [DistListId]    INT NULL,
    [UID]           INT NULL,
    CONSTRAINT [PK_MemberList] PRIMARY KEY CLUSTERED ([EmailMemberId] ASC)
);

