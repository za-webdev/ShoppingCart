using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.DBAccess
{
    public class AppDBAccess
    {
        public readonly string sqlConnection;

        public AppDBAccess()
        {
            var configuration = GetConfiguration();
            sqlConnection = new SqlConnection(configuration.GetConnectionString("DevConnection")).ConnectionString;
        }

        public IConfiguration GetConfiguration()
        {
            var builder = new ConfigurationBuilder().SetBasePath(Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
            return builder.Build();
        }
    }
}
