CREATE TABLE [dbo].[ShipLogTripTypes] (
    [TripTypeId]  INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (50) NULL,
    [Value]       VARCHAR (1)  NULL,
    [Status]      BIT          CONSTRAINT [DF_ShipLogTripTypes_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ShipLogTripTypes] PRIMARY KEY CLUSTERED ([TripTypeId] ASC)
);

