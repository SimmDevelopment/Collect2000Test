CREATE TABLE [dbo].[Attunely_BatchMasters]
(
[Id] [uniqueidentifier] NOT NULL,
[AccountStubsReconciled] [int] NOT NULL,
[LastAccountStubDate] [datetime2] NOT NULL,
[AgentsReconciled] [int] NOT NULL,
[LastAgentDate] [datetime2] NOT NULL,
[AttributesReconciled] [int] NOT NULL,
[LastAttributeDate] [datetime2] NOT NULL,
[CallsReconciled] [int] NOT NULL,
[LastCallDate] [datetime2] NOT NULL,
[ContactAddressesReconciled] [int] NOT NULL,
[LastContactAddressDate] [datetime2] NOT NULL,
[ContactEmailsReconciled] [int] NOT NULL,
[LastContactEmailDate] [datetime2] NOT NULL,
[ContactPhonesReconciled] [int] NOT NULL,
[LastContactPhoneDate] [datetime2] NOT NULL,
[DebtsReconciled] [int] NOT NULL,
[LastDebtDate] [datetime2] NOT NULL,
[EmailsReconciled] [int] NOT NULL,
[LastEmailDate] [datetime2] NOT NULL,
[EventsReconciled] [int] NOT NULL,
[LastEventDate] [datetime2] NOT NULL,
[LegalActionsReconciled] [int] NOT NULL,
[LastLegalActionDate] [datetime2] NOT NULL,
[LegalComplaintsReconciled] [int] NOT NULL,
[LastLegalComplaintDate] [datetime2] NOT NULL,
[LettersReconciled] [int] NOT NULL,
[LastLetterDate] [datetime2] NOT NULL,
[MappedCallsReconciled] [int] NOT NULL,
[LastMappedCallDate] [datetime2] NOT NULL,
[ModifiersReconciled] [int] NOT NULL,
[LastModifierDate] [datetime2] NOT NULL,
[PaymentsReconciled] [int] NOT NULL,
[LastPaymentDate] [datetime2] NOT NULL,
[PortfoliosReconciled] [int] NOT NULL,
[LastPortfolioDate] [datetime2] NOT NULL,
[ScheduledPaymentsReconciled] [int] NOT NULL,
[LastScheduledPaymentDate] [datetime2] NOT NULL,
[SmsesReconciled] [int] NOT NULL,
[LastSmsDate] [datetime2] NOT NULL,
[CreatedDate] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_BatchMasters] ADD CONSTRAINT [PK_Attunely_BatchMasters] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
