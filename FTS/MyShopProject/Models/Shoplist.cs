using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Models
{

    public class ShopslistInput
    {
        public string selectedusrid { get; set; }
        public string StateId { get; set; }
        public List<GetUsersshops> userlsit { get; set; }
        public List<GetUsersStates> states { get; set; }
        public string Fromdate { get; set; }
        public string Todate { get; set; }
        public int Uniquecont { get; set; }

    }


    public class GetUsersshops
    {
        public string UserID { get; set; }
        public string username { get; set; }
    }


    public class GetUsersStates
    {
        public string ID { get; set; }
        public string StateName { get; set; }
    }


    public class Shopslists
    {

        public string shop_Auto { get; set; }
        public string UserName { get; set; }
        public string shop_id { get; set; }
        [Required]
        public string shop_name { get; set; }
        [Required]
        public string address { get; set; }
        [Required]
        public string pin_code { get; set; }
       
        public string shop_lat { get; set; }
        
        public string shop_long { get; set; }
        [Required]
        public string owner_name { get; set; }
        [Required]
        public string owner_contact_no { get; set; }


        [Required]
        [RegularExpression(".+\\@.+\\..+", ErrorMessage = "Please Enter your valid email")]
        public string owner_email { get; set; }

        public string Shop_Image { get; set; }


        public string PP { get; set; }

        public string DD { get; set; }


        public DateTime? Shop_CreateTime { get; set; }

        public DateTime? dob { get; set; }

        public DateTime? date_aniversary { get; set; }
        public string Shoptype { get; set; }

        public List<shopTypes> shptypes { get; set; }


        public string dobstr { get; set; }

        public string date_aniversarystr { get; set; }
        public string time_shop { get; set; }

        public int countactivity { get; set; }

        public string Lastactivitydate { get; set; }

    }

    public class shopTypes
    {
        public string ID { get; set; }

        public string Name { get; set; }
    }


}