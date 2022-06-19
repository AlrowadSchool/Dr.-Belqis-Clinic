<%@ WebHandler Language="VB" Class="AntiBotImage" %>

'منقول  مع بعض التعديلات الخفيفة

Imports System
Imports System.Data
Imports System.Configuration
Imports System.Web
Imports System.Web.SessionState
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Drawing.Imaging
Imports System.Text

''' <summary>
''' This Handler renders out a so called Anti-Bot image. It is used to prevent bots from making automatic entries in the guestbook.
''' The random text for the image is taken out of the session-variable "antibotimage". If this value is not present in the session, a empty gif is returned.
''' </summary>
Public Class AntiBotImage
    Implements IHttpHandler
    Implements IRequiresSessionState
    
    
    
    #Region "IHttpHandler Members"
    
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
    
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        'If context.Session("antibotimage") Is Nothing Then
        context.Session("antibotimage") = generateRandomString(4).ToUpper()
        'End If
        
        GenerateImage(context.Session("antibotimage").ToString(), 100, 20, "Arial").Save(context.Response.OutputStream, ImageFormat.Jpeg)
    End Sub
    
#End Region
    
    Private Function GenerateImage(ByVal text As String, ByVal width As Integer, ByVal height As Integer, ByVal fontFamily As String) As Bitmap
        Dim random As New Random()
        
        ' Create a new 32-bit bitmap image.
        Dim bitmap As New Bitmap(width, height, PixelFormat.Format32bppArgb)
        
        ' Create a graphics object for drawing.
        Dim g As Graphics = Graphics.FromImage(bitmap)
        g.SmoothingMode = SmoothingMode.AntiAlias
        Dim rect As New Rectangle(0, 0, width, height)
        
        ' Fill in the background.
        Dim hatchBrush As New HatchBrush(HatchStyle.Wave, Color.LightGray, Color.White)
        g.FillRectangle(hatchBrush, rect)
        
        ' Set up the text font.
        Dim size As SizeF
        Dim fontSize As Single = rect.Height + 1
        Dim font As Font
        Dim format As New StringFormat()
        format.Alignment = StringAlignment.Center
        format.LineAlignment = StringAlignment.Center
        
        ' Adjust the font size until the text fits within the image.
        Do
            fontSize -= 1
            font = New Font(fontFamily, fontSize, FontStyle.Bold)
            size = g.MeasureString(text, font, New SizeF(width, height), format)
        Loop While size.Width > rect.Width
        
        ' Create a path using the text and warp it randomly.
        Dim path As New GraphicsPath()
        path.AddString(text, font.FontFamily, CInt(font.Style), font.Size, rect, format)
        Dim v As Single = 4.0F
        Dim points As PointF() = {New PointF(random.[Next](rect.Width) / v, random.[Next](rect.Height) / v), New PointF(rect.Width - random.[Next](rect.Width) / v, random.[Next](rect.Height) / v), New PointF(random.[Next](rect.Width) / v, rect.Height - random.[Next](rect.Height) / v), New PointF(rect.Width - random.[Next](rect.Width) / v, rect.Height - random.[Next](rect.Height) / v)}
        Dim matrix As New Matrix()
        matrix.Translate(0.0F, 0.0F)
        path.Warp(points, rect, matrix, WarpMode.Perspective, 0.0F)
        
        ' Draw the text.
        hatchBrush = New HatchBrush(HatchStyle.DashedUpwardDiagonal, Color.DarkGray, Color.Black)
        g.FillPath(hatchBrush, path)
        
        ' Add some random noise.
        Dim m As Integer = Math.Max(rect.Width, rect.Height)
        For i As Integer = 0 To CInt((rect.Width * rect.Height / 30.0F)) - 1
            Dim x As Integer = random.[Next](rect.Width)
            Dim y As Integer = random.[Next](rect.Height)
            Dim w As Integer = random.[Next](m / 50)
            Dim h As Integer = random.[Next](m / 50)
            g.FillEllipse(hatchBrush, x, y, w, h)
        Next
        
        ' Clean up.
        font.Dispose()
        hatchBrush.Dispose()
        g.Dispose()
        
        Return bitmap
    End Function
    
    Private Function generateRandomString(ByVal size As Integer) As String
        Dim builder As New StringBuilder()
        Dim CapatchaChars As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        Dim random As New Random()
        Dim ch As Char
        For i As Integer = 0 To size - 1
            ' ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)))
            
            Dim sRnd As Int16 = Math.Floor(35 * random.NextDouble() + 1)
            ch = CapatchaChars.Substring(sRnd, 1)
            builder.Append(ch)
        Next
        Return builder.ToString()
    End Function
End Class
