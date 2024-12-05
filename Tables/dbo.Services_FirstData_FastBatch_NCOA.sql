CREATE TABLE [dbo].[Services_FirstData_FastBatch_NCOA]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[NCOAFootnotes] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOAUrbanization] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOAAddress] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOACity] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOAState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOA5DigitZIPCodeTM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOA4DigitAddOnCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOADeliveryPointCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOAMoveType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOAMoveEffectiveDateCCYYMM] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOACarrierRoute] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOACountyCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DirectMarketingAssociationDMASuppressionCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOAMatchRangeFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReservedForFutureUse] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstDatause] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberofNeighborsRequested] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberofMultiplesRequested] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_NCOA] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_NCOA] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
