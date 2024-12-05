CREATE TABLE [dbo].[Midland_Daily_A102]
(
[Number] [int] NOT NULL,
[Datestamp] [datetime] NOT NULL,
[TypeTable] [int] NOT NULL,
[TableUID] [int] NOT NULL,
[Amount] [money] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Midland_Daily_A102] ADD CONSTRAINT [PK_Midland_Daily_A102] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
