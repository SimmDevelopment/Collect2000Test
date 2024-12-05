CREATE TABLE [dbo].[Receiver_CustomerLookup]
(
[CustomerLookupID] [int] NOT NULL IDENTITY(1, 1),
[AgencyCustomer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientCustomer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientId] [int] NULL
) ON [PRIMARY]
GO
