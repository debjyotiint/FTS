using BusinessLogicLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ERP.OMS.Reports.XtraReports;
using DevExpress.DataAccess.Sql;
using DevExpress.XtraReports.UI;
using DevExpress.XtraPrinting;
using DevExpress.XtraPrinting.Preview;
using System.Net.Mail;

namespace ERP.Export
{
    public class ExportToPDF
    {

        public void ExportToPdfforEmail(string rptName, string RptModuleName, String mapPath, string PrintType, string DocumentID)
        {
            string filePath = "";
            string Module_name = "";
            string DesignPath = "";
            string PDFFilePath = "";
            string filePathtoPDF = "";
            string ReportType = "";

            #region create Path
            if (RptModuleName == "Invoice")
            {

                Module_name = "SALETAX";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Invoice_POS")
            {

                Module_name = "SALETAX";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\SPOS\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\SPOS\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Install_Coupon")
            {

                Module_name = "INSCUPN";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\InstCoupon\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\InstCoupon\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "BranchReq")
            {

                Module_name = "BRANCHREQ";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\BranchRequisition\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\BranchRequisition\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\BranchRequisition\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\BranchRequisition\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Porder")
            {

                Module_name = "PORDER";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\PurchaseOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\PurchaseOrder\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\PurchaseOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\PurchaseOrder\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Sorder")
            {

                Module_name = "SORDER";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesOrder\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesOrder\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "PIQuotation")
            {
                Module_name = "PIQUOTATION";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\Proforma\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\Proforma\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\Proforma\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\Proforma\DocDesign\PDFFiles\";
                }
            }
            #endregion
            HttpContext.Current.Session["Module_Name"] = Module_name;
            string fullpath = mapPath;
            fullpath = fullpath.Replace("ERP.UI\\", "");
            string DesignFullPath = fullpath + DesignPath;
            filePath = System.IO.Path.GetDirectoryName(DesignFullPath);
            filePath = filePath + "\\" + rptName + ".repx";


            DevExpress.DataAccess.Sql.SqlDataSource sql = GenerateSqlDataSource(RptModuleName, DocumentID);
            XtraReport newXtraReport = XtraReport.FromFile(filePath, true);
            newXtraReport.LoadLayout(filePath);
            newXtraReport.DataSource = sql;
            filePathtoPDF = filePath;
            filePathtoPDF = filePathtoPDF.Split('~')[0];

            if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS")
            {
                if (PrintType == "1")
                {
                    ReportType = "Original";
                }
                else if (PrintType == "2")
                {
                    ReportType = "Duplicate";
                }
                else
                {
                    ReportType = "Triplicate";
                }

                if (RptModuleName == "Invoice")
                {
                    filePathtoPDF = filePathtoPDF.Replace("Normal", "PDFFiles");
                }
                else
                {
                    filePathtoPDF = filePathtoPDF.Replace("SPOS", "PDFFiles");
                }
            }
            else if (RptModuleName == "Install_Coupon")
            {
                filePathtoPDF = filePathtoPDF.Replace("InstCoupon", "PDFFiles");
            }
            else if (RptModuleName == "BranchReq" || RptModuleName == "Porder" || RptModuleName == "Sorder" || RptModuleName == "PIQuotation")
            {
                filePathtoPDF = filePathtoPDF.Replace("Designes", "PDFFiles");
            }
            else
            {
                filePathtoPDF = filePathtoPDF + ".pdf";
            }

            if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS")
            {
                filePathtoPDF = filePathtoPDF + "-" + ReportType + "-" + DocumentID + ".pdf";
            }
            else
            {
                filePathtoPDF = filePathtoPDF + "-" + DocumentID + ".pdf";
            }

            newXtraReport.ExportToPdf(filePathtoPDF);
        }


        private DevExpress.DataAccess.Sql.SqlDataSource GenerateSqlDataSource(String RptModuleName, string DocumentID)
        {
            DevExpress.DataAccess.Sql.SqlDataSource result = new DevExpress.DataAccess.Sql.SqlDataSource("crmConnectionString");
            BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string Module_Name = Convert.ToString(HttpContext.Current.Session["Module_Name"]);
            DataTable dtRptTables = new DataTable();
            string query = "";
            query = @"Select Query_Table_name from tbl_trans_ReportSql where Module_name = '" + Module_Name + "' order by Query_ID ";
            dtRptTables = oDbEngine.GetDataTable(query);
            string[] filePaths = new string[] { };
            string path = System.Web.HttpContext.Current.Server.MapPath("~");
            string path1 = path.Replace("Reports\\", "ERP.UI");
            string fullpath = path1.Replace("\\", "/");
         

            if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS")
            {
                string PrintOption = HttpContext.Current.Request.QueryString["PrintOption"];

                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_TAXINVOICE '" + Convert.ToString(HttpContext.Current.Session["LastCompany"]) + "','" + Convert.ToString(HttpContext.Current.Session["LastFinYear"]) + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "S" + "','" + PrintOption + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Install_Coupon")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_INSTALLATIONCOUPON_REPORT '" + Convert.ToString(HttpContext.Current.Session["LastCompany"]) + "','" + fullpath + "','" + Convert.ToString(HttpContext.Current.Session["LastFinYear"]) + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "BranchReq")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_BRANCHREQ_REPORT '" + Convert.ToString(HttpContext.Current.Session["LastCompany"]) + "','" + Convert.ToString(HttpContext.Current.Session["LastFinYear"]) + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Porder")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASEORDER_REPORT '" + Convert.ToString(HttpContext.Current.Session["LastCompany"]) + "','" + Convert.ToString(HttpContext.Current.Session["LastFinYear"]) + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Sorder")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASEORDER_REPORT '" + Convert.ToString(HttpContext.Current.Session["LastCompany"]) + "','" + Convert.ToString(HttpContext.Current.Session["LastFinYear"]) + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "S" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "PIQuotation")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_PROFORMAINVQUOTATION '" + Convert.ToString(HttpContext.Current.Session["LastCompany"]) + "','" + Convert.ToString(HttpContext.Current.Session["LastFinYear"]) + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }

            DataTable dtRptRelation = new DataTable();
            string RelationQuery = "";
            RelationQuery = @"Select Parent_Query_name,Child_Query_name, Parent_Column_name,Child_Column_name from tbl_trans_ReportTableRelation where Module_name = '" + Module_Name + "' order by Query_ID ";
            dtRptRelation = oDbEngine.GetDataTable(RelationQuery);
            if (dtRptRelation.Rows.Count > 0)
            {
                foreach (DataRow row in dtRptRelation.Rows)
                {
                    result.Relations.Add(Convert.ToString(row[0]), Convert.ToString(row[1]), Convert.ToString(row[2]), Convert.ToString(row[3]));
                }
            }

            result.RebuildResultSchema();
            return result;
        }


    }
}