CREATE TABLE [dbo].[Custom_HSBC_HowClose]
(
[HCID] [int] NOT NULL IDENTITY(1, 1),
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_HSBC_HowClose] ADD CONSTRAINT [PK_Custom_HSBC_HowClose] PRIMARY KEY CLUSTERED ([HCID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
