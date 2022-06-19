using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Net;
namespace موقع_الدكتوره_بلقيس_الانسي { }

namespace موقع_الدكتوره_بلقيس_الانسي
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            String nember, img;
            nember = txtnumber.Text.Trim();
            img = Session["antibotimage"].ToString().Trim();
            if (img == nember)
            {
                try
                {
                    Label1.Text = SendEmaill("ibbrahimyahya@gmail.com", txtsubject.Text, txtbody.Text);

        }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "popup", "alert('خطاء');", true);
                }
           
           Label1.Text = "تم ارسال الرساله";
            }
            else
            {

                txtnumber.Text = "";
                Label1.Text = "الرقم غير صحيح";

            }
        }
        private string SendEmaill(string To, string Subject, string Body)
        {
            try
            {
                SmtpClient SmtpClient = new SmtpClient("smtp.gmail.com", 587);
                SmtpClient.EnableSsl = true;
                SmtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                SmtpClient.UseDefaultCredentials = false;
                SmtpClient.Credentials = new System.Net.NetworkCredential("ibbrahimyahya@gmail.com", "ibr711722323");

                MailMessage MyEmailMsg = new MailMessage();
                MyEmailMsg.To.Add(txtemail.Text.Trim());
                MyEmailMsg.From = new MailAddress("ibbrahimyahya@gmail.com");
                MyEmailMsg.Subject = txtsubject.Text.Trim();
                MyEmailMsg.Body = txtbody.Text.Trim();
                SmtpClient.Send(MyEmailMsg);

            }
            catch (Exception ex)
            {

                return "فشل الارسال";
            }
            txtsubject.Text = "";
            txtemail.Text = "";
            txtbody.Text = "";
            txtnumber.Text = "";
            return "ok";

        }
    }
}