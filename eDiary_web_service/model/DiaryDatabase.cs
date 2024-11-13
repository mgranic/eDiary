namespace eDiary.Model;

using Microsoft.EntityFrameworkCore;
using System;

public class DiaryDatabase : DbContext {
    public DbSet<Chapter> chapters { get; set; }
    public string DbPath { get; }

    public DiaryDatabase() {
        var folder = Environment.SpecialFolder.LocalApplicationData;
        var path = Environment.GetFolderPath(folder);
        DbPath = System.IO.Path.Join(path, "diary_database.db"); // C:\Users\mate.granic\AppData\Local
    }

     // The following configures EF to create a Sqlite database file in the
    // special "local" folder for your platform.
    protected override void OnConfiguring(DbContextOptionsBuilder options) 
        => options.UseSqlite($"Data Source={DbPath}");
}