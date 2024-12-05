CREATE TABLE [dbo].[DialerContactAttempt]
(
[DialerContactAttemptId] [int] NOT NULL IDENTITY(1, 1),
[DialerCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [bigint] NOT NULL,
[DebtorId] [bigint] NOT NULL,
[DebtorSeq] [int] NOT NULL,
[ContactDevice] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactDeviceType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactDeviceSubType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerAttemptId] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListId] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CampaignCd] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConnectStatus] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerCRC] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttemptDateTime] [smalldatetime] NULL,
[UTCAttemptDateTime] [smalldatetime] NULL,
[DebtorLocalTime] [smalldatetime] NULL,
[Duration] [time] NULL,
[AttemptType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerUser] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LatitudeUser] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResultsSourceName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsAgentHandled] [bit] NULL,
[IsRightPartyContact] [bit] NULL,
[IsBadPhoneNumber] [bit] NULL,
[IsIVRRecord] [bit] NULL,
[IsPaymentTaken] [bit] NULL,
[PaymentAmount] [money] NULL,
[ArrangementId] [int] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__DialerContactAttempt__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerContactAttempt] ADD CONSTRAINT [PK_DialerContactAttempt] PRIMARY KEY CLUSTERED ([DialerContactAttemptId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Information about contact attempts initiated from a dialer.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude FileNumber.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If an arrangement was setup during the contact then this should be a valid arrangementId.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'ArrangementId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the attempt was launched/received or initiated manually.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'AttemptDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifier if attempt was Manual call, Inbound, or Outbound call.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'AttemptType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialer campaign/sub-campaign used when generating outbound calls.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'CampaignCd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Telephony result (Connected, Abandoned, Failed, Tri-tone).', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'ConnectStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The phone number/email/sms that was attempted.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'ContactDevice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The device sub-type when contact was attempted (Home, Work, Cell, Other).', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'ContactDeviceSubType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The device type when contact was attempted (Phone, Email, SMS).', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'ContactDeviceType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user name or service that generated this record.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The PK for the debtor record for this contact attempt.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Best available identification of local time for debtor when call handled.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DebtorLocalTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The seq value for the debtor on the account for the phone number dialed.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DebtorSeq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Id from dialer to identify the attempt record.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DialerAttemptId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DialerInstanceCode.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DialerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Unique Identity.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DialerContactAttemptId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Disposition as selected by the dialer collector/agent if interaction, or automatically set by dialer if no agent.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DialerCRC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialer agent who handled the call, null if none.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'DialerUser'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Duration does not include post call wrap up time.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'Duration'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Boolean indicating if an agent handled the contact or not.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'IsAgentHandled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Boolean indicating if the phone number was invalid.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'IsBadPhoneNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Boolean indicating if the call was part of an IVR campaign.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'IsIVRRecord'
GO
EXEC sp_addextendedproperty N'MS_Description', N'True/False if a payment was taken or arrangement established during the contact.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'IsPaymentTaken'
GO
EXEC sp_addextendedproperty N'MS_Description', N'True/False if right party contact made.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'IsRightPartyContact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user who handled the call, null if none.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'LatitudeUser'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dialer list name/id used when generating outbound campaigns/sub-campaigns/calls.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'ListId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of a payment taken during the contact.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'PaymentAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude result generated based on DialerCRC if applicable.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'Result'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the file/table/view that provided the data for this record.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'ResultsSourceName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UTC value for the AttemptDateTime.', 'SCHEMA', N'dbo', 'TABLE', N'DialerContactAttempt', 'COLUMN', N'UTCAttemptDateTime'
GO
