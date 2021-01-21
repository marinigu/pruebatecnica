﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Dao.Transactions.Interfaces;
using Domain.Transactions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;

namespace Rest.Transactions.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TransactController : ControllerBase
    {
        private readonly ILogger<TransactController> _logger;

        public TransactController(ILogger<TransactController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public List<TransactionDomain> Get()
        {
            TransactionDomain transaction = new TransactionDomain();
            transaction.idPerson = "123";
            transaction.accountNumber = "A";
            transaction.accountNumberDestination = "B";
            transaction.value = "9600000";
            transaction.idOperation = "1";
            string valid = ExecuteReaderIsValidTransaction(transaction);

            if (valid.Equals("1"))
            {
                List<TransactionDomain> lst = ExecuteReaderTransaction(transaction);
                ExecuteNoQueryTransaction(transaction);
                return lst;
            }
            else {
                List<TransactionDomain> lst = ExecuteReaderTransaction(transaction);
                return lst;
            }

           // return null;
        }

        private List<TransactionDomain> ExecuteReaderTransaction(TransactionDomain transaction)
        {
            try
            {
                List<TransactionDomain> ListTransactionDomains = new List<TransactionDomain>();

                IDBConectionSqlServer dBConectionSqlServer;

                dBConectionSqlServer = new Dao.Transactions.Implementation.DBConectionSqlServer();

                ListTransactionDomains = dBConectionSqlServer.ExecuteReaderTransaction("", transaction);
                return ListTransactionDomains;
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            return null;
        }

        private void ExecuteNoQueryTransaction(TransactionDomain transaction)
        {
            try
            {
                IDBConectionSqlServer dBConectionSqlServer;
                dBConectionSqlServer = new Dao.Transactions.Implementation.DBConectionSqlServer();
                int estado = dBConectionSqlServer.ExecuteNoQueryTransaction("", transaction);
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }
        }

        private string ExecuteReaderIsValidTransaction(TransactionDomain transaction)
        {
            string valid = "0";
            try
            {
                IDBConectionSqlServer dBConectionSqlServer;
                dBConectionSqlServer = new Dao.Transactions.Implementation.DBConectionSqlServer();
                valid = dBConectionSqlServer.ExecuteReaderIsValidTransaction("", transaction);
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            return valid;
        }
    }
}