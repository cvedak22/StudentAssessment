using System;
using System.Configuration;


namespace StudentAssessment.Services.Common
{
    public class Connection : IConnection
    {
        public Connection(ConnectionStringSettings settings)
        {
            //must use a guard clause to ensure something is injected
            if (settings == null)
                throw new ArgumentNullException("settings", "Connection expects constuctor injection for ConnectionStringSettings param");
            //we have a value by now so assign it
            ConnectionString = settings.ConnectionString;
        }
        public string ConnectionString { get; set; }
    }
}
