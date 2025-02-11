using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Z.EntityFramework.Plus;

namespace EmeraldFL.DataAccess.Model
{
    public partial class EmeraldDataContext
    {
        public virtual DbSet<AuditEntry> AuditEntries { get; set; }
        public virtual DbSet<DisplayAuditEntry> DisplayAuditEntries { get; set; }
        public virtual DbSet<DisplayAuditEntryProperty> DisplayAuditEntryProperties { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Event> Events { get; set; }
        public virtual DbSet<Location> Locations { get; set; }
        public virtual DbSet<AssignedChecklist> AssignedChecklists { get; set; }
        public virtual DbSet<AssignedChecklistComment> AssignedChecklistComments { get; set; }
        public virtual DbSet<AssignedChecklistItemResponse> AssignedChecklistItemResponse { get; set; }
        public virtual DbSet<Checklist> Checklists { get; set; }
        public virtual DbSet<ChecklistAreaType> ChecklistAreaTypes { get; set; }
        public virtual DbSet<ChecklistFrequency> ChecklistFrequencys { get; set; }
        public virtual DbSet<ChecklistInspectionType> ChecklistInspectionTypes { get; set; }
        public virtual DbSet<ChecklistItem> ChecklistItems { get; set; }
        public virtual DbSet<InjuryVictim> Injuries { get; set; }
        public virtual DbSet<InjuryLocation> InjuryLocations { get; set; }
        public virtual DbSet<InjuryType> InjuryTypes { get; set; }
        public virtual DbSet<InjuryDetail> InjuryDetails { get; set; }
        public virtual DbSet<IncidentReport> IncidentReports { get; set; }
        public virtual DbSet<IncidentCategory> IncidentCategories { get; set; }
        public virtual DbSet<JobTitle> JobTitles { get; set; }
        public virtual DbSet<State> States { get; set; }

    }
}
