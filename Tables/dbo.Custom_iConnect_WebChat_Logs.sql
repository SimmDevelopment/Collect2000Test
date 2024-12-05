CREATE TABLE [dbo].[Custom_iConnect_WebChat_Logs]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[FileNumber] [int] NULL,
[UserType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommentDateTime] [datetime] NULL,
[EventID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_iConnect_WebChat_Logs] ADD CONSTRAINT [PK_Custom_iConnect_WebChat_Logs] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
