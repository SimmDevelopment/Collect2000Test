CREATE TABLE [dbo].[LatitudeLegal_FeeScheduleReference]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL,
[PostSuitFeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Modified] [bit] NULL CONSTRAINT [DF__LatitudeL__Modif__360D7185] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_FeeScheduleReference] ADD CONSTRAINT [PK_LatitudeLegal_FeeScheduleReference] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LatitudeLegal_FeeScheduleReference_Number] ON [dbo].[LatitudeLegal_FeeScheduleReference] ([Number]) ON [PRIMARY]
GO
