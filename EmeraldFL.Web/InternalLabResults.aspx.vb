
Partial Class InternalLabResults
    Inherits System.Web.UI.Page

    Protected Sub GridView2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView2.SelectedIndexChanged
        Response.Redirect("pcb/print.aspx?batchid=" & GridView2.SelectedDataKey(0) & "&MinDispVal=1&InternalLab=Yes")
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

    End Sub
    Protected Sub btnSelSearch_Click(sender As Object, e As EventArgs) Handles btnSelSearch.Click
        'Open search panel
        PnlSearch.Visible = True
        btnSelSearch.Visible = False
        txtbxSearch.Focus()
    End Sub

    Protected Sub btnCancSearch_Click(sender As Object, e As EventArgs) Handles btnCancSearch.Click
        'Cancel Search
        'PnlSearch.Visible = False
        'btnSelSearch.Visible = True
        Response.Redirect("internallabresults.aspx")
    End Sub

    Protected Sub btnSearch0_Click(sender As Object, e As EventArgs) Handles btnSearch0.Click
        SqlDataSource3.SelectCommand = " SELECT SampleBatches.BatchId, SampleBatches.BatchName, SampleBatches.SentToLab, SampleBatches.DateStamp, SampleBatches.BatchComplete, Labs.Name, SampleBatches.ProcessingDate, SampleBatches.CustomerNumber, SampleBatches.ReportNumber, SampleBatches.ShippingNumber, SampleBatches.ReceivedDate, CAST(DATEDIFF(hh, SampleBatches.ProcessingDate, SampleBatches.ProcessingComplete) AS float) / 24 AS Age, SampleBatches.ProcessingComplete, Customers.Name AS CustomerName, SampleBatches.CustomerLoad, Customers.InventoryLocationID FROM SampleBatches LEFT OUTER JOIN Labs ON SampleBatches.SentToLab = Labs.LabId LEFT OUTER JOIN Customers ON SampleBatches.CustomerNumber = Customers.id WHERE (SampleBatches.InventoryLocation = " & Session("UserLocation") & ") AND (SampleBatches.BatchComplete = 1) AND (Customers.IsFTIInProcess = 1) " & _
                                       " and  ((dbo.SampleBatches.BatchName  like '%" & txtbxSearch.Text & "%') or (dbo.Labs.Name  like '%" & txtbxSearch.Text & "%') or (dbo.SampleBatches.ReportNumber like '%" & txtbxSearch.Text & "%') or (dbo.SampleBatches.CustomerNumber like '%" & txtbxSearch.Text & "%') or (dbo.SampleBatches.ShippingNumber like '%" & txtbxSearch.Text & "%') or (dbo.SampleBatches.CustomerLoad like '%" & txtbxSearch.Text & "%') or (dbo.Customers.Name like '%" & txtbxSearch.Text & "%')) " & _
                                        " ORDER BY SampleBatches.DateStamp DESC"

    End Sub
End Class
