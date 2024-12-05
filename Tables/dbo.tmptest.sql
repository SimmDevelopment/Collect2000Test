CREATE TABLE [dbo].[tmptest]
(
[Number] [int] NOT NULL,
[Done] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__tmptest__Done__670E398E] DEFAULT ('N'),
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetFollowup] [bit] NOT NULL CONSTRAINT [DF__tmptest__SetFoll__68025DC7] DEFAULT ('0'),
[LastAccessed] [datetime] NOT NULL CONSTRAINT [DF__tmptest__LastAcc__68F68200] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CQ_test_Done_LastAccessed] ON [dbo].[tmptest] ([Done], [LastAccessed]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CQ_test_Number] ON [dbo].[tmptest] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
