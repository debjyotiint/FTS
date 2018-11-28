using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{
    public class ShopslistInput
    {

        public string session_token { get; set; }
        public string user_id { get; set; }

        public int Uniquecont { get; set; }



    }

    public class ShopslistOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public Datalists data { get; set; }

    }

    public class Datalists
    {

        public string session_token { get; set; }

        public List<Shopslists> shop_list { get; set; }

    }

    public class Shopslists
    {
        public string shop_id { get; set; }
        public string shop_name { get; set; }

        public string address { get; set; }

        public string pin_code { get; set; }

        public string shop_lat { get; set; }

        public string shop_long { get; set; }

        public string owner_name { get; set; }

        public string owner_contact_no { get; set; }

        public string owner_email { get; set; }

        public string Shop_Image { get; set; }

        public DateTime? dob { get; set; }

        public DateTime? date_aniversary { get; set; }

        public DateTime? last_visit_date { get; set; }

        public int total_visit_count { get; set; }

        public int isAddressUpdated { get; set; }
        public int type { get; set; }
        public string Shoptype { get; set; }
        public string assigned_to_pp_id { get; set; }
        public string assigned_to_dd_id { get; set; }

        public bool is_otp_verified { get; set; }

    }
}