CREATE TABLE [dbo].[DialerSoundBiteResultFile]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[FileName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileSize] [int] NOT NULL,
[Records] [int] NULL,
[TotalCallSeconds] [int] NULL,
[TotalDCHoldSeconds] [int] NULL,
[TotalDCRingSeconds] [int] NULL,
[TotalDCDirectConnectTalkSeconds] [int] NULL,
[DateCreated] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerSoundBiteResultFile] ADD CONSTRAINT [PK_DialerSoundBiteResultFile] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
