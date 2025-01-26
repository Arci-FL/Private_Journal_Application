using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace journalBackend.Data
{
    public class User
    {
        public required Guid UserId { get; set; } // Primary key
        public required string User_Name { get; set;}
        public required string Email { get; set; }
        public required string Password { get; set; }
    }
}