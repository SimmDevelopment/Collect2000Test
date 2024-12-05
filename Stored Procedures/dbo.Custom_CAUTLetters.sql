SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CAUTLetters]
	-- Add the parameters for the stored procedure here
	@number int
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--create the variables to be used throughout the query
declare @accountID int
declare @customercode varchar (7)
declare @letterid int
declare @lettercode varchar (5)
declare @daterequested datetime
declare @dateprocessed datetime
declare @username varchar (10)
declare @datecreated datetime
declare @dateupdated datetime
declare @subjdebtorid int
declare @recipientdebtorid int
declare @letterrequestid int
declare @empty varchar(1)
declare @seq int

--set an empty variable for the sif payment fields
set @empty = ''

    -- Insert statements for procedure here
	select @accountid = m.number, @customercode = customer, @letterid = '53', @lettercode = '37', @username = 'Global', 
                                    @subjdebtorid = d.debtorid, 
                                    @recipientdebtorid = d.debtorid, @seq = d.seq
            from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number
            where m.number = @number

	insert into letterrequest (accountid, customercode, letterid, lettercode,  
                                                username, sifpmt1, sifpmt2, sifpmt3, sifpmt4, sifpmt5, sifpmt6, 
                                                subjdebtorid, recipientdebtorid)
            values(@accountid, @customercode, @letterid, @lettercode, @username, @empty, @empty, @empty, @empty, @empty, @empty, 
                                    @subjdebtorid, @recipientdebtorid)

	SELECT @LetterRequestID = scope_identity()

            --Insert the information into the letterrequestrecipient table now
            insert into letterrequestrecipient(LetterRequestID, AccountID, seq, debtorID)
            values( @letterrequestid, @accountid, @Seq, @subjdebtorid)
END
GO
