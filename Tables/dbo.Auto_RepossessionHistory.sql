CREATE TABLE [dbo].[Auto_RepossessionHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[LoginName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTimeStamp] [datetime] NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_RepossessionHistory] ADD CONSTRAINT [PK_Auto_RepossessionHistory] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
