CREATE TABLE [dbo].[Custom_Equabli_Serial_Numbers]
(
[ID] [int] NOT NULL,
[UniqueID] [int] NOT NULL IDENTITY(100001, 1),
[EntityType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[issueDate] [datetime] NULL,
[issue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transmitDate] [datetime] NULL,
[fileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[secondaryID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Serial_Numbers] ADD CONSTRAINT [PK_Custom_Equabli_Serial_Numbers] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
