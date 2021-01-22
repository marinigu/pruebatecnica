using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TransactionsWS.Models
{
    public class TransactionsModel
    {
        [Required]
        public string idPerson { get; set; }
        [Required]
        public string idOperation { get; set; }
        public string initialValue { get; set; }
        [Required]
        public string value { get; set; }
        public string finalValue { get; set; }
        [Required]
        public string accountNumber { get; set; }
        public string accountNumberDestination { get; set; }
        public string gmf { get; set; }
    }
}
