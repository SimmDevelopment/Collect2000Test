CREATE TABLE [dbo].[Services_FirstData_FastBatch_Main]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[InputName] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputUrbanization] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputDeliveryAddress] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputOptionalAddress] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputCity] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputZIPCodeTM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputPhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputSSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserReferenceArea] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondaryUserReferenceArea] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnPremium1ResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnPremium2ResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnPremium3ResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnPremium4ResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnPremium5ResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP41ResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOA2ResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reservedforfutureuse] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeighborResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DAResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameAddressVerificationResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameAddressAppendResultCodePhoneSearch] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPVTMResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativesResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressHistoryResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSNSearchResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociatesResultCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_Main] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_Main] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
