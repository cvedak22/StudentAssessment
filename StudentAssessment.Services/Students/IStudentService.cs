using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudentAssessment.Services.Students
{
    public interface IStudentService
    {
        Task<IEnumerable<Student>> GetStudentsAsync();
    }
}