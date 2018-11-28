using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ShopAPI.Controllers
{
    public class FileUploadController : Controller
    {
        //
        // GET: /FileUpload/
        [AcceptVerbs("POST")]
        public JsonResult UploadOutletImages(HttpPostedFileBase imageData, string imagePath)
        {
            //EventLogEL eventlog;
            //LogBL log = new LogBL();
            //FileUploadEL result = new FileUploadEL();
            //string IsServerPath = Convert.ToString(ConfigurationManager.AppSettings["IsServerPath"]);
            //string UploadFileDirectory = Convert.ToString(ConfigurationManager.AppSettings["UploadImagePathDirectory"]);
            //if (imageData == null || imageData.ContentLength <= 0)
            //{
            //    result.IsSuccess = false;
            //    result.responseCode = "201";
            //    result.responseMessage = "File is required!";
            //    eventlog = new EventLogEL() {
            //        DateTime = DateTime.Now.ToString(),
            //        EventName = "UploadOutletImages",
            //        ResultMessage = result.responseMessage, 
            //        EventDecription = "Parameters(imageData=null, imagePath=" + imagePath + ")",
            //        OtherInfo = "Please select a file before upload.",
            //    };
            //    log.MaintainLog(eventlog);
            //    return Json(result);
            //}
            //else
            //{
            //    if (imageData.ContentLength > 5242880)
            //    {
            //        result.IsSuccess = false;
            //        result.responseCode = "201";
            //        result.responseMessage = "File size must be less than 5 mb!";
            //        eventlog = new EventLogEL()
            //        {
            //            DateTime = DateTime.Now.ToString(),
            //            EventName = "UploadOutletImages",
            //            ResultMessage = result.responseMessage,
            //            ImageName = imageData.FileName,
            //            EventDecription = "Parameters(imageData=" + imageData.FileName + ", imagePath=" + imagePath + ")",
            //            OtherInfo = "Please compress the file.",
            //        };
            //        log.MaintainLog(eventlog);
            //        return Json(result);
            //    }
            //}  
            //if (string.IsNullOrWhiteSpace(imagePath))
            //{
            //    result.IsSuccess = false;
            //    result.responseCode = "201";
            //    result.responseMessage = "File name with proper path is required!";
            //    eventlog = new EventLogEL()
            //    {
            //        DateTime = DateTime.Now.ToString(),
            //        EventName = "UploadOutletImages",
            //        ResultMessage = result.responseMessage,
            //        ImageName = imageData.FileName,
            //        EventDecription = "Parameters(imageData=" + imageData.FileName + ", imagePath=" + imagePath + ")",
            //        OtherInfo = "Please provide a proper path with image name i.e(/<ROOT FOLDER>/<SUB FOLDER>/<IMAGE NAME>.<EXTENSION NAME>).",
            //    };
            //    log.MaintainLog(eventlog);
            //    return Json(result);
            //}  
            //try
            //{
            //    string[] ImageContainArry = imagePath.Split('/');
            //    string RootDirectory = string.Empty;
            //    string SubFolder = string.Empty;
            //    string ImageName = string.Empty; 
            //    if (ImageContainArry.Count() > 0)
            //    {
            //        RootDirectory = ImageContainArry[0];
            //    }
            //    if (ImageContainArry.Count() > 1)
            //    {
            //        SubFolder = ImageContainArry[1];
            //    }
            //    if (ImageContainArry.Count() > 2)
            //    {
            //        ImageName = ImageContainArry[2];
            //    } 
            //    if(IsServerPath == "no")
            //    {
            //        if (!System.IO.Directory.Exists(Path.Combine(UploadFileDirectory + "/" + RootDirectory + "/" + SubFolder)))
            //        {
            //            System.IO.Directory.CreateDirectory(UploadFileDirectory + "/" + RootDirectory + "/" + SubFolder);
            //            string vPath = Path.Combine(UploadFileDirectory + "/" + RootDirectory + "/" + SubFolder, ImageName);
            //            imageData.SaveAs(vPath);

            //            result.IsSuccess = true;
            //            result.responseMessage = "Success";
            //            result.responseCode = "200";
            //            result.imagePath = imagePath; 
            //            return Json(result);
            //        }
            //        else
            //        {
            //            if(!System.IO.File.Exists(Path.Combine(UploadFileDirectory + "/" + RootDirectory + "/" + SubFolder, ImageName)))
            //            {
            //                string vPath = Path.Combine(UploadFileDirectory + "/" + RootDirectory + "/" + SubFolder, ImageName);
            //                imageData.SaveAs(vPath);

            //                result.IsSuccess = true;
            //                result.responseMessage = "Success";
            //                result.responseCode = "200";
            //                result.imagePath = imagePath; 
            //                return Json(result);
            //            }
            //            else
            //            {
            //                result.IsSuccess = true;
            //                result.responseMessage = "File already exist.";
            //                result.responseCode = "201";
            //                result.imagePath = imagePath;
            //                eventlog = new EventLogEL()
            //                {
            //                    DateTime = DateTime.Now.ToString(),
            //                    EventName = "UploadOutletImages",
            //                    ResultMessage = result.responseMessage,
            //                    ImageName = imageData.FileName,
            //                    EventDecription = "Parameters(imageData=" + imageData.FileName + ", imagePath=" + imagePath + ")",
            //                    OtherInfo = "File already exist.",
            //                };
            //                log.MaintainLog(eventlog);
            //                return Json(result);
            //            } 
            //        }
            //    }
            //    else
            //    {
            //        if (!System.IO.Directory.Exists(Path.Combine(Server.MapPath("/" + RootDirectory + "/" + SubFolder))))
            //        {
            //            System.IO.Directory.CreateDirectory(Server.MapPath("/" + RootDirectory + "/" + SubFolder));
            //            string vPath = Path.Combine(Server.MapPath("/" + RootDirectory + "/" + SubFolder), ImageName);
            //            imageData.SaveAs(vPath);

            //            result.IsSuccess = true;
            //            result.responseMessage = "Success";
            //            result.responseCode = "200";
            //            result.imagePath = imagePath; 
            //            return Json(result);
            //        }
            //        else
            //        {
            //            if (!System.IO.File.Exists(Path.Combine(Server.MapPath("/" + RootDirectory + "/" + SubFolder), ImageName)))
            //            {
            //                string vPath = Path.Combine(Server.MapPath("/" + RootDirectory + "/" + SubFolder), ImageName);
            //                imageData.SaveAs(vPath);

            //                result.IsSuccess = true;
            //                result.responseMessage = "Success";
            //                result.responseCode = "200";
            //                result.imagePath = imagePath; 
            //                return Json(result);
            //            }
            //            else
            //            {
            //                result.IsSuccess = true;
            //                result.responseMessage = "File already exist.";
            //                result.responseCode = "201";
            //                result.imagePath = imagePath;
            //                eventlog = new EventLogEL()
            //                {
            //                    DateTime = DateTime.Now.ToString(),
            //                    EventName = "UploadOutletImages",
            //                    ResultMessage = result.responseMessage,
            //                    ImageName = imageData.FileName,
            //                    EventDecription = "Parameters(imageData=" + imageData.FileName + ", imagePath=" + imagePath + ")",
            //                    OtherInfo = "File already exist.",
            //                };
            //                log.MaintainLog(eventlog);
            //                return Json(result);
            //            } 
            //        }
            //    }
                  
            //}
            //catch (Exception ex)
            //{
            //    string MoreInfo = string.Empty;
            //    result.IsSuccess = false;
            //    result.responseCode = "201";
            //    result.responseMessage = "Failed because: " + ex.Message;
            //    if (ex.InnerException != null)
            //    {
            //        MoreInfo = ex.InnerException.Message;
            //    }
            //    eventlog = new EventLogEL()
            //    {
            //        DateTime = DateTime.Now.ToString(),
            //        EventName = "UploadOutletImages",
            //        ResultMessage = ex.Message,
            //        ImageName = imageData.FileName,
            //        EventDecription = "Parameters(imageData=" + imageData.FileName + ", imagePath=" + imagePath + ")", 
            //        OtherInfo = MoreInfo,
            //    };
            //    log.MaintainLog(eventlog);
            //    return Json(result);
            //}5
            return Json(null);
        }
    }
}