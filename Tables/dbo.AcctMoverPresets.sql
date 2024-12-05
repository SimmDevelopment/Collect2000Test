CREATE TABLE [dbo].[AcctMoverPresets]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[XML] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AcctMoverPresets] ADD CONSTRAINT [PK_AcctMoverJobDefs] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saved Account Mover Options that may be reused', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverPresets', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined description of Account Mover Job', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverPresets', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity of Options row', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverPresets', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name given to Preset/Options saved from Account Mover', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverPresets', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'All options and User Defined SQL ', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverPresets', 'COLUMN', N'XML'
GO
