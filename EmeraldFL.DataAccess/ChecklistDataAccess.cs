using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;

 
using Z.EntityFramework.Plus;
using System.Data.Entity;

namespace EmeraldFL.DataAccess
{
    public class ChecklistDataAccess : GenericRepositoryGuid<Model.EmeraldDataContext, Model.Checklist>
    {
        public static ChecklistDataAccess Instance = new ChecklistDataAccess();

        public ChecklistDataAccess() : base(EmeraldDataContext.GetContext())
        {
        }

        public Checklist GetGraph(Guid id)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                return context.Checklists
                    .Include(e => e.ChecklistItems)
                    .Include(e => e.Location)
                    .Include(e => e.ChecklistFrequency)
                    .Include(e => e.ChecklistAreaType)
                    .SingleOrDefault(e => e.Id == id);
            }
        }
    }
}
