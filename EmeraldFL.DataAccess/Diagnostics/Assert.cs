using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace EmeraldFL.DataAccess.Diagnostics
{
    [DebuggerNonUserCode]
    public static class Assert
    {
        public static void Condition(bool condition, string message)
        {
            if (!condition)
                throw new ApplicationException(message);
        }

        public static void IsNotNullOrEmpty(string value, string variableName)
        {
            Condition(!string.IsNullOrEmpty(value), $"Value cannot be null. Variable name: {variableName}.");
        }

        public static void IsNotEmpty<T>(IEnumerable<T> collection, string collectionName)
        {
            Condition(collection.Any(), $"Collection cannot be empty. Collection name: {collectionName}.");
        }

        public static void IsNotNullOrEmpty<T>(IEnumerable<T> collection, string collectionName)
        {
            Condition(collection != null, $"Collection cannot be null. Collection name: {collectionName}.");
            IsNotEmpty(collection, collectionName);
        }

        public static void IsNotNull(object obj, string variableName)
        {
            Condition(obj != null, $"Value cannot be null. Variable name: {variableName}.");
        }

        public static void IsNull(object obj, string variableName)
        {
            Condition(obj == null, $"Value should be null. Variable name: {variableName}.");
        }

        public static void Fail(string message)
        {
            Condition(false, message);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="val"></param>
        /// <param name="variableName"></param>
        public static void IsValidEnumValue<T>(T val, string variableName) where T : struct
        {
            Condition(Enum.IsDefined(typeof(T), val), $"Value is not valid for enum {typeof(T).Name}: {val}");
        }
    }
}
