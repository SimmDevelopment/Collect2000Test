CREATE TABLE [dbo].[Linking_ResultTests]
(
[TestID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__Linking_R__TestI__2ACC04F9] DEFAULT (newid()),
[LinkID] [uniqueidentifier] NOT NULL,
[Test] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Score] [int] NOT NULL,
[SourceDebtorID] [int] NULL,
[TargetDebtorID] [int] NULL,
[SourceData] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetData] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Exception] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_ResultTests] ADD CONSTRAINT [PK__Linking_ResultTe__206E7217] PRIMARY KEY NONCLUSTERED ([TestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_ResultTests_ID] ON [dbo].[Linking_ResultTests] ([LinkID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_ResultTests] ADD CONSTRAINT [FK__Linking_R__LinkI__2256BA89] FOREIGN KEY ([LinkID]) REFERENCES [dbo].[Linking_Results] ([LinkID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used by linking to retain all accounts that meet the possible linking threshold but fall under the required linking threshold defined.  They are retained for analysis when determining optimal link settings.', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Explanation of link exception', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'Exception'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LinkID of target account', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'LinkID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Score attained by Source DebtorID', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'Score'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Source data for given test', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'SourceData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DebtorID that met the possible threshold', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'SourceDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target data for given test', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'TargetData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DebtorID of target that the source attempted to link to.', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'TargetDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Test based on configured linking data points (SSN, DOB etc.)', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'Test'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ResultTests', 'COLUMN', N'TestID'
GO
