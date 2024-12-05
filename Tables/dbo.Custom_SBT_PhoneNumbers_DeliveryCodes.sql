CREATE TABLE [dbo].[Custom_SBT_PhoneNumbers_DeliveryCodes]
(
[Phone_Number] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Delivery_Status] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Delivery_Date] [datetime] NOT NULL,
[Note_Added] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SBT_PhoneNumbers_DeliveryCodes] ADD CONSTRAINT [PK__Custom_S__45EA31F65CA02EE7] PRIMARY KEY CLUSTERED ([Phone_Number], [Delivery_Status], [Delivery_Date]) ON [PRIMARY]
GO
