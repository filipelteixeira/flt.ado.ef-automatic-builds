using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace flt.ado.efbuild.entities.Models
{
    public partial class department
    {
        public department()
        {
            employees = new HashSet<employee>();
        }

        [Key]
        public int department_id { get; set; }
        [StringLength(30)]
        [Unicode(false)]
        public string department_name { get; set; } = null!;
        public int? location_id { get; set; }

        [ForeignKey("location_id")]
        [InverseProperty("departments")]
        public virtual location? location { get; set; }
        [InverseProperty("department")]
        public virtual ICollection<employee> employees { get; set; }
    }
}
