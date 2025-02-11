CREATE TABLE [dbo].[SoldTo] (
    [SoldToid] INT           IDENTITY (1, 1) NOT NULL,
    [Name]     VARCHAR (50)  NULL,
    [Address]  VARCHAR (150) NULL,
    [City]     VARCHAR (150) NULL,
    [State]    VARCHAR (2)   NULL,
    [Zip]      VARCHAR (15)  NULL,
    CONSTRAINT [PK_SoldTo] PRIMARY KEY CLUSTERED ([SoldToid] ASC)
);

