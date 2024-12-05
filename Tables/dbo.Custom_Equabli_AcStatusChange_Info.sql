CREATE TABLE [dbo].[Custom_Equabli_AcStatusChange_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[queue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bankruptcyStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isDeceased] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isFraud] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountChannel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelAttorneyRepFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelCCCSFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelLitigiousFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelCeaseDesistFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preLegalTalkoff] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[debtSettlementFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_AcStatusChange_Info] ADD CONSTRAINT [PK_Custom_Equabli_AcStatusChange_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
