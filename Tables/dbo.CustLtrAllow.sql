CREATE TABLE [dbo].[CustLtrAllow]
(
[CustCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LtrCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyCustomer] [bit] NOT NULL CONSTRAINT [DF_CustLtrAllow_CopyCustomer] DEFAULT (0),
[SaveImage] [bit] NOT NULL CONSTRAINT [DF_CustLtrAllow_SaveImage] DEFAULT (0)
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_CustLtrAllow_CustCode_LtrCode] ON [dbo].[CustLtrAllow] ([CustCode], [LtrCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table controls which letters are allowed to be generated for a given Customer.', 'SCHEMA', N'dbo', 'TABLE', N'CustLtrAllow', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Allows Customer to be copied on letter', 'SCHEMA', N'dbo', 'TABLE', N'CustLtrAllow', 'COLUMN', N'CopyCustomer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'CustLtrAllow', 'COLUMN', N'CustCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter Code Allowed', 'SCHEMA', N'dbo', 'TABLE', N'CustLtrAllow', 'COLUMN', N'LtrCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Allows image of letter to be saved', 'SCHEMA', N'dbo', 'TABLE', N'CustLtrAllow', 'COLUMN', N'SaveImage'
GO
