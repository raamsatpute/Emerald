using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Helper;

namespace EmeraldFL.DataAccess
{
   public class InjuryTypeDataAccess : GenericRepositoryGuid<EmeraldDataContext, InjuryType>
    {

        public static InjuryTypeDataAccess Instance = new InjuryTypeDataAccess();

        public InjuryTypeDataAccess() : base(EmeraldDataContext.GetContext())
        { }
        
        public List<InjuryType> GetInjuryTypes()
        {
            using (var context = EmeraldDataContext.GetContext())
            {
                return context.InjuryTypes.Where(loc=> loc.Location == Convert.ToInt32(Helper.Helper.GetLocationIdForCurrentUser())).ToList();
            }
        }
    }
}
