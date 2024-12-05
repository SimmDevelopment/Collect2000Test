CREATE TABLE [dbo].[Services_SurePlacement_MotorVehicleRecord]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[VehicleDesc] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LienHolderName] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LienHolderAddress] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LienHolderCity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LienHolderState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LienHolderZipcode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tag] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vin] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Owner1Name] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Owner2Name] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regis1Name] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regis2Name] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MVRSeqNum] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_MotorVehicleRecord] ADD CONSTRAINT [PK_Services_SurePlacement_MotorVehicleRecord] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
