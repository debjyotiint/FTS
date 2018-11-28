using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{
    public class Collectionclass_Input
    {
        public string session_token { get; set; }
        public string user_id { get; set; }
        public string shop_id { get; set; }
        public string collection { get; set; }
        public string collection_id { get; set; }
        public string collection_date { get; set; }

    }

    public class Collectionclass_Output
    {
        public string status { get; set; }
        public string message { get; set; }
        public string user_id { get; set; }
        public string shop_id { get; set; }
        public string collection { get; set; }

    }


    public class CollectionList_Output
    {
        public string status { get; set; }
        public string message { get; set; }
        public int total_orderlist_count { get; set; }
        public List<collection_details_list> collection_details_list { get; set; }
    }
    public class collection_details_list
    {
        public string shop_id { get; set; }
        public string collection { get; set; }
        public string collection_date { get; set; }
        public string collection_id { get; set; }
    }
}