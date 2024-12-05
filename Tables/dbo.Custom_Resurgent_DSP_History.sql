CREATE TABLE [dbo].[Custom_Resurgent_DSP_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DistputeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputeDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputeTypeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputeCommTypeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputeSourceID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputeResponsibilityID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputeResolutionDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputeResolutionTypeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Custom_Resurgent_DSP_History_DateCreated] DEFAULT (format(getdate(),'MM/dd/yyyy'))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Resurgent_DSP_History] ADD CONSTRAINT [PK_Custom_Resurgent_DSP_History] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
