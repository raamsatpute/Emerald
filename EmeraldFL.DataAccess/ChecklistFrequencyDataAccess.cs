using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using Z.EntityFramework.Plus;

namespace EmeraldFL.DataAccess
{
    public class ChecklistFrequencyDataAccess : GenericRepository<EmeraldDataContext, ChecklistFrequency>
    {
        public static ChecklistFrequencyDataAccess Instance = new ChecklistFrequencyDataAccess();

        public ChecklistFrequencyDataAccess() : base(EmeraldDataContext.GetContext())
        { }

        public static List<ChecklistFrequency> GetChecklistFrequencys()
        {
            
            using (var context = Model.EmeraldDataContext.GetContext())
                return context.ChecklistFrequencys.FromCache().ToList();
          
        }

        public static List<SelectListItem> GetChecklistFrequencySelectionItems()
        {
            return GetChecklistFrequencys().Select(l => new SelectListItem
            {
                Value = l.Id,
                Text = l.Name
            }).ToList();
        }

        public override void AfterDelete()
        {
            QueryCacheManager.ExpireAll();
        }

        public override void AfterInsert()
        {
            QueryCacheManager.ExpireAll();
        }
        public override void AfterUpdate()
        {
            QueryCacheManager.ExpireAll();
        }

    }
}
