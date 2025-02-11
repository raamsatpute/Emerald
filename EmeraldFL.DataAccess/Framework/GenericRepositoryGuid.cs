using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using EmeraldFL.DataAccess.Diagnostics;

namespace EmeraldFL.DataAccess.Framework
{
    public class GenericRepositoryGuid<TContext, TEntity> : IGenericRepositoryGuid<TEntity>
        where TContext : DbContext, new()
        where TEntity :  EntityGuid, new()

    {
        protected TContext Context;
        protected readonly Func<TContext> _GetContextFunc;


        public GenericRepositoryGuid()
        { }

        public GenericRepositoryGuid(TContext context)
        {
            Context = context;
        }

        public GenericRepositoryGuid(Func<TContext> contextFunc)
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

        public virtual TEntity Get(Guid id)
        {
            return Context.Set<TEntity>().Find(id);
        }


        public virtual async Task<TEntity> GetAsync(Guid id)
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
            if (t.Id == Guid.Empty)
                t.Id = Guid.NewGuid();
            Context.Set<TEntity>().Add(t);
            Context.SaveChanges();
            AfterInsert();
            return t;
        }

        public virtual void Insert(IEnumerable<TEntity> t)
        {
            foreach (TEntity e in t)
            {
                e.Id = (e.Id == Guid.Empty) ? Guid.NewGuid() : e.Id;
            }

            Context.Set<TEntity>().AddRange(t);
            AfterInsert();
            Context.SaveChanges();
        }

        public virtual async Task<TEntity> InsertAsync(TEntity t)
        {
            Context.Set<TEntity>().Add(t);
            await Context.SaveChangesAsync();
            AfterInsert();
            return t;
        }

        public virtual TEntity Update(TEntity updated)
        {
            if (updated == null)
                return null;

            if (updated.Id == Guid.Empty)
                return null;

            TEntity existing = Context.Set<TEntity>().Find(updated.Id);
            if (existing != null)
            {
                Context.Entry(existing).CurrentValues.SetValues(updated);
                Context.SaveChanges();
            }
            AfterUpdate();
            return existing;
        }

        public virtual async Task<TEntity> UpdateAsync(TEntity updated)
        {
            if (updated == null)
                return null;

            if (updated.Id != Guid.Empty)
                return null;

            TEntity existing = await Context.Set<TEntity>().FindAsync(updated.Id);
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

        public virtual void Delete(Guid id)
        {
            TEntity itemTodelete = this.Get(id);

            if (itemTodelete == null)
                return;

            Context.Set<TEntity>().Remove(itemTodelete);
            Context.SaveChanges();
            AfterDelete();
        }

        public virtual async Task<int> DeleteAsync(TEntity t)
        {
            Context.Set<TEntity>().Remove(t);
            AfterDelete();
            return await Context.SaveChangesAsync();
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