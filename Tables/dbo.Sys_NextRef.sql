CREATE TABLE [dbo].[Sys_NextRef]
(
[SeriesName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastRefID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sys_NextRef] ADD CONSTRAINT [PK_Sys_NextRef] PRIMARY KEY CLUSTERED ([SeriesName]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Each row represents a virtual key and its current max value. Access by using spGetNextKeyValue.', 'SCHEMA', N'dbo', 'TABLE', N'Sys_NextRef', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value for the virtual key. This is the last returned value from spGetNextKeyValue.', 'SCHEMA', N'dbo', 'TABLE', N'Sys_NextRef', 'COLUMN', N'LastRefID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name for the virtual key. Normally the name of the column the virtual key value is stored in.', 'SCHEMA', N'dbo', 'TABLE', N'Sys_NextRef', 'COLUMN', N'SeriesName'
GO
