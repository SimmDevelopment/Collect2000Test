CREATE TABLE [dbo].[Custom_Equabli_RankScore_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliPartnerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[servicingIntensityBucket] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[maximumDiscount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scoreDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority1Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority2Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority3Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority1Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority2Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rankUniqueId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_RankScore_Info] ADD CONSTRAINT [PK_Custom_Equabli_RankScore_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
