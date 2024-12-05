CREATE TABLE [dbo].[Discover_Financial_Codes]
(
[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BatchTypePositive] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BatchTypeNegative] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_Discover_Financial_Codes_Code] ON [dbo].[Discover_Financial_Codes] ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
