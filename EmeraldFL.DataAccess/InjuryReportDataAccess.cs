using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using Z.EntityFramework.Plus;
using System.Data.Entity;
using EmeraldFL.DataAccess.Helper;

namespace EmeraldFL.DataAccess
{
    public class InjuryVictimDataAccess : GenericRepositoryGuid<EmeraldDataContext, InjuryVictim>
    {
        public static InjuryVictimDataAccess Instance = new InjuryVictimDataAccess();

        public InjuryVictimDataAccess() : base(EmeraldDataContext.GetContext())
        {
        }

        public InjuryVictim GetGraph(Guid id)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                return context.Injuries
                    .Include(e => e.IncidentReport)
                    .Include(e => e.InjuryDetails)
                    .Include(e => e.InjuryDetails.Select(a => a.InjuryLocation))
                    .Include(e => e.InjuryDetails.Select(a => a.InjuryType))
                    .SingleOrDefault(e => e.Id == id);
            }
        }
    }
}
