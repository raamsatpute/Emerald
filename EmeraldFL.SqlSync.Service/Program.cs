using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmeraldFL.SqlSync.Service
{
    class Program
    {
        static void Main(string[] args)
        {
            LogManager.ThrowExceptions = true;
            Logger logger = LogManager.GetLogger("Main");
            ServiceConfiguration.Configure();
        }
    }
}
