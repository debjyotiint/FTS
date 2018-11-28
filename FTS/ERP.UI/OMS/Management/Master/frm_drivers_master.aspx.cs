using System;
using System.Web;
using System.Web.UI;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using EntityLayer.CommonELS;
using System.IO;
using BusinessLogicLayer;

namespace ERP.OMS.Management.Master
{
    public partial class frm_drivers_master : ERP.OMS.ViewState_class.VSPage //System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        BusinessLogicLayer.Bank objBankStatementBL = new BusinessLogicLayer.Bank();
        string MyGlobalVariable = "ConnectionStrings:crmConnectionString";
        DriverMasterBL objDriverMasterBL = new DriverMasterBL();
        //bellow code added by debjyoti 17-11-2016
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        //end 17-11-2016
        protected void Page_Init(object sender, EventArgs e)
        {

        }
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Response.Write(); 
                // gridStatusDataSource.
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
           rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/frm_drivers_master.aspx");

            if (HttpContext.Current.Session["userid"] == null)
            {
                //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
         
            //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");

            fillGrid();
            gridStatus.JSProperties["cpDelmsg"] = null;
        }

    
        protected void gridStatus_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                string[] CallVal = e.Parameters.ToString().Split('~');
                // string tranid = e.Parameters.ToString();

                if (CallVal[0].ToString() == "s")
                {
                    gridStatus.Settings.ShowFilterRow = true;
                }
                else if (CallVal[0].ToString() == "All")
                {
                    gridStatus.FilterExpression = string.Empty;
                }
                else if (CallVal[0].ToString() == "Delete")
                {
                 
                    Contact cm=new Contact();
                    DataTable dtdel = cm.DeleteDriver(CallVal[1].ToString());
                    //if (dtdel.Rows.Count > 0)
                    //{
                        //if (Convert.ToString(dtdel.Rows[0]["retval"]) == "999")
                        //{
                        //    gridStatus.JSProperties["cpDelmsg"] = "Used in other modules. Cannot Delete.";
                        //}
                        //else if (Convert.ToString(dtdel.Rows[0]["retval"]) == "1")
                        //{
                            oDBEngine.DeleteValue("tbl_master_contact ", "cnt_id ='" + CallVal[1].ToString() + "'");
                            gridStatus.JSProperties["cpDelmsg"] = "Succesfully Deleted";
                      //  }
                   // }                    
                                    
                        fillGrid();
                 
                }
            }
            catch (Exception ex)
            {

            }

        }


        protected void grdproduct_DataBinding(object sender, EventArgs e)
        {
            if (Session["DtVendata"] != null)
            {
                DataTable productdt = (DataTable)Session["DtVendata"];               
                grdproduct.DataSource = productdt;
                //grdproduct.DataBind();
            }
        }


        public void fillGrid()
        {
            gridStatusDataSource.SelectCommand = "select tbl_master_contact.cnt_id, tbl_master_contact.cnt_internalId, tbl_master_contact.cnt_UCC, tbl_master_contact.cnt_firstName,branch_description=(select branch_description from tbl_master_branch where branch_id=tbl_master_contact.cnt_branchid),tbl_master_contact.cnt_VerifcationRemarks,(select VehiclesRegNo from tbl_trans_VehiclesDriver where DriversInternalId=tbl_master_contact.cnt_InternalId) as VehicleNO from  tbl_master_contact where cnt_contactType='DI' order by tbl_master_contact.cnt_id desc";
            gridStatus.DataBind();
        }
       
        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                //if (Session["exportdriver"] == null)
                //{
                //    Session["exportdriver"] = Filter;
                //    bindexport(Filter);
                //}
                //else if (Convert.ToInt32(Session["exportdriver"]) != Filter)
                //{
                //    Session["exportdriver"] = Filter;
                    bindexport(Filter);
                //}
            } 
        }
        public void bindexport(int Filter)
        {
            gridStatus.Columns[3].Visible = false;
            string filename = "DriverMaster";
            exporter.FileName = filename;
            
            exporter.PageHeader.Left = "Driver Master";
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";

            switch (Filter)
            {
                case 1:
                    exporter.WritePdfToResponse();
                    break;
                case 2:
                    exporter.WriteXlsToResponse();
                    break;
                case 3:
                    exporter.WriteRtfToResponse();
                    break;
                case 4:
                    exporter.WriteCsvToResponse();
                    break;
            }
        }
        protected void WriteToResponse(string fileName, bool saveAsFile, string fileFormat, MemoryStream stream)
        {
            if (Page == null || Page.Response == null) return;
            string disposition = saveAsFile ? "attachment" : "inline";
            Page.Response.Clear();
            Page.Response.Buffer = false;
            Page.Response.AppendHeader("Content-Type", string.Format("application/{0}", fileFormat));
            Page.Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Page.Response.AppendHeader("Content-Disposition", string.Format("{0}; filename={1}.{2}", disposition, HttpUtility.UrlEncode(fileName).Replace("+", "%20"), fileFormat));
            if (stream.Length > 0)
                Page.Response.BinaryWrite(stream.ToArray());
            //Page.Response.End();
        }

        


        protected void propanel_Callback1(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            string[] data = e.Parameter.Split('~');
            if (data[0] == "ShowHistory")
            {
                DataTable productdt = objDriverMasterBL.PopulateDriverDetail(Convert.ToString(data[1]));
                Session["DtVendata"] = productdt;
                grdproduct.DataSource = productdt;
                grdproduct.DataBind();

            }
        }

    }
}