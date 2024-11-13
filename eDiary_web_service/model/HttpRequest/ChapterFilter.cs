namespace eDiary.Model.HttpRequest;
public class ChapterFilter {
    public int userId {set; get;}
    public int pageNum {set; get;}

    public ChapterFilter(int userId, int pageNum) {
        this.userId = userId;
        this.pageNum = pageNum;
    }
}