﻿using DataAccessLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SalesmanTrack
{
    public class Shop
    {

        public DataTable GetShopList(string userid, string fromdate, string todate, string cont, string weburl,string stateId)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("SP_API_Getshoplists_Report");
            proc.AddPara("@user_id", userid);
            proc.AddPara("@Uniquecont", cont);
            proc.AddPara("@FromDate", fromdate);
            proc.AddPara("@Todate", todate);
            proc.AddPara("@Weburl", weburl);
            proc.AddPara("@StateId", stateId);
            proc.AddPara("@Action", "ShopDetails");
            ds = proc.GetTable();
            return ds;
        }

        public DataSet GetShopListHierarchy(string userid, string fromdate, string todate, string weburl,string DesgId,string stateid,int pagenumber,int pagecount)
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("SP_API_Getshoplists_Report_Hiaerarchy");
            proc.AddPara("@user_id", userid);
            proc.AddPara("@FromDate", fromdate);
            proc.AddPara("@Todate", todate);
            proc.AddPara("@Weburl", weburl);
            proc.AddPara("@DesgId", DesgId);
            proc.AddPara("@StateId", stateid);
            proc.AddPara("@startindex", pagenumber);
            proc.AddPara("@Maxdata", pagecount);
            ds = proc.GetDataSet();
            return ds;
        }


        public DataTable GetTypesList()
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("SP_API_Getshoplists_Report");
            proc.AddPara("@Action", "Gettypes");
            ds = proc.GetTable();
            return ds;
        }

        public int ShopModify(string shopid,string address,string pincode,string shopname,string ownername,string ownercontact,string owneremail,string types,string dob,string doanniversary)
        {
            int s = 0;
            ProcedureExecute proc = new ProcedureExecute("SP_API_Getshoplists_Report");
            proc.AddPara("@shopid", shopid);
            proc.AddPara("@address", address);
            proc.AddPara("@pincode", pincode);
            proc.AddPara("@shopname", shopname);
            proc.AddPara("@ownername", ownername);
            proc.AddPara("@ownercontact", ownercontact);
            proc.AddPara("@owneremail", owneremail);
            proc.AddPara("@dob", dob);
            proc.AddPara("@doanniversary", doanniversary);
            proc.AddPara("@Action", "Modify");
            s=proc.RunActionQuery();

            return s;
        }

        public int ShopDelete(string shopid)
        {
            int s = 0;
            ProcedureExecute proc = new ProcedureExecute("SP_API_Getshoplists_Report");
            proc.AddPara("@shopid", shopid);
            proc.AddPara("@Action", "Delete");
            s = proc.RunActionQuery();

            return s;
        }


        public DataTable ShopGetDetails(string shopid)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("SP_API_Getshoplists_Report");
            proc.AddPara("@shopid", shopid);
            proc.AddPara("@Action", "ShopDetailsById");
            ds = proc.GetTable();
            return ds;
        }



        public DataTable GetShopListCounterwise(string shoptype,  string weburl, string stateId)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("SP_API_Getshoplists_Report");
            proc.AddPara("@Shoptype", shoptype);
            proc.AddPara("@Weburl", weburl);
            proc.AddPara("@StateId", stateId);
            proc.AddPara("@Action", "Counter");
            ds = proc.GetTable();
            return ds;
        }



    }
}
