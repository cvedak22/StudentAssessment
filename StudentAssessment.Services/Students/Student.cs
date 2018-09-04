using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudentAssessment.Services.Students
{
    public class Student : IStudent
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string University { get; set; }
        public string Country { get; set; }
        public char Sex { get; set; }
        public int Age { get; set; }
        public DateTime StartDate { get; set; }
        public string Degree { get; set; }
    }
}


