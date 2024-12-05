CREATE TABLE [dbo].[RegionInfo]
(
[Code] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ISO3] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NativeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyNativeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyISO3] [nchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencySymbol] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RegionInfo] ADD CONSTRAINT [pk_RegionInfo] PRIMARY KEY CLUSTERED ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RegionInfo] ADD CONSTRAINT [uq_RegionInfo_ISO3] UNIQUE NONCLUSTERED ([ISO3]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'RegionInfo', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'RegionInfo', 'COLUMN', N'Code'
GO
