CREATE TABLE [dbo].[Custom_AccountList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_AccountList] ADD CONSTRAINT [PK_Custom_AccountList] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
