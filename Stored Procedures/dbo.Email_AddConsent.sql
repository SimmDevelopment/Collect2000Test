SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Email_AddConsent]      
@EmailId INTEGER,      
@Email VARCHAR(50) = NULL,      
@DebtorId INTEGER,      
@TypeCd VARCHAR(10) = NULL,      
@ConsentGiven BIT,      
@ConsentSource VARCHAR(255) = NULL,      
@ContactMethod VARCHAR(50) = NULL,  
@WrittenConsent BIT,  
@Comment text,  
@CreatedBy VARCHAR(255),  
@ModifiedBy VARCHAR(255)  
AS      
      
SET NOCOUNT ON;      
 BEGIN    
	
	--Update created by with login name to fix the issue
	SELECT @CreatedBy = u.LoginName from Users u where u.UserName = @CreatedBy;

	DECLARE @Count INTEGER;
	SET @Count = (SELECT COUNT(*) FROM Email WHERE DebtorID = @DebtorID);	
   
  IF(@Count > 0)         
   BEGIN     
     UPDATE [Email] SET Email = @Email, TypeCd = @TypeCd, ConsentGiven = @ConsentGiven,ConsentSource = @ConsentSource,  
     WrittenConsent = @WrittenConsent, Comment = @Comment, DebtorAssociationId = @DebtorId, ModifiedBy = COALESCE(@ModifiedBy, ''), ModifiedWhen = GETDATE()  
     WHERE DebtorId = @DebtorId    
     
     UPDATE DEBTORS SET contactmethod = @ContactMethod,Email = @Email WHERE DebtorId = @DebtorID        
   END          
  ELSE          
   BEGIN      
     INSERT INTO [dbo].[Email]       
     (      
         Email,DebtorId,TypeCd, ConsentGiven,ConsentSource,WrittenConsent,Comment,DebtorAssociationId, CreatedBy, ModifiedBy , CreatedWhen, ModifiedWhen
     )            
     VALUES     
     (      
         @Email,@DebtorId,@TypeCd,@ConsentGiven,@ConsentSource,@WrittenConsent,@Comment, @DebtorId, COALESCE(@CreatedBy, ''),COALESCE(@ModifiedBy, ''), GETDATE(), GETDATE()
     ); 
     SET @EmailId = SCOPE_IDENTITY()   
     UPDATE DEBTORS SET contactmethod = @ContactMethod,Email = @Email WHERE DebtorId = @DebtorID  
   END  
  
  DECLARE @Number VARCHAR(10), @DebtorName VARCHAR(50);
	SELECT @Number = Number, @DebtorName = Name FROM Debtors WHERE DebtorID = @DebtorId;

END 
 
GO
