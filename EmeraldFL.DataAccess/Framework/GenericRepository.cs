using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Diagnostics;

namespace EmeraldFL.DataAccess.Framework
{
    public class GenericRepository<TContext, TEntity> : IGenericRepository<TEntity>
        where TContext : DbContext, new()
        where TEntity : class, IEntity, new()
    {
        protected TContext Context;
        protected readonly Func<TContext> _GetContextFunc;


        public GenericRepository()
        { }

        public GenericRepository(TContext context)
        {
            Context = context;
        }

        public GenericRepository(Func<TContext> contextFunc)
        {
            Assert.IsNotNull(contextFunc, nameof(contextFunc));
            _GetContextFunc = contextFunc;
            Context = _GetContextFunc();
        }

        public virtual ICollection<TEntity> GetAll()
        {
            return Context.Set<TEntity>().ToList();
        }



        public virtual IQueryable<TEntity> GetAllAsQueryable()
        {

            IQueryable<TEntity> query = Context.Set<TEntity>();
            return query;
        }

        public virtual IQueryable<TEntity> FindAllAsQueryable(Expression<Func<TEntity, bool>> predicate)
        {
            IQueryable<TEntity> query = Context.Set<TEntity>().Where(predicate);
            return query;
        }

        public virtual async Task<ICollection<TEntity>> GetAllAsync()
        {
            return await Context.Set<TEntity>().ToListAsync();
        }

        public virtual TEntity Get(int id)
        {
            return Context.Set<TEntity>().Find(id);
        }


        public virtual async Task<TEntity> GetAsync(int id)
        {
            return await Context.Set<TEntity>().FindAsync(id);
        }

        public virtual TEntity Find(Expression<Func<TEntity, bool>> criteria)
        {
            return Context.Set<TEntity>().SingleOrDefault(criteria);
        }




        public virtual async Task<TEntity> FindAsync(Expression<Func<TEntity, bool>> criteria)
        {
            return await Context.Set<TEntity>().SingleOrDefaultAsync(criteria);
        }

        public virtual ICollection<TEntity> FindAll(Expression<Func<TEntity, bool>> criteria)
        {
            return Context.Set<TEntity>().Where(criteria).ToList();
        }

        public virtual async Task<ICollection<TEntity>> FindAllAsync(Expression<Func<TEntity, bool>> criteria)
        {
            return await Context.Set<TEntity>().Where(criteria).ToListAsync();
        }

        public virtual TEntity Insert(TEntity t)
        {
            Context.Set<TEntity>().Add(t);
            Context.SaveChanges();
            AfterInsert();
            return t;
        }

        public virtual void Insert(IEnumerable<TEntity> t)
        {
            Context.Set<TEntity>().AddRange(t);
            Context.SaveChanges();
            AfterInsert();
        }

        public virtual async Task<TEntity> InsertAsync(TEntity t)
        {
            Context.Set<TEntity>().Add(t);
            await Context.SaveChangesAsync();
            AfterInsert();
            return t;
        }

        public virtual TEntity Update(TEntity updated, int key = 0)
        {
            if (updated == null)
                return null;

            if (key == 0)
                key = updated.Id;

            Assert.Condition(key != 0, "Key was not set to an valid value.");

            TEntity existing = Context.Set<TEntity>().Find(key);
            if (existing != null)
            {
                Context.Entry(existing).CurrentValues.SetValues(updated);
                Context.SaveChanges();
            }
            AfterUpdate();
            return existing;
        }

        public virtual async Task<TEntity> UpdateAsync(TEntity updated, int key = 0)
        {
            if (updated == null)
                return null;


            if (key == 0)
                key = updated.Id;

            TEntity existing = await Context.Set<TEntity>().FindAsync(key);
            if (existing != null)
            {
                Context.Entry(existing).CurrentValues.SetValues(updated);
                await Context.SaveChangesAsync();
            }
            AfterUpdate();
            return existing;
        }

        public virtual void Delete(TEntity t)
        {
            Context.Set<TEntity>().Remove(t);
            Context.SaveChanges();
            AfterDelete();
        }

        public virtual void Delete(int id)
        {
            TEntity entity = Context.Set<TEntity>().Find(id);

            if (entity == null)
                return;

            Context.Set<TEntity>().Remove(entity);
            Context.SaveChanges();
            AfterDelete();
        }

        public virtual async Task<int> DeleteAsync(TEntity t)
        {
            try
            {
                Context.Set<TEntity>().Remove(t);
                return await Context.SaveChangesAsync();
            }
            finally
            {
                AfterDelete();
            }
        }

        public virtual int Count()
        {
            return Context.Set<TEntity>().Count();
        }

        public virtual async Task<int> CountAsync()
        {
            return await Context.Set<TEntity>().CountAsync();
        }


        public virtual void AfterInsert() { }
        public virtual void AfterUpdate() { }
        public virtual void AfterDelete() { }


    }
}