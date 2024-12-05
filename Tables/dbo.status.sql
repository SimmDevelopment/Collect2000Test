CREATE TABLE [dbo].[status]
(
[code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[statustype] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[returndays] [smallint] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CbrReport] [bit] NOT NULL CONSTRAINT [DF__Status__CbrRepor__0F183235] DEFAULT (0),
[CaseCount] [bit] NOT NULL CONSTRAINT [DF__Status__CaseCoun__6AFB98A7] DEFAULT (1),
[IsBankruptcy] [bit] NOT NULL CONSTRAINT [DF_status_IsBankruptcy] DEFAULT (0),
[IsDeceased] [bit] NOT NULL CONSTRAINT [DF_status_IsDeceased] DEFAULT (0),
[ReduceStats] [int] NOT NULL CONSTRAINT [DF__Status__ReduceSt__5931EE27] DEFAULT (0),
[cbrDelete] [bit] NOT NULL CONSTRAINT [DF__status__cbrDelet__3D0AB0C5] DEFAULT (0),
[IsDisputed] [bit] NOT NULL CONSTRAINT [DF__status__IsDisput__3DFED4FE] DEFAULT (0),
[IsPIF] [bit] NOT NULL CONSTRAINT [DF__status__IsPIF__3EF2F937] DEFAULT (0),
[IsSIF] [bit] NOT NULL CONSTRAINT [DF__status__IsSIF__3FE71D70] DEFAULT (0),
[IsFraud] [bit] NOT NULL CONSTRAINT [def_status_IsFraud] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[status] ADD CONSTRAINT [PK_status] PRIMARY KEY NONCLUSTERED ([code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'status', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'status', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Data', 'SCHEMA', N'dbo', 'TABLE', N'status', 'COLUMN', N'Description'
GO
