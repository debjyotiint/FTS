﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{

    public class AttendancemanageInput
    {
        public string session_token { get; set; }
        public string user_id { get; set; }
        public string work_type { get; set; }
        public string work_desc { get; set; }
        public string work_lat { get; set; }
        public string work_long { get; set; }
        public string work_address { get; set; }
        public string work_date_time { get; set; }
        public string is_on_leave { get; set; }
        public string add_attendence_time { get; set; }
        public string route { get; set; }
        public string leave_from_date { get; set; }
        public string leave_to_date { get; set; }
        public string leave_type { get; set; }
        public List<shopAttendance> shop_list { get; set; }

    }

    public class shopAttendance
    {
        public string route { get; set; }
        public string shop_id { get; set; }

    }
    public class AttendancemanageOutput
    {
        public string status { get; set; }
        public string message { get; set; }

    }


}