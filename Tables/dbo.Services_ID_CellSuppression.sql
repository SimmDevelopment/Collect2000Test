CREATE TABLE [dbo].[Services_ID_CellSuppression]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[PhoneNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsCellPhone] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_ID_CellSuppression] ADD CONSTRAINT [PK_Services_ID_CellSuppression] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
