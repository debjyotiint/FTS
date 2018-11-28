using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{


    public class ShopdaywiseInput
    {

      //  public string session_token { get; set; }
        public int? user_id { get; set; }
        public string from_date { get; set; }
        public string to_date { get; set; }
        public int? date_span { get; set; }

    }

    public class ShopdaywiseOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public int toal_shopvisit_count { get; set; }
        public int avg_shopvisit_count { get; set; }
        public List<ShopdaywiseList> date_list { get; set; }
    }

    public class ShopdaywiseList
    {
        public string date { get; set; }

     
        public List<ShopList> shop_list { get; set; }
    }

    public class ShopList
    {

        public string date { get; set; }
        public string shopid { get; set; }
        public string duration_spent { get; set; }
        public string shop_name { get; set; }
        public string shop_address { get; set; }
        public DateTime? visited_date { get; set; }


    }


}