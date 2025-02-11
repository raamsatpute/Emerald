using System;
using System.Data.Entity;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;

namespace EmeraldFL.DataAccess.Framework
{
    public class SoftDeleteQueryVisitor : DefaultExpressionVisitor
    {
        private readonly DbContext _context;

        public SoftDeleteQueryVisitor(DbContext context)
        {
            _context = context;
        }

        private bool IncludeSoftDeletedEntities
        {
            get { return false; }
        }

        public override DbExpression Visit(DbScanExpression expression)
        {
            var columnSpec = SoftDeleteAttribute.GetAttribute(expression.Target.ElementType);

            if (columnSpec != null && IncludeSoftDeletedEntities == false)
            {
                var table = (EntityType)expression.Target.ElementType;

                if (table.Properties.Any(p => p.Name == columnSpec.ColumnName))
                {
                    var binding = expression.Bind();

                    switch (columnSpec.Comparison)
                    {
                        case SoftDeleteAttribute.ComparisonType.Boolean:
                            {
                                return binding.Filter(binding.VariableType.Variable(binding.VariableName).Property(columnSpec.ColumnName).NotEqual(DbExpression.FromBoolean(columnSpec.BooleanValue)));
                            }
                        case SoftDeleteAttribute.ComparisonType.Integer:
                            {
                                return binding.Filter(binding.VariableType.Variable(binding.VariableName).Property(columnSpec.ColumnName).NotEqual(DbExpression.FromInt32(columnSpec.IntegerValue)));
                            }
                        case SoftDeleteAttribute.ComparisonType.String:
                            {
                                return binding.Filter(binding.VariableType.Variable(binding.VariableName).Property(columnSpec.ColumnName).NotEqual(DbExpression.FromString(columnSpec.StringValue)));
                            }
                        default:
                            {
                                throw new NotSupportedException($"Invalid comparison type: {columnSpec.Comparison}");
                            }
                    }
                }
            }

            return base.Visit(expression);
        }
    }
}