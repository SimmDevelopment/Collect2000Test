CREATE TABLE [dbo].[DialerInstance]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DialerType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_DialerInstance_Active] DEFAULT (0),
[DataSource] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InitialCatalog] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserId] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataPath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HistoryTable] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerServer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DialerInstance_DialerServer] DEFAULT ('Dialer'),
[DialerPort] [int] NOT NULL CONSTRAINT [DF_DialerInstance_DialerPort] DEFAULT (0),
[TransferCRC] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DialerInstance_TransferCRC] DEFAULT ('XFER'),
[HistoryLastReadDate] [datetime] NULL,
[HistoryLastReadId] [int] NULL,
[DoNotCallFileInfo] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFU] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerInstance] ADD CONSTRAINT [PK_DialerInstance] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines an instance of a dialer. ', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Should DialerHistoryUpdateService search this dialerinstance for history records.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A unique code assigned to this dialerinstance', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialer specific information', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'DataPath'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialer Connection Info', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'DataSource'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialer port that is used when configuring clients to connect to dialer.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'DialerPort'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DialerServer that is used when configuring clients to connect to dialer.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'DialerServer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A string value indicating the dialer vendor.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'DialerType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'location of file for number removal service', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'DoNotCallFileInfo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The call datetime stamp of the last history record that was read.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'HistoryLastReadDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The id of the last history record that was read.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'HistoryLastReadId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the table or file to read call history from.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'HistoryTable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialer Connection Info', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'InitialCatalog'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encrypted database logon info', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'Password'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reserved for future use.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'RFU'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A default result to apply to a note when a call is transferred.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'TransferCRC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Unique Identity', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encrypted database logon info', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstance', 'COLUMN', N'UserId'
GO
