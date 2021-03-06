USE [MarketPlace]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Category_Id] [int] IDENTITY(1,1) NOT NULL,
	[Category_Name] [varchar](max) NULL,
	[SalesTax] [numeric](19, 4) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Item_Id] [int] IDENTITY(1,1) NOT NULL,
	[Item_Name] [varchar](max) NULL,
	[Price] [numeric](19, 4) NULL,
	[Category_Id] [int] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Item_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shopping_Cart]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shopping_Cart](
	[Item_Id] [int] NOT NULL,
	[Purchased] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [DF_Categories_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Shopping_Cart] ADD  CONSTRAINT [DF_Shopping_Cart_Purchased]  DEFAULT ((0)) FOR [Purchased]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([Category_Id])
REFERENCES [dbo].[Categories] ([Category_Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Products] FOREIGN KEY([Item_Id])
REFERENCES [dbo].[Products] ([Item_Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Products]
GO
ALTER TABLE [dbo].[Shopping_Cart]  WITH CHECK ADD  CONSTRAINT [FK_Shopping_Cart_Products] FOREIGN KEY([Item_Id])
REFERENCES [dbo].[Products] ([Item_Id])
GO
ALTER TABLE [dbo].[Shopping_Cart] CHECK CONSTRAINT [FK_Shopping_Cart_Products]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCategories]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllCategories]

AS
Begin
SET NOCOUNT ON;
select * from Categories where IsDeleted = 0

End
GO
/****** Object:  StoredProcedure [dbo].[GetAllProducts]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllProducts]

AS
Begin
SET NOCOUNT ON;
select p.Item_Id,p.Item_Name,p.Category_Id,p.Price,c.Category_Name from Products p
Inner Join Categories c on p.Category_Id = c.Category_Id where p.IsDeleted = 0 and c.IsDeleted = 0

End
GO
/****** Object:  StoredProcedure [dbo].[GetCategoryById]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCategoryById] 
  @ID int = 0

AS
Begin
SET NOCOUNT ON;

select * from Categories where Category_Id = @ID and IsDeleted = 0

End
GO
/****** Object:  StoredProcedure [dbo].[GetItemsInCart]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetItemsInCart]

AS
Begin
SET NOCOUNT ON;
select prod.Item_Id,prod.Item_Name,prod.Price from Products prod
inner join Shopping_Cart sc on sc.Item_Id = prod.Item_id
End
GO
/****** Object:  StoredProcedure [dbo].[GetItemsInfoForReceipt]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetItemsInfoForReceipt]

AS
Begin
SET NOCOUNT ON;

SELECT DISTINCT
     p.Item_Id,
     p.Item_Name,
     p.Price,
     c.SalesTax,
     (
          SELECT 
              COUNT(s.Item_Id) 
          FROM 
              Shopping_Cart s
          WHERE 
              p.Item_Id = s.Item_Id and s.Purchased =0
     ) AS Count
FROM 
     Products p
	 inner join Categories c on p.Category_Id = c.Category_Id
	 inner join Shopping_Cart s on p.Item_Id = s.Item_Id
where p.IsDeleted = 0 and c.IsDeleted = 0 and s.Purchased = 0

End

GO
/****** Object:  StoredProcedure [dbo].[GetSelectItemsInCart]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSelectItemsInCart]
    @Item_Ids	nvarchar(max) = null

AS

Begin
SET NOCOUNT ON;

DECLARE @xml as xml,
@delimiter as varchar(10)

SET @delimiter =','

-- Convert it to an XML document
SET @xml = cast(('<X>'+replace(@Item_Ids,@delimiter ,'</X><X>')+'</X>') as xml)

SELECT Item_Id,Item_Name,Price FROM Products WHERE Item_Id IN
(SELECT N.value('.', 'varchar(10)') as value FROM @xml.nodes('X') as T(N))


End
GO
/****** Object:  StoredProcedure [dbo].[MarkItemsAsPurchased]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[MarkItemsAsPurchased]

AS
Begin
SET NOCOUNT ON;
Update Shopping_Cart set Purchased = 1 where Purchased = 0
End
GO
/****** Object:  StoredProcedure [dbo].[UpSert_Category]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpSert_Category] --@Id=0,@CategoryName='xxxxx',@Salestax = 2.9
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
GO
/****** Object:  StoredProcedure [dbo].[UpSert_Product]    Script Date: 7/17/2021 11:41:54 PM ******/
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
GO
/****** Object:  StoredProcedure [dbo].[UpSert_ShoppingCart]    Script Date: 7/17/2021 11:41:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpSert_ShoppingCart]
@Item_Ids	nvarchar(max) = null
AS

Begin
SET NOCOUNT ON;

DECLARE @xml as xml,
@delimiter as varchar(10)

SET @delimiter =','

-- Convert it to an XML document
SET @xml = cast(('<X>'+replace(@Item_Ids,@delimiter ,'</X><X>')+'</X>') as xml)

-- Select back from the XML
INSERT INTO Shopping_Cart (Item_Id)
SELECT N.value('.', 'varchar(10)') as value FROM @xml.nodes('X') as T(N)

End
GO
