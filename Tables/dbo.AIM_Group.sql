CREATE TABLE [dbo].[AIM_Group]
(
[GroupId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupTypeId] [int] NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Configuration] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Group] ADD CONSTRAINT [PK_AIM_Group] PRIMARY KEY CLUSTERED ([GroupId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Group] ADD CONSTRAINT [FK_AIM_Group_AIM_GroupType] FOREIGN KEY ([GroupTypeId]) REFERENCES [dbo].[AIM_GroupType] ([GroupTypeId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group city', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group Configuration (XML) used for import and export definitions', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Configuration'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group description', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group fax', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'GroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group type (Buyer,Seller,Investor)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'GroupTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group name', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group phone', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group state', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group street1', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group street2', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group zip', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Group', 'COLUMN', N'Zipcode'
GO
