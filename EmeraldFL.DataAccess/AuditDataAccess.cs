using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Data.Linq;
using System.Linq;
using System.Data.Entity;
using System.Runtime.Caching;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Caching;
using EmeraldFL.DataAccess.Model;
using EmeraldFL.DataAccess.Framework;

namespace EmeraldFL.DataAccess
{
    public class AuditDataAccess
    {
        public static AuditDataAccess Instance = new AuditDataAccess();

        public AuditDataAccess()
        { }


        public List<DisplayAuditEntry> GetAuditDetails(string table, string key)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                List<int> ids = context.GetAuditEntryIdsForTable(table, key).ToList();

                return context.DisplayAuditEntries.Include(e => e.DisplayAuditEntryProperties)
                    .Where(e => ids.Contains(e.Id))
                    .ToList();
            }
        }
    }
}
