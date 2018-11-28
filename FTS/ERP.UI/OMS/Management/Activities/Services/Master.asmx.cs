using DataAccessLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

namespace ERP.OMS.Management.Activities.Services
{
    /// <summary>
    /// Summary description for Master 
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Master : System.Web.Services.WebService
    {
        [WebMethod(EnableSession=true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetCustomer(string SearchKey)
        {
            List<CustomerModel> listCust = new List<CustomerModel>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable cust = oDBEngine.GetDataTable("select cnt_internalid ,uniquename ,Name,Billing  from ( select top 10 cnt_internalid ,uniquename ,Name ,Billing,len(Name)size  from v_pos_customerDetails where uniquename like '%" + SearchKey + "%' or Name like '%" + SearchKey + "%' )a order by size");
              
               
                listCust = (from DataRow dr in cust.Rows
                            select new CustomerModel()
                            {
                                id = dr["cnt_internalid"].ToString(),
                                Na = dr["Name"].ToString(),
                                UId = Convert.ToString(dr["uniquename"]),
                                add = Convert.ToString(dr["Billing"])
                            }).ToList();
            }

            return listCust;
        }


        public object GetMainAccountForPaymentDet(string BranchId)
        {
            List<MainActPaymentDet> listMainAct = new List<MainActPaymentDet>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                ProcedureExecute proc = new ProcedureExecute("prc_ucPayementDetails");
                proc.AddVarcharPara("@action", 50, "GetMainActByBranch");
                proc.AddIntegerPara("@branchId", Convert.ToInt32(BranchId));
                DataTable Addresstbl = proc.GetTable();

                listMainAct = (from DataRow dr in Addresstbl.Rows
                               select new MainActPaymentDet()
                            {
                                MainAccount_AccountCode =Convert.ToString( dr["MainAccount_AccountCode"]),
                                MainAccount_Name = Convert.ToString(dr["MainAccount_Name"]),
                                MainAccount_BankCashType = Convert.ToString(dr["MainAccount_BankCashType"]),
                                MainAccount_branchId = Convert.ToInt64(dr["MainAccount_branchId"])
                            }).ToList();
            }

            return listMainAct;
        }



        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetSalesManAgent(string SearchKey)
        {
            List<SalesManAgntModel> listSalesMan = new List<SalesManAgntModel>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable cust = oDBEngine.GetDataTable("select top 10 cnt_id ,Name from v_GetAllSalesManAgent where  Name like '%" + SearchKey + "%'");


                listSalesMan = (from DataRow dr in cust.Rows
                            select new SalesManAgntModel()
                            {
                                id = dr["cnt_id"].ToString(),
                                Na = dr["Name"].ToString()
                            }).ToList();
            }

            return listSalesMan;
        }


        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetMainAccountJournal(string SearchKey, string branchId)
        {
            List<MainAccountJournal> listMainAccount = new List<MainAccountJournal>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable cust = oDBEngine.GetDataTable("select top 10 MainAccount_Name,MainAccount_ReferenceID,MainAccount_SubLedgerType,MainAccount_branchId,MainAccount_BankCompany,MainAccount_AccountCode  from v_MainAccountList_journal where MainAccount_Name like '%" + SearchKey + "%' or MainAccount_AccountCode like '%" + SearchKey + "%' and (MainAccount_branchId=0 or MainAccount_branchId='" + branchId + "')");


                listMainAccount = (from DataRow dr in cust.Rows
                                   select new MainAccountJournal()
                                   {
                                       MainAccount_ReferenceID = Convert.ToInt32(dr["MainAccount_ReferenceID"]),
                                       MainAccount_Name = dr["MainAccount_Name"].ToString(),
                                       MainAccount_AccountCode = Convert.ToString(dr["MainAccount_AccountCode"]),

                                       MainAccount_SubLedgerType = Convert.ToString(dr["MainAccount_SubLedgerType"])

                                   }).ToList();
            }

