
<%@ WebHandler Language="VB" Class="SimpleAntiBotImage" %>
'منقول  مع بعض التعديلات الخفيفة
Imports System
Imports System.Web
Imports System.Drawing

Public Class SimpleAntiBotImage
    Implements IHttpHandler
    Implements IRequiresSessionState
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        '--------------------------------------------
        'يمكن  استخدام فونت معين بدل الفونت المشهورة بحيث يتم تحميله على الموقع
        ' يمكن تحميل فونت لهذا الهدف من الموقع
        'http://dejavu.sourceforge.net/wiki/index.php/Download 
        'حيث من الممكن ان تعطي اشكال مختلفة للصورة
        
        'Dim privateFontCollection As New Drawing.Text.PrivateFontCollection
        'privateFontCollection.AddFontFile(Server.MapPath("DejaVuSerifCondensed-Bold.ttf"))
        'Dim thisFont As FontFamily = privateFontCollection.Families(0)
        'Dim Fnt As New Font(thisFont, 19, FontStyle.Bold, GraphicsUnit.Pixel)
        '--------------------------------------------
        
        Dim Rand As New Random()
        Dim iNum As Integer = Rand.[Next](1000, 9999)
        Dim Bmp As New Bitmap(90, 50)
        Dim Gfx As Graphics = Graphics.FromImage(Bmp)
        Dim Fnt As New Font("Verdana", 12, FontStyle.Bold)
       
        ' Create random numbers for the first line
        
        Gfx.DrawString(iNum.ToString(), Fnt, Brushes.Orange, 15, 15)
        'Gfx.DrawString("اب ت ث", Fnt, Brushes.Orange, 15, 15)
        Dim RandY1 As Integer = Rand.[Next](0, 50)
        Dim RandY2 As Integer = Rand.[Next](0, 50)
        ' Draw the first line
        Gfx.DrawLine(Pens.Yellow, 0, RandY1, 90, RandY2)
        ' Create random numbers for the second line
        RandY1 = Rand.[Next](0, 50)
        RandY2 = Rand.[Next](0, 50)
        ' Draw the second line
        Gfx.DrawLine(Pens.Yellow, 0, RandY1, 90, RandY2)
        Bmp.Save(context.Response.OutputStream, Imaging.ImageFormat.Gif)
        context.Session.Add("antibotimage", iNum)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class