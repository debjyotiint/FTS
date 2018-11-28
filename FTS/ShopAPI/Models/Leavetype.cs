using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{

    public class LeavetypeInput
    {
        public string user_id { get; set; }
    }


    public class Leavetypeoutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public List<Leavetype> leave_type_list { get; set; }
    }
    public class Leavetype
    {
        public int id { get; set; }
        public string type_name { get; set; }

    }
}