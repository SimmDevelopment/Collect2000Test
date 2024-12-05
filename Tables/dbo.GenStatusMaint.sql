CREATE TABLE [dbo].[GenStatusMaint]
(
[LatStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CancelCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReasonCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HoldDays] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GenStatusMaint] ADD CONSTRAINT [PK_GenStatusMaint] PRIMARY KEY CLUSTERED ([LatStatus]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
