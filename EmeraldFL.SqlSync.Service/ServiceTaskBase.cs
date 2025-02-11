using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Quartz;

namespace EmeraldFL.SqlSync.Service
{
    internal class ServiceTaskBase
    {
        protected Logger LogWriter { get; private set; }

        protected ServiceTaskBase()
        {
            LogWriter = LogManager.GetLogger(GetType().FullName);
        }
    }

    internal interface IServiceTask : IJob
    {
        void Start();
        void Stop();
    }

}