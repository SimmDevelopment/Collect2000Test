CREATE TABLE [dbo].[MidCustMaint]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeePercent] [money] NOT NULL,
[ForwarderId] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MidCustMaint] ADD CONSTRAINT [PK_MidCustMaint] PRIMARY KEY CLUSTERED ([Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
