using journalBackend.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace journalBackend.Controllers{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]

    public class EntryController : ControllerBase {
        private readonly AppDbContext _context;

        public EntryController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetSpecEntryById(Guid UserId) {
            var entries = await _context.Entries
            .Where(e => e.User_Id == UserId) // Filter by UserId
            .Select(e => new EntryDto
            {
                Title = e.Title,
                Time_stamp = e.Time_stamp,
                Mood = e.Mood
            })
            .ToListAsync();

            if (entries == null)
            {
                return NotFound();
            }

            return Ok(entries);
        }

        [HttpGet("entry/{userId}")]
        public async Task<IActionResult> GetEntryById(Guid UserId)
        {
            // Retrieve specific fields only
            var entries = await _context.Entries
                .Where(e => e.User_Id == UserId) // Filter by UserId
                .Select(e => new EntryDto2
                {
                    Title = e.Title,
                    Content = e.Content,
                    Time_stamp = e.Time_stamp,
                    Mood = e.Mood
                })
                .ToListAsync();

            return Ok(entries);
        }
        public class EntryDto2
        {
            public required string Title { get; set;}
            public required string Content { get; set; }
            public required DateTime Time_stamp{ get; set; }
            public required string Mood { get; set; }
        }


        [HttpPost("entry")]
        public async Task<ActionResult<Entry>> CreateEntry([FromBody] EntryDtoFor newEntry)
        {
            var authHeader = Request.Headers["Authorization"].FirstOrDefault();
            if (authHeader == null || !authHeader.StartsWith("Bearer "))
            {
                return Unauthorized("Authorization header is missing or malformed.");
            }

            var token = authHeader.Substring("Bearer ".Length).Trim();
            var userId = User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value;
            if (userId == null) return Unauthorized("User ID not found");

            var entry = new Entry
            {
                EntryId = Guid.NewGuid(),
                Title = newEntry.Title,
                Content = newEntry.Content,
                Time_stamp = DateTime.UtcNow,
                Mood = newEntry.Mood,
                User_Id = Guid.Parse(userId)
            };

            if (newEntry == null || string.IsNullOrEmpty(newEntry.Title))
            {
                return BadRequest("Invalid entry data.");
            }
            if (string.IsNullOrEmpty(token))
            {
                return Unauthorized(new { message = "Token is missing" });
            }

            _context.Entries.Add(entry);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(CreateEntry), new { id = entry.EntryId }, entry);

        }
        public class EntryDtoFor
        {
            public required string Title { get; set; }
            public required string Content { get; set; }
            public DateTime Time_stamp { get; set; }
            public required string Mood { get; set; }
            public Guid User_Id { get; set; }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateEntry(Guid EntryId, Entry entry)
        {
            if (EntryId != entry.EntryId)
            {
                return BadRequest();
            }

            var existingEntry = await _context.Entries.FindAsync(EntryId);
            if (existingEntry == null)
            {
                return NotFound();
            }

            // Update fields
            existingEntry.Title = entry.Title;
            existingEntry.Content = entry.Content;
            existingEntry.Time_stamp = DateTime.UtcNow;
            existingEntry.Mood = entry.Mood;

            _context.Entry(existingEntry).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEntry(int id)
        {
            var entry = await _context.Entries.FindAsync(id);
            if (entry == null)
            {
                return NotFound();
            }

            _context.Entries.Remove(entry);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }

}