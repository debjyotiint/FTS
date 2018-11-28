using DataAccessLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogicLayer.SalesmanTrack
{

    

    public class OrderList
    {
        public DataTable GetallorderList(string stateid, string shopid, string fromdate, string todate,  int userid)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Proc_FTS_OrderListADMIN");

            proc.AddPara("@start_date", fromdate);
            proc.AddPara("@end_date", todate);
            proc.AddPara("@stateID", stateid);

            proc.AddPara("@shop_id", shopid);
            proc.AddPara("@user_id", userid);

            ds = proc.GetTable();

            return ds;
        }
    }


  

 

}
