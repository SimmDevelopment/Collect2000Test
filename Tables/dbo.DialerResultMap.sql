CREATE TABLE [dbo].[DialerResultMap]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[DialerInstanceCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CRC] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRCDefault] [bit] NOT NULL CONSTRAINT [DF_DialerResultMap_CRCDefault] DEFAULT (1),
[CRCStatus] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRCStatusDefault] [bit] NOT NULL CONSTRAINT [DF_DialerResultMap_CRCStatusDefault] DEFAULT (1),
[LatitudeInstanceCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DialerResultMap_LatitudeInstanceCode] DEFAULT ('Default'),
[Result] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResultDefault] [bit] NOT NULL CONSTRAINT [DF_DialerResultMap_ResultDefault] DEFAULT (1),
[SystemNoteId] [int] NOT NULL,
[DisplayOrder] [int] NOT NULL,
[MoveQDateDays] [int] NOT NULL CONSTRAINT [DF_DialerResultMap_MoveQDateDays] DEFAULT (1),
[RemoveNumberCount] [int] NOT NULL CONSTRAINT [DF_DialerResultMap_BadNumerResult] DEFAULT (0),
[RFU] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerResultMap] ADD CONSTRAINT [PK_DialerResultMap] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains mappings from a dialers status and crc values to Latitude Result', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialers Call Result Code', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'CRC'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'CRC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this the value that should be used for mapping from crc if more than one crc of same value.', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'CRCDefault'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'CRCDefault'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialers Call Status value', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'CRCStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this the value that should be used for mapping from status if more than one status of same value.', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'CRCStatusDefault'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The dialerinstancecode that this resultmapping applies to.', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'DialerInstanceCode'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'DialerInstanceCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order this should display if presented to user.', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'DisplayOrder'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LatitudeInstanceCode', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'LatitudeInstanceCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days to advance the queue date.', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'MoveQDateDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of consecutive results before removing number from account. ', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'RemoveNumberCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitudes result code value', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'Result'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this the value that should be used for mapping from result if more than one result of same value.', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'ResultDefault'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reserved for future use.', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'RFU'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the SystemNoteTemplate table. ', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'SystemNoteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Unique Identity', 'SCHEMA', N'dbo', 'TABLE', N'DialerResultMap', 'COLUMN', N'UID'
GO
