using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using Z.EntityFramework.Plus;

namespace EmeraldFL.DataAccess
{
    public class ChecklistAreaTypeDataAccess : GenericRepositoryGuid<EmeraldDataContext, ChecklistAreaType>
    {
        public static ChecklistAreaTypeDataAccess Instance = new ChecklistAreaTypeDataAccess();

        public ChecklistAreaTypeDataAccess() : base(EmeraldDataContext.GetContext())
        { }

        public static List<ChecklistAreaType> GetAreaTypes()
        {
            using (var context = Model.EmeraldDataContext.GetContext())
                return context.ChecklistAreaTypes.FromCache().ToList();
          
        }

        public static List<SelectListItem<Guid>> GetAreaTypeSelectionItems()
        {
            return GetAreaTypes().Select(l => new SelectListItem<Guid>
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
