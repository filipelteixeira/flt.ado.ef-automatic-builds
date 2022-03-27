using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace flt.ado.efbuild.entities.Models
{
    public partial class dependent
    {
        [Key]
        public int dependent_id { get; set; }
        [StringLength(50)]
        [Unicode(false)]
        public string first_name { get; set; } = null!;
        [StringLength(50)]
        [Unicode(false)]
        public string last_name { get; set; } = null!;
        [StringLength(25)]
        [Unicode(false)]
        public string relationship { get; set; } = null!;
        public int employee_id { get; set; }

        [ForeignKey("employee_id")]
        [InverseProperty("dependents")]
        public virtual employee employee { get; set; } = null!;
    }
}
