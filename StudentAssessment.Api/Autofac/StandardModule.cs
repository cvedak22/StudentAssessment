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

            
            var conn = ConfigurationManager.ConnectionStrings["DBConnection"];

            
            builder.RegisterType<Connection>() 
                .As<IConnection>() 
                .WithParameter("settings", conn)
                .InstancePerLifetimeScope();

            
            builder.RegisterType<Repository>()
                .As<IRepository>()
                .InstancePerLifetimeScope();
           
            builder.RegisterType<DashboardService>()
                .As<IDashboardService>()
                .InstancePerLifetimeScope();

            
            builder.RegisterType<StudentService>()
                .As<IStudentService>()
                .InstancePerLifetimeScope();
        }
    }
}