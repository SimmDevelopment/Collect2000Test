CREATE TABLE [dbo].[Custom_USBank_CACS_SIF_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [datetime] NULL,
[SettlementAmount] [money] NULL,
[ProjectedEndDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_USBank_CACS_SIF_History] ADD CONSTRAINT [PK_Custom_USBank_CACS_SIF_History] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
