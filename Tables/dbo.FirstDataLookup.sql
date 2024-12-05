CREATE TABLE [dbo].[FirstDataLookup]
(
[LatCust] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ALCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankID] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AgencyName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeePercent] [numeric] (5, 0) NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstDataLookup] ADD CONSTRAINT [PK_FirstDataLookup] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndALCode] ON [dbo].[FirstDataLookup] ([ALCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndLatCust] ON [dbo].[FirstDataLookup] ([LatCust]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
