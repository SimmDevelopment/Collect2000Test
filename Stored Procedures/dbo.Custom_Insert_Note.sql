SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Insert_Note]
@Number int,
@User0 varchar(10),
@Action varchar(6),
@Result varchar(6),
@Comment varchar(5000)
AS 

INSERT INTO Notes (Number,CTL, Created, User0, Action, Result, 
                   Comment, Seq)
VALUES (@Number, 'CTL', GetDate(), @User0, @Action, @Result, 
        @Comment, Null)
GO
