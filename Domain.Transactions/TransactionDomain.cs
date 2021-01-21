using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Transactions
{
    public class TransactionDomain
    {
        public string idPerson { get; set; }
        public string idOperation { get; set; }
        public string initialValue { get; set; }
        public string value { get; set; }
        public string finalValue { get; set; }
       public string accountNumber { get; set; }
        public string accountNumberDestination { get; set; }
        public string gmf { get; set; }
    }
}
