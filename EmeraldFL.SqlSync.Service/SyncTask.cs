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
    internal class SyncTask : ServiceTaskBase, IServiceTask
    {
        private Logger log = null;
        private bool _stopping;
        private string _scriptPath = string.Empty;
        private List<ConnectionInfo> _syncTargets = new List<ConnectionInfo>();
        private string _source = string.Empty;


        public SyncTask()
        {
            log = LogManager.GetLogger(GetType().FullName);
            log.Info("SyncTask Constructor Begin\nService.Start - Begin");
            try
            {
                log.Info("Service.Start - initializing Source CN Config");
                _source = ConfigurationManager.AppSettings["Source"];
                log.Info($"Service.Start - Source CN = {_source}");
            }
            catch (Exception ex)
            {
                log.Fatal(ex, "Can not read Source Database");
                throw;
            }

            try
            {
                log.Info("Service.Start - initializing Script Path");
                _scriptPath = ConfigurationManager.AppSettings["ScriptPath"];



                if (!System.IO.Directory.Exists(_scriptPath))
                {
                    log.Error($"Scipt path \"{_scriptPath}\" was not found");
                    throw new FileNotFoundException("ScriptPath was not found");
                }

                log.Info($"Service.Start - Script Path set to {_scriptPath}");
            }
            catch (FileNotFoundException ex)
            {
                log.Fatal(ex);
                throw;
            }
            catch (Exception ex)
            {
                log.Fatal(ex, "Can not read Source Database");
                throw;
            }

            try
            {
                log.Info("Service.Start - initializing Sync Targets");
                _syncTargets = ConfigurationManager.AppSettings.AllKeys
                           .Where(key => key.StartsWith("Sync_"))
                           .Select(key => ConfigurationManager.AppSettings[key])
                           .Select(value => JsonConvert.DeserializeObject<ConnectionInfo>(value))
                           .OrderBy(t => t.step)
                           .ToList();

                log.Info($"Service.Start - Sync Targets initialized with {_syncTargets.Count()} targets staged");

            }
            catch (Exception ex)
            {
                log.Fatal(ex, "Can not read Sync Targets");
                throw;
            }

            log.Info("SyncTask Constructor Complete");
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
            log.Info("Service.Execute - initializing Sync Targets");
            
            foreach (var destination in _syncTargets)
            {
                if (_stopping)
                    continue;
                ExecuteScript(destination);
            }
        }

        private void ExecuteScript(ConnectionInfo conn)
        {
            try
            {
                log.Info($"Service.Execute - Intializing Sync Target {conn.Connection} with script {conn.Script}");
                var script = Path.Combine(_scriptPath, conn.Script);

                log.Info($"Service.Execute - Reading Script file \"{script}\"");
                if (!System.IO.File.Exists(script))
                {
                    log.Error($"Script path \"{script}\" was not found");
                    throw new FileNotFoundException("Script was not found");
                }
                var fileContext = System.IO.File.ReadAllLines(script);
                StringBuilder sb = new StringBuilder();

                string currentTable = string.Empty;
                foreach (var line in fileContext)
                {
                    if (line.StartsWith("\n--- START ["))
                    {
                        int start = line.IndexOf("[");
                        int end = line.IndexOf("]") - (start - 1);
                        currentTable = line.Substring(start, end);
                        sb = new StringBuilder();
                    }
                    else if (line.StartsWith("--- END ["))
                    {
                        ExecuteSqlScript(sb.ToString(), currentTable, ConfigurationManager.ConnectionStrings[conn.Connection].ConnectionString);
                    }
                    sb.AppendLine(line);
                }
            }
            catch (FileNotFoundException ex)
            {
                log.Fatal(ex);
                throw;
            }
            catch (Exception ex)
            {
                log.Error(ex);
            }

        }

        private void ExecuteSqlScript(string queryString, string table, string connectionString)
        {
            try
            {
                log.Trace($"Executing Script on table {table}");
                log.Trace(queryString);

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(queryString, connection);
                    command.Connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    StringBuilder entry = new StringBuilder("\n");
                    if (reader.Read())
                    {
                        for (int i = 0; i < reader.FieldCount; i++)
                            entry.Append($" {reader.GetName(i)} |");

                        int len = entry.ToString().Length;

                        entry.AppendLine();
                        for (int i = 0; i < len; i++)
                            entry.Append($"-");
                        entry.AppendLine();
                    }
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

        }
    }

   




}
