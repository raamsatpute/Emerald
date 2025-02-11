using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;


namespace EmeraldFL.DataAccess
{

    public class IncidentCategoryDataAccess : GenericRepositoryGuid<EmeraldDataContext, IncidentCategory>
    {
        public static IncidentCategoryDataAccess Instance = new IncidentCategoryDataAccess();

        public IncidentCategoryDataAccess() : base(EmeraldDataContext.GetContext())
        {

        }
    }



}
