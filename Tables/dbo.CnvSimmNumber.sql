CREATE TABLE [dbo].[CnvSimmNumber]
(
[SimmAcctno] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SimmDbtrno] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Number] [int] NOT NULL IDENTITY(1, 1),
[DebtorID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CnvSimmNumber] ADD CONSTRAINT [Pk_SimmNumber] PRIMARY KEY CLUSTERED ([SimmAcctno]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Ix_SimmNumber] ON [dbo].[CnvSimmNumber] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
