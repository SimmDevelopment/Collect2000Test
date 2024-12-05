CREATE TABLE [dbo].[Goals_CompanyCustomer]
(
[GoalsCompanyID] [uniqueidentifier] NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Goals_CompanyCustomer] ADD CONSTRAINT [FK_Goals_CompanyCustomer_Customer] FOREIGN KEY ([Customer]) REFERENCES [dbo].[Customer] ([customer])
GO
ALTER TABLE [dbo].[Goals_CompanyCustomer] ADD CONSTRAINT [FK_Goals_CompanyCustomer_Goals_Company] FOREIGN KEY ([GoalsCompanyID]) REFERENCES [dbo].[Goals_Company] ([GoalsCompanyID])
GO
