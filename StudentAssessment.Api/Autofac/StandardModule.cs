using System.Configuration;
using Autofac;
using StudentAssessment.Services.Common;
using StudentAssessment.Services.Dashboards;
using StudentAssessment.Services.Students;
using StudentAssessment.Services.SQLServer;

namespace StudentAssessment.Api.Autofac
{
    public class StandardModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            base.Load(builder);

            // obtain database connection string once and reuse by Connection class
            var conn = ConfigurationManager.ConnectionStrings["DBConnection"];

            // Register Connection class and expose IConnection 
            // by passing in the Database connection information
            builder.RegisterType<Connection>() // concrete type
                .As<IConnection>() // abstraction
                .WithParameter("settings", conn)
                .InstancePerLifetimeScope();

            // Register Repository class and expose IRepository
            builder.RegisterType<Repository>()
                .As<IRepository>()
                .InstancePerLifetimeScope();
            // Register DashboardService class and expose IDashboardService
            builder.RegisterType<DashboardService>()
                .As<IDashboardService>()
                .InstancePerLifetimeScope();

            // Register EmployeeService class and expose IEmployeeService
            builder.RegisterType<StudentService>()
                .As<IStudentService>()
                .InstancePerLifetimeScope();
        }
    }
}