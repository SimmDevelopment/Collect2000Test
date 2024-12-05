CREATE TABLE [dbo].[ServicesCustomers]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ServiceID] [int] NULL,
[CustomerID] [int] NULL,
[MinBalance] [money] NULL,
[ProfileID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServicesCustomers] ADD CONSTRAINT [PK_ServicesCustomers] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Ix_ServicesCustomers_CustomerID] ON [dbo].[ServicesCustomers] ([CustomerID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServicesCustomers] ADD CONSTRAINT [Uq_ServicesCustomers_ServiceID_CustomerID] UNIQUE NONCLUSTERED ([ServiceID], [CustomerID]) ON [PRIMARY]
GO
