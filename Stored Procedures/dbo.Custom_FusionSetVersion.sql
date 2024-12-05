SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_FusionSetVersion]
	-- Add the parameters for the stored procedure here
	@build int,
	@minor int,
	@major int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS(select * from dbo.sysobjects where id = object_id(N'[dbo].Fusion_AppSettings') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		CREATE TABLE [dbo].[Fusion_AppSettings](
		[ID] [varchar] (100) NULL,
		[Value] [varchar] (1000) NULL
		) ON [PRIMARY]
	END
	
	Delete from Fusion_AppSettings
	where [ID] like 'Build%'

	Insert into Fusion_AppSettings([ID],[Value])
	Values
	('Build.Major',@major)
	
	Insert into Fusion_AppSettings([ID],[Value])
	Values
	('Build.Minor',@minor)
	
	Insert into Fusion_AppSettings([ID],[Value])
	Values
	('Build.Build',@build)
END
GO
