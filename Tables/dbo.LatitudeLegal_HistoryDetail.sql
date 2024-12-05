CREATE TABLE [dbo].[LatitudeLegal_HistoryDetail]
(
[LLHistoryDetailID] [int] NOT NULL IDENTITY(1, 1),
[LLHistoryID] [int] NULL,
[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyID] [int] NULL,
[RawSource] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_HistoryDetail] ADD CONSTRAINT [PK_LatitudeLegal_HistoryDetail] PRIMARY KEY CLUSTERED ([LLHistoryDetailID]) ON [PRIMARY]
GO
