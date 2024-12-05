CREATE TABLE [dbo].[cbrCustomGroup]
(
[number] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbrCustomGroup] ADD CONSTRAINT [PK_cbrCustomGroup] PRIMARY KEY CLUSTERED ([number]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Any user derived set of accounts in conjunction with the respective procedure parameter cbrCustumGroup that has the respective account number inserted into this table. The evaluation will be limited to only the respective set .', 'SCHEMA', N'dbo', 'TABLE', N'cbrCustomGroup', NULL, NULL
GO
