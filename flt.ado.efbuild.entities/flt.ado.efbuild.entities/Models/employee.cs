using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace flt.ado.efbuild.entities.Models
{
    public partial class employee
    {
        public employee()
        {
            Inversemanager = new HashSet<employee>();
            dependents = new HashSet<dependent>();
        }

        [Key]
        public int employee_id { get; set; }
        [StringLength(20)]
        [Unicode(false)]
        public string? first_name { get; set; }
        [StringLength(25)]
        [Unicode(false)]
        public string last_name { get; set; } = null!;
        [StringLength(100)]
        [Unicode(false)]
        public string email { get; set; } = null!;
        [StringLength(20)]
        [Unicode(false)]
        public string? phone_number { get; set; }
        [Column(TypeName = "date")]
        public DateTime hire_date { get; set; }
        public int job_id { get; set; }
        [Column(TypeName = "decimal(8, 2)")]
        public decimal salary { get; set; }
        public int? manager_id { get; set; }
        public int? department_id { get; set; }

        [ForeignKey("department_id")]
        [InverseProperty("employees")]
        public virtual department? department { get; set; }
        [ForeignKey("job_id")]
        [InverseProperty("employees")]
        public virtual job job { get; set; } = null!;
        [ForeignKey("manager_id")]
        [InverseProperty("Inversemanager")]
        public virtual employee? manager { get; set; }
        [InverseProperty("manager")]
        public virtual ICollection<employee> Inversemanager { get; set; }
        [InverseProperty("employee")]
        public virtual ICollection<dependent> dependents { get; set; }
    }
}
