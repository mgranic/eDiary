namespace eDiary.util.PdfGenerator;

using PdfSharp.Pdf;
using PdfSharp.Fonts;
using PdfSharp.Drawing;
using System.Reflection;

// https://stackoverflow.com/questions/1244109/generating-pdf-file-in-net
// https://sourceforge.net/projects/pdfsharp/
public class PdfGenerator {

    // generate PDF consisting of all o the images of an event (stored in imageFolder) and
    // event title stored in eventData[0]
    public async void generatePdf(string imageFolder, string[] eventData) {
        // Create a new PDF document
        PdfDocument document = new PdfDocument();

        // Create an empty page
        PdfPage page = document.AddPage();
        page.Orientation = PdfSharp.PageOrientation.Landscape;

        // Get an XGraphics object for drawing
        XGraphics gfx1 = XGraphics.FromPdfPage(page);

        // Create a font
        GlobalFontSettings.FontResolver = new FileFontResolver();
        XFont font = new XFont("Verdana", 20); //, XFontStyle.BoldItalic);

        // get all images from image folder
        var files = from file in Directory.EnumerateFiles(imageFolder) select file;

        Console.WriteLine("**** Iterate images in folder");
        foreach (string file in files) {
          Console.WriteLine("****" + file);
          // draw image
          XImage image = XImage.FromFile(file);
          // https://www.pdfsharp.net/wiki/Graphics-sample.ashx
          //gfx.DrawImage(image, 50, 50, 250, 250);
          gfx1.ScaleTransform(0.2);
          gfx1.DrawImage(image, 600, 300);
        }
        gfx1.Dispose();

        // Get an XGraphics object for drawing
        XGraphics gfx2 = XGraphics.FromPdfPage(page);
        // Draw the text
        gfx2.DrawString(eventData[0], font, XBrushes.Black,
          new XRect(0, 0, page.Width, page.Height),
          XStringFormat.Center);

        // Save the document...
        string filename = imageFolder + "/" + eventData[0] + ".pdf";
        document.Save(filename);
    }

    // generate PDF consisting of all o the images stored in imageFolder
    public async void generatePdf(string imageFolder) {
        // Create a new PDF document
        PdfDocument document = new PdfDocument();

        // Create an empty page
        PdfPage page = document.AddPage();
        page.Orientation = PdfSharp.PageOrientation.Landscape;
        page.Size = PdfSharp.PageSize.A4;

        // Get an XGraphics object for drawing
        XGraphics gfx = XGraphics.FromPdfPage(page);

        // Create a font
        GlobalFontSettings.FontResolver = new FileFontResolver();
        XFont font = new XFont("Verdana", 20); //, XFontStyle.BoldItalic);

        // get all images from image folder
        var files = from file in Directory.EnumerateFiles(imageFolder) select file;

        Console.WriteLine("**** Iterate images in folder " + imageFolder);
        foreach (string file in files) {
          Console.WriteLine("****" + file);
          // draw image
          XImage image = XImage.FromFile(file);
          // https://www.pdfsharp.net/wiki/Graphics-sample.ashx
          //Console.WriteLine("Page width = " + page.Width);
          //Console.WriteLine("Page height = " + page.Height);
          gfx.DrawImage(image, 20, 20, calculateImageHeight(page, image), calculateImageWidth(page, image));
          //gfx.DrawImage(image, 20, 20, 400, 250);
          //gfx.ScaleTransform(calculateImageScale(page, image));
          //gfx.ScaleTransform(0.25);
          //gfx.DrawImage(image, 20, 20);
        }
        gfx.Dispose();

        // Save the document...
        string filename = imageFolder + "/PhotoAlbum.pdf";
        document.Save(filename);
    }

    // generate PDF consisting of all o the images stored in imageFolder
    // save generated PDF into uploads folder
    public async void generatePdf(string imageFolder, string pdfName) {
        // Create a new PDF document
        PdfDocument document = new PdfDocument();

        // Create a font
        try {
          GlobalFontSettings.FontResolver = new FileFontResolver();
        } catch {
          Console.WriteLine("*** ERROR: You must not change font resolver after is was once used. GlobalFontSettings.FontResolver is already set ***");
        }
        
        XFont font = new XFont("Verdana", 20); //, XFontStyle.BoldItalic);

        // get all images from image folder
        var files = from file in Directory.EnumerateFiles(imageFolder) select file;

        Console.WriteLine("**** Iterate images in folder " + imageFolder);
        foreach (string file in files) {
          Console.WriteLine("****" + file);
          // Create an empty page
          PdfPage page = document.AddPage();
          //page.Orientation = PdfSharp.PageOrientation.Landscape;
          page.Size = PdfSharp.PageSize.A4;

          // Get an XGraphics object for drawing
          XGraphics gfx = XGraphics.FromPdfPage(page);
          // draw image
          XImage image = XImage.FromFile(file);
          // https://www.pdfsharp.net/wiki/Graphics-sample.ashx
          //Console.WriteLine("Page width = " + page.Width);
          //Console.WriteLine("Page height = " + page.Height);
          gfx.DrawImage(image, 20, 20, calculateImageHeight(page, image), calculateImageWidth(page, image));
          
          //gfx.DrawImage(image, 20, 20, 400, 250);
          //gfx.ScaleTransform(calculateImageScale(page, image));
          //gfx.ScaleTransform(0.25);
          //gfx.DrawImage(image, 20, 20);
         // break;
          gfx.Dispose();
        }
        

        // Save the document...
        string filename = "uploads/" + pdfName + ".pdf";
        document.Save(filename);
    }

