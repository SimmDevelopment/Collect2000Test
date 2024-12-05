CREATE TABLE [dbo].[CustomCustGroups]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOnInvoices] [bit] NULL,
[DisplayOnStats] [bit] NULL,
[LetterGroup] [bit] NOT NULL CONSTRAINT [DF_CustomCustGroups_LetterGoup] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_CustomCustGroups_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_CustomCustGroups_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomCustGroups] ADD CONSTRAINT [PK_CustomCustGroups] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Groups represent general types of collection business given to your agency and are used to categorize customers for invoicing and statistics. Individual customers may be placed into one or more groups (or none).Custom groups are used to bunch related customers together for reports within Latitude.  These are defined in Maintenance  Custom Groups, and should not be confused with Parent Customers (invoice groups) or Customer Letter Groups.  A customer may belong to more than one custom group.', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of Group', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set shows the customer group for selection within the Invoices add-on program', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', 'COLUMN', N'DisplayOnInvoices'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set shows the customer group for selection within the Statistics Console add-on program.  ', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', 'COLUMN', N'DisplayOnStats'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Group Name', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroups', 'COLUMN', N'Name'
GO
