using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Z.EntityFramework.Plus;

namespace EmeraldFL.DataAccess
{
    public class IncidentWitnessDataAccess : GenericRepositoryGuid<EmeraldDataContext, IncidentWitness>
    {
        public static IncidentWitnessDataAccess Instance = new IncidentWitnessDataAccess();

        public IncidentWitnessDataAccess() : base(EmeraldDataContext.GetContext())
        { }

    }
}
