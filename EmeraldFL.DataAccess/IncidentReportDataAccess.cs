using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using Z.EntityFramework.Plus;
using System.Data.Entity;

namespace EmeraldFL.DataAccess
{
    public class IncidentReportDataAccess : GenericRepositoryGuid<EmeraldDataContext, IncidentReport>
    {
        public static IncidentReportDataAccess Instance = new IncidentReportDataAccess();

        public IncidentReportDataAccess() : base(EmeraldDataContext.GetContext())
        {
        }

        public List<Model.IncidentCategory> GetIncidentCategories()
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                return context.IncidentCategories.FromCache().ToList();
            }
        }

        public List<Model.State> GetStates()
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                return context.States.FromCache().ToList();
            }
        }

        public IncidentReport GetGraph(Guid id)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                return context.IncidentReports
                    .Include(e => e.State)
                    .Include(e => e.Category)
                    .Include(e => e.Location)
                    .Include(e => e.IncidentWitnesses)
                    .Include(e => e.Injuries)
                    .Include(e => e.Injuries.Select(i => i.InjuryDetails))
                    .Include(e => e.Injuries.Select(i => i.InjuryDetails.Select(x => x.InjuryLocation)))
                    .Include(e => e.Injuries.Select(i => i.InjuryDetails.Select(x => x.InjuryType)))
                    .SingleOrDefault(e => e.Id == id);
            }
        }

        public override void Delete(Guid id)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                context.DeleteIncidentReport(id);
            }
        }

        public string GetNextNumber()
        {
            int counter = 1;
            string number;
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                do
                {
                    number = $"{DateTime.Today:yy}.{DateTime.Today.DayOfYear}.{counter++:00}";
                } while (context.IncidentReports.Any(ir => ir.Number == number));
            }
            return number;
        }

         public override void AfterDelete()
        {
            QueryCacheManager.ExpireAll();
        }

        public override void AfterInsert()
        {
            QueryCacheManager.ExpireAll();
        }
        public override void AfterUpdate()
        {
            QueryCacheManager.ExpireAll();
        }

    }
}
