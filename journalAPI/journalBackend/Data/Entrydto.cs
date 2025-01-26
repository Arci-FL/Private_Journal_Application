using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace journalBackend.Data
{
    public class EntryDto
    {
        public required string Title { get; set;}
        public required DateTime Time_stamp{ get; set; }
        public required string Mood { get; set; }
    }
}