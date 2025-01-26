using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace journalBackend.Migrations
{
    /// <inheritdoc />
    public partial class UpdateEntryModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Entries_Users_UserId",
                table: "Entries");

            migrationBuilder.DropIndex(
                name: "IX_Entries_UserId",
                table: "Entries");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Entries");

            migrationBuilder.CreateIndex(
                name: "IX_Entries_User_Id",
                table: "Entries",
                column: "User_Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Entries_Users_User_Id",
                table: "Entries",
                column: "User_Id",
                principalTable: "Users",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Entries_Users_User_Id",
                table: "Entries");

            migrationBuilder.DropIndex(
                name: "IX_Entries_User_Id",
                table: "Entries");

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "Entries",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.CreateIndex(
                name: "IX_Entries_UserId",
                table: "Entries",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Entries_Users_UserId",
                table: "Entries",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
