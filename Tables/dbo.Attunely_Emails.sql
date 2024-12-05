CREATE TABLE [dbo].[Attunely_Emails]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SentTime] [datetime2] NOT NULL,
[DestinationAddress] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VariationKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryStatus_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstOpenTime] [datetime2] NULL,
[FirstClickTime] [datetime2] NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Emails] ADD CONSTRAINT [PK_Attunely_Emails] PRIMARY KEY CLUSTERED ([AccountKey], [EventKey]) ON [PRIMARY]
GO
