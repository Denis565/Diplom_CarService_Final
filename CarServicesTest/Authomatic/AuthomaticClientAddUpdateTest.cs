using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect;
using System;
using System.Threading;

namespace CarServicesTest.Authomatic
{
    [TestClass]
    public class AuthomaticClientAddUpdateTest
    {
        [TestMethod]
        public void AddBtnClick_Success()
        {
            AdminMain adminMain = new AdminMain()
            {
                LoginPerson = "admin2",
                IDBranch = 1,
                IDWorkers = 32,
                CBSortingValue = 0,
                CbFilterValue = 0,
                TextFilterValue = ""
            };
            adminMain.Show();

            Thread.Sleep(10000);

            adminMain.clientList.CurrentCell = adminMain.clientList.Rows[1].Cells[1];

            ClientAddUpdate clientAddUpdate = new ClientAddUpdate
            {
                DGVMain = adminMain.clientList
            };
            clientAddUpdate.Show();

            clientAddUpdate.name.Text = "Иван";
            clientAddUpdate.surname.Text = "Мулькин";
            clientAddUpdate.patronymic.Text = "Казим";
            clientAddUpdate.phone.Text = "98557898768888";
            clientAddUpdate.dateBirth.Text = "20.05.1988";

            try
            {
                clientAddUpdate.Save_Click(clientAddUpdate, new EventArgs());
                Assert.IsTrue(true);
            }
            catch
            {
                Assert.IsTrue(false);
            }

        }

        [TestMethod]
        public void AddBtnClick_Error()
        {
            AdminMain adminMain = new AdminMain()
            {
                LoginPerson = "admin2",
                IDBranch = 1,
                IDWorkers = 32,
                CBSortingValue = 0,
                CbFilterValue = 0,
                TextFilterValue = ""
            };
            adminMain.Show();

            Thread.Sleep(10000);

            adminMain.clientList.CurrentCell = adminMain.clientList.Rows[1].Cells[1];

            ClientAddUpdate clientAddUpdate = new ClientAddUpdate
            {
                DGVMain = adminMain.clientList
            };
            clientAddUpdate.Show();

            clientAddUpdate.name.Text = "Иван";
            clientAddUpdate.surname.Text = "Мулькин";
            clientAddUpdate.patronymic.Text = "Казим";
            clientAddUpdate.phone.Text = "985";
            clientAddUpdate.dateBirth.Text = "20.05.1988";

            try
            {
                clientAddUpdate.Save_Click(clientAddUpdate, new EventArgs());
                Assert.IsTrue(true);
            }
            catch
            {
                Assert.IsTrue(false);
            }

        }

        [TestMethod]
        public void UpdateBtnClick_Success()
        {
            AdminMain adminMain = new AdminMain()
            {
                LoginPerson = "admin2",
                IDBranch = 1,
                IDWorkers = 32,
                CBSortingValue = 0,
                CbFilterValue = 0,
                TextFilterValue = ""
            };
            adminMain.Show();

            Thread.Sleep(10000);

            adminMain.clientList.CurrentCell = adminMain.clientList.Rows[1].Cells[1];

            ClientAddUpdate clientAddUpdate = new ClientAddUpdate
            {
                DGVClient = adminMain.clientList,
                IsStatusUpdate = true
            };
            clientAddUpdate.Show();

            clientAddUpdate.name.Text = "Иван";

            try
            {
                clientAddUpdate.Save_Click(clientAddUpdate, new EventArgs());
                Assert.IsTrue(true);
            }
            catch
            {
                Assert.IsTrue(false);
            }
        }

        [TestMethod]
        public void UpdateBtnClick_Error()
        {
            AdminMain adminMain = new AdminMain()
            {
                LoginPerson = "admin2",
                IDBranch = 1,
                IDWorkers = 32,
                CBSortingValue = 0,
                CbFilterValue = 0,
                TextFilterValue = ""
            };
            adminMain.Show();

            Thread.Sleep(10000);

            adminMain.clientList.CurrentCell = adminMain.clientList.Rows[1].Cells[1];

            ClientAddUpdate clientAddUpdate = new ClientAddUpdate
            {
                DGVClient = adminMain.clientList,
                IsStatusUpdate = true
            };
            clientAddUpdate.Show();

            clientAddUpdate.name.Text = "";

            try
            {
                clientAddUpdate.Save_Click(clientAddUpdate, new EventArgs());
                Assert.IsTrue(true);
            }
            catch
            {
                Assert.IsTrue(false);
            }
        }
    }
}
