using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace ShopAPI.Models
{

    #region Login
    public class ClassLogin
    {
        [Required]
        public string username { get; set; }
        [Required]
        public string password { get; set; }

        public string latitude { get; set; }
        public string longitude { get; set; }

        public string login_time { get; set; }

        //[Required]
        public string Imei { get; set; }
        public string version_name { get; set; }


    }

    public class ClassLoginOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public string session_token { get; set; }

    

        public UserClass user_details { get; set; }

        public UserClasscounting user_count { get; set; }


    }


    public class UserClass
    {

        public string user_id { get; set; }
        public string name { get; set; }

        public string email { get; set; }
        public string phone_number { get; set; }

        public string imeino { get; set; }
        public string success { get; set; }
        public string version_name { get; set; }
        public string address { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
        public int country { get; set; }
        public int state { get; set; }
        public string city { get; set; }
        public string pincode { get; set; }
        public string profile_image { get; set; }
        public string isAddAttendence { get; set; }
        public string add_attendence_time { get; set; }

    }

    public class UserClasscounting
    {
        public int total_time_spent_at_shop { get; set; }
        public int total_shop_visited { get; set; }

        public int total_attendance { get; set; }
    }

    #endregion





    #region Registershop

    public class RegisterShopInputData
    {
        //public RegisterShopInputData()
        //{
        //    data = new RegisterShopInput();
        //}


        public string data { get; set; }

        public HttpPostedFileBase shop_image { get; set; }
    }
    public class RegisterShopInput
    {
        [Required]
        public string session_token { get; set; }
        [Required]
        public string user_id { get; set; }

        [Required]
        public string shop_name { get; set; }
        [Required]
        public string address { get; set; }
        [Required]
        public string pin_code { get; set; }
        [Required]
        public string shop_lat { get; set; }
        [Required]
        public string shop_long { get; set; }
        [Required]
        public string owner_name { get; set; }
        [Required]
        public string owner_contact_no { get; set; }
        [Required]
        public string owner_email { get; set; }
        public int? type { get; set; }
        public string dob { get; set; }
        public string date_aniversary { get; set; }

        public string shop_id { get; set; }
        public string added_date { get; set; }

        public string assigned_to_pp_id { get; set; }
        public string assigned_to_dd_id { get; set; }


    }





    public class RegisterShopOutput
    {
        public string status { get; set; }
        public string message { get; set; }
        public string session_token { get; set; }
        public ShopRegister data { get; set; }
    }


    public class ShopRegister
    {

        public string session_token { get; set; }

        public string user_id { get; set; }

        public string shop_name { get; set; }

        public string address { get; set; }

        public string pin_code { get; set; }

        public string shop_lat { get; set; }

        public string shop_long { get; set; }

        public string owner_name { get; set; }

        public string owner_contact_no { get; set; }

        public string owner_email { get; set; }


        public string dob { get; set; }

        public string date_aniversary { get; set; }

        public int? type { get; set; }
        public string shop_id { get; set; }
        public string assigned_to_dd_id { get; set; }
        public string assigned_to_pp_id { get; set; }


    }

    #endregion



    #region Encryption
    public class Encryption
    {
        #region Properties

        private string Password = "3269875";
        private string Salt = "05983654";
        private string HashAlgorithm = "SHA1";
        private int PasswordIterations = 2;
        private string InitialVector = "OFRna73m*aze01xY";
        private int KeySize = 256;

        public string password
        {
            get { return Password; }
        }

        public string salt
        {
            get { return Salt; }
        }

        public string hashAlgo
        {
            get { return HashAlgorithm; }
        }

        public int passwordterations
        {
            get { return PasswordIterations; }
        }

        public string initialvector
        {
            get { return InitialVector; }
        }

        public int keysize
        {
            get { return KeySize; }
        }

        #endregion Properties

        #region Encrypt region

        public string Encrypt(string PlainText)
        {
            if (string.IsNullOrEmpty(PlainText))
                return "";
            byte[] InitialVectorBytes = Encoding.ASCII.GetBytes(initialvector);
            byte[] SaltValueBytes = Encoding.ASCII.GetBytes(salt);
            byte[] PlainTextBytes = Encoding.UTF8.GetBytes(PlainText);
            PasswordDeriveBytes DerivedPassword = new PasswordDeriveBytes(password, SaltValueBytes, hashAlgo, passwordterations);
            byte[] KeyBytes = DerivedPassword.GetBytes(KeySize / 8);
            RijndaelManaged SymmetricKey = new RijndaelManaged();
            SymmetricKey.Mode = CipherMode.CBC;
            byte[] CipherTextBytes = null;
            using (ICryptoTransform Encryptor = SymmetricKey.CreateEncryptor(KeyBytes, InitialVectorBytes))
            {
                using (MemoryStream MemStream = new MemoryStream())
                {
                    using (CryptoStream CryptoStream = new CryptoStream(MemStream, Encryptor, CryptoStreamMode.Write))
                    {
                        CryptoStream.Write(PlainTextBytes, 0, PlainTextBytes.Length);
                        CryptoStream.FlushFinalBlock();
                        CipherTextBytes = MemStream.ToArray();
                        MemStream.Close();
                        CryptoStream.Close();
                    }
                }
            }
            SymmetricKey.Clear();
            return Convert.ToBase64String(CipherTextBytes);
        }

        #endregion Encrypt region

        #region Decrypt Region

        public string Decrypt(string CipherText)
        {
            try
            {
                if (string.IsNullOrEmpty(CipherText))
                    return "";
                byte[] InitialVectorBytes = Encoding.ASCII.GetBytes(initialvector);
                byte[] SaltValueBytes = Encoding.ASCII.GetBytes(salt);
                byte[] CipherTextBytes = Convert.FromBase64String(CipherText);
                PasswordDeriveBytes DerivedPassword = new PasswordDeriveBytes(password, SaltValueBytes, hashAlgo, passwordterations);
                byte[] KeyBytes = DerivedPassword.GetBytes(KeySize / 8);
                RijndaelManaged SymmetricKey = new RijndaelManaged();
                SymmetricKey.Mode = CipherMode.CBC;
                byte[] PlainTextBytes = new byte[CipherTextBytes.Length];
                int ByteCount = 0;
                using (ICryptoTransform Decryptor = SymmetricKey.CreateDecryptor(KeyBytes, InitialVectorBytes))
                {
                    using (MemoryStream MemStream = new MemoryStream(CipherTextBytes))
                    {
                        using (CryptoStream CryptoStream = new CryptoStream(MemStream, Decryptor, CryptoStreamMode.Read))
                        {
                            ByteCount = CryptoStream.Read(PlainTextBytes, 0, PlainTextBytes.Length);
                            MemStream.Close();
                            CryptoStream.Close();
                        }
                    }
                }
                SymmetricKey.Clear();
                return Encoding.UTF8.GetString(PlainTextBytes, 0, ByteCount);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion
    }

    #endregion



    #region HelperMethod
    public class APIHelperMethods
    {

        public static T ToModel<T>(DataTable dt)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataColumn column in dt.Columns)
                {
                    foreach (PropertyInfo pro in temp.GetProperties())
                    {
                        if (pro.Name == column.ColumnName && dt.Rows[0][column.ColumnName] != DBNull.Value)
                        {
                            try
                            {
                                pro.SetValue(obj, dt.Rows[0][column.ColumnName], null);
                            }
                            catch
                            {

                            }
                        }
                    }
                }
            }

            return obj;
        }

        public static List<T> ToModelList<T>(DataTable dt)
        {
            Type temp = typeof(T);

            List<T> objList = new List<T>();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    T obj = Activator.CreateInstance<T>();

                    foreach (DataColumn column in row.Table.Columns)
                    {
                        foreach (PropertyInfo pro in temp.GetProperties())
                        {
                            if (pro.Name == column.ColumnName && row[column.ColumnName] != DBNull.Value)
                            {
                                try
                                {
                                    pro.SetValue(obj, row[column.ColumnName], null);
                                }
                                catch
                                {

                                }
                            }
                        }
                    }

                    objList.Add(obj);
                }
            }

            return objList;
        }




    }
    #endregion
}