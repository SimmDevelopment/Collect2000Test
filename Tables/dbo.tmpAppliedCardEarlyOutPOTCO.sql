CREATE TABLE [dbo].[tmpAppliedCardEarlyOutPOTCO]
(
[Number] [int] NULL,
[DONE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__tmpApplied__DONE__2C60DE5E] DEFAULT ('N'),
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetFollowup] [bit] NOT NULL CONSTRAINT [DF__tmpApplie__SetFo__2D550297] DEFAULT (0),
[LastAccessed] [datetime] NOT NULL CONSTRAINT [DF__tmpApplie__LastA__2E4926D0] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CQ_tmpAppliedCardEarlyOutPOTCO_Number] ON [dbo].[tmpAppliedCardEarlyOutPOTCO] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
