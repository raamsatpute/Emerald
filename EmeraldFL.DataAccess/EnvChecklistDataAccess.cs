using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;

namespace EmeraldFL.DataAccess
{
    public class  EnvChecklistDataAccess  : GenericRepositoryGuid<Model.EmeraldDataContext , Model.AssignedChecklist> 
    {
        public static EnvChecklistDataAccess Instance = new EnvChecklistDataAccess();

        public EnvChecklistDataAccess() : base(EmeraldDataContext.GetContext())
        {
        }
    }
}
