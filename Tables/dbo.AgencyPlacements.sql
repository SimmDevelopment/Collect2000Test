CREATE TABLE [dbo].[AgencyPlacements]
(
[Number] [int] NOT NULL,
[AgencyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AmtPlaced] [money] NOT NULL,
[DatePlaced] [datetime] NOT NULL,
[PlacementLevel] [tinyint] NOT NULL,
[Collected] [money] NOT NULL CONSTRAINT [DF_AgencyPlacements_Collected] DEFAULT (0),
[FeePaid] [money] NOT NULL CONSTRAINT [DF_AgencyPlacements_FeePaid] DEFAULT (0),
[ReturnedDate] [datetime] NULL,
[ReturnedStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[PlacementFileUID] [int] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'AgencyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'AmtPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'Collected'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'DatePlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'FeePaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'PlacementFileUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'PlacementLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'ReturnedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'ReturnedStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPlacements', 'COLUMN', N'UID'
GO
