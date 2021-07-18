using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace SalesTaxes.CodeHelpers
{
    public class DBCommandHelpers
    {
        public static SqlCommand GetWriteSqlProcedureCommand(string sqlCommand = "", string connection = null)
        {
            var con = new SqlConnection(connection);
            con.Open();
            var retVal = new SqlCommand(sqlCommand, con);
            retVal.CommandType = CommandType.StoredProcedure;
            retVal.Parameters.Clear();
            return retVal;
        }

        public static int ExecuteScalarAndCloseConnection(SqlCommand cmd)
        {
            int retVal = 0;
            try
            {
                retVal = Convert.ToInt32(cmd.ExecuteScalar());
            }
            catch (Exception ex)
            {
                if (ex != null)
                {
                    throw ex;
                }
            }
            finally
            {
                if (cmd.Connection != null && cmd.Connection.State == ConnectionState.Open)
                {
                    cmd.Connection.Close();
                }
            }

            return retVal;
        }


        public static bool ExecuteScalarBoolAndCloseConnection(SqlCommand cmd)
        {
            bool retVal = false;
            try
            {
                retVal = Convert.ToBoolean(cmd.ExecuteScalar());
            }
            catch (Exception ex)
            {
                if (ex != null)
                {
                    throw ex;
                }
            }
            finally
            {
                if (cmd.Connection != null && cmd.Connection.State == ConnectionState.Open)
                {
                    cmd.Connection.Close();
                }
            }

            return retVal;
        }

    }
}
