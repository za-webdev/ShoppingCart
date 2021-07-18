USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[GetAllProducts]    Script Date: 7/15/2021 1:05:31 AM ******/
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
