CREATE TABLE [dbo].[AIM_GroupContactAssn]
(
[GroupContactAssnId] [int] NOT NULL IDENTITY(1, 1),
[GroupId] [int] NULL,
[ContactId] [int] NULL,
[OwnershipPercentage] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_GroupContactAssn] ADD CONSTRAINT [PK_AIM_InvestorGroup] PRIMARY KEY CLUSTERED ([GroupContactAssnId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_GroupContactAssn] ADD CONSTRAINT [FK_AIM_GroupContactAssn_AIM_Contact] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[AIM_Contact] ([ContactId])
GO
ALTER TABLE [dbo].[AIM_GroupContactAssn] ADD CONSTRAINT [FK_AIM_GroupContactAssn_AIM_Group] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[AIM_Group] ([GroupId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'The associated contact id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_GroupContactAssn', 'COLUMN', N'ContactId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_GroupContactAssn', 'COLUMN', N'GroupContactAssnId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The associated group id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_GroupContactAssn', 'COLUMN', N'GroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Owenership percentage if investor', 'SCHEMA', N'dbo', 'TABLE', N'AIM_GroupContactAssn', 'COLUMN', N'OwnershipPercentage'
GO
