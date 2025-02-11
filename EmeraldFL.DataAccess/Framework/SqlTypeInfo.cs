using System;

namespace EmeraldFL.DataAccess.Framework
{
    public enum SqlDataType
    {
        Unknown,
        Image,
        Text,
        UniqueIdentifier,
        Date,
        Time,
        DateTime2,
        DateTimeOffset,
        TinyInt,
        SmallInt,
        Int,
        SmallDateTime,
        Real,
        Money,
        DateTime,
        Float,
        Variant,
        NText,
        Bit,
        Decimal,
        Numeric,
        SmallMoney,
        BigInt,
        HierarchyId,
        Geometry,
        Geography,
        VarBinary,
        VarChar,
        Binary,
        Char,
        TimeStamp,
        NVarChar,
        NChar,
        Xml,
        SysName
    }

    public enum DotNetDataType
    {
        Unknown,
        ByteArray,
        String,
        Guid,
        DateTime,
        DateTimeOffset,
        Byte,
        Short,
        Int,
        Long,
        Decimal,
        Double,
        Bool,
        Xml,
        TimeSpan
    }

    public static class SqlDataTypes
    {
        public const string BigInt = "bigint";
        public const string Binary = "binary";
        public const string Bit = "bit";
        public const string Char = "char";
        public const string Date = "date";
        public const string DateTime = "datetime";
        public const string DateTime2 = "datetime2";
        public const string DateTimeOffset = "datetimeoffset";
        public const string Decimal = "decimal";
        public const string Float = "float";
        public const string Geography = "geography";
        public const string Geometry = "geometry";
        public const string HierarchyId = "hierarchyid";
        public const string Image = "image";
        public const string Int = "int";
        public const string Money = "money";
        public const string NChar = "nchar";
        public const string NText = "ntext";
        public const string Numeric = "numeric";
        public const string NVarChar = "nvarchar";
        public const string Real = "real";
        public const string SmallDateTime = "smalldatetime";
        public const string SmallInt = "smallint";
        public const string SmallMoney = "smallmoney";
        public const string Variant = "sql_variant";
        public const string SysName = "sysname";
        public const string Text = "text";
        public const string Time = "time";
        public const string TimeStamp = "timestamp";
        public const string TinyInt = "tinyint";
        public const string UniqueIdentifier = "uniqueidentifier";
        public const string VarBinary = "varbinary";
        public const string VarChar = "varchar";
        public const string Xml = "xml";
    }

    public class TypeInfoFactory
    {
        public static SqlDataType GetSqlType(string type)
        {
            switch (type)
            {
                case "bigint":
                    return SqlDataType.BigInt;
                case "binary":
                    return SqlDataType.Binary;
                case "bit":
                    return SqlDataType.Bit;
                case "char":
                    return SqlDataType.Char;
                case "date":
                    return SqlDataType.Date;
                case "datetime":
                    return SqlDataType.DateTime;
                case "datetime2":
                    return SqlDataType.DateTime2;
                case "datetimeoffset":
                    return SqlDataType.DateTimeOffset;
                case "decimal":
                    return SqlDataType.Decimal;
                case "float":
                    return SqlDataType.Float;
                case "geography":
                    return SqlDataType.Geography;
                case "geometry":
                    return SqlDataType.Geometry;
                case "hierarchyid":
                    return SqlDataType.HierarchyId;
                case "image":
                    return SqlDataType.Image;
                case "int":
                    return SqlDataType.Int;
                case "money":
                    return SqlDataType.Money;
                case "nchar":
                    return SqlDataType.NChar;
                case "ntext":
                    return SqlDataType.NText;
                case "numeric":
                    return SqlDataType.Numeric;
                case "nvarchar":
                    return SqlDataType.NVarChar;
                case "real":
                    return SqlDataType.Real;
                case "smalldatetime":
                    return SqlDataType.SmallDateTime;
                case "smallint":
                    return SqlDataType.SmallInt;
                case "smallmoney":
                    return SqlDataType.SmallMoney;
                case "sql_variant":
                    return SqlDataType.Variant;
                case "sysname":
                    return SqlDataType.SysName;
                case "text":
                    return SqlDataType.Text;
                case "time":
                    return SqlDataType.Time;
                case "timestamp":
                    return SqlDataType.TimeStamp;
                case "tinyint":
                    return SqlDataType.TinyInt;
                case "uniqueidentifier":
                    return SqlDataType.UniqueIdentifier;
                case "varbinary":
                    return SqlDataType.VarBinary;
                case "varchar":
                    return SqlDataType.VarChar;
                case "xml":
                    return SqlDataType.Xml;
                default:
                    throw new ArgumentOutOfRangeException(nameof(type), $"Unrecognized SQL type: {type}");
            }
        }

