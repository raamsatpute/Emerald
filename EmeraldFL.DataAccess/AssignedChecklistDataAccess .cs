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
    public class AssignedChecklistDataAccess : GenericRepositoryGuid<Model.EmeraldDataContext, Model.AssignedChecklist>
    {
        public static AssignedChecklistDataAccess Instance = new AssignedChecklistDataAccess();

        public AssignedChecklistDataAccess() : base(EmeraldDataContext.GetContext())
        {
        }

        public  List<AssignedChecklist> GetOverDue()
        {
            return Context.AssignedChecklists
                  .Where(a => a.CompletedOnDate == null && a.RequiredByDate < DateTime.Now)
                  .ToList();

        }

        public List<AssignedChecklist> GetAssignedChecklistsByLocation(int locationId)
        {
            return Context.AssignedChecklists
                  .Include(a => a.Checklist)
                  .Where(a => a.CompletedOnDate == null && a.LocationId == locationId)
                  .Distinct()
                  .ToList();
        }

        public List<Checklist> GetChecklistsAvailableByLocation(int locationId)
        {
            var assigned = GetAssignedChecklistsByLocation(locationId)
                .Select(c => c.Id).Distinct();

            return Context.Checklists
                  .Where(c => !assigned.Contains(c.Id))
                  .Distinct()
                  .ToList();
        }

        public void Unassign(int locationId, Guid checklistId)
        {
            var x = Context.AssignedChecklists
                 .Where(c => c.ChecklistId == checklistId && c.LocationId == locationId && c.CompletedOnDate == null)
                 .Delete();
        }

        public void UnassignAssignedChecklist( Guid checklistId)
        {
            var x = Context.AssignedChecklists
                .Where(c => c.ChecklistId == checklistId && c.CompletedOnDate == null)
                .Delete();
        }
        public  List<AssignedChecklist> GetCompleted()
        {
            return Context.AssignedChecklists
                .Where(a => a.CompletedOnDate != null)
                .ToList();

        }

        public  List<AssignedChecklist> GetAllAssignedChecklists()
        {
            return Context.AssignedChecklists.Where(al => al.ChecklistId == al.Checklist.Id).ToList();
        }

        public List<AssignedChecklistComment> GetAssignedChecklistComment()
        {
            //not for real...just for compiling
            return new List<AssignedChecklistComment>();
        }

    }
}
