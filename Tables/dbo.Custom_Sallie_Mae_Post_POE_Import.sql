CREATE TABLE [dbo].[Custom_Sallie_Mae_Post_POE_Import]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[RecordID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENCIN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARRELTYPID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOENAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOEADR1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOEADR2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOECITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOEST] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOEZIP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOEACTIVE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOEBEST] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHPHONEWRK] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHPHONEBUS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOETYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOETITLE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOEHIREDATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPOETERMDATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Sallie_Mae_Post_POE_Import] ADD CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
