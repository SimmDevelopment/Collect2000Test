CREATE TABLE [dbo].[Attunely_Smses]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MessageKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SentTime] [datetime2] NOT NULL,
[Direction_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VariationKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryStatus_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyPhoneNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorPhoneNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Smses] ADD CONSTRAINT [PK_Attunely_Smses] PRIMARY KEY CLUSTERED ([AccountKey], [MessageKey]) ON [PRIMARY]
GO
