CREATE TABLE [dbo].[CbrDataCycleEndReported]
(
[CbrDataCycleEndReportedID] [int] NOT NULL IDENTITY(1, 1),
[racctstat] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rcompliance] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rinfoind] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rspcomment] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pacctstat] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pcompliance] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pinfoind] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pspcomment] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[specialnote] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fileid] [int] NULL,
[cbrenabled] [bit] NULL,
[cbrportfoliotype] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cbrAccountType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[debtorseq] [int] NULL,
[recoa] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pecoa] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[debtorresponsible] [bit] NULL,
[cbrexclude] [bit] NULL,
[cbrprevent] [bit] NULL,
[isdisputed] [bit] NULL,
[isdeceased] [bit] NULL,
[statusisfraud] [bit] NULL,
[statuscbrreport] [bit] NULL,
[statuscbrdelete] [bit] NULL,
[pndexception] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cbrdod] [int] NULL,
[cbroverride] [bit] NULL,
[rptLines] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CbrDataCycleEndReported] ADD CONSTRAINT [PK_CbrDataCycleEndReported] PRIMARY KEY CLUSTERED ([CbrDataCycleEndReportedID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is a work table which is truncated and refreshed each EOM when producing the creadit bureau report.  The cbrDataReported() function is the source data.  The dataset can be used to validate the cbr credit report', 'SCHEMA', N'dbo', 'TABLE', N'CbrDataCycleEndReported', NULL, NULL
GO
