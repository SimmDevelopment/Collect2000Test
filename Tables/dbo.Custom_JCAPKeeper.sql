CREATE TABLE [dbo].[Custom_JCAPKeeper]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NOT NULL,
[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_JCAPKeeper] ADD CONSTRAINT [PK__Custom_JCAPKeepe__3D8B6A60] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
