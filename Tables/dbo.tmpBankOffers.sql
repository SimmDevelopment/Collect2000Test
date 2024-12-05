CREATE TABLE [dbo].[tmpBankOffers]
(
[Number] [int] NULL,
[DONE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__tmpBankOff__DONE__5A1103C7] DEFAULT ('N'),
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetFollowup] [bit] NOT NULL CONSTRAINT [DF__tmpBankOf__SetFo__5B052800] DEFAULT (0),
[LastAccessed] [datetime] NOT NULL CONSTRAINT [DF__tmpBankOf__LastA__5BF94C39] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CQ_tmpBankOffers_Number] ON [dbo].[tmpBankOffers] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
