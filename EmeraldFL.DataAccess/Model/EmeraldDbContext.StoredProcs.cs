using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmeraldFL.DataAccess.Model
{ 
    public partial class EmeraldDataContext
    {
        internal List<int> GetAuditEntryIdsForTable(string tableName, string key)
        {
           
                var tableParameter = new SqlParameter("@Table", tableName);
                var keyParameter = new SqlParameter("@Key", key);

                return this.Database
                    .SqlQuery<int>("GetAuditIdsForTableAndKey @Table, @Key", tableParameter, keyParameter)
                    .ToList();
            
        }

        internal int DeleteIncidentReport(Guid id)
        {
            
                var parameter = new SqlParameter("@id", id);
                return this.Database.ExecuteSqlCommand("usp_DeleteIncidentReport @id", parameter);
            
        }
        internal int DeleteInjuryDetail(Guid id)
        {
            
                var parameter = new SqlParameter("@id", id);
                return this.Database.ExecuteSqlCommand("Delete from InjuryDetail where ID =  @id", parameter);
            
        }

        internal int DeleteInjuryVictime(Guid id)
        {
            
                var parameter = new SqlParameter("@id", id);
                return this.Database.ExecuteSqlCommand("Delete from InjuryVictim where ID =  @id", parameter);
            
        }

    }
}