        private static string GetSqlNullableDef(bool isNullable)
        {
            return isNullable ? string.Empty : " NOT NULL";
        }

        private static string GetSqlIdentityDef(bool isIdentity)
        {
            return isIdentity ? " IDENTITY(1, 1)" : string.Empty;
        }

        private static string GetSqlSuffix(bool isNullable, bool isIdentity)
        {
            return GetSqlNullableDef(isNullable) + GetSqlIdentityDef(isIdentity);
        }

        public static string GetSqlTypeDef(string type, int length, int scale, int precision, bool isNullable, bool isIdentity)
        {
            switch (type)
            {
                case "decimal":
                case "numeric":
                    return $"{type}({precision}, {scale}){GetSqlSuffix(isNullable, isIdentity)}";
                case "float":
                case "datetime2":
                case "time":
                case "datetimeoffset":
                    return $"{type}({scale}){GetSqlSuffix(isNullable, isIdentity)}";
                case "nchar":
                case "nvarchar":
                case "binary":
                case "varbinary":
                case "char":
                case "varchar":
                    return (length == -1 ? $"{type}(max)" : $"{type}({length})") + GetSqlSuffix(isNullable, isIdentity);
                default:
                    return $"{type}{GetSqlSuffix(isNullable, isIdentity)}";
            }
        }

        public static DotNetDataType GetDotNetType(SqlDataType type)
        {
            switch (type)
            {
                // BOOL
                case SqlDataType.Bit:
                    return DotNetDataType.Bool;

                //BYTE
                case SqlDataType.TinyInt:
                    return DotNetDataType.Byte;

                //BYTE ARRAY
                case SqlDataType.Binary:
                case SqlDataType.VarBinary:
                case SqlDataType.Image:
                    return DotNetDataType.ByteArray;

                //DateTime
                case SqlDataType.Date:
                case SqlDataType.DateTime:
                case SqlDataType.DateTime2:
                case SqlDataType.TimeStamp:
                case SqlDataType.SmallDateTime:
                    return DotNetDataType.DateTime;

                //DateTimeOffset
                case SqlDataType.DateTimeOffset:
                    return DotNetDataType.DateTimeOffset;

                //DECIMAL 
                case SqlDataType.Money:
                case SqlDataType.Numeric:
                case SqlDataType.Real:
                case SqlDataType.SmallMoney:
                case SqlDataType.Decimal:
                    return DotNetDataType.Decimal;

                //DOUBLE
                case SqlDataType.Float:
                    return DotNetDataType.Double;

                //GUID 
                case SqlDataType.UniqueIdentifier:
                    return DotNetDataType.Guid;

                //INT
                case SqlDataType.Int:
                    return DotNetDataType.Int;

                //LONG
                case SqlDataType.BigInt:
                    return DotNetDataType.Long;

                //SHORT 
                case
                SqlDataType.SmallInt:
                    return DotNetDataType.Short;

                //STRING
                case SqlDataType.NChar:
                case SqlDataType.NText:
                case SqlDataType.Char:
                case SqlDataType.NVarChar:
                case SqlDataType.SysName:
                case SqlDataType.Text:
                case SqlDataType.Xml:
                case SqlDataType.VarChar:
                    return DotNetDataType.String;

                //TIMESPAN
                case SqlDataType.Time:
                    return DotNetDataType.TimeSpan;

                default:
                    throw new ArgumentOutOfRangeException(nameof(type), $"Unrecognized SQL type: {type}");
            }
        }

        public static string GetDotNetTypeDef(SqlDataType type, bool isNullable)
        {
            switch (GetDotNetType(type))
            {
                case DotNetDataType.Bool:
                    return $"bool{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.Byte:
                    return $"byte{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.ByteArray:
                    return "byte[]";
                case DotNetDataType.DateTime:
                    return $"DateTime{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.DateTimeOffset:
                    return $"DateTimeOffset{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.Decimal:
                    return $"decimal{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.Double:
                    return $"double{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.Guid:
                    return $"Guid{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.Int:
                    return $"int{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.Long:
                    return $"long{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.Short:
                    return $"short{GetDotNetNullableSuffix(isNullable)}";
                case DotNetDataType.String:
                    return $"string";
                case DotNetDataType.TimeSpan:
                    return $"TimeSpan{GetDotNetNullableSuffix(isNullable)}";
                default:
                    throw new ArgumentOutOfRangeException(nameof(type), $"Unrecognized type: {type}");
            }
        }
        private static string GetDotNetNullableSuffix(bool isNullable)
        {
            return isNullable ? "?" : string.Empty;
        }
    }



}
