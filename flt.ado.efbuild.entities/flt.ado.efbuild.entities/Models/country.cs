using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace flt.ado.efbuild.entities.Models
{
    public partial class country
    {
        public country()
        {
            locations = new HashSet<location>();
        }

        [Key]
        [StringLength(2)]
        [Unicode(false)]
        public string country_id { get; set; } = null!;
        [StringLength(40)]
        [Unicode(false)]
        public string? country_name { get; set; }
        public int region_id { get; set; }

        [ForeignKey("region_id")]
        [InverseProperty("countries")]
        public virtual region region { get; set; } = null!;
        [InverseProperty("country")]
        public virtual ICollection<location> locations { get; set; }
    }
}
