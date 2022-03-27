using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using flt.ado.efbuild.entities.Models;

namespace flt.ado.efbuild.entities.Data
{
    public partial class DatabaseContext : DbContext
    {
        public DatabaseContext()
        {
        }

        public DatabaseContext(DbContextOptions<DatabaseContext> options)
            : base(options)
        {
        }

        public virtual DbSet<country> countries { get; set; } = null!;
        public virtual DbSet<department> departments { get; set; } = null!;
        public virtual DbSet<dependent> dependents { get; set; } = null!;
        public virtual DbSet<employee> employees { get; set; } = null!;
        public virtual DbSet<job> jobs { get; set; } = null!;
        public virtual DbSet<location> locations { get; set; } = null!;
        public virtual DbSet<region> regions { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<country>(entity =>
            {
                entity.HasKey(e => e.country_id)
                    .HasName("PK__countrie__7E8CD055059C6B21");

                entity.Property(e => e.country_id).IsFixedLength();

                entity.HasOne(d => d.region)
                    .WithMany(p => p.countries)
                    .HasForeignKey(d => d.region_id)
                    .HasConstraintName("FK__countries__regio__60A75C0F");
            });

            modelBuilder.Entity<department>(entity =>
            {
                entity.HasKey(e => e.department_id)
                    .HasName("PK__departme__C2232422614F876C");

                entity.HasOne(d => d.location)
                    .WithMany(p => p.departments)
                    .HasForeignKey(d => d.location_id)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK__departmen__locat__6E01572D");
            });

            modelBuilder.Entity<dependent>(entity =>
            {
                entity.HasKey(e => e.dependent_id)
                    .HasName("PK__dependen__F25E28CE1F63A2F1");

                entity.HasOne(d => d.employee)
                    .WithMany(p => p.dependents)
                    .HasForeignKey(d => d.employee_id)
                    .HasConstraintName("FK__dependent__emplo__797309D9");
            });

            modelBuilder.Entity<employee>(entity =>
            {
                entity.HasKey(e => e.employee_id)
                    .HasName("PK__employee__C52E0BA8822463FE");

                entity.HasOne(d => d.department)
                    .WithMany(p => p.employees)
                    .HasForeignKey(d => d.department_id)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK__employees__depar__75A278F5");

                entity.HasOne(d => d.job)
                    .WithMany(p => p.employees)
                    .HasForeignKey(d => d.job_id)
                    .HasConstraintName("FK__employees__job_i__74AE54BC");

                entity.HasOne(d => d.manager)
                    .WithMany(p => p.Inversemanager)
                    .HasForeignKey(d => d.manager_id)
                    .HasConstraintName("FK__employees__manag__76969D2E");
            });

            modelBuilder.Entity<job>(entity =>
            {
                entity.HasKey(e => e.job_id)
                    .HasName("PK__jobs__6E32B6A5BA5327A9");
            });

            modelBuilder.Entity<location>(entity =>
            {
                entity.HasKey(e => e.location_id)
                    .HasName("PK__location__771831EA15281D4C");

                entity.Property(e => e.country_id).IsFixedLength();

                entity.HasOne(d => d.country)
                    .WithMany(p => p.locations)
                    .HasForeignKey(d => d.country_id)
                    .HasConstraintName("FK__locations__count__66603565");
            });

            modelBuilder.Entity<region>(entity =>
            {
                entity.HasKey(e => e.region_id)
                    .HasName("PK__regions__01146BAEAB6A49FE");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
