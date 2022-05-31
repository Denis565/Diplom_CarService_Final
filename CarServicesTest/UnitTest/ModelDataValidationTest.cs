using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Progect.Custom;
using Progect.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CarServicesTest.UnitTest
{
    [TestClass]
    public class ModelDataValidationTest
    {
        public TestContext TestContext { get; set; }

        [TestMethod]
        [DynamicData(nameof(GetTestClient), DynamicDataSourceType.Property)]
        public void Valid_Client(Client client)
        {
            try
            {
                new ModelDataValidation().Validation(client);
                Assert.IsTrue(true);
            }
            catch
            {
                Assert.IsTrue(false);
            }
        }

        private List<Client> GetTestClient()
        {
            var client = new List<Client>
            {
                new Client { ID_Client = 1, Surname = "Балаев", Name = "Денис", Middle_Name = "Максимович", Phone = "+6 (666) 688-6566", Date_Birth = "20.04.1988"}
                /*new Client { ID_Client = 2, Surname = "Иванов", Name = "Иван", Middle_Name = "Иванович", Phone = "+6 (666) 708-6566", Date_Birth = "20.04.1988"},
                new Client { ID_Client = 3, Surname = "Гурген", Name = "Александр", Middle_Name = "Максимович", Phone = "+6 (666) 008-6566", Date_Birth = "20.04.1988"},
                new Client { ID_Client = 4, Surname = "Булеев", Name = "Иван", Middle_Name = "Дмитревич", Phone = "+6 (666) 118-6566", Date_Birth = "20.04.1988"},
                new Client { ID_Client = 5, Surname = "Раевских", Name = "Артем", Middle_Name = "Максимович", Phone = "+6 (666) 228-6566", Date_Birth = "20.04.1988"}*/
            };
            return client;
        }

        [TestMethod]
        public void Valid_Car()
        {

            Car carModel = new Car
            {
                VIN = "HDULGGFFGGFYH7779",
                Registration_Mark = "F122JH797",
                Year_Release = "2012",
                Mileage = 120000,
                Brand_Model_Compliance_ID = 1,
                Client_ID = 1
            };

            try
            {
                new ModelDataValidation().Validation(carModel);
                Assert.IsTrue(true);
            }
            catch
            {
                Assert.IsTrue(false);
            }
        }
    }
}
