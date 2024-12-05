CREATE TABLE [dbo].[Servicehistory_BU_72007]
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
[TypeName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
