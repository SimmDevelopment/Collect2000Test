SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_AddLedgerType]
@name varchar(50),
@creditGroupTypeId int,
@debitGroupTypeId int

AS

DECLARE @maxledgertypeid int

SELECT @maxledgertypeid = max(ledgertypeid) FROM AIM_LedgerType

if(@maxledgertypeid >= 1000)
begin
	SET @maxledgertypeid = @maxledgertypeid + 1
end
else
begin
	SET @maxledgertypeid = 1000
end

INSERT INTO AIM_LedgerType 
(LedgerTypeId,Name,CreditGroupTypeId,DebitGroupTypeId,IsSystem)
VALUES
(@maxledgertypeid,@name,@creditgrouptypeid,@debitgrouptypeid,0)

GO
