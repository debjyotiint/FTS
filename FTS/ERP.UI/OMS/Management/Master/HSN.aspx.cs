using System;
using System.Web;
//using DevExpress.Web;
using DevExpress.Web;
using System.Configuration;
using ClsDropDownlistNameSpace;
using EntityLayer.CommonELS;
using System.Collections.Generic;
using System.Data;
using BusinessLogicLayer;

namespace ERP.OMS.Management.Master
{
    public partial class HSN : System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        BusinessLogicLayer.MasterDataCheckingBL masterChecking = new BusinessLogicLayer.MasterDataCheckingBL();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        BusinessLogicLayer.UdfGroupMasterBL udfBl = new BusinessLogicLayer.UdfGroupMasterBL();

        clsDropDownList OclsDropDownList = new clsDropDownList();

        string[] lengthIndex;
        string RemarksId;
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
                //debjyoti
                Session["exportval"] = null;
            }

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/HSN.aspx");
            SqlDataSource1.ConnectionString = ConfigurationManager.AppSettings["DBConnectionDefault"];
            if (!IsPostBack)
            {
                
                //string[,] list = oDBEngine.GetFieldValue("tbl_master_UDFApplicable", "APP_CODE, APP_NAME", "IS_ACTIVE=1", 2, "ORDER_BY");
                //OclsDropDownList.AddDataToDropDownListToAspx(list, CboApplicableFor, false);

            }


        }

        protected void gridudfGroup_HtmlRowCreated(object sender, DevExpress.Web.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType == GridViewRowType.Data)
            {
                int commandColumnIndex = -1;
                for (int i = 0; i < gridudfGroup.Columns.Count; i++)
                    if (gridudfGroup.Columns[i] is GridViewCommandColumn)
                    {
                        commandColumnIndex = i;
                        break;
                    }
                if (commandColumnIndex == -1)
                {
                    return;
                }
                //____One colum has been hided so index of command column will be leass by 1 
                commandColumnIndex = commandColumnIndex;
                DevExpress.Web.Rendering.GridViewTableCommandCell cell = e.Row.Cells[commandColumnIndex] as DevExpress.Web.Rendering.GridViewTableCommandCell;
                for (int i = 0; i < cell.Controls.Count; i++)
                {
                    DevExpress.Web.Rendering.GridCommandButtonsCell button = cell.Controls[i] as DevExpress.Web.Rendering.GridCommandButtonsCell;
                    if (button == null) return;
                    DevExpress.Web.Internal.InternalHyperLink hyperlink = button.Controls[0] as DevExpress.Web.Internal.InternalHyperLink;

                    if (hyperlink.Text == "Delete")
                    {
                        if (Session["PageAccess"] == "DelAdd" || Session["PageAccess"] == "Delete" || Session["PageAccess"] == "All")
                        {
                            hyperlink.Enabled = true;
                            continue;
                        }
                        else
                        {
                            hyperlink.Enabled = false;
                            continue;
                        }
                    }


                }

            }

        }

        protected void gridudfGroup_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                gridudfGroup.JSProperties["cpHide"] = null;
                gridudfGroup.JSProperties["cpMsg"] = null;
                gridudfGroup.JSProperties["cpEditJson"] = null;

                string[] lengthIndex;
                lengthIndex = e.Parameters.Split('~');

                if (lengthIndex[0].ToString() == "SAVE_NEW")
                {
                    ProductComponentBL pbl = new ProductComponentBL();
                    int retData = pbl.InsertHSN(txtCode.Text.Trim(), txtDescription.Text.Trim(),"HSN");
                    if (retData==1)
                    {
                        gridudfGroup.JSProperties["cpHide"] = "Y";
                        gridudfGroup.JSProperties["cpMsg"] = "Saved Successfully";
                    }
                    else if (retData == 999)
                    {
                        gridudfGroup.JSProperties["cpHide"] = "N";
                        gridudfGroup.JSProperties["cpMsg"] = "HSN Code already exists";
                    }
                }

               
                gridudfGroup.DataBind();
                gridudfGroup.Settings.ShowFilterRow = true;

            }
            catch (Exception ex)
            {

            }
        }
        protected void gridudfGroup_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e)
        {
            e.Properties["cpHeight"] = "All";
        }

        private void DataBinderSegmentSpecific()
        {

            SqlDataSource1.SelectCommand = "select HSN_Id, Code, [Description] from tbl_HSN_Master";

            gridudfGroup.DataBind();


        }

        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {

            //Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            //if (Filter != 0)
            //{
            //    if (Session["exportval"] == null)
            //    {
            //        Session["exportval"] = Filter;
            //        bindexport(Filter);
            //    }
            //    else if (Convert.ToInt32(Session["exportval"]) != Filter)
            //    {
            //        Session["exportval"] = Filter;
            //        bindexport(Filter);
            //    }
            //}





        }

        public void bindexport(int Filter)
        {
            gridudfGroup.Columns[4].Visible = false;


            //exporter.FileName = "UDF Group Master";
            //exporter.ReportHeader = "UDF Group Master";
            //exporter.PageFooter.Center = "[Page # of Pages #]";
            //exporter.PageFooter.Right = "[Date Printed]";

            //switch (Filter)
            //{
            //    case 1:
            //        exporter.WritePdfToResponse();
            //        break;
            //    case 2:
            //        exporter.WriteXlsToResponse();
            //        break;
            //    case 3:
            //        exporter.WriteRtfToResponse();
            //        break;
            //    case 4:
            //        exporter.WriteCsvToResponse();
            //        break;
            //}
        }

    }
}