CREATE TABLE [dbo].[Custom_ListData]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ListCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SysCode] [bit] NOT NULL,
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Custom_ListData_CreatedBy] DEFAULT (suser_sname()),
[UpdatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Custom_ListData_UpdatedBy] DEFAULT (suser_sname()),
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_Custom_ListData_CreatedWhen] DEFAULT (getutcdate()),
[UpdatedWhen] [datetime] NULL CONSTRAINT [DF_Custom_ListData_UpdatedWhen] DEFAULT (getutcdate()),
[Enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_ListData] ADD CONSTRAINT [PK_Custom_ListData] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Custom_ListData_Code_ListCode] ON [dbo].[Custom_ListData] ([Code], [ListCode]) INCLUDE ([Description], [Enabled], [SysCode]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Custom_ListData_ListCode_Code] ON [dbo].[Custom_ListData] ([ListCode], [Code]) INCLUDE ([Description], [Enabled], [SysCode]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom table to contain list data values for various code/description values in custom applications', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code value for this row of list data', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user who created the list data row, relates back to users.loginname', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime stamp when the list data row was created', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description for the code for this row of list data', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether or not the code is enabled for use in application. Codes never deleted, this value simply set to 0.', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'Enabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for a row of list data', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to the custom_lists table for which list this row belongs to', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'ListCode'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'ListCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determines whether or not a user can remove or modify this entry in the maintenance application', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'SysCode'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'SysCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user who last updated the list data row, relates back to users.loginname', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'UpdatedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'UpdatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime stamp of the last time the list data row was modified', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'UpdatedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_ListData', 'COLUMN', N'UpdatedWhen'
GO
