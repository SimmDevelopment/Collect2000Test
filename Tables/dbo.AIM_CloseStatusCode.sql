CREATE TABLE [dbo].[AIM_CloseStatusCode]
(
[CloseStatusCodeId] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [int] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MoveToDeskValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MoveToQueueValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_CloseStatusCode] ADD CONSTRAINT [PK_CloseStatusCode] PRIMARY KEY CLUSTERED ([CloseStatusCodeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_CloseStatusCode] ADD CONSTRAINT [IX_CloseStatusCode] UNIQUE NONCLUSTERED ([Code], [AgencyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_CloseStatusCode] ADD CONSTRAINT [AIM_FK_CloseStatusCode_Agency] FOREIGN KEY ([AgencyId]) REFERENCES [dbo].[AIM_Agency] ([AgencyId]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'associated agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CloseStatusCode', 'COLUMN', N'AgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CloseStatusCode', 'COLUMN', N'CloseStatusCodeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'user defined code for this closed status', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CloseStatusCode', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'what desks to move accounts to upon processing', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CloseStatusCode', 'COLUMN', N'MoveToDeskValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'what qlevel to move accounts to upon processing', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CloseStatusCode', 'COLUMN', N'MoveToQueueValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the name of the close status code', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CloseStatusCode', 'COLUMN', N'Name'
GO
