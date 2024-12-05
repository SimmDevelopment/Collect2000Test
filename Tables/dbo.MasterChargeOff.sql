CREATE TABLE [dbo].[MasterChargeOff]
(
[MasterChargeOffID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NOT NULL,
[ChargeOffAmount] [money] NOT NULL,
[PaymentHistoryProfile] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentHistoryDate] [datetime] NULL,
[HighestCredit] [money] NULL,
[CreditLimit] [money] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__MasterCha__Creat__327CD7C3] DEFAULT (getdate()),
[SecondaryAgencyIdenitifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondaryAccountNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MortgageIdentificationNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TermsDuration] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClosedDate] [datetime] NULL,
[ChargeOffStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MasterChargeOff_Status] DEFAULT ('97'),
[SpecialComment] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ComplianceCondition] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MasterChargeOff] ADD CONSTRAINT [CHK_MasterChargeOff_ComplianceCondition] CHECK (([ComplianceCondition]=case  when [ComplianceCondition]='XR' OR [ComplianceCondition]='XJ' OR [ComplianceCondition]='XH' OR [ComplianceCondition]='XG' OR [ComplianceCondition]='XF' OR [ComplianceCondition]='XE' OR [ComplianceCondition]='XD' OR [ComplianceCondition]='XC' OR [ComplianceCondition]='XB' OR [ComplianceCondition]='XA' OR [ComplianceCondition]=' ' then [ComplianceCondition] end))
GO
ALTER TABLE [dbo].[MasterChargeOff] ADD CONSTRAINT [CHK_MasterChargeOff_SecondaryAgencyIdenitifier] CHECK (([SecondaryAccountNumber]=case  when [SecondaryAgencyIdenitifier]='00' then '' else [SecondaryAccountNumber] end))
GO
ALTER TABLE [dbo].[MasterChargeOff] ADD CONSTRAINT [CHK_MasterChargeOff_SpecialComment] CHECK (([SpecialComment]=case when [SpecialComment]='CS' OR [SpecialComment]='CO' OR [SpecialComment]='CN' OR [SpecialComment]='CM' OR [SpecialComment]='CL' OR [SpecialComment]='CK' OR [SpecialComment]='CJ' OR [SpecialComment]='CI' OR [SpecialComment]='CH' OR [SpecialComment]='BT' OR [SpecialComment]='BS' OR [SpecialComment]='BP' OR [SpecialComment]='BO' OR [SpecialComment]='BN' OR [SpecialComment]='BL' OR [SpecialComment]='BK' OR [SpecialComment]='BJ' OR [SpecialComment]='BI' OR [SpecialComment]='BH' OR [SpecialComment]='BG' OR [SpecialComment]='BF' OR [SpecialComment]='BE' OR [SpecialComment]='BD' OR [SpecialComment]='BC' OR [SpecialComment]='BB' OR [SpecialComment]='BA' OR [SpecialComment]='AZ' OR [SpecialComment]='AX' OR [SpecialComment]='AW' OR [SpecialComment]='AV' OR [SpecialComment]='AU' OR [SpecialComment]='AT' OR [SpecialComment]='AS' OR [SpecialComment]='AP' OR [SpecialComment]='AO' OR [SpecialComment]='AN' OR [SpecialComment]='AM' OR [SpecialComment]='AL' OR [SpecialComment]='AJ' OR [SpecialComment]='AI' OR [SpecialComment]='AH' OR [SpecialComment]='AG' OR [SpecialComment]='AC' OR [SpecialComment]='AB' OR [SpecialComment]='V' OR [SpecialComment]='S' OR [SpecialComment]='O' OR [SpecialComment]='M' OR [SpecialComment]='I' OR [SpecialComment]='H' OR [SpecialComment]='C' OR [SpecialComment]='B' OR [SpecialComment]=' ' then [SpecialComment]  end))
GO
ALTER TABLE [dbo].[MasterChargeOff] ADD CONSTRAINT [PK_MasterChargeOff] PRIMARY KEY CLUSTERED ([MasterChargeOffID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_MasterChargeOff] ON [dbo].[MasterChargeOff] ([number]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MasterChargeOff] ADD CONSTRAINT [FK_MasterChargeOff_Master] FOREIGN KEY ([number]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'1st party Static ChargeOffStatus Code', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'ChargeOffStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the date that a first party charged off account was closed to further purchases', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'ClosedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1st party compliance condition code to be loaded as an initial override', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'ComplianceCondition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Identity Key Value.', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'MasterChargeOffID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The MIN indicates that the loan is registered with the Mortgage Electronic Registration Systems, Inc. (MERS), the electronic registry for tracking the ownership of mortgage rights.', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'MortgageIdentificationNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the account number as assigned by the secondary marketing agency. If SecondaryAgencyIdenitifier  = 00, this field should be blank filled.', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'SecondaryAccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains a code indicating which secondary marketing agency has interest in this loan. Values available: 00 = Agency Identifier not applicable (Used when reporting MIN only) 01 = Fannie Mae 02 = Freddie Mac', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'SecondaryAgencyIdenitifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1st party special comment code to be loaded as an initial override', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'SpecialComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the duration of credit extended (Leading zeroes for numeric values). Line of Credit = Constant of LOC. Installment = Number of months. Mortgage = Number of years. Open = Constant of 001. One payment as scheduled Revolving = Constant of REV', 'SCHEMA', N'dbo', 'TABLE', N'MasterChargeOff', 'COLUMN', N'TermsDuration'
GO
