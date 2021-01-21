using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using TransactionsWS.Models;

namespace TransactionsWS.Controllers
{
    public class DefaultController : Controller
    {
        private readonly ILogger<DefaultController> _logger;

        public DefaultController(ILogger<DefaultController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            //var url = $"https://localhost:44372/weatherforecast";
            var url = $"https://localhost:44372/transact";
        
            var request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";
            request.ContentType = "application/json";
            request.Accept = "application/json";

            try
            {
                using (WebResponse response = request.GetResponse())
                {
                    using (Stream strReader = response.GetResponseStream())
                    {
                        if (strReader != null)
                        {

                            using (StreamReader objReader = new StreamReader(strReader))
                            {
                                var responseBody = objReader.ReadToEnd();
                                // Do something with responseBody
                                ArrayList result = new ArrayList();
                                Array a = responseBody.ToArray();

                                //  var objResponse1 = JsonConvert.DeserializeObject<List<Class1>>(responseBody);
                                var objResponse1 = JsonConvert.DeserializeObject<List<TransactionsModel>>(responseBody);

                                Console.WriteLine(responseBody);
                                return View(objResponse1);
                            }
                        }
                    }
                }
            }
            catch (WebException ex)
            {
                string msg = ex.Message;
                // Handle error
            }
            return View();
        }
    }
}