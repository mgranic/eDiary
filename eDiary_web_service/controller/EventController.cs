

using Microsoft.AspNetCore.Mvc;
using eDiary.Model;
using eDiary.util.PdfGenerator;

namespace eDiary.Controllers;

[ApiController]
[Route("[controller]")]
public class EventController : ControllerBase {

    DiaryDatabase db = new DiaryDatabase();

    [HttpPost("createEvent")]
    [Produces("application/json")]
    public IActionResult createEvent([FromForm(Name = "files")] List<IFormFile> files,
                                     [FromForm(Name = "title")] string title,
                                     [FromForm(Name = "description")] string description,
                                     [FromForm(Name = "dateStr")] string dateStr) {
        Console.WriteLine(title);
        Console.WriteLine(description);
        Console.WriteLine(dateStr);
        Console.WriteLine(files.Count);
        //Console.WriteLine(imgs.First().Name);

        // create uploads directory which will contain all uploaded albums
        string uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadsDir);
        Console.WriteLine("********6**************");

        // create folder for each album that is being uploaded within uploads folder
        string uploadedAlbum = Path.Combine(uploadsDir, title);
        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadedAlbum);
        Console.WriteLine("********5**************");

        if(files.Count == 0) return BadRequest();
        Console.WriteLine("********1**************");
        List<string> data = new List<string>();
        foreach(var file in files) {
            Console.WriteLine("********2**************");
            data.Add($"Filename: {file.FileName} || Type: {file.ContentType}");
            if (file.Length > 0)
            {
                Console.WriteLine("********3**************");
                string filePath = Path.Combine(uploadedAlbum, file.FileName);
                Console.WriteLine(file.FileName);
                using (Stream fileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                {
                    Console.WriteLine("********4**************");
                    file.CopyTo(fileStream);
                }
            }
        }

        PdfGenerator pdfGenerator = new PdfGenerator();
        //pdfGenerator.generatePdf(uploadedAlbum, [title, description]);
        pdfGenerator.generatePdf(uploadedAlbum);

        return Ok("createEvent " + title + " is working");
    }
}