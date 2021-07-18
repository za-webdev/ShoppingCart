using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.ViewModels
{
    public class CategoryViewModel
    {
        public int Category_Id { get; set; }

        [Required]
        [MinLength(3, ErrorMessage = "Category Name cannot be less than 3 characters")]
        public string Category_Name { get; set; }
        [Required (ErrorMessage = "Enter a valid percentage")]
        public double SalesTax { get; set; }

        public MessageViewModel Messages { get; set; } = new MessageViewModel();
    }
}
