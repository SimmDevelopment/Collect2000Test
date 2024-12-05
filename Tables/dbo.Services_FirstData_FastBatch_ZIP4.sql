CREATE TABLE [dbo].[Services_FirstData_FastBatch_ZIP4]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[ZIP4Urbanization] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4StandardizedDeliveryAddress] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4StandardizedOptionalAddress] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4StandardizedCity] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4StandardizedState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP45DigitZIPCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP44DigitAddOnCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4DeliveryPointCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4CarrierRoute] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4MatchLevel] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4Footnotes] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4RecordType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4CountyCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4DwellingUnits] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4LACSIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP4PMB] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPVTMReturnCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPVTMFootnotes] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EWSIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_ZIP4] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_ZIP4] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
