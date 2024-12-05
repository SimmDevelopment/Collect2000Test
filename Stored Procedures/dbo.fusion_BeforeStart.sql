SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 09/25/2006
-- Description:	This is the StoredProc that will be executed before Fusion starts
-- =============================================
CREATE PROCEDURE [dbo].[fusion_BeforeStart]
AS
BEGIN

	SET NOCOUNT ON;

	--Create the FusionConfig table if necessary
	if not exists (select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='FusionConfig')
	BEGIN
		CREATE TABLE [dbo].[FusionConfig](
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Config] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		 CONSTRAINT [PK_FusionConfig] PRIMARY KEY CLUSTERED 
		(
			[ID] ASC
		) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	END
END
GO
