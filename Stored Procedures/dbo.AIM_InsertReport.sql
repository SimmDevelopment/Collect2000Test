SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE        procedure [dbo].[AIM_InsertReport]
@name varchar(50) = '',
@description varchar(250) = '',
@configuration text = ''

AS
DECLARE @reportid int

INSERT INTO AIM_Report
(Name,Description,Configuration)
VALUES
(@name,@description,@configuration)

SELECT @reportid = @@Identity
SELECT @reportid as [ReportId]



GO
