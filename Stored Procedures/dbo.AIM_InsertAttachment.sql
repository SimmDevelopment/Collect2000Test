SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    procedure [dbo].[AIM_InsertAttachment]
	@attachmenttypeid int,
	@referenceid int
AS

	insert into 
		AIM_Attachment
		(
			attachmenttypeid,
			referenceid
		)
		values
		(
			@attachmenttypeid,
			@referenceid
		)
	select @@identity



GO
