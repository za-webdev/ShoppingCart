using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.Models
{
    public class ProductInfo
    {
        public string Item_Name { get; set; }
        public double Price { get; set; }
        public double SalesTax { get; set; }
        public double PriceWithTax { get; set; }
        public double Count { get; set; }
        public string Description { get; set; }
    }
}
