CREATE TABLE [dbo].[Zipcodes]
(
[DETAIL_CD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP_CODE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITYSTKEY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP_CLASS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITYSTNAME] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITYABBREV] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FAC_CD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAILNAME] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LLCITYKEY] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LL_CITY] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITYDELV] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRRTMAIL] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNIQZIP] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIN_NO] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIPS] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAT] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LNG] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AREACODE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[T_Z] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ELEVATION] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PERNS_HOUS] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POP_1990] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AREA_SQ_MI] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HOUSEHOLDS] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WHITE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLACK] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HISPANIC] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INCOM_HHLD] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HOUSE_VAL] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ZipCodes_AreaCode_TimeZone] ON [dbo].[Zipcodes] ([AREACODE]) INCLUDE ([STATE], [T_Z]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_Zipcodes] ON [dbo].[Zipcodes] ([ZIP_CODE]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ZipCodes_ZipCode_TimeZone] ON [dbo].[Zipcodes] ([ZIP_CODE]) INCLUDE ([STATE], [T_Z]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Zipcodes', 'COLUMN', N'CITYSTKEY'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Zipcodes', 'COLUMN', N'ZIP_CODE'
GO
