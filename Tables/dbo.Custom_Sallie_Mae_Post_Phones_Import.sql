CREATE TABLE [dbo].[Custom_Sallie_Mae_Post_Phones_Import]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecordID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZZENCIN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARRELTYPID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHPHONE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHTYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHMAPKEY] [nvarchar] (999) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHWRONG] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHBAD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARPHCEASE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Sallie_Mae_Post_Phones_Import] ADD CONSTRAINT [PK_Custom_Sallie_Mae_Post_Phones_Import] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
