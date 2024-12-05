CREATE TABLE [dbo].[PhoneContactPreferenceChoiceHistory]
(
[MasterPhoneId] [int] NOT NULL,
[SaveGroupId] [uniqueidentifier] NOT NULL,
[ContactPreferenceChoiceCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CanCall] [bit] NOT NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF__PhoneCont__Creat__11D0DC66] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PhoneContactPreferenceChoiceHistory] ON [dbo].[PhoneContactPreferenceChoiceHistory] ([MasterPhoneId], [CreatedWhen]) INCLUDE ([SaveGroupId], [ContactPreferenceChoiceCode], [CanCall], [CreatedBy]) ON [PRIMARY]
GO
