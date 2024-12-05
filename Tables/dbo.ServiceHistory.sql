CREATE TABLE [dbo].[ServiceHistory]
(
[RequestID] [int] NOT NULL IDENTITY(1, 1),
[AcctID] [int] NULL,
[DebtorID] [int] NULL,
[CreationDate] [datetime] NULL,
[ReturnedDate] [datetime] NULL,
[ServiceID] [int] NULL,
[RequestedBY] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestedProgram] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processed] [int] NULL,
[XMLInfoRequested] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XMLInfoReturned] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cost] [money] NULL,
[SystemYear] [int] NULL,
[SystemMonth] [int] NULL,
[ServiceBatch] [float] NULL,
[VerifiedBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VerifiedDate] [datetime] NULL,
[BatchId] [uniqueidentifier] NULL,
[ProfileID] [uniqueidentifier] NULL,
[TypeName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackageID] [int] NULL,
[RequestingDate] [datetime] NULL,
[RequestedDate] [datetime] NULL,
[ResponseBatchID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceHistory] ADD CONSTRAINT [PK_ServiceHistory] PRIMARY KEY CLUSTERED ([RequestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CVR_ServiceHistory_AcctID] ON [dbo].[ServiceHistory] ([AcctID]) INCLUDE ([Processed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceHistory_AcctID] ON [dbo].[ServiceHistory] ([AcctID]) INCLUDE ([Processed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceHistory_DebtorID] ON [dbo].[ServiceHistory] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceHistory_DebtorID_ServiceID] ON [dbo].[ServiceHistory] ([DebtorID], [ServiceID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceHistory_PackageID_BatchID] ON [dbo].[ServiceHistory] ([PackageID], [BatchId]) INCLUDE ([ReturnedDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceHistory] ADD CONSTRAINT [FK_ServiceHistory_Fusion_Packages] FOREIGN KEY ([PackageID]) REFERENCES [dbo].[Fusion_Packages] ([ID])
GO
ALTER TABLE [dbo].[ServiceHistory] WITH NOCHECK ADD CONSTRAINT [FK_ServiceHistory_ServiceBatch_REQUESTS] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[ServiceBatch_REQUESTS] ([BatchID]) NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[ServiceHistory] ADD CONSTRAINT [FK_ServiceHistory_Services] FOREIGN KEY ([ServiceID]) REFERENCES [dbo].[Services] ([ServiceId])
GO
