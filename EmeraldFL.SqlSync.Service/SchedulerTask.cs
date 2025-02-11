using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Security.Cryptography;
using System.Drawing;
using NLog;
using Quartz;
using System.Configuration;
using Newtonsoft.Json;
using System.Data.SqlClient;

namespace EmeraldFL.SqlSync.Service
{
    internal class SchedulerTask : ServiceTaskBase, IServiceTask
    {
        private Logger log = null;
        private bool _stopping;

        private List<string> _targets = new List<string>();

        public SchedulerTask()
        {
            log = LogManager.GetLogger(GetType().FullName);
            log.Info("SchedulerTask Constructor Begin\nService.Start - Begin");

            try
            {
                log.Info("SchedulerTask Service.Start - initializing Schedule Targets");
                _targets = ConfigurationManager.AppSettings.AllKeys
                           .Where(key => key.StartsWith("Scheduler_"))
                           .Select(key => ConfigurationManager.AppSettings[key])
                           .ToList();

                log.Info($"SchedulerTask Service.Start - Schedule Targets initialized with {_targets.Count()} targets staged");

            }
            catch (Exception ex)
            {
                log.Fatal(ex, "Can not read Schedule Targets");
                throw;
            }

            log.Info("ScheduleTask Constructor Complete");
        }

        public void Start()
        {
            _stopping = false;
        }
        public void Stop()
        {
            _stopping = true;
        }

        public void Execute(IJobExecutionContext context)
        {
            DateTime start = DateTime.Now;
            log.Info("SchedulerTask Service.Execute - initializing Schedule Targets");
            
            foreach (var db in _targets)
            {
                if (_stopping)
                    continue;
                Execute(db);
            }
        }

        private void Execute(string conn)
        {
            try
            {
                log.Info($"SchedulerTask Service.Execute - Intializing Schedule Target {conn}");
                var connectionString = ConfigurationManager.ConnectionStrings[conn].ConnectionString;

                var queryString = "EXEC usp_ResheduleRecurring";
                log.Info($"SchedulerTask Service.Execute - Executing Query {queryString}");

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(queryString, connection);
                    command.Connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    StringBuilder entry = new StringBuilder("\n");
                    while (reader.Read())
                    {
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            entry.Append($" {reader[i]} |");
                        }
                        entry.AppendLine();
                    }
                    log.Trace(entry.ToString());
                }
            }
            catch (Exception ex)
            {
                log.Error("Error executing script against table {table};  turn on trace in the web.config for more details");
                log.Error(ex);
            }
            log.Info($"SchedulerTask Service.Execute - Complete");
           
        }


    }
    
}