    public async void generateDummyPdf() {
        // Create a new PDF document
        PdfDocument document = new PdfDocument();

        // Create an empty page
        PdfPage page = document.AddPage();

        // Get an XGraphics object for drawing
        XGraphics gfx = XGraphics.FromPdfPage(page);

        // Create a font
        GlobalFontSettings.FontResolver = new FileFontResolver();
        XFont font = new XFont("Verdana", 20); //, XFontStyle.BoldItalic);

        // draw image
        XImage image = XImage.FromFile("resources/images/market_predictions.jpg");
        gfx.DrawImage(image, 50, 50, 250, 250);

        // Draw the text
        gfx.DrawString("Hello, World!", font, XBrushes.Black,
          new XRect(0, 0, page.Width, page.Height),
          XStringFormat.Center);

        // Save the document...
        string filename = "xxxHelloWorldxxx.pdf";
        document.Save(filename);
    }

    /******************************************************************************/
    //                    PRIVATE METHODS
    /******************************************************************************/
    private double calculateImageScale(PdfPage page, XImage image) {
      double scale = 1;

      // check image to page size ratio
      double widthScale = image.PointWidth / page.Width;
      double heightScale = image.PointHeight / page.Height;
      

      // if image is landscape oriented
      if (image.PixelWidth > image.PixelHeight) {
        // check width and height ratio and make sure the photo takes 1/4 of the page
        if (widthScale > 0.25) {
          scale = 0.25  / widthScale;
          Console.WriteLine("**** calculateImageScale LANDSCAPE =  " + widthScale);
        }
      } else { // if image is portrait oriented
        // check width and height ratio and make sure the photo takes 1/4 of the page
        if (heightScale > 0.25) {
          scale = 0.25  / heightScale;
          Console.WriteLine("**** calculateImageScale PORTRAIT=  " + heightScale);
        }
      }

      Console.WriteLine("**** calculateImageScale = " + scale);

      return scale;
    }

    private int calculateImageHeight(PdfPage page, XImage image) {
      double scale = 1;

      // check image to page height size ratio
      double heightScale = image.PointHeight / page.Height;

      // if image is landscape oriented
      if (image.PointWidth > image.PointHeight) {
        // check width and height ratio and make sure the photo takes 1/4 of the page
        if (heightScale > 0.25) {
          scale = 0.25  / heightScale;
          Console.WriteLine("**** calculateImageScale LANDSCAPE =  " + heightScale);
        }
      } else { // if image is portrait oriented
        // check width and height ratio and make sure the photo takes 1/4 of the page
        if (heightScale > 0.25) {
          scale = 0.25  / heightScale;
          Console.WriteLine("**** calculateImageScale PORTRAIT=  " + heightScale);
        }
      }

      Console.WriteLine("**** calculateImageScale = " + scale);

      return (int)(scale * image.PointHeight);
    }

    private int calculateImageWidth(PdfPage page, XImage image) {
      double scale = 1;

      // check image to page size ratio
      double widthScale = image.PointWidth / page.Width;

      // if image is landscape oriented
      if (image.PointWidth > image.PointHeight) {
        // check width and height ratio and make sure the photo takes 1/4 of the page
        if (widthScale > 0.25) {
          scale = 0.25  / widthScale;
          Console.WriteLine("**** calculateImageScale LANDSCAPE =  " + widthScale);
        }
      } else { // if image is portrait oriented
        // check width and height ratio and make sure the photo takes 1/4 of the page
        if (widthScale > 0.25) {
          scale = 0.25  / widthScale;
          Console.WriteLine("**** calculateImageScale PORTRAIT=  " + widthScale);
        }
      }

      Console.WriteLine("**** calculateImageScale = " + scale);

      return (int)(scale * image.PointWidth);
    }

}