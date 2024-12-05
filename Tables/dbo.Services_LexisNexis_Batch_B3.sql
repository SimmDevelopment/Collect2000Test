CREATE TABLE [dbo].[Services_LexisNexis_Batch_B3]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[mvr_1_vehicle_desc] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_1_lienholder_name] [varchar] (66) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_1_tag] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_1_vin] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_1_owner_name_1] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_1_owner_name_2] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_1_registrant_name_1] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_1_registrant_name_2] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_vehicle_desc] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_lienholder_name] [varchar] (66) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_tag] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_vin] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_owner_name_1] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_owner_name_2] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_registrant_name_1] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_2_registrant_name_2] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_vehicle_desc] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_lienholder_name] [varchar] (66) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_tag] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_vin] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_owner_name_1] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_owner_name_2] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_registrant_name_1] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mvr_3_registrant_name_2] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_B3] ADD CONSTRAINT [PK_ServicesLexNexBatch_B3] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
