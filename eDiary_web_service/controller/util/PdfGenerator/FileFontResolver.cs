namespace eDiary.util.PdfGenerator;

using PdfSharp.Fonts;


public class FileFontResolver : IFontResolver // FontResolverBase
{
    public string DefaultFontName => throw new NotImplementedException();

    public byte[] GetFont(string faceName)
    {
        using (var ms = new MemoryStream())
        {
            using (var fs = File.Open(faceName, FileMode.Open))
            {
                fs.CopyTo(ms);
                ms.Position = 0;
                return ms.ToArray();
            }
        }
    }

    public FontResolverInfo ResolveTypeface(string familyName, bool isBold, bool isItalic)
    {
        if (familyName.Equals("Verdana", StringComparison.CurrentCultureIgnoreCase))
        {
            if (isBold && isItalic)
            {
                return new FontResolverInfo("resources/Fonts/Verdana-BoldItalic.ttf");
            }
            else if (isBold)
            {
                return new FontResolverInfo("resources/Fonts/Verdana-Bold.ttf");
            }
            else if (isItalic)
            {
                return new FontResolverInfo("resources/Fonts/Verdana-Italic.ttf");
            }
            else
            {
                return new FontResolverInfo("resources/Fonts/Verdana-Regular.ttf");
            }
        }
        return null;
    }
}