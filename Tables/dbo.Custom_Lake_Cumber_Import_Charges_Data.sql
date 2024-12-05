CREATE TABLE [dbo].[Custom_Lake_Cumber_Import_Charges_Data]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientMRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParrentLineItemNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseIDNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeTransDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeCPTHPSCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeProcDescript] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalChargeAmt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentBalDueforCharge] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentRespPartyCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeUnits] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeRevenueCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeMod1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeMod2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeMod3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeMod4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeDiagCode1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeDiagCode2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeDiagCode3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeDiagCode4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntFacilityName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargePhysicianFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargePhysicianLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargePhsicianMiddle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargePhysicianSuffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Lake_Cumber_Import_Charges_Data] ADD CONSTRAINT [PK_Custom_Lake_Cumber_Import_Charges_Data] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
