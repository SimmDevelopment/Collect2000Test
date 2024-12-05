CREATE TABLE [dbo].[Custom_Resurgent_WRT_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkRestrictionTypeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkRestrictionSourceID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Custom_Resurgent_WRT_History_DateCreated] DEFAULT (format(getdate(),'MM/dd/yyyy'))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Resurgent_WRT_History] ADD CONSTRAINT [PK_Custom_Resurgent_WRT_History] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
