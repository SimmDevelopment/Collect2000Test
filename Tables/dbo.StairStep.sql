CREATE TABLE [dbo].[StairStep]
(
[customer] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSYear] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSMonth] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberPlaced] [money] NOT NULL,
[GrossDollarsPlaced] [money] NOT NULL,
[NetDollarsPlaced] [money] NOT NULL,
[Adjustments] [money] NOT NULL,
[GTcollections] [money] NOT NULL,
[GTfees] [money] NOT NULL,
[TMcollections] [money] NOT NULL,
[TMfees] [money] NOT NULL,
[LMcollections] [money] NOT NULL,
[LMfees] [money] NOT NULL,
[Month1] [money] NOT NULL,
[Month2] [money] NOT NULL,
[Month3] [money] NOT NULL,
[Month4] [money] NOT NULL,
[Month5] [money] NOT NULL,
[Month6] [money] NOT NULL,
[Month7] [money] NOT NULL,
[Month8] [money] NOT NULL,
[Month9] [money] NOT NULL,
[Month10] [money] NOT NULL,
[Month11] [money] NOT NULL,
[Month12] [money] NOT NULL,
[Month13] [money] NOT NULL,
[Month14] [money] NOT NULL,
[Month15] [money] NOT NULL,
[Month16] [money] NOT NULL,
[Month17] [money] NOT NULL,
[Month18] [money] NOT NULL,
[Month19] [money] NOT NULL,
[Month20] [money] NOT NULL,
[Month21] [money] NOT NULL,
[Month22] [money] NOT NULL,
[Month23] [money] NOT NULL,
[Month24] [money] NOT NULL,
[Month99] [money] NOT NULL,
[pct1a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct2a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct3a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct4a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct5a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct6a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct7a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct8a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct9a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct10a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct11a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct12A] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct99a] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pct1c] [real] NULL,
[pct2c] [real] NULL,
[pct3c] [real] NULL,
[pct4c] [real] NULL,
[pct5c] [real] NULL,
[pct6c] [real] NULL,
[pct7c] [real] NULL,
[pct8c] [real] NULL,
[pct9c] [real] NULL,
[pct10c] [real] NULL,
[pct11c] [real] NULL,
[pct12c] [real] NULL,
[pct99c] [real] NULL,
[Yeild] [real] NULL,
[PDCDollars] [money] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StairStep_customer] ON [dbo].[StairStep] ([customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StairStep_SSYear_SSMonth] ON [dbo].[StairStep] ([SSYear], [SSMonth]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO