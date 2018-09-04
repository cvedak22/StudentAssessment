using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using StudentAssessment.Services.Charts;
using StudentAssessment.Services.SQLServer;

namespace StudentAssessment.Services.Dashboards
{
    public class DashboardService : IDashboardService
    {
        private readonly IRepository _repo;

        public DashboardService(IRepository repo)
        {
            _repo = repo;
        }

        public async Task<Dashboard> GetDashboardSettingAsync()
        {
            return await _repo.WithConnection(async c =>
            {
                // execute the stored procedure called GetDashboardSetting
                var reader = await c.QueryMultipleAsync("GetDashboardSetting", commandType: CommandType.StoredProcedure);
                // map the result from stored procedure to Dashboard data model
                var results = new Dashboard
                {
                    TotalUniversities = reader.ReadAsync<int>().Result.SingleOrDefault(),
                    TotalCountries = reader.ReadAsync<int>().Result.SingleOrDefault(),
                    TotalStudents = reader.ReadAsync<int>().Result.SingleOrDefault(),
                    StudentsPerYear = reader.ReadAsync<ChartData>().Result.AsEnumerable(),
                    StudentsPerCountry = reader.ReadAsync<ChartData>().Result.AsEnumerable()
                };
                return results;
            });
        }
    }
}