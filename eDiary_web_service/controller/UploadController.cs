using Microsoft.AspNetCore.Mvc;
using eDiary.Model.iOS;
using eDiary.Model.HttpRequest;
using eDiary.util.PdfGenerator;

namespace eDiary.Controllers;

[ApiController]
[Route("[controller]")]
public class UploadController : ControllerBase {

    [HttpPost("UploadImage2")]
    [Produces("application/json")]
    [DisableRequestSizeLimit]
    public ActionResult<string>  UploadImage2([FromForm(Name = "files")] List<IFormFile> files,
                                              [FromForm] String folderName) 
    {
        // TODO: folderName -> eventName, add eventDescription, image does not have to be list
        // TODO: or you can add lis
        // create uploads directory which will contain all uploaded albums
        string uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadsDir);

        // create folder for each album that is being uploaded within uploads folder
        string uploadedAlbum = Path.Combine(uploadsDir, folderName);
        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadedAlbum);

        if(files.Count == 0) return BadRequest();
            List<string> data = new List<string>();
            foreach(var file in files) {
                data.Add($"Filename: {file.FileName} || Type: {file.ContentType}");
                if (file.Length > 0)
                {
                    string filePath = Path.Combine(uploadedAlbum, file.FileName);
                    using (Stream fileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                    {
                        file.CopyTo(fileStream);
                    }
                }
            }

            return Ok(new {
                message =  $"Uploaded {files.Count} files",
                files = data
            });
    }

    [HttpPost("UploadImages")]
    [Produces("application/json")]
    [DisableRequestSizeLimit]
    public ActionResult<string>  UploadImages([FromForm(Name = "files")] List<IFormFile> files) 
    {
        // TODO: folderName -> eventName, add eventDescription, image does not have to be list
        // TODO: or you can add lis
        // create uploads directory which will contain all uploaded albums
        string uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadsDir);

        // create folder for each album that is being uploaded within uploads folder
        string uploadedAlbum = Path.Combine(uploadsDir, "novi_album");
        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadedAlbum);

        if(files.Count == 0) return BadRequest();
            List<string> data = new List<string>();
            foreach(var file in files) {
                data.Add($"Filename: {file.FileName} || Type: {file.ContentType}");
                if (file.Length > 0)
                {
                    string filePath = Path.Combine(uploadedAlbum, file.FileName);
                    using (Stream fileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                    {
                        file.CopyTo(fileStream);
                    }
                }
            }

            return Ok(new {
                message =  $"Uploaded {files.Count} files",
                files = data
            });
    }

    [HttpPost("uploadEvent")]
    [Produces("application/json")]
    [DisableRequestSizeLimit]
    public IActionResult  uploadEvent([FromForm(Name = "file")] IFormFile file,
                                      [FromForm] string name,
                                      [FromForm] string description,
                                      [FromForm] string date) 
    {
        Console.WriteLine("description = " + description);
        Console.WriteLine("name = " + name);
        Console.WriteLine("date = " + date);
        Console.WriteLine("filename = " + file.FileName);

        string uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
        //PdfGenerator pdfGenerator = new PdfGenerator();
        //pdfGenerator.generatePdf("folderpath", ["data1", "data2"]);

        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadsDir);
        if (file.Length > 0)
        {
            string filePath = Path.Combine(uploadsDir, file.FileName);
            using (Stream fileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
            {
                file.CopyTo(fileStream);
            }
        }

        return Ok("file uploaded");
    }

    [HttpPost("uploadImage")]
    [Produces("application/json")]
    [DisableRequestSizeLimit]
    public IActionResult  uploadImage([FromForm] IFormFile file) 
    {
        Console.WriteLine("filename = " + file.FileName);

        string uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
        PdfGenerator pdfGenerator = new PdfGenerator();
        pdfGenerator.generatePdf("folderpath", ["data1", "data2"]);

        ////Create directory if it doesn't exist 
        //Directory.CreateDirectory(uploadsDir);

        //if (file.Length > 0)
        //{
        //    string filePath = Path.Combine(uploadsDir, file.FileName);
        //    using (Stream fileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
        //    {
        //        file.CopyTo(fileStream);
        //    }
        //}

        return Ok("file uploaded");
    }

    // http://localhost:5015/upload/createPhotoAlbumTest
    [HttpGet("createPhotoAlbumTest")]
    [Produces("application/json")]
    public IActionResult createPhotoAlbumTest()
    {
        
        // create uploads directory which will contain all uploaded albums
        string uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
        //Create directory if it doesn't exist 
        Directory.CreateDirectory(uploadsDir);

        //// create folder for each album that is being uploaded within uploads folder
        //string uploadedAlbum = Path.Combine(uploadsDir, "aaa");
        ////Create directory if it doesn't exist 
        //Directory.CreateDirectory(uploadedAlbum);

        PdfGenerator pdfGenerator = new PdfGenerator();
        ////pdfGenerator.generatePdf(uploadedAlbum, [title, description]);
        pdfGenerator.generatePdf("resources/images/rome", "rome");

        return Ok("createPhotoAlbumTest is working");
    }
}