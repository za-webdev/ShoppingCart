using SalesTaxes.CodeHelpers;
using SalesTaxes.Models;
using SalesTaxes.ViewModels;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.DBAccess
{
    public class DBAccessRepo : IDBAccessRepo
    {
        readonly AppDBAccess _dBAccess;

        public DBAccessRepo()
        {
            _dBAccess = new AppDBAccess();
        }

        public int UpsertCategory(Category category)
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[UpSert_Category]", _dBAccess.sqlConnection);
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = category.Category_Id;
            cmd.Parameters.Add("@CategoryName", SqlDbType.NVarChar).Value = category.Category_Name;
            cmd.Parameters.Add("@Salestax", SqlDbType.Decimal).Value = category.SalesTax;
            var retVal = DBCommandHelpers.ExecuteScalarAndCloseConnection(cmd);
            return retVal;
        }
        public CategoryViewModel GetCategoryById(int categoryId)
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[GetCategoryById]", _dBAccess.sqlConnection);
            cmd.Parameters.Add("@ID ", SqlDbType.Int).Value = categoryId;
            var category = new CategoryViewModel();
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    category.Category_Name = reader["Category_Name"] is DBNull ? string.Empty : Convert.ToString(reader["Category_Name"]);
                    category.Category_Id = reader["Category_Id"] is DBNull ? 0 : Convert.ToInt32(reader["Category_Id"]);
                    category.SalesTax = reader["SalesTax"] is DBNull ? 0 : Convert.ToDouble(reader["SalesTax"]);
                };
            }
            cmd.Connection.Close();

            return category;
        }

        public List<CategoryViewModel> GetCategories()
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[GetAllCategories]", _dBAccess.sqlConnection);
            var listOfCategories = new List<CategoryViewModel>();
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    var category = new CategoryViewModel()
                    {
                        Category_Id = reader["Category_Id"] is DBNull ? 0 : Convert.ToInt32(reader["Category_Id"]),
                        Category_Name = reader["Category_Name"] is DBNull ? string.Empty : Convert.ToString(reader["Category_Name"]),
                        SalesTax = reader["SalesTax"] is DBNull ? 0 : Convert.ToDouble(reader["SalesTax"])
                };

                    listOfCategories.Add(category);
                }
            }
            cmd.Connection.Close();

            return listOfCategories;
        }

        public int UpsertProduct(Product product)
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[UpSert_Product]", _dBAccess.sqlConnection);
            cmd.Parameters.Add("@Item_Id", SqlDbType.Int).Value = product.Item_Id;
            cmd.Parameters.Add("@Item_Name", SqlDbType.NVarChar).Value = product.Item_Name;
            cmd.Parameters.Add("@Price", SqlDbType.NVarChar).Value = product.Price;
            cmd.Parameters.Add("@Category_id", SqlDbType.NVarChar).Value = product.Item_Category_Id;
            var retVal = DBCommandHelpers.ExecuteScalarAndCloseConnection(cmd);
            return retVal;
        }
        public List<ProductViewModel> GetProducts()
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[GetAllProducts]", _dBAccess.sqlConnection);
            var listOfProducts = new List<ProductViewModel>();
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    var product = new ProductViewModel()
                    {
                        Item_Id = reader["Item_Id"] is DBNull ? 0 : Convert.ToInt32(reader["Item_Id"]),
                        Item_Name = reader["Item_Name"] is DBNull ? string.Empty : Convert.ToString(reader["Item_Name"]),
                        Price = reader["Price"] is DBNull ? 0 : Convert.ToDouble(reader["Price"]),
                        Item_Category_Id = reader["Category_Id"] is DBNull ? 0 : Convert.ToInt32(reader["Category_Id"]),
                        Item_Category_Name = reader["Category_Name"] is DBNull ? string.Empty : Convert.ToString(reader["Category_Name"])
                    };

                    listOfProducts.Add(product);
                }
            }
            cmd.Connection.Close();

            return listOfProducts;
        }

        public void AddItemsToCart(string listOfItemIds)
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[UpSert_ShoppingCart]", _dBAccess.sqlConnection);
            cmd.Parameters.Add("@Item_Ids", SqlDbType.NVarChar).Value = listOfItemIds;
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();
        }

        public List<ProductViewModel> GetItemsInCart(string selectedItems)
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[GetSelectItemsInCart]", _dBAccess.sqlConnection);
            cmd.Parameters.Add("@Item_Ids", SqlDbType.NVarChar).Value = selectedItems;
            var itemsInCart = new List<ProductViewModel>();
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    var product = new ProductViewModel()
                    {
                        Item_Id = reader["Item_Id"] is DBNull ? 0 : Convert.ToInt32(reader["Item_Id"]),
                        Item_Name = reader["Item_Name"] is DBNull ? string.Empty : Convert.ToString(reader["Item_Name"]),
                        Price = reader["Price"] is DBNull ? 0 : Convert.ToDouble(reader["Price"]),
                    };

                    itemsInCart.Add(product);
                }
            }
            cmd.Connection.Close();

            return itemsInCart;
        }
        public List<ProductInfo> GetItemsInfoForReceipt()
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[GetItemsInfoForReceipt]", _dBAccess.sqlConnection);
            var items = new List<ProductInfo>();
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    var item = new ProductInfo()
                    {
                        Item_Name = reader["Item_Name"] is DBNull ? string.Empty : Convert.ToString(reader["Item_Name"]),
                        Price = reader["Price"] is DBNull ? 0 : Convert.ToDouble(reader["Price"]),
                        SalesTax = reader["SalesTax"] is DBNull ? 0 : Convert.ToDouble(reader["SalesTax"]),
                        Count = reader["Count"] is DBNull ? 0 : Convert.ToInt32(reader["Count"])
                };

                    items.Add(item);
                }
            }
            cmd.Connection.Close();

            return items;
        }
        public void MarkItemsAsPurchased()
        {
            var cmd = DBCommandHelpers.GetWriteSqlProcedureCommand("[dbo].[MarkItemsAsPurchased]", _dBAccess.sqlConnection);
            cmd.ExecuteNonQuery();
            cmd.Connection.Close();
        }


    }
}
