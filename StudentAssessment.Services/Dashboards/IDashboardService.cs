using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudentAssessment.Services.Dashboards
{
    public interface IDashboardService
    {

        Task<Dashboard> GetDashboardSettingAsync();
    }

}
