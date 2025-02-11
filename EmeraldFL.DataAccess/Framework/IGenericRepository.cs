using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace EmeraldFL.DataAccess.Framework
{
    public interface IGenericRepository<TEntity> where TEntity : IEntity
    {
      
        TEntity Insert(TEntity t);

        int Count();

        void Delete(TEntity t);

        ICollection<TEntity> FindAll(Expression<Func<TEntity, bool>> criteria);

        TEntity Find(Expression<Func<TEntity, bool>> criteria);

        TEntity Get(int id);

        ICollection<TEntity> GetAll();

        TEntity Update(TEntity updated, int key);

        #region AsQuerable

        IQueryable<TEntity> GetAllAsQueryable();

        IQueryable<TEntity> FindAllAsQueryable(Expression<Func<TEntity, bool>> predicate);

        #endregion

        #region Async

        Task<TEntity> InsertAsync(TEntity t);

        Task<int> CountAsync();

        Task<int> DeleteAsync(TEntity t);

        Task<ICollection<TEntity>> GetAllAsync();

        Task<TEntity> GetAsync(int id);

        Task<ICollection<TEntity>> FindAllAsync(Expression<Func<TEntity, bool>> criteria);

        Task<TEntity> FindAsync(Expression<Func<TEntity, bool>> criteria);


        Task<TEntity> UpdateAsync(TEntity updated, int key);
    
        #endregion









    }
}