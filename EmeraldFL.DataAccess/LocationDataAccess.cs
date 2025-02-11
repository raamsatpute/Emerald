using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Data.Linq;
using System.Linq;
using System.Runtime.Caching;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Caching;
using EmeraldFL.DataAccess.Model;
using EmeraldFL.DataAccess.Framework;

namespace EmeraldFL.DataAccess
{
    public class LocationDataAccess : GenericRepository<EmeraldDataContext, Location>
    {
        public static LocationDataAccess Instance = new LocationDataAccess();


        public LocationDataAccess() : base( EmeraldDataContext.GetContext())
        {
        }

        private static readonly string locationKey = Guid.NewGuid().ToString();
        private static readonly string selectionKey = Guid.NewGuid().ToString();

        public static void InvalidateCache()
        {
            if (!GlobalCachingProvider.Instance.Contains(locationKey))
            {
                GlobalCachingProvider.Instance.RemoveItem(locationKey);
            }
        }

        public static List<Location> GetLocations()
        {
            if (!GlobalCachingProvider.Instance.Contains(locationKey))
            {
                CacheItemPolicy policy = new CacheItemPolicy()
                {
                    AbsoluteExpiration = GlobalCachingProvider.Instance.GetCachePolicyOffset(GlobalCachingProvider.Hour),
                };

                using (var context = Model.EmeraldDataContext.GetContext())
                {
                    var cacheValue = context.Locations.ToList();
                    GlobalCachingProvider.Instance.AddItem(locationKey, cacheValue, policy);
                }
            }

            return GlobalCachingProvider.Instance.GetItem(locationKey) as List<Location>;
        }

        public static List<SelectListItem> GetLocationSelectionItems()
        {

            if (!GlobalCachingProvider.Instance.Contains(selectionKey))
            {
                CacheItemPolicy policy = new CacheItemPolicy()
                {
                    AbsoluteExpiration = GlobalCachingProvider.Instance.GetCachePolicyOffset(GlobalCachingProvider.Hour),
                };

                var cacheValue = GetLocations().Select(l => new SelectListItem
                {
                    Value = l.Id,
                    Text = l.LocationName
                })
                .ToList();

                GlobalCachingProvider.Instance.AddItem(selectionKey, cacheValue, policy);
            }

            List<SelectListItem> results = GlobalCachingProvider.Instance.GetItem<List<SelectListItem>>(selectionKey);

            return results;
        }

        public override void AfterInsert()
        {
            InvalidateCache();
        }
        public override void AfterUpdate()
        {
            InvalidateCache();
        }
        public override void AfterDelete()
        {
            InvalidateCache();
        }
    }
}
