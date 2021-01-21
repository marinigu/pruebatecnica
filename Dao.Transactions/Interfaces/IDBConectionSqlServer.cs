using Domain.Transactions;
using System;
using System.Collections.Generic;
using System.Text;

namespace Dao.Transactions.Interfaces
{
    public interface IDBConectionSqlServer
    {
        void pru();
        List<TransactionDomain> ExecuteReaderTransaction(string sql, TransactionDomain transaction);
        int ExecuteNoQueryTransaction(string sql, TransactionDomain transaction);
        string ExecuteReaderIsValidTransaction(string sql, TransactionDomain transaction);
    }
}
