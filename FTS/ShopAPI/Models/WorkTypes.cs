using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{
    public class WorktypesInput
    {
        public string user_id { get; set; }
    }
 
   
    public class Worktypesoutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public List<worktypes> worktype_list { get; set; }
    }
    public class worktypes
    {
        public int ID { get; set; }
        public string Descrpton { get; set; }

    }
}