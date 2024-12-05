CREATE TABLE [dbo].[DialerInstanceSetting]
(
[dialinstset_key] [int] NOT NULL IDENTITY(1, 1),
[DialerInstanceUID] [int] NULL,
[SettingName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DialerIns__DataT__0E1F7BBC] DEFAULT ('UN'),
[Precedence] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DialerIns__Prece__0F139FF5] DEFAULT ('DF'),
[IntegerValue] [int] NOT NULL CONSTRAINT [DF__DialerIns__Integ__1007C42E] DEFAULT ((0)),
[StringValue] [varchar] (504) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerInstanceSetting] ADD CONSTRAINT [CK_DialerInstanceSetting_DataType] CHECK (([DataType]='UN' OR [DataType]='IN' OR [DataType]='BI' OR [DataType]='BL' OR [DataType]='DT' OR [DataType]='FL' OR [DataType]='ST'))
GO
ALTER TABLE [dbo].[DialerInstanceSetting] ADD CONSTRAINT [PK_DialerInstanceSetting] PRIMARY KEY CLUSTERED ([dialinstset_key]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerInstanceSetting] ADD CONSTRAINT [UQ_DialerInstanceSetting_Name] UNIQUE NONCLUSTERED ([DialerInstanceUID], [SettingName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerInstanceSetting] ADD CONSTRAINT [FK_DialerInstanceSetting_Parent] FOREIGN KEY ([DialerInstanceUID]) REFERENCES [dbo].[DialerInstance] ([UID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'DataType of setting: BL=Boolean; IN=Integer; BI=Big Integer; FL=Floating Point; DT=Date; ST=String; UN=indetermined', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceSetting', 'COLUMN', N'DataType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to DialerInstance table', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceSetting', 'COLUMN', N'DialerInstanceUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity value used as primary key.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceSetting', 'COLUMN', N'dialinstset_key'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value of anything that can be represented as an integer (datatypes BL,IN)', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceSetting', 'COLUMN', N'IntegerValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OV=use value in this table regardless of valid, DF=use the value in this table if its valid, CF=use value in config file if exists', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceSetting', 'COLUMN', N'Precedence'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name for this particular setting', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceSetting', 'COLUMN', N'SettingName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value of anything that cannot be represented as an integer (all exc BL,IN)', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceSetting', 'COLUMN', N'StringValue'
GO
