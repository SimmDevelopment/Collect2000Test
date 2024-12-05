CREATE TABLE [dbo].[Services_FirstData_FastBatch_AdditionalData]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[OutputDwellingUnits] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenderCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LengthofResidence] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReservedforFutureUse] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PremiumResultCodes] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_AdditionalData] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_AdditionalData] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
