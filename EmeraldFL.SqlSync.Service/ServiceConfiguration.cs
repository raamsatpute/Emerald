using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Topshelf;

namespace EmeraldFL.SqlSync.Service
{
    public static class ServiceConfiguration
    {
       

        internal static void Configure()
        {
            HostFactory.Run(configure =>
            {
                configure.Service<TaskManager>(service =>
                {
                    service.ConstructUsing(s => new TaskManager());
                    service.WhenStarted(s => s.Start());
                    service.WhenStopped(s => s.Stop());
                });
                //Setup Account that window service use to run.  
                configure.RunAsLocalSystem();
                configure.SetServiceName("EmeraldFL.SqlSync.Service");
                configure.SetDisplayName("EmeraldFL.SqlSync.Service");
                configure.SetDescription("EmeraldFL.SqlSync.Service - By Harpsoft");
            });
 
        }
    }
}
