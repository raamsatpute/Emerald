CREATE TABLE [dbo].[PcbTestMethods] (
    [PcbTestMethodId] INT          IDENTITY (1, 1) NOT NULL,
    [SampleType]      VARCHAR (50) NULL,
    [TestMethod]      VARCHAR (50) NULL,
    [IsDefault]       BIT          CONSTRAINT [[dbo]].[PcbTestMethods]]IsDefaultDefault] DEFAULT ((0)) NULL
);

