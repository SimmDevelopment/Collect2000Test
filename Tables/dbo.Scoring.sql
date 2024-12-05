CREATE TABLE [dbo].[Scoring]
(
[Number] [int] NOT NULL,
[RecordId] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[version] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scoringdate] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[score] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[collectioneffort] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[echofield] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pubbkreccode] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
