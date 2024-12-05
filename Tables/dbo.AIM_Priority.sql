CREATE TABLE [dbo].[AIM_Priority]
(
[priorityid] [int] NOT NULL,
[description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Priority] ADD CONSTRAINT [pk_priority] PRIMARY KEY CLUSTERED ([priorityid]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Priority', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Priority', 'COLUMN', N'priorityid'
GO
