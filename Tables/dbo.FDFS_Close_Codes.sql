CREATE TABLE [dbo].[FDFS_Close_Codes]
(
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReturnCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Narrative1] [varchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[HoldDays] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FDFS_Close_Codes] ADD CONSTRAINT [PK_FDFS_Close_Codes] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
