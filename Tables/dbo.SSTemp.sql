CREATE TABLE [dbo].[SSTemp]
(
[SSName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[SysMonth] [tinyint] NULL,
[SysYear] [smallint] NULL,
[NumberPlaced] [int] NULL,
[GrossDollarsPlaced] [money] NULL,
[NetDollarsPlaced] [money] NULL,
[Adjustments] [money] NULL,
[GTCollections] [money] NULL,
[GTFees] [money] NULL,
[TMCollections] [money] NULL,
[TMFees] [money] NULL,
[TMPDCs] [money] NULL,
[Collections1] [money] NULL,
[Collections2] [money] NULL,
[Collections3] [money] NULL,
[Collections4] [money] NULL,
[Collections5] [money] NULL,
[Collections6] [money] NULL,
[Collections7] [money] NULL,
[Collections8] [money] NULL,
[Collections9] [money] NULL,
[Collections10] [money] NULL,
[Collections11] [money] NULL,
[Collections12] [money] NULL,
[Collections13] [money] NULL,
[Collections14] [money] NULL,
[Collections15] [money] NULL,
[Collections16] [money] NULL,
[Collections17] [money] NULL,
[Collections18] [money] NULL,
[Collections19] [money] NULL,
[Collections20] [money] NULL,
[Collections21] [money] NULL,
[Collections22] [money] NULL,
[Collections23] [money] NULL,
[Collections24] [money] NULL,
[Collections25] [money] NULL,
[CumCol1] [money] NULL,
[CumCol2] [money] NULL,
[CumCol3] [money] NULL,
[CumCol4] [money] NULL,
[CumCol5] [money] NULL,
[CumCol6] [money] NULL,
[CumCol7] [money] NULL,
[CumCol8] [money] NULL,
[CumCol9] [money] NULL,
[CumCol10] [money] NULL,
[CumCol11] [money] NULL,
[CumCol12] [money] NULL,
[CumCol13] [money] NULL,
[CumCol14] [money] NULL,
[CumCol15] [money] NULL,
[CumCol16] [money] NULL,
[CumCol17] [money] NULL,
[CumCol18] [money] NULL,
[CumCol19] [money] NULL,
[CumCol20] [money] NULL,
[CumCol21] [money] NULL,
[CumCol22] [money] NULL,
[CumCol23] [money] NULL,
[CumCol24] [money] NULL,
[CumCol25] [money] NULL,
[Pct1] [real] NULL,
[Pct2] [real] NULL,
[Pct3] [real] NULL,
[Pct4] [real] NULL,
[Pct5] [real] NULL,
[Pct6] [real] NULL,
[Pct7] [real] NULL,
[Pct8] [real] NULL,
[Pct9] [real] NULL,
[Pct10] [real] NULL,
[Pct11] [real] NULL,
[Pct12] [real] NULL,
[Pct13] [real] NULL,
[Pct14] [real] NULL,
[Pct15] [real] NULL,
[Pct16] [real] NULL,
[Pct17] [real] NULL,
[Pct18] [real] NULL,
[Pct19] [real] NULL,
[Pct20] [real] NULL,
[Pct21] [real] NULL,
[Pct22] [real] NULL,
[Pct23] [real] NULL,
[Pct24] [real] NULL,
[Pct25] [real] NULL,
[CumPct1] [real] NULL,
[CumPct2] [real] NULL,
[CumPct3] [real] NULL,
[CumPct4] [real] NULL,
[CumPct5] [real] NULL,
[CumPct6] [real] NULL,
[CumPct7] [real] NULL,
[CumPct8] [real] NULL,
[CumPct9] [real] NULL,
[CumPct10] [real] NULL,
[CumPct11] [real] NULL,
[CumPct12] [real] NULL,
[CumPct13] [real] NULL,
[CumPct14] [real] NULL,
[CumPct15] [real] NULL,
[CumPct16] [real] NULL,
[CumPct17] [real] NULL,
[CumPct18] [real] NULL,
[CumPct19] [real] NULL,
[CumPct20] [real] NULL,
[CumPct21] [real] NULL,
[CumPct22] [real] NULL,
[CumPct23] [real] NULL,
[CumPct24] [real] NULL,
[CumPct25] [real] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_SSTemp1] ON [dbo].[SSTemp] ([SSName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO