using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models
{
    public class OrderDetailsListInput
    {
        public string selectedusrid { get; set; }

        public List<GetUserName> userlsit { get; set; }
        public string stateid { get; set; }
        public List<GetStateName> statelist { get; set; }
        public string shopId { get; set; }
        public List<Getmaster> shoplist { get; set; }
        public string Fromdate { get; set; }

        public string Todate { get; set; }

        public string usertype { get; set; }

    }


    public class Getmaster
    {
        public string ID { get; set; }
        public string Name { get; set; }

    }


    public class GetStateName
    {
        public string ID { get; set; }
        public string StateName { get; set; }

    }
    public class GetUserName
    {
        public string UserID { get; set; }
        public string username { get; set; }


    }

    public class OrderDetailsListOutput
    {
        public string shop_name { get; set; }

        public string address { get; set; }

        public string owner_name { get; set; }

        public string owner_contact_no { get; set; }

        public decimal order_amount { get; set; }

        public DateTime? Orderdate { get; set; }

        public decimal collection { get; set; }

        public string Shoptype { get; set; }

        public string UserName { get; set; }
        public string Order_Description { get; set; }
        public string State { get; set; }

    }



}