CREATE TABLE [dbo].[tmpLoanDefault]
(
[Number] [int] NULL,
[DONE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__tmpLoanDef__DONE__5FC9DD1D] DEFAULT ('N'),
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetFollowup] [bit] NOT NULL CONSTRAINT [DF__tmpLoanDe__SetFo__60BE0156] DEFAULT (0),
[LastAccessed] [datetime] NOT NULL CONSTRAINT [DF__tmpLoanDe__LastA__61B2258F] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CQ_tmpLoanDefault_Number] ON [dbo].[tmpLoanDefault] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
