CREATE TABLE [dbo].[StairStep_Temp_Placements]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PlacementMonth] [datetime] NOT NULL,
[AccountsPlaced] [bigint] NULL,
[GrossDollarsPlaced] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStep_Temp_Placements] ADD CONSTRAINT [PK_SS_Placements] PRIMARY KEY CLUSTERED ([Customer], [PlacementMonth]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StairStep_Temp_Placements_PlacementMonth] ON [dbo].[StairStep_Temp_Placements] ([PlacementMonth]) ON [PRIMARY]
GO
