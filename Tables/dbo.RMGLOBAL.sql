CREATE TABLE [dbo].[RMGLOBAL]
(
[SelectKey] [char] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Number] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RM_Number] ON [dbo].[RMGLOBAL] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RM_SelectKey] ON [dbo].[RMGLOBAL] ([SelectKey]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
