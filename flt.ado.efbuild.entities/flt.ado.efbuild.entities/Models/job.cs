using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace flt.ado.efbuild.entities.Models
{
    public partial class job
    {
        public job()
        {
            employees = new HashSet<employee>();
        }

        [Key]
        public int job_id { get; set; }
        [StringLength(35)]
        [Unicode(false)]
        public string job_title { get; set; } = null!;
        [Column(TypeName = "decimal(8, 2)")]
        public decimal? min_salary { get; set; }
        [Column(TypeName = "decimal(8, 2)")]
        public decimal? max_salary { get; set; }

        [InverseProperty("job")]
        public virtual ICollection<employee> employees { get; set; }
    }
}
