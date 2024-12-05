CREATE TABLE [dbo].[Custom_Simm_Track_ReturnedDate]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NOT NULL,
[date] [datetime] NOT NULL,
[old_returned] [datetime] NULL,
[new_returned] [datetime] NULL,
[UserID] [int] NOT NULL,
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramName] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WindowsUser] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostName] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Simm_Track_ReturnedDate] ADD CONSTRAINT [PK__Custom_Simm_Trac__77F80317] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
