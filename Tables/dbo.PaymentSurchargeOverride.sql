CREATE TABLE [dbo].[PaymentSurchargeOverride]
(
[SurchargeTypeId] [int] NOT NULL,
[PaymentId] [int] NOT NULL,
[PaymentTableId] [int] NOT NULL,
[DTE] [datetime] NOT NULL CONSTRAINT [DF__PaymentSurc__DTE__19025A79] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PaymentSu__Creat__19F67EB2] DEFAULT (suser_sname()),
[LastUpdated] [datetime] NOT NULL CONSTRAINT [DF__PaymentSu__LastU__1AEAA2EB] DEFAULT (getdate()),
[LastUpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PaymentSu__LastU__1BDEC724] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentSurchargeOverride] ADD CONSTRAINT [PK_PaymentSurchargeOverride] PRIMARY KEY CLUSTERED ([PaymentId], [PaymentTableId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
