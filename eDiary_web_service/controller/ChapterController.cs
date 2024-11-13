

using Microsoft.AspNetCore.Mvc;
using eDiary.Model;
using eDiary.Model.HttpRequest;

namespace eDiary.Controllers;

[ApiController]
[Route("[controller]")]
public class ChapterController : ControllerBase {

    DiaryDatabase db = new DiaryDatabase();

    [HttpPost("postChapterBasicPing")]
    //[Produces("application/json")]
    public IActionResult postChapterBasicPing([FromForm(Name = "param")] string param)
    {
        Console.WriteLine("!!!!!!!!!!!!!! postChapterPing is working " + param + " !!!!!!!!!!!!!!!!!!!!!!");

       // var temp = getAllChapters();
       // Console.WriteLine(temp);

        //deleteAllChapters();
        
        return Ok("postChapterPing " + param + " is working");
    }

    [HttpGet("getChapterPing")]
    [Produces("application/json")]
    public IActionResult getChapterPing()
    {
        Console.WriteLine("!!!!!!!!!!!!!! getChapterPing is working !!!!!!!!!!!!!!!!!!!");
        Console.WriteLine("!!!!!!!!!!!!!! " + db.DbPath + " !!!!!!!!!!!!!!!!!!!");
        
        return Ok("getChapterPing is working");
    }

    [HttpPost("postChapterPing")]
    [Produces("application/json")]
    public IActionResult postChapterPing([FromBody] Chapter chapter)
    {
        Console.WriteLine("!!!!!!!!!!!!!! postChapterPing is working " + chapter.name + " !!!!!!!!!!!!!!!!!!!!!!");

       // var temp = getAllChapters();
       // Console.WriteLine(temp);

        //deleteAllChapters();
        
        return Ok("postChapterPing " + chapter.name + " is working");
    }

    [HttpPost("createChapter")]
    [Produces("application/json")]
    public IActionResult createChapter([FromBody] Chapter chapter)
    {
        Console.WriteLine("!!!!!!!!!!!!!! createChapter " + chapter.name + " !!!!!!!!!!!!!!!!!!!!!!");

        

        // Note: This sample requires the database to be created before running.
        Console.WriteLine($"Database path: {db.DbPath}.");

        // Create
        db.Add(new Chapter(chapter.userId, chapter.name, chapter.desc, chapter.date));
        db.SaveChanges();
        
        return Ok("createChapter " + chapter.name + " is working");
    }

    [HttpPost("getAllChapters")]
    [Produces("application/json")]
    public async Task<IActionResult> getAllChapters([FromBody] ChapterFilter filterParams)
    {
        //Console.WriteLine("filterParams[0] = " + filterParams[0]);
        //Console.WriteLine("filterParams[1] = " + filterParams[1]);
        Console.WriteLine(filterParams.pageNum);
        //foreach(var kvPair in filterParams) {
        //    Console.WriteLine("key = " + kvPair.Item1);
        //    Console.WriteLine("value = " + kvPair.Item2);
        //    Console.WriteLine(kvPair);
        //}
        // Read
        Console.WriteLine("+++++++++++++++ getAllChapters ++++++++++++++++++");
        var chaptersFromDB = db.chapters
            .OrderBy(ch => ch.date)
            .Skip(filterParams.pageNum * 15)
            .Take(15);

        
        //foreach(var chap in chaptersFromDB) {
        //    Console.WriteLine(chap.name);
        //}

        return Ok(chaptersFromDB);
    }

    [HttpPost("deleteAllChapters")]
    [Produces("application/json")]
    public IActionResult deleteAllChapters()
    {
        foreach (var item in db.chapters) {
            // TODO: for each chapter, delete all events
            db.chapters.Remove(item);
        }
        db.SaveChanges();

        return Ok();
    }

    [HttpPost("createBulkChapter")]
    [Produces("application/json")]
    public IActionResult createBulkChapter([FromForm(Name = "files")] List<IFormFile> files,
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

        return Ok("createBulkChapter " + title + " is working");
    }



    //[HttpPost("createExpense")]
    //[Produces("application/json")]
    //public async Task<IActionResult> createExpense([FromBody] ExpenseModel expense)
    //{
    //    Console.WriteLine("!!!!!!!!!!!!!! createExpense " + expense.name + " - " + expense.price + " " + expense.timestamp + " !!!!!!!!!!!!!!!!!!!");
    //    
    //    return Ok(expense.name + " - " + expense.price);
    //}
//
    //[HttpPost("getTotalMoneySpentThisMonth")]
    //[Produces("application/json")]
    //public async Task<IActionResult> getTotalMoneySpentThisMonth([FromBody] UserModel user)
    //{
    //    Console.WriteLine("!!!!!!!!!!!!!! getTotalMoneySpentThisMonth " + user.id + " !!!!!!!!!!!!!!!!!!!");
    //    
    //    Random random = new Random();
    //    double randomPrice = random.NextDouble() * 1000;
//
    //    Console.WriteLine("!!!!!!!!!!!!!! getTotalMoneySpentThisMonth randomPrice = " + randomPrice + " !!!!!!!!!!!!!!!!!!!");
//
    //    return Ok(randomPrice);
    //}
//
    //[HttpPost("getAllExpenses")]
    //[Produces("application/json")]
    //public async Task<IActionResult> getAllExpenses([FromBody] UserModel user)
    //{
    //     Console.WriteLine("************************** getAllExpenses userId = " + user.id + " **************************");
//
    //    var expenseList = new List<ExpenseModel>{
    //        new ExpenseModel(1, "kava", 2.5, "caffe", DateTime.Now, 3),
    //        new ExpenseModel(2, "kruh", 3.5, "food", DateTime.Now, 4),
    //        new ExpenseModel(3, "gorivo", 30.7, "transportation", DateTime.Now, 5),
    //    };
    //    
    //    return Ok(expenseList);
    //}
//
    //[HttpPost("filterExpenses")]
    //[Produces("application/json")]
    //public async Task<IActionResult> filterExpenses([FromBody] FilterModel filter)
    //{
    //     Console.WriteLine("************************** filterExpenses dateFrom = " + filter.dateFrom + " **************************");
//
    //    var expenseList = new List<ExpenseModel>{
    //        new ExpenseModel(1, "sok", 2.5, "caffe", DateTime.Now, 3),
    //        new ExpenseModel(2, "mliko", 3.5, "food", DateTime.Now, 4),
    //        new ExpenseModel(3, "gume", 30.7, "transportation", DateTime.Now, 5),
    //    };
    //    
    //    return Ok(expenseList);
    //}
//
    //[HttpPost("getTotalPricePerCategory")]
    //[Produces("application/json")]
    //public async Task<IActionResult> getTotalPricePerCategory([FromBody] UserModel user)
    //{
    //     Console.WriteLine("************************** getAllExpenses userId = " + user.id + " **************************");
//
    //    var totalPriceList = new List<TotalPriceModel>{
    //        new TotalPriceModel(58, "caffe"),
    //        new TotalPriceModel(479, "food"),
    //        new TotalPriceModel(437, "transportation"),
    //    };
    //    
    //    return Ok(totalPriceList);
    //}

}