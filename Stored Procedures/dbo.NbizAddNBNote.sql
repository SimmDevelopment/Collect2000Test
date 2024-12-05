SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [dbo].[NbizAddNBNote] 
@cliref varchar(30),
@created datetime,
@user0 varchar(10),
@action varchar(6),
@result varchar(6),
@comment text,
@seq integer
AS
declare @dnumber int
select @dnumber = number from nbmaster where account = @cliref

insert NBNotes
values (@dnumber,@created,@user0,@action,@result,@comment,@seq)








GO
