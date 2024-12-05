CREATE TABLE [dbo].[AIM_CustomPaymentType]
(
[CustomPaymentTypeID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LatitudeCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bucket] [int] NULL,
[IsSystem] [bit] NOT NULL CONSTRAINT [DF__AIM_Custo__IsSys__0B430F11] DEFAULT ((0)),
[LegalLedgerTypeID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_CustomPaymentType] ADD CONSTRAINT [PK_AIM_CustomPaymentType] PRIMARY KEY CLUSTERED ([CustomPaymentTypeID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CustomPaymentType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CustomPaymentType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CustomPaymentType', 'COLUMN', N'CustomPaymentTypeID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Data', 'SCHEMA', N'dbo', 'TABLE', N'AIM_CustomPaymentType', 'COLUMN', N'LatitudeCode'
GO
