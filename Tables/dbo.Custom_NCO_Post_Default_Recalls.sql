CREATE TABLE [dbo].[Custom_NCO_Post_Default_Recalls]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Recordcode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCOFileNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Forw_File] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Masco_File] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Forw_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Firm_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PCMT] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_NCO_Post_Default_Recalls] ADD CONSTRAINT [PK_Custom_NCO_Post_Default_Recalls] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
