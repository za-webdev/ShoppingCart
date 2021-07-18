using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.ViewModels
{
    public class ProductViewModel
    {
        public int Item_Id { get; set; }

        [Required(ErrorMessage = "Name is required")]
        public string Item_Name { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Choose a product category")]
        public int Item_Category_Id { get; set; }

        [BindProperty (SupportsGet = true)]
        public string Item_Category_Name { get; set; }

        [Required (ErrorMessage ="Enter a valid price")]
        public double Price { get; set; }

        public SelectList ProductCategories { get; set; }

        public MessageViewModel Messages { get; set; } = new MessageViewModel();

    }
}
