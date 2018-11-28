using System;
using System.Web;
using System.Web.UI;
using DevExpress.Web;
using BusinessLogicLayer;
using EntityLayer.CommonELS;

namespace ERP.OMS.Management.Master
{
    public partial class management_master_frm_workingShedule : ERP.OMS.ViewState_class.VSPage //System.Web.UI.Page
    {
        int NoOfRow = 0;
        public string pageAccess = "";
        //DBEngine oDBEngine = new DBEngine(string.Empty);
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/frm_workingShedule.aspx");
         

            if (HttpContext.Current.Session["userid"] == null)
            {
               //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
            Session["KeyVal"] = null;
            WorkingHourDataSource.SelectCommand = " select wor_id,wor_scheduleName,(IsNULL(wor_mondayBeginTime,'') + '-'+IsNULL(wor_mondayEndTime,'')) as mondayTime,(IsNULL(wor_tuesdayBeginTime,'') + '-'+IsNULL(wor_tuesdayEndTime,'')) as tuesdayTime,(IsNULL(wor_wednesdayBeginTime,'') + '-'+IsNULL(wor_wednesdayEndTime,'')) as wednesdayTime,(IsNULL(wor_thursdayBeginTime,'') + '-'+IsNULL(wor_thursdayEndTime,'')) as thursdayTime,(IsNULL(wor_fridayBeginTime,'') + '-'+IsNULL(wor_fridayEndTime,'')) as fridayTime,(IsNULL(wor_saturdayBeginTime,'') + '-'+IsNULL(wor_saturdayEndTime,'')) as saturdayTime,(IsNULL(wor_sundayBeginTime,'') + '-'+IsNULL(wor_sundayEndTime,'')) as sundayTime from tbl_Master_workingHours ";
            WorkingHourGrid.DataBind();
            //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");
        }
        protected void EmployeeGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            WorkingHourGrid.ClearSort();
            WorkingHourGrid.DataBind();
        }

        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(cmbExport.SelectedItem.Value.ToString());
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
    }
}