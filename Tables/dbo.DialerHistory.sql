CREATE TABLE [dbo].[DialerHistory]
(
[DialerHistoryId] [int] NOT NULL IDENTITY(1, 1),
[DialerCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [int] NULL,
[HistoryId] [int] NULL,
[ListId] [int] NULL,
[CampaignCd] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorSeq] [int] NULL,
[CallDateTime] [datetime] NULL,
[CallTime] [smalldatetime] NULL,
[CallType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HistoryTable] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsAgentHandled] [bit] NULL,
[IsBadPhoneNumber] [bit] NULL,
[IsIVRRecord] [bit] NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerInstance] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[act_date] [smalldatetime] NULL,
[act_time] [int] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__DialerHis__Creat__1DFC19C0] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerHistory] ADD CONSTRAINT [PK_DialerHistory] PRIMARY KEY CLUSTERED ([DialerHistoryId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Provides a location to make a copy of a dialers history records.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude FileNumber', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of call', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'act_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time of call', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'act_time'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the call was placed.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'CallDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time the call was placed.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'CallTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inbound, Outbound, Manual, etc.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'CallType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A code for the campaign that call record was from.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'CampaignCd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The debtors.seq value for the phone number dialed.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'DebtorSeq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agents identification for an agent handled call.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DialerInstanceCode', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'DialerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Unique Identity', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'DialerHistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DialerInstanceCode for the DialerInstance this record came from.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'DialerInstance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Id from dialers history record', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'HistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the table or file that this record came from.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'HistoryTable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Boolean indicating if an agent handled the call or not.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'IsAgentHandled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Boolean indicating if the phone number was invalid.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'IsBadPhoneNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Boolean indicating if the call was part of an IVR campaign.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'IsIVRRecord'
GO
EXEC sp_addextendedproperty N'MS_Description', N'An id for the list that was used. List is subordinate to campaign.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'ListId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The phone number that was dialed', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'PhoneNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialers result value. Actual values depend on dialer.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'Result'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialers status value. Actual values depend on dialer.', 'SCHEMA', N'dbo', 'TABLE', N'DialerHistory', 'COLUMN', N'Status'
GO