            return listMainAccount;
        }



        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetSubAccountJournal(string SearchKey, string MainAccountCode)
        {
            List<SubAccount> listSubAccount = new List<SubAccount>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable cust = oDBEngine.GetDataTable("select top 10 Contact_Name,SubAccount_ReferenceID,MainAccount_SubLedgerType  from v_SubAccountList where Contact_Name like '%" + SearchKey + "%'  and mainaccount_referenceid='" + MainAccountCode + "'");


                listSubAccount = (from DataRow dr in cust.Rows
                                   select new SubAccount()
                                   {
                                       SubAccount_ReferenceID = Convert.ToString(dr["SubAccount_ReferenceID"]),
                                       Contact_Name = dr["Contact_Name"].ToString(),
                                       MainAccount_SubLedgerType = Convert.ToString(dr["MainAccount_SubLedgerType"])                                      

                                   }).ToList();
            }

            return listSubAccount;
        }



        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetVendorWithBranch(string SearchKey, string BranchID)
        {
            List<VendorModel> listVen = new List<VendorModel>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);

                string strQuery = @"Select top 10 * From (Select cnt_internalid,IsNull(cnt_shortName,'NA') as uniquename,IsNull(cnt_firstName,'')+IsNull(cnt_middleName,'')+IsNull(cnt_lastName,'') as Name 
                                    From tbl_master_contact Where cnt_contactType ='DV' AND 
                                    cnt_internalId in (Select Ven_InternalId from tbl_master_VendorBranch_map Where branch_id in('" + BranchID + "','0'))) as tbl " +
                                    "Where uniquename like '%" + SearchKey + "%' or Name like '%" + SearchKey + "%'";

                DataTable dt = oDBEngine.GetDataTable(strQuery);
                listVen = (from DataRow dr in dt.Rows
                           select new VendorModel()
                           {
                               id = dr["cnt_internalid"].ToString(),
                               Na = dr["Name"].ToString(),
                               UId = Convert.ToString(dr["uniquename"])
                           }).ToList();
            }

            return listVen;
        }


        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetVendorWithOutBranch(string SearchKey)
        {
            //string[] SearchKeyList = SearchList.Split(new string[] { "||@||" }, StringSplitOptions.None);
            //string SearchKey = SearchKeyList[0];
            //string BranchID = SearchKeyList[1];

            List<VendorModel> listVen = new List<VendorModel>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);

                string strQuery = @"Select top 10  * From (Select cnt_internalid,IsNull(cnt_shortName,'NA') as uniquename,IsNull(cnt_firstName,'')+IsNull(cnt_middleName,'')+IsNull(cnt_lastName,'') as Name 
                                    From tbl_master_contact Where cnt_contactType ='DV' 
                                  ) as tbl " +
                                    " Where uniquename like '%" + SearchKey + "%' or Name like '%" + SearchKey + "%'";

                DataTable dt = oDBEngine.GetDataTable(strQuery);
                listVen = (from DataRow dr in dt.Rows
                           select new VendorModel()
                           {
                               id = dr["cnt_internalid"].ToString(),
                               Na = dr["Name"].ToString(),
                               UId = Convert.ToString(dr["uniquename"])
                           }).ToList();
            }

            return listVen;
        }


        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetPosProduct(string SearchKey)
        {
            List<PosProductModel> listCust = new List<PosProductModel>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable cust = oDBEngine.GetDataTable("select top 10  Products_ID,Products_Name ,Products_Description ,HSNSAC  from v_Product_MargeDetailsPOS where Products_Name like '%" + SearchKey + "%'  or Products_Description  like '%" + SearchKey + "%' ");


                listCust = (from DataRow dr in cust.Rows
                            select new PosProductModel()
                            {
                                id = dr["Products_ID"].ToString(),
                                Na = dr["Products_Name"].ToString(),
                                Des = Convert.ToString(dr["Products_Description"]),
                                HSN = Convert.ToString(dr["HSNSAC"])
                            }).ToList();
            }

            return listCust;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public object GetCustomerAddress(string CustomerId)
        {
            List<AddressDetails> address = new List<AddressDetails>();
            if (HttpContext.Current.Session["userid"] != null)
            {
                ProcedureExecute proc = new ProcedureExecute("prc_posCustomerBillingShipping");
                proc.AddVarcharPara("@Action", 50, "PopulatebyCustomerId");
                proc.AddVarcharPara("@customerId", 10, CustomerId);
                DataTable Addresstbl = proc.GetTable();

                address = (from DataRow dr in Addresstbl.Rows
                           select new AddressDetails()
                           {
                               id = Convert.ToInt32(dr["add_id"]),
                               Type = Convert.ToString(dr["Type"]),
                               add_address1 = Convert.ToString(dr["add_address1"]),
                               add_address2 = Convert.ToString(dr["add_address2"]),
                               add_address3 = Convert.ToString(dr["add_address3"]),
                               couId = Convert.ToInt32(dr["couId"]),
                               conName = Convert.ToString(dr["conName"]),
                               stId = Convert.ToInt32(dr["stId"]),
                               stName = Convert.ToString(dr["stName"]),
                               pnId = Convert.ToInt32(dr["pnId"]),
                               pnCd = Convert.ToString(dr["pnCd"]),
                               ctyId = Convert.ToInt32(dr["ctyId"]),
                               ctyName = Convert.ToString(dr["ctyName"]),
                               landMk = Convert.ToString(dr["add_landMark"]),
                               deflt = Convert.ToBoolean(dr["Isdefault"])

                           }).ToList();

                return address;
            }

            return null;
        }

        public class CustomerModel
        {
            public string id { get; set; }
            public string Na { get; set; }
            public string UId { get; set; }
            public string add { get; set; }
        }

        public class SalesManAgntModel
        {
            public string id { get; set; }
            public string Na { get; set; }
        }

        public class VendorModel
        {
            public string id { get; set; }
            public string Na { get; set; }
            public string UId { get; set; }
        }

        public class PosProductModel
        {
            public string id { get; set; }
            public string Na { get; set; }
            public string Des { get; set; }
            public string HSN { get; set; }
        }
        public class MainAccountJournal
        {
            public int MainAccount_ReferenceID { get; set; }
            public string MainAccount_Name { get; set; }
            public string MainAccount_AccountCode { get; set; }


            public string MainAccount_SubLedgerType { get; set; }
           

        }
        public class SubAccount
        {
            public string SubAccount_ReferenceID { get; set; }
            public string Contact_Name { get; set; }
            public string MainAccount_SubLedgerType { get; set; }


        }
        public class AddressDetails
        {
            public int id { get; set; }
            public string Type { get; set; }
            public string add_address1 { get; set; }
            public string add_address2 { get; set; }
            public string add_address3 { get; set; }
            public int couId { get; set; }
            public string conName { get; set; }
            public int stId { get; set; }
            public string stName { get; set; }
            public int pnId { get; set; }
            public string pnCd { get; set; }
            public int ctyId { get; set; }
            public string ctyName { get; set; }
            public string landMk { get; set; }
            public bool deflt { get; set; }
        
        }
        public class MainActPaymentDet
        {
            public string MainAccount_Name { get; set; }
            public string MainAccount_AccountCode { get; set; }
            public string MainAccount_BankCashType { get; set; }
            public Int64 MainAccount_branchId { get; set; }
        }
    }
}
