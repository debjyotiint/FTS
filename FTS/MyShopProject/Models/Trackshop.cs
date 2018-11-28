using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models
{
    public class Trackshop
    {
        public string Lat_visit { get; set; }
        public string Long_visit { get; set; }

        public List<TracksalesmanAreaTrack> salesmanarea { get; set; }
        public string location_name { get; set; }

        public string SDate { get; set; }

        public string loginstatus { get; set; }
        public string latlanLogin { get; set; }

        public string latlanLogout { get; set; }

        public string Fullresponse { get; set; }


    }
    public class UserListTrackModel
    {
        public string selectedusrid { get; set; }

        public string Date { get; set; }
        public List<GetUsers> userlsit { get; set; }




    }

    public class TracksalesmanArea
    {

        public string title { get; set; }
        public string lat { get; set; }
        public string lng { get; set; }
        public string description { get; set; }
        public string SDate { get; set; }
        public string loginstatus { get; set; }
    }


    public class TracksalesmanAreaTrack
    {

        public string title { get; set; }
        public string lat { get; set; }
        public string lng { get; set; }
        public string description { get; set; }
        public string SDate { get; set; }
        public string loginstatus { get; set; }

        public string location { get; set; }
    }
}