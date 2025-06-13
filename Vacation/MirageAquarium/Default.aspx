<%@ Import Namespace="System.IO" %>
<script runat="server" language="VB">
  Sub Page_Load(sender as Object, e as EventArgs)
    'Get list of images
    Dim dirInfo as New DirectoryInfo(Server.MapPath(""))
    Dim images() as FileInfo = FilterForImages(dirInfo.GetFiles())
    
    'Determine the current image to show
    Dim imgIndex as Integer = 0
    If Not Request.QueryString("N") is Nothing AndAlso IsNumeric(Request.QueryString("N")) then
      imgIndex = CInt(Request.QueryString("N"))
    End If
    
    currentImgTitle.Text = "You are Viewing: " & _
          Path.GetFileNameWithoutExtension(images(imgIndex).Name) & _
          " (" & imgIndex + 1 & " of " & images.Length & ")"
        currentImg.ImageUrl = Path.GetFileName(images(imgIndex).Name)
        
        currentImgTitle.Text = "You are viewing the Aquarium at the Mirage Hotel"
    
    If imgIndex > 0 then
      lnkPrev.NavigateUrl = "Default.aspx?N=" & imgIndex - 1
    End If
    
    If imgIndex < images.Length - 1 then
      lnkNext.NavigateUrl = "Default.aspx?N=" & imgIndex + 1
    End If
    
    dlIndex.DataSource = images
    dlIndex.DataBind()
  End Sub


  Function FilterForImages(images() as FileInfo) as FileInfo()
    Dim newImages as New ArrayList(images.Length)
    
    Dim i as Integer
    For i = 0 to images.Length - 1
      If Path.GetExtension(images(i).Name.ToLower()) = ".jpg" OrElse _
         Path.GetExtension(images(i).Name.ToLower()) = ".jpeg" OrElse _  
         Path.GetExtension(images(i).Name.ToLower()) = ".png" OrElse _ 
         Path.GetExtension(images(i).Name.ToLower()) = ".gif" then
        newImages.Add(images(i))
      End If
    Next
    
    Return CType(newImages.ToArray(GetType(FileInfo)), FileInfo())
  End Function
  
  Sub dlIndex_ItemDataBound(sender as Object, e as DataListItemEventArgs)
    If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem then
      'Get the Hyperlink
      Dim hl as HyperLink = CType(e.Item.FindControl("lnkPic"), HyperLink)
    
      'Set the Text and Navigation properties
      hl.Text = Path.GetFileNameWithoutExtension(DataBinder.Eval(e.Item.DataItem, "Name").ToString()) & _
             " (" & Int(DataBinder.Eval(e.Item.DataItem, "Length") / 1000) & " KB)"
      hl.NavigateUrl = "Default.aspx?N=" & e.Item.ItemIndex
    End If
  End Sub
</script>

<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title></title>
  <style type="text/css">
    body { font-family:Verdana;font-size: medium;}
    .ImageTitle { font-weight:bold; font-size:large;}
    .index {font-size: small;}
    .NavLink { background-color: yellow; font-weight: bold; }
  </style>
</head>
<body>

  <center>
    <asp:Label runat="server" id="currentImgTitle" CssClass="ImageTitle" /><br />
    <asp:Image runat="server" id="currentImg" />
    <p>
    <asp:HyperLink runat="server" CssClass="NavLink" id="lnkPrev" Text="< Previous" /> |
    <asp:HyperLink runat="server" CssClass="NavLink" id="lnkNext" Text="Next >" />
    </p>
    <asp:DataList runat="server" id="dlIndex" OnItemDataBound="dlIndex_ItemDataBound"
        RepeatColumns="3" CssClass="index">
      <ItemTemplate>
        <li><asp:HyperLink runat="server" id="lnkPic" /></li>
      </ItemTemplate>
    </asp:DataList>
  </center>
  
  <p>
    <a href="../../">Home Page</a>
  </p>

</body>
</html>

