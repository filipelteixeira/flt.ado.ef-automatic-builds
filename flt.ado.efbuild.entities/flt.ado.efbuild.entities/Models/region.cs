using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace flt.ado.efbuild.entities.Models
{
    public partial class region
    {
        public region()
        {
            countries = new HashSet<country>();
        }

        [Key]
        public int region_id { get; set; }
        [StringLength(25)]
        [Unicode(false)]
        public string? region_name { get; set; }

        [InverseProperty("region")]
        public virtual ICollection<country> countries { get; set; }
    }
}
