CREATE TABLE [dbo].[GenCustMaint]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeePercent] [money] NOT NULL CONSTRAINT [DF__GenCustMa__FeePe__4BADD5D7] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GenCustMaint] ADD CONSTRAINT [PK_GenCustMaint] PRIMARY KEY CLUSTERED ([Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
