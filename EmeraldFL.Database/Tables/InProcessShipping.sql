CREATE TABLE [dbo].[InProcessShipping] (
    [ShipmentID]    INT          IDENTITY (1, 1) NOT NULL,
    [ShipmentName]  VARCHAR (75) NULL,
    [DateStarted]   DATETIME     NULL,
    [DateCompleted] DATETIME     NULL,
    [ShippedFrom]   INT          NULL,
    [ShippedTo]     INT          NULL,
    [DateShipped]   DATETIME     NULL,
    [Complete]      BIT          CONSTRAINT [[dbo]].[InProcessShipping]]CompleteDefault] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_InProcessShipping] PRIMARY KEY CLUSTERED ([ShipmentID] ASC)
);

