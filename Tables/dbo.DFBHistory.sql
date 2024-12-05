CREATE TABLE [dbo].[DFBHistory]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Action] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Automated] [bit] NOT NULL CONSTRAINT [DF_DFBHistory_UpdateMethod] DEFAULT (0),
[TotalRecords] [int] NULL CONSTRAINT [DF_DFBHistory_TotalRecords] DEFAULT (0),
[TotalRecordsWritten] [int] NULL CONSTRAINT [DF_DFBHistory_TotalRecordsWritten] DEFAULT (0),
[TotalErrorRecords] [int] NULL CONSTRAINT [DF_DFBHistory_TotalErrorRecords] DEFAULT (0),
[SQLQuery] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DirectoryPath] [varchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF_DFBHistory_Created] DEFAULT (getdate()),
[CreatedBy] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DFBHistory_CreatedBy] DEFAULT (N'GetCurrentLatitudeUser()'),
[DialerInstance] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LatitudeInstance] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DFBHistory_LatitudeInstance] DEFAULT ('master'),
[Options] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DFBHistory] ADD CONSTRAINT [PK_DFBHistory] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains output information from ListBuilder (formerly DialFileBldr - DFB)', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Action that was taken.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'Action'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Boolean, was this output created without user interaction?', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'Automated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When was this record created.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user that created record.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The dialerinstance code from dialerinstance table that output is meant for.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'DialerInstance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'path where file was written to, or database info if direct insert.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'DirectoryPath'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the file or table data written to.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'FileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The LatitudeInstanceCode that the data was queried from.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'LatitudeInstance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'xml snipet indicating options chosen for export Note: slashes delimit possible values. Example <Options TableCleanup=0/1/2 ClearBeforeImport=True/False InsertIntoLiveQueue=True/False UpdateMatched=True/False />', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'Options'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Query used to select records.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'SQLQuery'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of errored records ignored by dialer.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'TotalErrorRecords'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of records in output.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'TotalRecords'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of records successfully written to dialer', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'TotalRecordsWritten'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK identity', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory', 'COLUMN', N'UID'
GO
