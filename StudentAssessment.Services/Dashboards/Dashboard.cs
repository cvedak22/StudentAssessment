using System.Collections;
using System.Collections.Generic;
using StudentAssessment.Services.Charts;

namespace StudentAssessment.Services.Dashboards

{
    public class Dashboard : IDashboard
    {
        public int TotalUniversities { get; set; }
        public int TotalCountries { get; set; }
        public int TotalStudents { get; set; }
        public IEnumerable<ChartData> StudentsPerYear { get; set; }
        public IEnumerable<ChartData> StudentsPerCountry { get; set; }
    }
}