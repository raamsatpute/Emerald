CREATE TABLE [dbo].[Locations] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [LocationName]   VARCHAR (150) NULL,
    [Status]         VARCHAR (1)   CONSTRAINT [DF_InventoryLocations_Status] DEFAULT ('A') NULL,
    [Address]        VARCHAR (150) NULL,
    [City]           VARCHAR (150) NULL,
    [State]          VARCHAR (50)  NULL,
    [Zip]            VARCHAR (50)  NULL,
    [InProcessGroup] INT           NULL,
    [TimeOffSet]     INT           CONSTRAINT [[dbo]].[Locations]]TimeOffSetDefault] DEFAULT ((0)) NULL,
    [Phone]          VARCHAR (15)  NULL,
    [CreateSnapShot] BIT           CONSTRAINT [DF_Locations_CreateSnapShot] DEFAULT ((0)) NULL
);

