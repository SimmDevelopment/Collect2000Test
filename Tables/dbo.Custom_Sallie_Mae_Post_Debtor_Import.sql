CREATE TABLE [dbo].[Custom_Sallie_Mae_Post_Debtor_Import]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[RecordID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARACID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENCIN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENSSN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARRELTYPID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENLNM] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENFNM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENMNM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENBTHDTE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENADR] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENUNT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENCTY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENST] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENZIP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENCNTRY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENADR3] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENADR4] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZZENADRFLAG] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZRENEMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENEMFL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENNUMDEBTS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENCITIENCD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENSEPDTE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENENTERMBEGIN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENENTERMEND] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENBNKRPT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENLANG] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARRELCONLVL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARRELLASTCTCDTE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENDECEASED] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENDISABLED] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENSCRAIDARSCRAACTIVE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENSCRAIDARSCRAENDDTE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARENSCRAIDARSCRASTARTDTE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATFIRM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATFNM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATLNM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATSPEC] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATADR] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATADR2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATCTY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATST] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATZIP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATPH] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATEMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATCONFNM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARATCONLNM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Sallie_Mae_Post_Debtor_Import] ADD CONSTRAINT [PK_Custom_Sallie_Mae_Post_Debtor_Import] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
