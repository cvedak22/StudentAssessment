using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace StudentAssessment.Services.SQLServer
{
    public interface IRepository
    {
        Task<T> WithConnection<T>(Func<IDbConnection, Task<T>> getData);
        SqlConnection GetConnection(bool multipleActiveResultSets = false);
    }
}
