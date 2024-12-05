CREATE TABLE [dbo].[Services_LexisNexis_Batch_B1]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[nearby_1_first_name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_1_last_name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_1_address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_1_city_3] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_1_state_3] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_1_zipcode_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_1_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_2_first_name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_2_last_name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_2 _address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_2_city_3] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_2_state_3] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_2_zipcode_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_2_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_3_first_name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_3_last_name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_3_ address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_3_city_3] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_3_state_3] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_3_zipcode_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nearby_3_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_B1] ADD CONSTRAINT [PK_ServicesLexNexBatch_B1] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
