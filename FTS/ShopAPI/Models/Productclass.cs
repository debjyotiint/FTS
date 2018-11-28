using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{
    public class Productclass
    {
        public long id { get; set; }
        public long brand_id { get; set; }
        public long category_id { get; set; }
        public long watt_id { get; set; }
        public string brand { get; set; }
        public string product_name { get; set; }
        public string category { get; set; }

        public string watt { get; set; }

   
    }
    public class ProductclassInput
    {

        public string session_token { get; set; }
        public string user_id { get; set; }

        public string last_update_date { get; set; }

    }

    public class ProductlistOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public int total_product_list_count { get; set; }
        public List<Productclass> product_list { get; set; }
    }

  
 }

    
