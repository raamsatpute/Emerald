using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EmeraldFL.DataAccess.Framework
{
 
    public interface IEntity
    {
        int Id { get; set; }
    }

    public interface IEntityGuid
    {
        Guid Id { get; set; }
    }

    public interface IAuditable
    {
        DateTime? LastUpdatedOn { get; set; }
        string LastUpdatedBy { get; set; }
    }

    public abstract class Entity : IEntity, IAuditable
    {
        public int Id { get; set; }
        public DateTime? LastUpdatedOn { get; set; }
        public string LastUpdatedBy { get; set; }
    }

    public abstract class LegacyEntity : IEntity
    {
        public int Id { get; set; }
    }


    public abstract class EntityGuid : IEntityGuid, IAuditable
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid Id { get; set; }
        public DateTime? LastUpdatedOn { get; set; }
        public string LastUpdatedBy { get; set; }

        public int Location { get; set; }
    }
}

