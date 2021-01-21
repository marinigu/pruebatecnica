using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TransactionsWS.Models
{
    public class TransactionsModel
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
