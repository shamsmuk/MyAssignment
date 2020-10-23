using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyAssignment.Model
{
    [Table("person")]
    public partial class Person
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("first_name")]
        [StringLength(50)]
        public string FirstName { get; set; }
        [Column("last_name")]
        [StringLength(50)]
        public string LastName { get; set; }
        [Column("date_created", TypeName = "date")]
        public DateTime? DateCreated { get; set; }
    }
}
