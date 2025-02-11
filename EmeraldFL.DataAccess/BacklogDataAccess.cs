using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Data.Linq;
using System.Linq;
using System.Runtime.Caching;
using System.Text;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Caching;
using EmeraldFL.DataAccess.Helper;

namespace EmeraldFL.DataAccess
{
    public class BacklogDataAccess
    {
        private static readonly string CacheKey = Guid.NewGuid().ToString();

       
        public Dictionary<string, string> GetToolTips()
        {

            if (!GlobalCachingProvider.Instance.Contains(CacheKey))
            {
                CacheItemPolicy policy = new CacheItemPolicy()
                {
                    AbsoluteExpiration = GlobalCachingProvider.Instance.GetCachePolicyOffset(),
                };

                using (var context = Model.EmeraldDataContext.GetContext())
                {
                    var cacheValue = context.Database
                        .SqlQuery<allcomments>("SELECT barcode, [User], DateStamp, comment FROM dbo.allComments where location = " + Helper.Helper.GetLocationIdForCurrentUser())
                        .GroupBy(a => a.barcode)
                        .ToDictionary(a => a.Key, b => BuildToolTip(b.OrderByDescending(e => e.DateStamp).ToList()));

                    GlobalCachingProvider.Instance.AddItem(CacheKey, cacheValue, policy);
                }
            }

            return GlobalCachingProvider.Instance.GetItem(CacheKey) as Dictionary<string, string>;
        }



        private string BuildToolTip(List<allcomments> values)
        {
            if (!values.Any())
                return "";

            StringBuilder sb = new StringBuilder($" There are {values.Count()} comments for job # {values.FirstOrDefault().barcode}{Environment.NewLine}{Environment.NewLine}");

            values.ForEach(v => sb.Append($"{v.User} - {v.DateStamp} {Environment.NewLine} {v.comment} {Environment.NewLine}{Environment.NewLine}"));
            return sb.ToString();
        }


        private class allcomments
        {
            public string barcode { get; set; }
            public string User { get; set; }
            public DateTime? DateStamp { get; set; }
            public string comment { get; set; }

        }
    }
}
