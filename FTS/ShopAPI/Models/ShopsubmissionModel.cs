using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{

    public class ShopsubmissionInput
    {
        public string session_token { get; set; }
        public string user_id { get; set; }


        public List<ShopsubmissionModel> shop_list { get; set; }
    }

    public class ShopsubmissionModel
    {

        public string shop_id { get; set; }
        public string visited_date { get; set; }
        public string visited_time { get; set; }
        public string spent_duration { get; set; }
        public int total_visit_count { get; set; }


    }


    public class ShopsubmissionOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public List<DatalistsSumission> shop_list { get; set; }
    }

    public class DatalistsSumission
    {

        public string shopid { get; set; }
        public int total_visit_count { get; set; }

        public DateTime? visited_date { get; set; }
        public DateTime? visited_time { get; set; }
        public string spent_duration { get; set; }



    }
}