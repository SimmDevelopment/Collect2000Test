CREATE TABLE [dbo].[Custom_Equabli_Cost_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliPartnerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[costType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateOfCost] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[costAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Cost_Info] ADD CONSTRAINT [PK_Custom_Equabli_Cost_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
