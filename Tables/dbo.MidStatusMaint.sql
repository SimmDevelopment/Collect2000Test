CREATE TABLE [dbo].[MidStatusMaint]
(
[LatStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PaperlessCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HoldDays] [int] NOT NULL,
[PaperlessComment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsStatus] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MidStatusMaint] ADD CONSTRAINT [PK_MidStatusMaint] PRIMARY KEY CLUSTERED ([LatStatus]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
