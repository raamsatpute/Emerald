using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using EmeraldFL.DataAccess.Helper;

namespace EmeraldFL.DataAccess
{

    public class InjuryLocationDataAccess : GenericRepositoryGuid<EmeraldDataContext, InjuryLocation>
    {
        public static InjuryLocationDataAccess Instance = new InjuryLocationDataAccess();

        public InjuryLocationDataAccess() : base(EmeraldDataContext.GetContext())
        {
        }

        public List<InjuryLocation> GetInjuryLocations()
        {
            using (var context = EmeraldDataContext.GetContext())
            {
                return context.InjuryLocations.Where(loc=>loc.Location == Convert.ToInt32(Helper.Helper.GetLocationIdForCurrentUser())).ToList();                
            }
        }

    }
}
