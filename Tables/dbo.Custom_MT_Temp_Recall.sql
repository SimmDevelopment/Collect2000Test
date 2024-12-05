CREATE TABLE [dbo].[Custom_MT_Temp_Recall]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecallReason] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountingSysID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_MT_Temp_Recall] ADD CONSTRAINT [PK_Custom_MT_Temp_Recall] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
