CREATE TABLE [dbo].[SurchargeType]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SurchargeAmount] [money] NULL,
[SurchargePercent] [real] NULL,
[AdditionalAmount] [money] NULL,
[AdditionalPercent] [real] NULL,
[Active] [bit] NOT NULL,
[DTE] [datetime] NOT NULL CONSTRAINT [DF__SurchargeTy__DTE__69534757] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Surcharge__Creat__6A476B90] DEFAULT (suser_sname()),
[LastUpdated] [datetime] NOT NULL CONSTRAINT [DF__Surcharge__LastU__6B3B8FC9] DEFAULT (getdate()),
[LastUpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Surcharge__LastU__6C2FB402] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurchargeType] ADD CONSTRAINT [PK_SurchargeType] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
