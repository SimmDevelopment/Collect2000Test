CREATE TABLE [dbo].[AIM_BatchFileHistory]
(
[BatchFileHistoryId] [int] NOT NULL IDENTITY(1, 1),
[BatchFileTypeId] [int] NULL,
[BatchId] [int] NULL,
[AgencyId] [int] NULL,
[FileUrl] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WasImport] [bit] NULL,
[LogMessageId] [int] NULL,
[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RawFile] [image] NULL,
[DataSet] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataSetDataDiff] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumErrors] [int] NULL,
[NumRecords] [int] NULL,
[FTPSuccess] [bit] NULL,
[EmailSuccess] [bit] NULL,
[FTPMessage] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailMessage] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorOnOpening] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BatchFileHistory] ADD CONSTRAINT [PK_BatchFileHistory] PRIMARY KEY CLUSTERED ([BatchFileHistoryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_BatchFileHistory_AgencyId] ON [dbo].[AIM_BatchFileHistory] ([AgencyId]) INCLUDE ([BatchId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_BatchFileHistory_BatchFileTypeId] ON [dbo].[AIM_BatchFileHistory] ([BatchFileTypeId]) INCLUDE ([BatchId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BatchFileHistory] ADD CONSTRAINT [AIM_FK_BatchFileHistory_Agency] FOREIGN KEY ([AgencyId]) REFERENCES [dbo].[AIM_Agency] ([AgencyId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIM_BatchFileHistory] ADD CONSTRAINT [AIM_FK_BatchFileHistory_Batch] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[AIM_Batch] ([BatchId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIM_BatchFileHistory] ADD CONSTRAINT [AIM_FK_BatchFileHistory_BatchFileType] FOREIGN KEY ([BatchFileTypeId]) REFERENCES [dbo].[AIM_BatchFileType] ([BatchFileTypeId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIM_BatchFileHistory] ADD CONSTRAINT [AIM_FK_BatchFileHistory_LogMessage] FOREIGN KEY ([LogMessageId]) REFERENCES [dbo].[AIM_LogMessage] ([LogMessageId]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated agency for this batch', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'AgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'BatchFileHistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of file (Placement, Demographic, Placement, etc.)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'BatchFileTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated batch id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'BatchId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the dataset', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'DataSet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the dataset w/ row information ', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'DataSetDataDiff'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the name of the file', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'FileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the location of the file', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'FileUrl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the log message (error message or success)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'LogMessageId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'number of errors in the file', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'NumErrors'
GO
EXEC sp_addextendedproperty N'MS_Description', N'number of records in the file', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'NumRecords'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the raw data file in binary', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'RawFile'
GO
EXEC sp_addextendedproperty N'MS_Description', N'whether this batch file was an import', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BatchFileHistory', 'COLUMN', N'WasImport'
GO
