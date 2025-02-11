using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Z.EntityFramework.Plus;
using System.Data.Entity;

namespace EmeraldFL.DataAccess
{
    public class InjuryDetailDataAccess : GenericRepositoryGuid<EmeraldDataContext, InjuryDetail>
    {
        public static InjuryDetailDataAccess Instance = new InjuryDetailDataAccess();

        public InjuryDetailDataAccess() : base(EmeraldDataContext.GetContext())
        { }

        public override void Delete(Guid id)
        {
             using (var context = Model.EmeraldDataContext.GetContext())
            {
                context.DeleteInjuryDetail(id);
            }
        }

        public InjuryDetail GetGraph(Guid id)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                return context.InjuryDetails
                    .Include(e => e.InjuryLocation)
                    .Include(e => e.InjuryType)
                    .SingleOrDefault(e => e.Id == id);
            }
        }

    }
}
