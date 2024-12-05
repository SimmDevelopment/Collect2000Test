CREATE TABLE [dbo].[Auto_AuctionAppraisal]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[AppraiserCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AverageValue] [money] NULL,
[RetailValue] [money] NULL,
[AppraisalSourcePublication] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AppraisalReceivedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_AuctionAppraisal] ADD CONSTRAINT [PK__Auto_AuctionAppraisal] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Auto_AuctionAppraisal] ON [dbo].[Auto_AuctionAppraisal] ([AccountID]) ON [PRIMARY]
GO
