using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudentAssessment.Services.Students
{
    public interface IStudent
    {
        int Id { get; set; }
        string FirstName { get; set; }
        string LastName { get; set; }
        string University { get; set; }
        string Country { get; set; }
        char Sex { get; set; }
        int Age { get; set; }
        DateTime StartDate { get; set; }
        string Degree { get; set; }
    }
}