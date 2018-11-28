using System;
using System.Web;
using DevExpress.Web;
using BusinessLogicLayer;

public partial class management_master_Store_sMarkets : System.Web.UI.Page
{
    public string pageAccess = "";
  //  DBEngine oDBEngine = new DBEngine(string.Empty);
    BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
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
        //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");
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
    protected void marketsGrid_HtmlRowCreated(object sender, DevExpress.Web.ASPxGridViewTableRowEventArgs e)
    {
        if (e.RowType == GridViewRowType.Data)
        {
            int commandColumnIndex = -1;
            for (int i = 0; i < marketsGrid.Columns.Count; i++)
                if (marketsGrid.Columns[i] is GridViewCommandColumn)
                {
                    commandColumnIndex = i;
                    break;
                }
            if (commandColumnIndex == -1)
                return;
            //____One colum has been hided so index of command column will be leass by 1 
            commandColumnIndex = commandColumnIndex - 5;
            DevExpress.Web.Rendering.GridViewTableCommandCell cell = e.Row.Cells[commandColumnIndex] as DevExpress.Web.Rendering.GridViewTableCommandCell;
            for (int i = 0; i < cell.Controls.Count; i++)
            {
                DevExpress.Web.Rendering.GridCommandButtonsCell button = cell.Controls[i] as DevExpress.Web.Rendering.GridCommandButtonsCell;
                if (button == null) return;
                DevExpress.Web.Internal.InternalHyperLink hyperlink = button.Controls[0] as DevExpress.Web.Internal.InternalHyperLink;

                if (hyperlink.Text == "Delete")
                {
                    if (Session["PageAccess"].ToString() == "DelAdd" || Session["PageAccess"].ToString() == "Delete" || Session["PageAccess"].ToString() == "All")
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
    protected void marketsGrid_HtmlEditFormCreated(object sender, ASPxGridViewEditFormEventArgs e)
    {
        if (!marketsGrid.IsNewRowEditing)
        {
            ASPxGridViewTemplateReplacement RT = marketsGrid.FindEditFormTemplateControl("UpdateButton") as ASPxGridViewTemplateReplacement;
            if (Session["PageAccess"].ToString().Trim() == "Add" || Session["PageAccess"].ToString().Trim() == "Modify" || Session["PageAccess"].ToString().Trim() == "All")
                RT.Visible = true;
            else
                RT.Visible = false;
        }

    }
    protected void marketsGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
    {
        if (e.Parameters == "s")
            marketsGrid.Settings.ShowFilterRow = true;

        if (e.Parameters == "All")
        {
            marketsGrid.FilterExpression = string.Empty;
        }
    }
}
