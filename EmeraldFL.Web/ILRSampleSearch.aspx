<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ILRSampleSearch.aspx.vb" Inherits="ILRSampleSearch" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %> 
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<link rel="stylesheet" type="text/css" href="pcb/style.css" />

<title>Regulated Services</title> 
</head>
<body>
    <form id="form1" runat="server">
  
 <div id="container">
		<div id="header">
        	<h1>Emerald<span class="off">Transformer</span>
            </h1>
            <h2>Management</h2>
        </div>   
         
        <div id="menu">
        <ul>
            	<li class="menuitem"><a href="fi/Default.aspx">Home</a></li> 
     
              <li class="menuitem"><a href="fi/Login.aspx"  >Exit</a></li>
            </ul>
         </div>
        
        <div id="leftmenu">

        <div id="leftmenu_top"></div>

				<div id="leftmenu_main">    
                
                <h3>PCB Lab</h3>
<ul>
<li><a href="InternalLabResults.aspx" >Internal Lab Results</a></li>  
<li><a href="ilrsamplesearch.aspx" >Sample Search</a></li>  
</ul>
                        
                <!--Insert LEft Column -->
          
</div>
                
                
              <div id="leftmenu_bottom"></div>
        </div>
        
        
        
        
		<div id="content">
        
        
        <div id="content_top"></div>
        <div id="content_main">
<!-- Main content -->
            <h2>Sample Search</h2><hr /><br />
         
    <asp:Panel ID="pnlSearch" runat="server">
        <table id="table1" cellpadding="0" class="auto-style1">
            <tr>
                <td class="auto-style2">Customer Number</td>
                <td class="auto-style2">&nbsp;</td>
                <td class="auto-style2" style="vertical-align: top; text-align: left">Keyword</td>
                <td class="auto-style2" style="vertical-align: top; text-align: left">&nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style2">
                    <asp:TextBox ID="txtbxCustNum" runat="server"></asp:TextBox>

                </td>
                <td class="auto-style2">&nbsp;</td>
                <td class="auto-style2" style="vertical-align: top; text-align: left">

                    <asp:TextBox ID="txtbxSearch" runat="server"></asp:TextBox>
                </td>
                <td class="auto-style2" style="vertical-align: top; text-align: left">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
        Please select minimum value to dispaly
        <asp:DropDownList ID="DDLPercentLessThan" runat="server" AutoPostBack="True">
            <asp:ListItem>1</asp:ListItem>
            <asp:ListItem>.26</asp:ListItem>
        </asp:DropDownList>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" EnableModelValidation="True"
            BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical"
            EmptyDataText="There are no records for your query" DataKeyNames="batchid,barcode" Width="600px">
            <AlternatingRowStyle BackColor="#DCDCDC" />
            <Columns>
                <asp:CommandField ShowSelectButton="True" SelectText="View/Print">
                    <ItemStyle ForeColor="Blue" />
                </asp:CommandField>
                <asp:BoundField DataField="CustomerNumber" HeaderText="Customer Number" SortExpression="CustomerNumber" />
                <asp:BoundField DataField="Barcode" HeaderText="Barcode" SortExpression="Barcode" />
                <asp:BoundField DataField="SerialNumber" HeaderText="Serial Number" SortExpression="SerialNumber" />
                <asp:BoundField DataField="batchid" HeaderText="batchid" SortExpression="batchid" Visible="false" />
                <asp:BoundField DataField="Datestamp" HeaderText="Date" SortExpression="Datestamp" />
            </Columns>
            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
            <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
            <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:FInventoryConn %>" SelectCommandType="Text"></asp:SqlDataSource>
        <br />
        <asp:Label ID="lblOther" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
    </asp:Panel>

</div>
        <div id="content_bottom"></div>
             <div id="footer">
            
            
            <!-- Insert Footer -->
             
            </div>
      </div>
   </div>
       </form>
</body>
</html>

