CREATE TABLE [dbo].[ztempACBCalls]
(
[DATE] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TIME] [datetime] NULL,
[TLENGTH] [int] NULL,
[RESULT_PFX] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RESULT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LIST_NAME] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FW_QUEUE] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FW_ENTITY] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGNTHIST_TLENGTH] [int] NULL,
[ENTITY_HOST_ID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
