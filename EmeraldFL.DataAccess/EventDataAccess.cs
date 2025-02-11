using EmeraldFL.DataAccess.Framework;
using EmeraldFL.DataAccess.Model;
using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;


namespace EmeraldFL.DataAccess
{
    public class EventDataAccess
    {
        public static EventDataAccess Instance = new EventDataAccess();

        public async Task AddEventAsync(Event evt)
        {
            using (var scope = new TransactionScope(TransactionScopeOption.Suppress))
            {
                using (var context = new EmeraldDataContext())
                {
                    context.Events.Add(evt);
                    await context.SaveChangesAsync();
                }
            }
        }

        public  async Task AddEventAsync(int? uId, string ipAddress, string action, string description, int? locationId, DateTime eventdate)
        {
            Event evt = new Event()
            {
                UserId = uId,
                IpPAddress = ipAddress,
                Action = action,
                Description = description,
                Eventdate = eventdate,
                LocationId = 1
            };

            await AddEventAsync(evt);

        }

        public void AddEvent(Event evt)
        {
            using (var scope = new TransactionScope(TransactionScopeOption.Suppress))
            {
                using (var context = new EmeraldDataContext())
                {
                    context.Events.Add(evt);
                    context.SaveChanges();
                }
            }
        }

        public void AddEvent(int? uId, string ipAddress, string action, string description, DateTime eventdate, int locID)
        {
            Event evt = new Event()
            {
                UserId = uId,
                IpPAddress = ipAddress,
                Action = action,
                Description = description,
                Eventdate = eventdate,
                Location = locID
            };
            Task.Run(() => AddEvent(evt));
        }




    }
}
