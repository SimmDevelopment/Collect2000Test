CREATE TABLE [dbo].[Exchange_NSF_Import_History]
(
[Exchange_NSF_Import_History_Id] [int] NOT NULL IDENTITY(1, 1),
[Exchange_Data_Id] [int] NOT NULL,
[Import_Rank] [int] NOT NULL CONSTRAINT [DF__Exchange___Impor__00272D77] DEFAULT ((0)),
[Import_Date] [datetime] NOT NULL CONSTRAINT [DF__Exchange___Impor__011B51B0] DEFAULT (getdate()),
[PDC_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PDCDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NSF_Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PaymentLinkUID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reversal_Status] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payhistory_UID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payhistory_Reversal_UID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Import_Complete] [bit] NULL CONSTRAINT [DF__Exchange___Impor__7F33093E] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exchange_NSF_Import_History] ADD CONSTRAINT [PK_Exchange_Data_History] PRIMARY KEY CLUSTERED ([Exchange_NSF_Import_History_Id]) ON [PRIMARY]
GO
