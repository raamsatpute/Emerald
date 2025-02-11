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
    public class UserDataAccess : GenericRepository<EmeraldDataContext, User>
    {
        public static UserDataAccess Instance = new UserDataAccess();

        public UserDataAccess() : base(EmeraldDataContext.GetContext())
        {
            
        }

        public static User GetUser(string UserId, int LocationId)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                var user = context.Users.Include("Location").Where(p => p.UserId == UserId && p.LocationId == LocationId).SingleOrDefault();
                return user;
            }
        }
                
        public async void UpdateLoginAsync(int userId, DateTime dtm, int LocationId)
        {
            using (var context = Model.EmeraldDataContext.GetContext())
            {
                var user = context.Users.Find(userId);

                if (user == null)
                    return;

                user.Lastlogin = dtm;
                await context.SaveChangesAsync();
            }
        }
    }
}
