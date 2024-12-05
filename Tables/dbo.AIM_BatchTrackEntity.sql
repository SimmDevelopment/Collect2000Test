CREATE TABLE [dbo].[AIM_BatchTrackEntity]
(
[BatchTrackId] [int] NOT NULL,
[EntityId] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [tinyint] NOT NULL CONSTRAINT [DF__AIM_BatchT__Type__69E21B46] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BatchTrackEntity] ADD CONSTRAINT [FK_BatchTrackId] FOREIGN KEY ([BatchTrackId]) REFERENCES [dbo].[AIM_BatchTrack] ([Id]) ON DELETE CASCADE
GO
