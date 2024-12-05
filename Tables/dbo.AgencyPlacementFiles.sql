CREATE TABLE [dbo].[AgencyPlacementFiles]
(
[Number] [int] NOT NULL,
[FileDate] [datetime] NOT NULL,
[AgencyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Tier] [tinyint] NOT NULL,
[AmtPlaced] [money] NOT NULL,
[Filename] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Acknowledged] [bit] NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'Acknowledged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'AgencyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'AmtPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'FileDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'Filename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'Tier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacementFiles', 'COLUMN', N'UID'
GO
