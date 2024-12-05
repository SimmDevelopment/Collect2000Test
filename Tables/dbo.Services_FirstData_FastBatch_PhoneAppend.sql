CREATE TABLE [dbo].[Services_FirstData_FastBatch_PhoneAppend]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[PhoneAppendLevelofMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleResponseCount] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AppendedPhoneNumberSource] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneAppendVerificationCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DALevelofMatchCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOAOriginalInputAddressPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_PhoneAppend] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_PhoneAppend] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
