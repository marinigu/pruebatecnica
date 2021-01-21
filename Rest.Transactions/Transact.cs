using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Rest.Transactions
{
    public class Transact
    {
        public string idPerson { get; set; }
        public string idOperation { get; set; }
        public string initialValue { get; set; }
        public string value { get; set; }
        public string finalValue { get; set; }
    }
}
