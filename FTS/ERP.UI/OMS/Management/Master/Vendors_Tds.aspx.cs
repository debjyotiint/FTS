using BusinessLogicLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ERP.OMS.Management.Master
{
    public partial class Vendors_Tds : ERP.OMS.ViewState_class.VSPage
    {
        BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        VendorTDSBl tdsdetails = new VendorTDSBl(); 
        protected void Page_Load(object sender, EventArgs e)
        {
            string InternalId = Convert.ToString(Session["KeyVal_InternalID"]);
            if (InternalId != "")
            {
                if (!IsPostBack)
                {
                    showDtat(InternalId);
                }
            }
        }

        private void showDtat(string InternalId)
        {
            DataTable tdsDetails = tdsdetails.GetVendorTdsDetails(InternalId);
            if (tdsDetails.Rows.Count > 0)
            {
                HdMode.Value = "Edit";
                aspxDeductees.Value = tdsDetails.Rows[0]["TDS_Deductees"];
            }
            else {
                HdMode.Value = "Add";
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string InternalId = Convert.ToString(Session["KeyVal_InternalID"]);
            if (Convert.ToString(HdMode.Value) == "Add")
            {
                tdsdetails.SaveVendorTDSMap(InternalId, Convert.ToString(aspxDeductees.Value), Convert.ToInt32(Session["userid"]));
                HdMode.Value = "Edit";
            }
            else if (Convert.ToString(HdMode.Value) == "Edit")
            {
                tdsdetails.UpdateVendorTDSMap(InternalId, Convert.ToString(aspxDeductees.Value), Convert.ToInt32(Session["userid"]));
            }
            
        }

    }
}