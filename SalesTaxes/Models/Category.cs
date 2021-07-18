using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.Models
{
    public class Category
    {
        public int Category_Id { get; set; }
        public string Category_Name { get; set; }
        public double SalesTax { get; set; }

        public Category()
        {
            Category_Id = 0;
            Category_Name = "";
            SalesTax = 0.00;
        }
    }
}
