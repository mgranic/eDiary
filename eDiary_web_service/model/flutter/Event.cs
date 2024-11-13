namespace eDiary.Model;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
public class Event {

    //[Key]
    //[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int id { get; set; }
    public string name { get; set; }
    public string desc { get; set; }
    public DateTime date { get; set; }

    public Event(int userId, string name, string desc, DateTime date) {
        this.name = name;
        this.desc = desc;
        this.date = date;
    }
}