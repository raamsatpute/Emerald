<%@ Page Language="VB" AutoEventWireup="false" CodeFile="InternalLabResults.aspx.vb" Inherits="InternalLabResults" %>
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
            <h2>Daily Lab Results</h2><hr /><br />
             <table cellpadding="0" style="width: 100%;">
                <tr><td >
                    <asp:Panel ID="PnlSearch" runat="server" Visible="False">
                        <asp:TextBox ID="txtbxSearch" runat="server"></asp:TextBox>
                        &nbsp;<asp:Button ID="btnSearch0" runat="server" Text="Search" />
                        &nbsp;<asp:Button ID="btnCancSearch" runat="server" Text="Cancel" />
                        &nbsp;</asp:Panel>
                </td></tr>
                  <tr>
                     
                    <td style="text-align: right;">
                        <asp:Button ID="btnSelSearch" runat="server" Text="Search" />
                        &nbsp;</td>
                </tr>
            </table>
              <asp:GridView ID="GridView2" runat="server"
                AutoGenerateColumns="False" BackColor="White" BorderColor="#999999"
                BorderStyle="None" BorderWidth="1px" CellPadding="3" DataKeyNames="BatchId"
                DataSourceID="SqlDataSource3" EnableModelValidation="True"
                GridLines="Vertical" AllowPaging="True" AllowSorting="True" Width="650px" PageSize="50">
                <AlternatingRowStyle BackColor="#DCDCDC" />
                <Columns>
                    <asp:CommandField ShowSelectButton="True">
                        <ItemStyle ForeColor="Blue" />
                    </asp:CommandField>
                    <asp:BoundField DataField="ReportNumber" HeaderText="ReportNumber" InsertVisible="False"
                        ReadOnly="True" SortExpression="ReportNumber"  />
                     <asp:BoundField DataField="BatchId" HeaderText="BatchId" InsertVisible="False"
                        ReadOnly="True" SortExpression="BatchId" Visible="false" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Customer"
                        SortExpression="CustomerName" />
                    <asp:BoundField DataField="Name" HeaderText="Lab Name"
                        SortExpression="name" Visible="false" />
                    <asp:BoundField DataField="SentToLab" HeaderText="Processing Lab"
                        SortExpression="SentToLab" Visible="false" />
                    <asp:BoundField DataField="DateStamp" HeaderText="DateStamp"
                        SortExpression="DateStamp" Visible="False" />
                    <asp:BoundField DataField="ReceivedDate" ItemStyle-Width="85px" HeaderText="Received Date"
                        SortExpression="ReceivedDate" Visible="False">
                        <ItemStyle Width="85px" />
                    </asp:BoundField>
                     <asp:BoundField DataField="ProcessingDate" ItemStyle-Width="85px" HeaderText="Processing Date"
                        SortExpression="ProcessingDate">
                        <ItemStyle Width="85px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ProcessingComplete" ItemStyle-Width="85px" HeaderText="Processing Complete"
                        SortExpression="ProcessingComplete" >
                        <ItemStyle Width="85px" />
                    </asp:BoundField>
                   <asp:BoundField DataField="Age" HeaderText="Age"
                        SortExpression="Age" DataFormatString="{0:0.0}" />
                    <asp:BoundField DataField="BatchComplete" HeaderText="Batch Complete"
                        SortExpression="BatchComplete" Visible="false" />

                </Columns>
                <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
                <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource3" runat="server"
                ConnectionString="<%$ ConnectionStrings:FInventoryConn %>"
                SelectCommand="SELECT SampleBatches.BatchId, SampleBatches.BatchName, SampleBatches.SentToLab, SampleBatches.DateStamp, SampleBatches.BatchComplete, Labs.Name, SampleBatches.ProcessingDate, SampleBatches.CustomerNumber, SampleBatches.ReportNumber, SampleBatches.ShippingNumber, SampleBatches.ReceivedDate, CAST(DATEDIFF(hh, SampleBatches.ProcessingDate, SampleBatches.ProcessingComplete) AS float) / 24 AS Age, SampleBatches.ProcessingComplete, Customers.Name AS CustomerName, SampleBatches.CustomerLoad, Customers.InventoryLocationID FROM SampleBatches LEFT OUTER JOIN Labs ON SampleBatches.SentToLab = Labs.LabId LEFT OUTER JOIN Customers ON SampleBatches.CustomerNumber = Customers.id WHERE (SampleBatches.InventoryLocation = @UserLocation) AND (SampleBatches.BatchComplete = 1) AND (Customers.IsFTIInProcess = 1) ORDER BY SampleBatches.DateStamp DESC">
                <SelectParameters>
                    <asp:SessionParameter Name="UserLocation" SessionField="UserLocation" />
                     
                </SelectParameters>
            </asp:SqlDataSource><br /><br />
          <span style="color:red">*** Only batches marked as complete that are in Florida Transformer in processing area are available here.</span>
         
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

