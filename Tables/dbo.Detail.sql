CREATE TABLE [dbo].[Detail]
(
[number] [int] NULL,
[TransDate] [datetime] NULL,
[TransRef] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransInvoice] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDesc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qty] [int] NULL,
[Cost] [money] NULL,
[Misc] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Returned] [datetime] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Detail1] ON [dbo].[Detail] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
