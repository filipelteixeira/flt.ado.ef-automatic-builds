using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace flt.ado.efbuild.entities.Models
{
    public partial class location
    {
        public location()
        {
            departments = new HashSet<department>();
        }

        [Key]
        public int location_id { get; set; }
        [StringLength(40)]
        [Unicode(false)]
        public string? street_address { get; set; }
        [StringLength(12)]
        [Unicode(false)]
        public string? postal_code { get; set; }
        [StringLength(30)]
        [Unicode(false)]
        public string city { get; set; } = null!;
        [StringLength(25)]
        [Unicode(false)]
        public string? state_province { get; set; }
        [StringLength(2)]
        [Unicode(false)]
        public string country_id { get; set; } = null!;

        [ForeignKey("country_id")]
        [InverseProperty("locations")]
        public virtual country country { get; set; } = null!;
        [InverseProperty("location")]
        public virtual ICollection<department> departments { get; set; }
    }
}
