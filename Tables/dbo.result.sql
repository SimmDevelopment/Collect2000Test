CREATE TABLE [dbo].[result]
(
[code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[worked] [smallint] NULL,
[contacted] [smallint] NULL,
[note] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ComplianceAttempt] [smallint] NULL CONSTRAINT [DF_result_ComplianceAttempt] DEFAULT ((0))
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'result', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'result', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Boolean, when combined with an action that is an attempt, then this will be considered an attempt for compliance purposes.', 'SCHEMA', N'dbo', 'TABLE', N'result', 'COLUMN', N'ComplianceAttempt'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'result', 'COLUMN', N'Description'
GO
