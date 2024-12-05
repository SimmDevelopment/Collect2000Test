CREATE TABLE [dbo].[LatitudeLegal_History]
(
[LLHistoryID] [int] NOT NULL IDENTITY(1, 1),
[LatitudeUsername] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartedDateTime] [datetime] NULL,
[EndedDateTime] [datetime] NULL,
[SentReconciliation] [bit] NULL,
[Test] [bit] NULL,
[Type] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_History] ADD CONSTRAINT [PK_LatitudeLegal_History] PRIMARY KEY CLUSTERED ([LLHistoryID]) ON [PRIMARY]
GO
