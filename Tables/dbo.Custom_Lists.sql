CREATE TABLE [dbo].[Custom_Lists]
(
[ListCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CodeLengthMax] [int] NOT NULL,
[DescLengthMax] [int] NOT NULL,
[CodeIsNumeric] [bit] NOT NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_Custom_Lists_CreatedWhen] DEFAULT (getutcdate()),
[Namespace] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Lists] ADD CONSTRAINT [PK_Custom_Lists] PRIMARY KEY CLUSTERED ([ListCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Custom_Lists] ON [dbo].[Custom_Lists] ([ListCode], [Description], [DisplayName], [CodeLengthMax], [DescLengthMax], [CodeIsNumeric], [CreatedWhen], [Namespace]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom table to contain information on lists of various code/description values used in custom applications', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determines whether or not the ''code'' field for the list is a string or integer', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'CodeIsNumeric'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'CodeIsNumeric'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum length of the ''code'' field for specific list', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'CodeLengthMax'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'CodeLengthMax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime stamp when the list was created', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum length of the ''description'' field for specific list', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'DescLengthMax'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'DescLengthMax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the supposed contents of a list', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of list displayed in maintenace application', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'DisplayName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'DisplayName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK, short hand code provided for a list', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'ListCode'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'ListCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The application/context where this list is used', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'Namespace'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_Lists', 'COLUMN', N'Namespace'
GO
