using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;

namespace EmeraldFL.DataAccess
{
    public class ChecklistItemDataAccess : GenericRepositoryGuid<Model.EmeraldDataContext, Model.ChecklistItem>
    {
        public static ChecklistItemDataAccess Instance = new ChecklistItemDataAccess();

        public ChecklistItemDataAccess() : base(EmeraldDataContext.GetContext())
        { }

        public List<ChecklistItem> GetByChecklist(Guid checkListId)
        {
            return this.Context.ChecklistItems.Where(c => c.ChecklistId == checkListId).ToList();
        }
    }
}
