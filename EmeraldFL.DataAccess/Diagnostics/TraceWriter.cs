using System;
using System.Data.Entity.Core.Objects;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Text;

namespace EmeraldFL.DataAccess.Diagnostics
{
    public class TraceWriter : IDisposable
    {
        #region Fields
        private const string Source = "DataAccessLayer";
        private static readonly TraceSource TraceSource = new TraceSource(Source);
        private static int _nextId;

        private string Message { get; set; }
        private int Id { get; set; }
        #endregion

        #region Construction and Destruction
        public TraceWriter(string message)
        {
            Id = NextId();
            Message = message;
            TraceSource.TraceEvent(TraceEventType.Start, Id, "Start: " + Message);
        }

        public void Dispose()
        {
            TraceSource.TraceEvent(TraceEventType.Stop, Id, "End: " + Message);
        }
        #endregion

        #region Methods
        [MethodImpl(MethodImplOptions.Synchronized)]
        private static int NextId()
        {
            return _nextId++;
        }

        public static void Write(string message, TraceEventType traceEventType = TraceEventType.Information)
        {
            TraceSource.TraceEvent(traceEventType, NextId(), message);
        }

        public static void TraceSql(object query)
        {
#if DEBUG
            var objectQuery = query as ObjectQuery;
            if (objectQuery == null)
                return;

            StringBuilder builder = new StringBuilder("\n~~~~~~~~~~~\n");

            foreach (var item in objectQuery.Parameters)
            {
                string type;
                if (item.ParameterType == typeof(string))
                    type = $"varchar({item.Value.ToString().Length})";
                else if (item.ParameterType == typeof(int))
                    type = "int";
                else if (item.ParameterType == typeof(DateTime))
                    type = "datetime";
                else
                    type = "Unknown type - Add to Case Statement";

                builder.AppendLine($"DECLARE @{item.Name} {type}");
                builder.AppendLine($"SET @{item.Name} = '{item.Value}'");
            }
            builder.AppendLine(objectQuery.ToTraceString());

            Debug.WriteLine(builder.ToString());
            TraceSource.TraceEvent(TraceEventType.Verbose, NextId(), builder.ToString());
#endif
        }
        #endregion
    }
}
