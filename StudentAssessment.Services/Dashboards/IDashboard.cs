using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudentAssessment.Services.Charts;


namespace StudentAssessment.Services.Dashboards
{
    public interface IDashboard
    {
        int TotalUniversities { get; set; }
        int TotalCountries { get; set; }
        int TotalStudents { get; set; }
        // a set of data points on a chart that represent historical growth of students yearly
        IEnumerable<ChartData> StudentsPerYear { get; set; }
        // a set of data points on a chart that represent the number of students per university
        IEnumerable<ChartData> StudentsPerCountry { get; set; }

    }
}
