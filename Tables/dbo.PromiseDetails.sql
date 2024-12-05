CREATE TABLE [dbo].[PromiseDetails]
(
[PromiseID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[Amount] [money] NOT NULL,
[Surcharge] [money] NOT NULL,
[Settlement] [bit] NOT NULL,
[ProjectedCurrent] [money] NOT NULL,
[ProjectedRemaining] [money] NOT NULL,
[ProjectedFee] [money] NULL,
[ProjectedCollectorFee] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PromiseDetails] ADD CONSTRAINT [pk_PromiseDetails] PRIMARY KEY NONCLUSTERED ([PromiseID], [AccountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PromiseDetails_AccountID] ON [dbo].[PromiseDetails] ([AccountID]) ON [PRIMARY]
GO
