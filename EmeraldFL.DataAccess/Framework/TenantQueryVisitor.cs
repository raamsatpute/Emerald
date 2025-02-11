using System.Data.Entity.Core.Common.CommandTrees;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;

namespace EmeraldFL.DataAccess.Framework
{
    public class TenantQueryVisitor : DefaultExpressionVisitor
    {
        readonly int _tenantId = 1;

        public TenantQueryVisitor(int tenantId)
        {
            _tenantId = tenantId;
        }

        public override DbExpression Visit(DbScanExpression expression)
        {
            var column = TenantAttribute.GetColumnName(expression.Target.ElementType);
            if (column != null)
            {
                var table = (EntityType)expression.Target.ElementType;
                if (table.Properties.Any(p => p.Name == column))
                {
                    var binding = expression.Bind();
                    return binding.Filter(binding.VariableType.Variable(binding.VariableName).Property(column).Equal(DbExpression.FromInt32(_tenantId)));
                }
            }
            return base.Visit(expression);
        }
    }
}