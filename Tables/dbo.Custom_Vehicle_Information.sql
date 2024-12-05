CREATE TABLE [dbo].[Custom_Vehicle_Information]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[year] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[make] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vin] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vehicleinfo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[repodate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[solddate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[saleprice] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Vehicle_Information] ADD CONSTRAINT [PK_Custom_Vehicle_Information] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
