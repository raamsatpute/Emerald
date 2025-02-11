Imports System.Data.SqlClient

Partial Class ILRSampleSearch
    Inherits System.Web.UI.Page
    Dim cn As New SqlConnection(ConfigurationManager.ConnectionStrings("fInventoryConn").ConnectionString)
    Dim TimeOffSet As Integer = 0

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        'Search
        lblOther.Text = String.Empty
        SqlDataSource2.SelectCommand = "SELECT DISTINCT dbo.SampleBatches.CustomerNumber, dbo.SampleBatches.BatchId, dbo.PCBSampleLog.Barcode, dbo.PCBSampleLog.SerialNumber, CONVERT(varchar,  " & _
                         " dbo.PCBSampleLog.Datestamp, 107) AS DateStamp FROM            dbo.PCBSampleLog INNER JOIN dbo.SampleBatches ON dbo.PCBSampleLog.BatchID = dbo.SampleBatches.BatchId INNER JOIN " & _
                         " dbo.Customers ON dbo.SampleBatches.CustomerNumber = dbo.Customers.id WHERE  (dbo.SampleBatches.InventoryLocation = " & Session("UserLocation") & ") AND (dbo.Customers.IsFTIInProcess = 1)  AND (SampleBatches.BatchComplete = 1) and SampleBatches.CustomerNumber like '%" & Trim(txtbxCustNum.Text) & "%' AND PCBSampleLog.Barcode LIKE '%" & Trim(txtbxSearch.Text) & "%' OR (dbo.SampleBatches.InventoryLocation = " & Session("UserLocation") & ") AND (dbo.Customers.IsFTIInProcess = 1) and SampleBatches.CustomerNumber like '%" & txtbxCustNum.Text & "%' AND PCBSampleLog.SerialNumber LIKE '%" & Trim(txtbxSearch.Text) & "%' "
        'Response.Write(SqlDataSource2.SelectCommand.ToString)
        GridView1.DataBind()
        Dim sString As String = "SELECT count(*) FROM dbo.PCBSampleLog INNER JOIN dbo.SampleBatches ON dbo.PCBSampleLog.BatchID = dbo.SampleBatches.BatchId INNER JOIN " & _
                         " dbo.Customers ON dbo.SampleBatches.CustomerNumber = dbo.Customers.id WHERE (dbo.SampleBatches.InventoryLocation = " & Session("UserLocation") & ") AND (dbo.Customers.IsFTIInProcess = 1)  AND (SampleBatches.BatchComplete = 0) and SampleBatches.CustomerNumber like '%" & Trim(txtbxCustNum.Text) & "%' AND PCBSampleLog.Barcode LIKE '%" & Trim(txtbxSearch.Text) & "%' OR (dbo.SampleBatches.InventoryLocation = " & Session("UserLocation") & ") AND (dbo.Customers.IsFTIInProcess = 1)  AND (SampleBatches.BatchComplete = 0) and SampleBatches.CustomerNumber like '%" & txtbxCustNum.Text & "%' AND PCBSampleLog.SerialNumber LIKE '%" & Trim(txtbxSearch.Text) & "%' "
        If GridView1.Rows.Count = 0 Then


            Try
                cn.Open()
                Dim sql As New SqlCommand(sString, cn)
                lblOther.Text = sql.ExecuteScalar & " item(s) with the barcode " & txtbxSearch.Text & " exists in a batch that has not been completed yet."
            Catch ex As Exception
            Finally
                cn.Close()
            End Try
        End If
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView1.SelectedIndexChanged
        'pnlSearch.Visible = False
        'pnlShow.Visible = True
        Response.Redirect("pcb/print.aspx?batchid=" & GridView1.SelectedDataKey(0) & "&barcode=" & GridView1.SelectedDataKey(1) & "&MinDispVal=" & DDLPercentLessThan.SelectedValue)
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            pnlSearch.Visible = True


        End If
    End Sub
End Class
