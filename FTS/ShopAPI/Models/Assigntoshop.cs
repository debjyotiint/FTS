using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{
    public class AssigntoshopPPInput
    {
        public string session_token { get; set; }
        public string user_id { get; set; }
        public string state_id { get; set; }
    }

    public class AssigntoshopPP
    {
        public  string   assigned_to_pp_id { get; set; }
        public  string  assigned_to_pp_authorizer_name { get; set; }
        public string phn_no { get; set; }

    }

    public class AssigntoshopDDInput
    {
        public string session_token { get; set; }
        public string user_id { get; set; }
        public string state_id { get; set; }
    }

  public class AssigntoshopPPOutput
    {
        public string status { get; set; }
        public string message { get; set; }
       public List<AssigntoshopPP> assigned_to_pp_list { get; set; }

    }

    public class AssigntoshopDD
    {
     public  string  assigned_to_dd_id { get; set; }
     public string assigned_to_dd_authorizer_name { get; set; }
     public string phn_no { get; set; }
    }

    public class AssigntoshopDDOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public List<AssigntoshopDD> assigned_to_dd_list { get; set; }

    }


}