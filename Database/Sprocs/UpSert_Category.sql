USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[UpSert_Category]    Script Date: 7/15/2021 1:07:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpSert_Category]
    @ID				int 
  , @CategoryName   nvarchar(50) = null
  , @Salestax       numeric(19,4) = null

AS
Begin
SET NOCOUNT ON;
Declare @retVal int = 0;
Declare @exsitingRecords int = 0;

if(@ID > 0)
	Begin
		set @exsitingRecords = (Select count(*) from Categories where Category_Name = @CategoryName and Category_Id <> @ID and IsDeleted = 0)
		if(@exsitingRecords > 0)
			begin
				set @retVal = 0;
			end
		else
		begin
			UPDATE Categories  
				SET
					Category_Name = isNull(@CategoryName,Category_Name),
					SalesTax = isNull(@Salestax,SalesTax),
					@retval = Category_Id where Category_Id = @ID 
		end
Select @retVal
return
End
if(@retVal = 0)
begin
 set @exsitingRecords = (Select count(*) from Categories where Category_Name = @CategoryName and IsDeleted = 0)
		if(@exsitingRecords > 0)
			begin
				set @retVal = 0;
			end
		else
		Begin
		  INSERT into Categories
		  (
			  Category_Name,
			  SalesTax,
			  isDeleted
		  ) VALUES (
			  @CategoryName,
			  @Salestax,
			  0
		  );
		  set @retVal = SCOPE_IDENTITY();
		end
End  
  Select @retVal
End