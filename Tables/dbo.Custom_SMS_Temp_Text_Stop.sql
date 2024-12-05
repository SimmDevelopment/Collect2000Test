CREATE TABLE [dbo].[Custom_SMS_Temp_Text_Stop]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModeOfCommunication] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageCategory] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageSubCategory] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeStamp] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryStatus] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryStatusID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UniqueID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionTicket] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TemplateID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrgCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SMS_Temp_Text_Stop] ADD CONSTRAINT [PK_Custom_SMS_Temp_Text_Stop] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
