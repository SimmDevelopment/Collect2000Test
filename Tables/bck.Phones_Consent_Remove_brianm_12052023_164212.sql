CREATE TABLE [bck].[Phones_Consent_Remove_brianm_12052023_164212]
(
[historyid] [int] NOT NULL,
[PhonesConsentId] [int] NOT NULL,
[MasterPhoneId] [int] NOT NULL,
[AllowManualCall] [bit] NULL,
[AllowAutoDialer] [bit] NULL,
[AllowFax] [bit] NULL,
[AllowText] [bit] NULL,
[WrittenConsent] [bit] NOT NULL,
[ObtainedFrom] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DocumentationId] [int] NULL,
[UserId] [int] NULL,
[EffectiveDate] [datetime2] NOT NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaveGroupId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
