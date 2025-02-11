using System;
using System.Collections.Concurrent;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;

namespace EmeraldFL.DataAccess.Framework
{
    /// <summary>
    ///  Specifies the column and value to use to determine if an entity is soft-deleted.
    ///  Soft-Delete is a convention where instead of physically deleting a row in a table, a column is designated
    ///   as the &apos;flag&apos; that indicates that a record is deleted.
    /// </summary>
    public sealed class SoftDeleteAttribute : Attribute
    {
        /// <summary>
        ///  Type of comparison to perform for determining soft-deleted state
        /// </summary>
        public enum ComparisonType
        {
            Boolean,
            String,
            Integer
        }

        /// <summary>Name of annotation to use for EF</summary>
        public const string AnnotationName = @"SoftDeleteSpecification";

        private readonly static ConcurrentDictionary<string, SoftDeleteAttribute> _softDeleteColumns = new ConcurrentDictionary<string, SoftDeleteAttribute>();
        private readonly static string MetadataPropertyEndsWithPattern = $"customannotation:{AnnotationName}";

        public SoftDeleteAttribute() { }

        /// <summary>
        ///  Constructs a SoftDeleteAttribute
        /// </summary>
        /// <param name="column">The database table column that is used to determine if an entity is (soft-deleted)</param>
        /// <param name="value">The value that indicates an entity is in a (soft-)deleted state</param>
        public SoftDeleteAttribute(string column, bool value)
            : this(column, ComparisonType.Boolean)
        {
            BooleanValue = value;
        }

        /// <summary>
        ///  Constructs a SoftDeleteAttribute
        /// </summary>
        /// <param name="column">The database table column that is used to determine if an entity is (soft-deleted)</param>
        /// <param name="value">The value that indicates an entity is in a (soft-)deleted state</param>
        public SoftDeleteAttribute(string column, int value)
            : this(column, ComparisonType.Integer)
        {
            IntegerValue = value;
        }

        /// <summary>
        ///  Constructs a SoftDeleteAttribute
        /// </summary>
        /// <param name="column">The database table column that is used to determine if an entity is (soft-deleted)</param>
        /// <param name="value">The value that indicates an entity is in a (soft-)deleted state</param>
        public SoftDeleteAttribute(string column, string value)
            : this(column, ComparisonType.String)
        {
            StringValue = value;
        }

        private SoftDeleteAttribute(string column, ComparisonType comparisonType)
        {
            if (string.IsNullOrEmpty(column))
            {
                throw new ArgumentNullException(nameof(column));
            }

            ColumnName = column;
            Comparison = comparisonType;
        }

        /// <summary>
        ///  The name of the column that is used to determine if an entity is (soft-)deleted
        /// </summary>
        public string ColumnName { get; set; }

        /// <summary>
        ///  Specifies the comparison strategy for determining if the value indicates an entity is (soft-)deleted
        /// </summary>
        public ComparisonType Comparison { get; set; }

        /// <summary>
        ///  Used in conjunction with the Comparison to determine the boolean value to compare against to determine if an entity is (soft-)deleted
        /// </summary>
        public bool BooleanValue { get { return _booleanValue.GetValueOrDefault(); } set { _booleanValue = value; } }
        private bool? _booleanValue;

        /// <summary>
        ///  Used in conjunction with the Comparison to determine the string value to compare against to determine if an entity is (soft-)deleted.  null is NOT allowable.
        /// </summary>
        public string StringValue { get { return _stringValue; } set { _stringValue = value; } }
        private string _stringValue;

        /// <summary>
        ///  Used in conjunction with the Comparison to determine the integer value to compare against to determine if an entity is (soft-)deleted
        /// </summary>
        public int IntegerValue { get { return _integerValue.GetValueOrDefault(); } set { _integerValue = value; } }
        private int? _integerValue;
        
        /// <summary>
        ///  Retrieves the SoftDeleteAttribute from the entity type via its metadata if it exists.  Result is null if none is found.
        /// </summary>
        /// <param name="type">The entity type</param>
        /// <returns>The attribute if it is definied in the entity type&apos;s metadata, otherwise null.</returns>
        internal static SoftDeleteAttribute GetAttribute(EdmType type)
        {
            var key = type.FullName;
            SoftDeleteAttribute spec;

            if (_softDeleteColumns.TryGetValue(key, out spec))
            {
                return spec;
            }
            var annotation =
                type.MetadataProperties
                    .FirstOrDefault(p => p.Name.EndsWith(MetadataPropertyEndsWithPattern));

            if (annotation == null)
            {
                _softDeleteColumns.TryAdd(key, null);
                return null;
            }
            var result = annotation.Value as SoftDeleteAttribute;
            _softDeleteColumns.TryAdd(key, result);
            return result;
        }

        private void Validate()
        {
            if (string.IsNullOrEmpty(ColumnName))
            {
                throw new InvalidOperationException($"{nameof(ColumnName)} not specified for {nameof(SoftDeleteAttribute)}");
            }

            switch (Comparison)
            {
                case ComparisonType.Boolean:
                    {
                        if (_booleanValue.HasValue == false)
                        {
                            throw new InvalidOperationException($"{nameof(BooleanValue)} is not set");
                        }
                    }
                    break;
                case ComparisonType.String:
                    {
                        if (_stringValue == null)
                        {
                            throw new InvalidOperationException($"{nameof(StringValue)} is not set");
                        }
                    }
                    break;
                case ComparisonType.Integer:
                    {
                        if (_integerValue == null)
                        {
                            throw new InvalidOperationException($"{nameof(IntegerValue)} is not set");
                        }
                    }
                    break;
                default:
                    throw new NotSupportedException($"Unhandled comparison type: {Comparison}");
            }
        }
    }
}