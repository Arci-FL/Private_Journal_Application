using journalBackend.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace journalBackend.Controllers{
    [ApiController]
    [Route("api/[controller]")]

    public class LoginController : Controller {
        private readonly TokenService _tokenService;
        private readonly AppDbContext _context;

        public LoginController(TokenService tokenService, AppDbContext context)
        {
            _context = context;
            _tokenService = tokenService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest(new { message = "Email and password are required." });
            }

            // Find the user by email
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
            if (user == null)
            {
                return Unauthorized(new { message = "Invalid email." });
            }

            // Verify the password
            bool isPasswordValid = BCrypt.Net.BCrypt.Verify(request.Password, user.Password);
            if (!isPasswordValid)
            {
                return Unauthorized(new { message = "Invalid password." });
            }

            var token = _tokenService.GenerateToken(user.UserId.ToString(), user.User_Name);

            // Return success
            return Ok(new { Token = token });
        }
    }

    public class LoginRequest
    {
        public required string Email { get; set; }
        public required string Password { get; set; }
    }
}