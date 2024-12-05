SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spAddNote    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE procedure [dbo].[spAddNote]
	@number int,
	@desk varchar (7),
	@ac varchar (5),
	@rc varchar(5),
	@note varchar(90)
as 
  insert into notes (number,ctl,created,user0,action,result,comment)
      values (@number,'ctl',getdate(),@desk,@ac,@rc,@note);
  DECLARE @description varchar(8000)
  SET @description = 'Added Note: '+@ac+','+@rc+' : '+@note
  EXEC spAddActivity @desk, @number, @description
GO
