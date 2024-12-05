CREATE TABLE [dbo].[OSSRequests]
(
[OSSReqID] [int] NOT NULL IDENTITY(1, 1),
[DebtorID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestDate] [datetime] NULL,
[UserID] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestParameter] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnData] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OSSRequests] ADD CONSTRAINT [PK_OSSRequests] PRIMARY KEY CLUSTERED ([OSSReqID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_OSSRequests_AccountID] ON [dbo].[OSSRequests] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_OSSRequests_DebtorID] ON [dbo].[OSSRequests] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
