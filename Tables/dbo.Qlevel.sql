CREATE TABLE [dbo].[Qlevel]
(
[code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomLevel] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShouldQueue] [bit] NOT NULL CONSTRAINT [DF__QLevel__ShouldQu__62F0628B] DEFAULT (1),
[AllowInDialFiles] [bit] NOT NULL CONSTRAINT [DF__QLevel__AllowInD__0E99DA9F] DEFAULT (1)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Qlevel', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Qlevel', 'COLUMN', N'code'
GO
