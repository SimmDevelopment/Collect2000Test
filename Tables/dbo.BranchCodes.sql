CREATE TABLE [dbo].[BranchCodes]
(
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone800] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BranchCodes] ADD CONSTRAINT [PK_BranchCodes] PRIMARY KEY CLUSTERED ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_BranchCodes] ON [dbo].[BranchCodes] ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Generally used only for agency having more than one office (or branch). Branch codes are assigned to accounts, which allow inventory separation by location.', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'Address1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'Address2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch City', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Internal code assigned by manager', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal comments identifying branch or business', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch Fax', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collections Manager in charge of Branch', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'Manager'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch Name (Office Name)', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch Phone', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Toll Free Branch number', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'Phone800'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch State', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'BranchCodes', 'COLUMN', N'Zipcode'
GO
