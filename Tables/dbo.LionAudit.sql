CREATE TABLE [dbo].[LionAudit]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LionUserID] [int] NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF_LionAudit_Date] DEFAULT (getdate()),
[Page] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionCode] [uniqueidentifier] NULL,
[Message] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserIPAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserHostName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RawUrl] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionAudit] ADD CONSTRAINT [PK_LionAudit] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
