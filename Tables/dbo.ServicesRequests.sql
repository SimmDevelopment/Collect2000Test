CREATE TABLE [dbo].[ServicesRequests]
(
[Number] [int] NULL,
[Requested] [datetime] NULL,
[ByWho] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceId] [int] NULL,
[FileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileCreated] [datetime] NULL,
[FileSent] [datetime] NULL,
[ServiceRequestID] [int] NOT NULL IDENTITY(1, 1),
[DebtorID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServicesRequests] ADD CONSTRAINT [PK_ServicesRequests] PRIMARY KEY CLUSTERED ([ServiceRequestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServicesRequests_DebtorID] ON [dbo].[ServicesRequests] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServicesRequests_Number] ON [dbo].[ServicesRequests] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
