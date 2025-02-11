using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmeraldFL.SqlSync.Service
{
    internal class ConnectionInfo
    {
        public string Connection { get; set; }
        public string Script { get; set; }
        public string sync_direction { get; set; }
        public int step { get; set; }
    }
}
