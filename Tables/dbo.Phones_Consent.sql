CREATE TABLE [dbo].[Phones_Consent]
(
[PhonesConsentId] [int] NOT NULL IDENTITY(1, 1),
[MasterPhoneId] [int] NOT NULL,
[AllowManualCall] [bit] NULL,
[AllowAutoDialer] [bit] NULL,
[AllowFax] [bit] NULL,
[AllowText] [bit] NULL,
[WrittenConsent] [bit] NOT NULL CONSTRAINT [def_Phones_Consent_WrittenConsent] DEFAULT ((0)),
[ObtainedFrom] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DocumentationId] [int] NULL,
[UserId] [int] NULL,
[EffectiveDate] [datetime2] NOT NULL CONSTRAINT [def_Phones_Consent_Created] DEFAULT (sysutcdatetime()),
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaveGroupId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Consent] ADD CONSTRAINT [pk_Phones_Consent] PRIMARY KEY NONCLUSTERED ([PhonesConsentId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Phones_Consent_masterphoneid] ON [dbo].[Phones_Consent] ([MasterPhoneId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Consent] ADD CONSTRAINT [fk_Phones_Consent_Phones_Master] FOREIGN KEY ([MasterPhoneId]) REFERENCES [dbo].[Phones_Master] ([MasterPhoneID])
GO
ALTER TABLE [dbo].[Phones_Consent] ADD CONSTRAINT [fk_Phones_Consent_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates that the contact consented to having this phone number dialed in a campaign using an auto-dialer.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'AllowAutoDialer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates that the contact consented to receiving faxed documents at this phone number.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'AllowFax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates that the contact consented to being called at this phone number.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'AllowManualCall'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates that the contact consented to receiving SMS/MSM messages at this phone number.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'AllowText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Comment provided while adding/editing phone consent information.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the documentation for the consent.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'DocumentationId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date/time in UTC at which the consent information was updated.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'EffectiveDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the phone record in the dbo.Phones_Master table.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'MasterPhoneId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The individual giving consent.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'ObtainedFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity field of the table.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'PhonesConsentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the Latitude user who entered the consent information.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'UserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates that the contact consented in writing.', 'SCHEMA', N'dbo', 'TABLE', N'Phones_Consent', 'COLUMN', N'WrittenConsent'
GO
