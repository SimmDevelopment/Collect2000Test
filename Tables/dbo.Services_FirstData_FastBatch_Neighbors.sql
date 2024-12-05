CREATE TABLE [dbo].[Services_FirstData_FastBatch_Neighbors]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[seq] [int] NULL,
[NumberofNeighborsReturned] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeighborName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeighborAddress] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeighborZipCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeighborPhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeighborDwellingUnits] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeighborLengthofResidence] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_Neighbors] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_Neighbors] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
