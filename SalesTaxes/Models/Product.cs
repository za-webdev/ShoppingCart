using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.Models
{
    public class Product
    {
        public int Item_Id { get; set; }
        public string Item_Name { get; set; }
        public int Item_Category_Id { get; set; }
        public double Price { get; set; }

        public Product()
        {
            Item_Id = 0;
            Item_Name = "";
            Item_Category_Id = 0;
            Price = 0.00;
        }
    }
}
