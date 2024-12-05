CREATE TABLE [dbo].[CustomerComments]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CustomerCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeCreated] [datetime] NULL CONSTRAINT [DF_CustomerComments_DateTimeCreated] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CustomerComments_CreatedBy] DEFAULT ('user_name')
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relates to the Comments tab of the Customer Properties window and is used to add notes and monitor changes made to the customer record within Customer Maintenance.', 'SCHEMA', N'dbo', 'TABLE', N'CustomerComments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Freeform comment', 'SCHEMA', N'dbo', 'TABLE', N'CustomerComments', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User logon Entering Comment', 'SCHEMA', N'dbo', 'TABLE', N'CustomerComments', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code of the respective Customer', 'SCHEMA', N'dbo', 'TABLE', N'CustomerComments', 'COLUMN', N'CustomerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime Entered', 'SCHEMA', N'dbo', 'TABLE', N'CustomerComments', 'COLUMN', N'DateTimeCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'CustomerComments', 'COLUMN', N'Id'
GO
