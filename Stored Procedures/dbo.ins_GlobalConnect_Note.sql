SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ins_GlobalConnect_Note]
(@Number int,
 @Created DateTime,
 @User0 varchar(10),
 @Action varchar(6),
 @Result varchar(6),
 @Comment text
)
AS

INSERT INTO Notes (Number, CTL, Created, User0, [Action], Result, Comment, Seq, IsPrivate)
VALUES (@Number, 'CTL', @Created, @User0, @Action, @Result, @Comment, Null, Null)

GO
