using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NLog;
using Quartz;
using Quartz.Impl;
using System.Configuration;

namespace EmeraldFL.SqlSync.Service
{


    public class TaskManager
    {
        private Logger LogWriter = null;
        private IScheduler sched;

        public TaskManager()
        {
            LogWriter = LogManager.GetLogger(GetType().FullName);

            ISchedulerFactory schedFact = new StdSchedulerFactory();
            sched = schedFact.GetScheduler();
            sched.Start();
        }

        public void Start()
        {
            int intervalInMinutes;

            int schedulerintervalInMinutes;
            bool syncEnabled = false;
            bool reoccuringEnabled = false;

            if (!int.TryParse(ConfigurationManager.AppSettings["SyncIntervalInMinutes"], out intervalInMinutes))
                intervalInMinutes = 10;

            if (!int.TryParse(ConfigurationManager.AppSettings["SchedulerIntervalInMinutes"], out schedulerintervalInMinutes))
                schedulerintervalInMinutes = 10;

            if (!bool.TryParse(ConfigurationManager.AppSettings["SyncEnabled"], out syncEnabled))
                syncEnabled = false;

            if (!bool.TryParse(ConfigurationManager.AppSettings["SchedulerEnabled"], out reoccuringEnabled))
                reoccuringEnabled = false;


            LogWriter.Trace("Service.Start invoked");
            try
            {

                if (syncEnabled)
                {
                    IJobDetail job = JobBuilder.Create<SyncTask>()
                      .Build();

                    // Trigger the job to run now, and then every X seconds Minutes
                    ITrigger trigger = TriggerBuilder.Create()
                        .StartNow()
                        .WithSimpleSchedule(x => x
                            .WithIntervalInMinutes(intervalInMinutes)
                            .RepeatForever())
                        .Build();

                    sched.ScheduleJob(job, trigger);
                }

                if (reoccuringEnabled)
                {
                    IJobDetail job = JobBuilder.Create<SchedulerTask>()
                      .Build();

                    // Trigger the job to run now, and then every X seconds Minutes
                    ITrigger trigger = TriggerBuilder.Create()
                        .StartNow()
                        .WithSimpleSchedule(x => x
                            .WithIntervalInMinutes(schedulerintervalInMinutes)
                            .RepeatForever())
                        .Build();

                    sched.ScheduleJob(job, trigger);
                }
            }
            catch (Exception ex)
            {
                LogWriter.Fatal(ex, "Error in Service.Start");
            }
        }
        public void Stop()
        {
            LogWriter.Warn("Service.Stop invoked");
            try
            {
                sched.Shutdown();

            }
            catch (Exception ex)
            {
                LogWriter.Fatal(ex, "Error in Service.Stop");
            }

        }
    }
}

