CREATE TABLE [dbo].[ScheduledPaymentCount]
(
[ScheduledPaymentCountID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[Link] [int] NULL,
[LinkDriver] [bit] NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PPA] [int] NULL,
[PDC] [int] NULL,
[PCC] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScheduledPaymentCount] ADD CONSTRAINT [PK_ScheduledPaymentCount] PRIMARY KEY CLUSTERED ([ScheduledPaymentCountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ScheduledPaymentCount_AccountID] ON [dbo].[ScheduledPaymentCount] ([AccountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ScheduledPaymentCount_Link_LinkDriver_Status] ON [dbo].[ScheduledPaymentCount] ([Link], [LinkDriver], [Status]) ON [PRIMARY]
GO
