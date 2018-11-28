using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MyShop.Models
{
    public class DashboardModelC
    {
        public int shopcount { get; set; }
        public int usercount { get; set; }
        public int activeusercount { get; set; }
        public int Nonactiveuser { get; set; }

        public string Userid { get; set; }

    }
}