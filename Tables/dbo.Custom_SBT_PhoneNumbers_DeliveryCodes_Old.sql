CREATE TABLE [dbo].[Custom_SBT_PhoneNumbers_DeliveryCodes_Old]
(
[Phone_Number] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Delivery_Status] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Delivery_Date] [datetime] NOT NULL,
[Note_Added] [int] NULL
) ON [PRIMARY]
GO
