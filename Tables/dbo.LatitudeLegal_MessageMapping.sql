CREATE TABLE [dbo].[LatitudeLegal_MessageMapping]
(
[MMID] [int] NOT NULL IDENTITY(1, 1),
[PCode] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qlevel] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecallAccount] [bit] NOT NULL CONSTRAINT [DF__LatitudeL__Recal__023EF0B2] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_MessageMapping] ADD CONSTRAINT [PK_LatitudeLegal_MessageMapping] PRIMARY KEY CLUSTERED ([MMID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LatitudeLegal_MessageMapping_PCode] ON [dbo].[LatitudeLegal_MessageMapping] ([PCode]) ON [PRIMARY]
GO
