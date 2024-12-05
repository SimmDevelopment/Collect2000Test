CREATE TABLE [dbo].[CultureInfo]
(
[LocaleID] [smallint] NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NativeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LanguageISO2] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LanguageISO3] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegionCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CultureInfo] ADD CONSTRAINT [pk_CultureInfo] PRIMARY KEY CLUSTERED ([LocaleID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_CultureInfo_Code] ON [dbo].[CultureInfo] ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used for language translation', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Windows culture code (customer.CultureCode can be set to this to set the culture of the customer to display alternate currencies)', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Data', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The 2 character ISO code of the culture', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'LanguageISO2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The 3 character ISO code of the culture', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'LanguageISO3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Windows locale ID of the culture', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'LocaleID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'LocaleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The English name of the culture', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The native name of the culture', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'NativeName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The region of the culture (RegionInfo.Code)', 'SCHEMA', N'dbo', 'TABLE', N'CultureInfo', 'COLUMN', N'RegionCode'
GO
