CREATE TABLE [dbo].[Custom_SMSDeactivation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhoneNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Carrier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewCarrier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeactivationDate] [date] NULL,
[CreatedOn] [date] NULL,
[UniqueID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SMSDeactivation] ADD CONSTRAINT [PK_Custom_SMSDeactivation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
