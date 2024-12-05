CREATE TABLE [dbo].[MidlandAcks]
(
[Number] [int] NOT NULL,
[Transmitted] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MidlandAcks] ADD CONSTRAINT [PK_MidlandAcks] PRIMARY KEY CLUSTERED ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
