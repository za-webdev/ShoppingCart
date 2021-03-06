USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[UpSert_Product]    Script Date: 7/15/2021 1:08:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpSert_Product] 
	@Item_Id		int
	,@Item_Name		varchar(max) 
	,@Price			numeric(19,4) 
	,@Category_id	int 
	,@IsDeleted		bit = 0

AS
Begin
SET NOCOUNT ON;
Declare @retVal int = 0;

if(@Item_Id > 0)
Begin
  UPDATE Products    
    SET
       Item_Name  = isNull(@Item_Name,Item_Name),
	   Price = isNull(@Price,Price),
	   Category_Id = isNull(@Category_id,Category_Id),
	   IsDeleted = isNull(@IsDeleted,IsDeleted),
		@retval = Item_Id
		where Item_Id = @Item_Id
End

if(@retVal = 0)
begin
  INSERT into Products
  (
      Item_Name,
	  Price,
	  Category_Id,
	  IsDeleted
  ) VALUES (
      @Item_Name,
	  @Price,
	  @Category_id,
	  0
  );
  set @retVal = SCOPE_IDENTITY();
  end
  Select @retVal
End