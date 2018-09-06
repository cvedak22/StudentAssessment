using System;
using System.Linq;
using System.Text;
using Dapper;
using StudentAssessment.Services.SQLServer;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;


namespace StudentAssessment.Services.Students
{
    public class StudentService : IStudentService
    {
        private readonly IRepository _repo;

        public StudentService(IRepository repo)
        {
            _repo = repo;
        }

        public async Task<IEnumerable<Student>> GetStudentsAsync()
        {
            // execute the stored procedure called GetStudents
            return await _repo.WithConnection(async c =>
            {
                // map the result from stored procedure to student data model
                var results = await c.QueryAsync<Student>("GetStudents", commandType: CommandType.StoredProcedure);
                return results;
            });
        }


    }
}
