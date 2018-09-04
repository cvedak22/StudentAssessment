﻿using System.Reflection;
using System.Web.Http;
using Autofac;
using Autofac.Integration.WebApi;
using StudentAssessment.Api.Autofac;
using Newtonsoft.Json.Serialization;
using System.Web.Http.Cors;

namespace StudentAssessment.Api
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            /* Allow Cross Domain Access */
            var cors = new EnableCorsAttribute("*", "*", "*");
            config.EnableCors(cors);

            // Web API routes
            config.MapHttpAttributeRoutes();

            // use camel case for JSON data
            config.Formatters.JsonFormatter.SerializerSettings.ContractResolver =
              new CamelCasePropertyNamesContractResolver();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            /*** Autofac: Build the container ***/
            var builder = new ContainerBuilder();

            // register Web API Controllers
            builder.RegisterAssemblyTypes(Assembly.GetExecutingAssembly());

            // register your classes and expose their interfaces - shared
            builder.RegisterModule(new StandardModule());

            var container = builder.Build();
            config.DependencyResolver = new AutofacWebApiDependencyResolver(container);
        }
    }
}