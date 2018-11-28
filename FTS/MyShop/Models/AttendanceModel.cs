using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models
{
    public class AttendanceModelInput
    {
        public string selectedusrid { get; set; }


        public List<GetUsersshopsforattendance> userlsit { get; set; }
        public string Fromdate { get; set; }

        public string Todate { get; set; }

    }

    public class GetUsersshopsforattendance
    {
        public string UserID { get; set; }
        public string username { get; set; }

    }


    public class AttendancerecordModel
    {
        public DateTime? login_date { get; set; }
        public DateTime? login_time { get; set; }

        public DateTime? logout_time { get; set; }

        public string duration { get; set; }
        public string Mintime { get; set; }
        public string Maxtime { get; set; }

        public string Minvisittime { get; set; }
        public string Maxvisittime { get; set; }

    }



    public class AttendanceListModel
    {
        public DateTime? login_date { get; set; }
        public DateTime? login_time { get; set; }

        public DateTime? logout_time { get; set; }

        public string duration { get; set; }
        public string Mintime { get; set; }
        public string Maxtime { get; set; }

        public string Minvisittime { get; set; }
        public string Maxvisittime { get; set; }
        public string Isonleave { get; set; }
        public string lateday { get; set; }
        public string user_name { get; set; }
        public string Designation { get; set; }

    }

}