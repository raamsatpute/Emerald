using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;

namespace EmeraldFL.DataAccess
{
    public class JobTitleDataAccess : GenericRepositoryGuid<EmeraldDataContext, JobTitle>
    {
        public static JobTitleDataAccess Instance = new JobTitleDataAccess();

        public JobTitleDataAccess() : base(EmeraldDataContext.GetContext())
        {

        }




    }
}
