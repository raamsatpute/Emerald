CREATE TABLE [dbo].[MapCustomers] (
    [MapCustId]     INT           IDENTITY (1, 1) NOT NULL,
    [CustomerName]  VARCHAR (100) NULL,
    [CompanyType]   VARCHAR (20)  NULL,
    [ParentName]    VARCHAR (100) NULL,
    [CustomerTotal] FLOAT (53)    NULL,
    [Street]        VARCHAR (150) NULL,
    [City]          VARCHAR (75)  NULL,
    [State]         VARCHAR (2)   NULL,
    [Zip]           VARCHAR (15)  NULL,
    [Rep]           VARCHAR (50)  NULL,
    [PinStyle]      VARCHAR (15)  NULL,
    [Latitude]      FLOAT (53)    NULL,
    [Longitude]     FLOAT (53)    NULL,
    CONSTRAINT [PK_MapCustomers] PRIMARY KEY CLUSTERED ([MapCustId] ASC)
);

