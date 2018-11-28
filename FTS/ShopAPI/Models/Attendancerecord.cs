﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShopAPI.Models
{

    public class AttendancerecordInput
    {


        public string session_token { get; set; }
        public string user_id { get; set; }
        public string start_date { get; set; }
        public string end_date { get; set; }


    }


    public class AttendancerecordOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        //public DatalistsAttendance data { get; set; }

        public List<Attendancerecord> shop_list { get; set; }

    }

    public class DatalistsAttendance
    {

        public string session_token { get; set; }

   

    }

    public class Attendancerecord
    {
        public DateTime? login_date { get; set; }
        public DateTime? login_time { get; set; }

        public DateTime? logout_time { get; set; }

        public string duration { get; set; }
        public string Isonleave { get; set; }

        //public string login_date { get; set; }
        //public DateTime? login_time { get; set; }

        //public DateTime? logout_time { get; set; }
        //public string logout_date { get; set; }

        //public string duration { get; set; }


    }

  
}