CREATE TABLE [dbo].[PMethod]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PayMethod] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Surcharge] [money] NULL,
[SurchargePercent] [real] NULL,
[IsPostDateType] [bit] NULL,
[InvoiceHoldDays] [tinyint] NULL,
[NITDLetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalcSurchargeFromGross] [bit] NOT NULL CONSTRAINT [def_PMethod_CalcSurchargeFromGross] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PMethod] ADD CONSTRAINT [PK_PMethod] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'PMethod', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PMethod', 'COLUMN', N'IsPostDateType'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'PMethod', 'COLUMN', N'PayMethod'
GO
