USE [MarketPlace]
GO
/****** Object:  StoredProcedure [dbo].[GetCategoryById]    Script Date: 7/15/2021 1:05:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetCategoryById] 
  @ID int = 0

AS
Begin
SET NOCOUNT ON;

select * from Categories where Category_Id = @ID and IsDeleted = 0

End