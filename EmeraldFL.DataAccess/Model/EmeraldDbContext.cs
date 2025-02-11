using EmeraldFL.DataAccess.Framework;
using System;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Z.EntityFramework.Plus;

namespace EmeraldFL.DataAccess.Model
{

    public partial class EmeraldDataContext : DbContext
    {
        public EmeraldDataContext()
            : base("name=FInventoryConn")
        {
            Database.SetInitializer<EmeraldDataContext>(null);
        }

        static EmeraldDataContext()
        {
            AuditManager.DefaultConfiguration.Exclude<Event>();
            AuditManager.DefaultConfiguration.ExcludeProperty<User>(u => u.Lastlogin);
            AuditManager.DefaultConfiguration.IgnorePropertyUnchanged = true;
            AuditManager.DefaultConfiguration.AutoSavePreAction = (context, audit) => (context as EmeraldDataContext)
                    .AuditEntries
                    .AddRange(audit.Entries.Where(e => !e.Properties.All(p => p.NewValue == p.OldValue)));
        }


        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
#if DEBUG
            if (this.Database.Log == null)
            {
                this.Database.Log = s => Debug.Write(s);
            }
            else
            {
                var currentLogger = this.Database.Log;
                this.Database.Log = s =>
                {
                    currentLogger(s);
                    Debug.Write(s);
                };
            }
#endif
            modelBuilder.Configurations.AddFromAssembly(typeof(EmeraldDataContext).Assembly);
        }

        public override int SaveChanges()
        {

            var audit = new Audit();
            audit.PreSaveChanges(this);
            SetAuditData(audit.CreatedBy);
            var rowAffecteds = base.SaveChanges();
            audit.PostSaveChanges();

            if (audit.Configuration.AutoSavePreAction != null)
            {
                audit.Configuration.AutoSavePreAction(this, audit);
                try
                {
                    base.SaveChanges();
                }
                catch (System.Data.Entity.Validation.DbEntityValidationException ex)
                {
                    Console.Write("{0}{1}Validation errors:{1}{2}", ex, Environment.NewLine, ex.EntityValidationErrors.Select(e => string.Join(Environment.NewLine, e.ValidationErrors.Select(v => string.Format("{0} - {1}", v.PropertyName, v.ErrorMessage)))));
                    throw;
                }

            }

            return rowAffecteds;
        }

        public override Task<int> SaveChangesAsync()
        {
            return SaveChangesAsync(CancellationToken.None);
        }

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken)
        {
            try
            {
                var audit = new Audit();
                audit.PreSaveChanges(this);
                SetAuditData(audit.CreatedBy);
                var rowAffecteds = await base.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
                audit.PostSaveChanges();

                if (audit.Configuration.AutoSavePreAction != null)
                {
                    audit.Configuration.AutoSavePreAction(this, audit);
                    if (audit != null && audit.Entries != null && audit.Entries.Any(e => e.Properties.All(p => p.OldValueFormatted != p.NewValueFormatted)))
                        await base.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
                }
                return rowAffecteds;
            }
            catch(Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
            }
            return 0;
        }

        public static EmeraldDataContext GetContext()
        {
            return new EmeraldDataContext();
        }

        private void SetAuditData(string user)
        {
            var entities = ChangeTracker.Entries().Where(x => x.Entity is IAuditable && (x.State == EntityState.Added || x.State == EntityState.Modified));

            foreach (var entity in entities)
            {
                ((IAuditable)entity.Entity).LastUpdatedOn = DateTime.UtcNow;
                ((IAuditable)entity.Entity).LastUpdatedBy = user;
            }
        }
    }
}
