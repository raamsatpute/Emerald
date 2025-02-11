using EmeraldFL.DataAccess.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Model;

namespace EmeraldFL.DataAccess
{
    public class ChecklistItemResponseDataAccess : GenericRepositoryGuid<Model.EmeraldDataContext, Model.AssignedChecklistItemResponse>
    {

        public static ChecklistItemResponseDataAccess Instance = new ChecklistItemResponseDataAccess();

        public ChecklistItemResponseDataAccess() : base(EmeraldDataContext.GetContext())
        {
            
        }

        public List<AssignedChecklistItemResponse> GetByChecklistItem(Guid checkListItemId)
        {
            return this.Context.AssignedChecklistItemResponse.Where(c => c.ChecklistItemId == checkListItemId).ToList();
        }
    }
}
