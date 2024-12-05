CREATE TABLE [dbo].[Linking_Results]
(
[LinkID] [uniqueidentifier] NOT NULL,
[Number] [int] NOT NULL,
[Target] [int] NOT NULL,
[Score] [int] NOT NULL,
[Threshold] [int] NOT NULL,
[Linked] [bit] NOT NULL,
[Evaluated] [datetime] NOT NULL CONSTRAINT [DF__Linking_R__Evalu__56DF9161] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_Results] ADD CONSTRAINT [PK__Linking_Results__1D92056C] PRIMARY KEY NONCLUSTERED ([LinkID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_Results_Evaluated] ON [dbo].[Linking_Results] ([Evaluated]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_Results_Linked] ON [dbo].[Linking_Results] ([Linked]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_Results_Number] ON [dbo].[Linking_Results] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_Results_Number_Target] ON [dbo].[Linking_Results] ([Number], [Target]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_Results_Target] ON [dbo].[Linking_Results] ([Target]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table retains the results of each linking pass', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of Evaluation', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', 'COLUMN', N'Evaluated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates account was linked', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', 'COLUMN', N'Linked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID for link', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', 'COLUMN', N'LinkID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Source Account Filenumber ID of evaluated account', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total score of all matching fields that have been configured', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', 'COLUMN', N'Score'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target Filenumber ID account will link to if threshold is met', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', 'COLUMN', N'Target'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Threshold limit that must be obtained in order to link account', 'SCHEMA', N'dbo', 'TABLE', N'Linking_Results', 'COLUMN', N'Threshold'
GO
