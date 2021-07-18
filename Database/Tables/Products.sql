USE [MarketPlace]
GO

/****** Object:  Table [dbo].[Products]    Script Date: 7/15/2021 1:10:36 AM ******/
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

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
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


