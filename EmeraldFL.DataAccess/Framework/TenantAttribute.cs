using System;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;

namespace EmeraldFL.DataAccess.Framework
{

    public class TenantAttribute : Attribute
    {
        const string DefaultColumnName = "TenantId";
        public  string ColumnName { get; private set; }

        public TenantAttribute() : this (DefaultColumnName)
        {}

        public TenantAttribute(string column)
        {
            ColumnName = column;
        }
        
        public static string GetColumnName(EdmType type)
        {
            MetadataProperty annotation = type.MetadataProperties
                .SingleOrDefault(p => p.Name.EndsWith("customannotation:TenantColumnName"));

            return (string)annotation?.Value;
        }
    }
}
