using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;
using System.Data;
using Microsoft.Data.SqlClient;
using Dao.Transactions.Interfaces;
using Domain.Transactions;

namespace Dao.Transactions.Implementation
{
    public class DBConectionSqlServer : IDBConectionSqlServer
    {
        string connectionString = string.Format("Data Source=CTSCO5CG9263FRW\\SQLEXPRESS;Initial Catalog=TransactionsDB;Integrated Security=true");

        public void executeSPNoQuery(string sql)
        {
            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionString);

                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {

                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Console.WriteLine("{0} {1}", reader.GetString(0), reader.GetString(1));
                            }
                        }
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }
        }

        public List<TransactionDomain> ExecuteReaderTransaction(string sql, TransactionDomain transaction)
        {
            List<TransactionDomain> listTransactionDomain = new List<TransactionDomain>();
            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionString);
                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        connection.Open();

                        command.CommandText = "GET_TRANSACTIONS";
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@idPerson", transaction.idPerson);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                TransactionDomain transactionReader = new TransactionDomain();
                                transactionReader.idPerson = reader.GetString(0);
                                transactionReader.idOperation = reader.GetString(1);
                                transactionReader.initialValue = reader.GetDouble(2).ToString();
                                transactionReader.value = reader.GetDouble(3).ToString();
                                transactionReader.finalValue = reader.GetDouble(4).ToString();
                                transactionReader.gmf = reader.GetDouble(5).ToString();

                                listTransactionDomain.Add(transactionReader);
                                // Console.WriteLine("{0} {1}", reader.GetString(0), reader.GetString(1));
                            }

                            return listTransactionDomain;
                        }
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            return null;
        }

        public string ExecuteReaderIsValidTransaction(string sql, TransactionDomain transaction)
        {
            string valid = "0";
            List<TransactionDomain> listTransactionDomain = new List<TransactionDomain>();
            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionString);
                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        connection.Open();

                        command.CommandText = "GET_ISVALID_TRANSACTIONS";
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@idPerson", transaction.idPerson);
                        command.Parameters.AddWithValue("@accountNumber", transaction.accountNumber);
                        command.Parameters.AddWithValue("@operation", transaction.idOperation);
                        command.Parameters.AddWithValue("@value", transaction.value);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                valid = reader.GetString(0);
                            }

                            return valid;
                        }
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            return valid;
        }
        public int ExecuteNoQueryTransaction(string sql, TransactionDomain transaction)
        {
            int estado = 0;
            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionString);
                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        connection.Open();

                        command.CommandText = "GENERATE_TRANSACTIONS";
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@idPerson", transaction.idPerson);
                        command.Parameters.AddWithValue("@accountNumber", transaction.accountNumber);
                        command.Parameters.AddWithValue("@operation", transaction.idOperation);
                        command.Parameters.AddWithValue("@value", transaction.value);
                        command.Parameters.AddWithValue("@AccountNumberDestination", string.IsNullOrEmpty(transaction.accountNumberDestination) ? "" : transaction.accountNumberDestination);


                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                estado = 1;
                            }
                        }
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            return estado;
        }
        public void pru()
        {
            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionString);

                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    Console.WriteLine("\nQuery data example:");
                    Console.WriteLine("=========================================\n");

                    String sql = "SELECT TOP (1000) CONVERT(VARCHAR(500),[id]) [id] , CONVERT(VARCHAR(500),[idType]) [idType]  ,[name]    ,CONVERT(VARCHAR(500),[created]) [created]      ,CONVERT(VARCHAR(500),[modified]) [modified] FROM[TransactionsDB].[dbo].[person]";

                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Console.WriteLine("{0} {1}", reader.GetString(0), reader.GetString(1));
                            }
                        }
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }
        }
    }
}
