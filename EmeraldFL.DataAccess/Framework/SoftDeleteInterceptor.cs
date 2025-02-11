using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.Entity.Infrastructure.Interception;
using System.Linq;

namespace EmeraldFL.DataAccess.Framework
{
    public class SoftDeleteInterceptor : IDbCommandTreeInterceptor
    {
        public void TreeCreated(DbCommandTreeInterceptionContext interceptionContext)
        {
            if (interceptionContext.OriginalResult.DataSpace == DataSpace.SSpace)
            {
                var queryCommand = interceptionContext.Result as DbQueryCommandTree;
                if (queryCommand != null)
                {

                    var newQuery = queryCommand.Query.Accept(new SoftDeleteQueryVisitor(interceptionContext.DbContexts.FirstOrDefault()));
                    interceptionContext.Result = new DbQueryCommandTree(
                        queryCommand.MetadataWorkspace,
                        queryCommand.DataSpace,
                        newQuery);
                }

                var deleteCommand = interceptionContext.OriginalResult as DbDeleteCommandTree;
                if (deleteCommand != null)
                {
                    var columnSpec = SoftDeleteAttribute.GetAttribute(deleteCommand.Target.VariableType.EdmType);
                    if (columnSpec != null)
                    {
                        var setClauses = new List<DbModificationClause>();
                        var table = (EntityType)deleteCommand.Target.VariableType.EdmType;
                        if (table.Properties.Any(p => p.Name == columnSpec.ColumnName))
                        {
                            //setClauses.Add(DbExpressionBuilder.SetClause(
                            //        deleteCommand.Target.VariableType.Variable(deleteCommand.Target.VariableName).Property(columnSpec.ColumnName),
                            //        DbExpression.FromBoolean(true)));
                        }

                        var update = new DbUpdateCommandTree(
                            deleteCommand.MetadataWorkspace,
                            deleteCommand.DataSpace,
                            deleteCommand.Target,
                            deleteCommand.Predicate,
                            setClauses.AsReadOnly(),
                            null);

                        interceptionContext.Result = update;
                    }
                }
            }
        }
    }
}