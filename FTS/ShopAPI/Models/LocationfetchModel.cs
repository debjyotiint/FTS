﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{
    public class LocationfetchInput
    {


        public int? user_id { get; set; }
        public string from_date { get; set; }
        public string to_date { get; set; }
        public int? date_span { get; set; }

    }


    public class LocationfetchOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public List<Locationfetch> location_details { get; set; }

    }

    public class Locationfetch
    {

        public string location_name { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
        public string distance_covered { get; set; }
        public string last_update_time { get; set; }
        public DateTime? date { get; set; }
        public string shops_covered { get; set; }

    }



}