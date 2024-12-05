SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Role_Add*/
CREATE Procedure [dbo].[sp_Role_Add]
@ID int,
@RoleName varchar(50)
AS

INSERT INTO Roles
(
RoleName
)
VALUES
(
@RoleName
)

--SET @ID = @@IDENTITY
GO
