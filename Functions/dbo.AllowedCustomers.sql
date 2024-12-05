SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[AllowedCustomers](@UserID int) 
RETURNS @Set TABLE (CustomerID varchar(7))
AS
BEGIN
  INSERT @Set
    select customerid from UserCustomers where UserID=@UserID and CustomerID is not null union
    select customerid from fact where CustomGroupID in (select CustomerGroupID from UserCustomers where UserID=@UserID and CustomerGroupID is not null)
  RETURN
END

GO
