using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using Z.EntityFramework.Plus;

namespace EmeraldFL.DataAccess
{
    public class ChecklistInspectionTypeDataAccess : GenericRepositoryGuid<EmeraldDataContext, ChecklistInspectionType>
    {
        public static ChecklistInspectionTypeDataAccess Instance = new ChecklistInspectionTypeDataAccess();

        public ChecklistInspectionTypeDataAccess() : base(EmeraldDataContext.GetContext())
        { }

        public static List<ChecklistInspectionType> GetChecklistInspectionTypes()
        {
            using (var context = Model.EmeraldDataContext.GetContext())
                return context.ChecklistInspectionTypes.FromCache().ToList();
          
        }

        public static List<SelectListItem<Guid>> GetChecklistInspectionTypeSelectionItems()
        {
            return GetChecklistInspectionTypes().Select(l => new SelectListItem<Guid>
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
