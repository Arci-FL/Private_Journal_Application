using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace journalBackend.Data
{
    public class Entry
    {
        [Key]
        public required Guid EntryId { get; set; } // Primary key

        [Required]
        public required string Title { get; set; }

        [Required]
        public required string Content { get; set; }

        [Required]
        public required DateTime Time_stamp { get; set; }

        [Required]
        public required string Mood { get; set; }

        // Foreign key
        [ForeignKey(nameof(User))]
        public required Guid User_Id { get; set; } // Explicit foreign key
        
        public User User { get; set; }
    }
}