using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect;
using System.Collections.Generic;
using System.Threading;
using System.Windows.Forms;

namespace CarServicesTest.Authomatic
{
    [TestClass]
    public class AuthomaticAdminMainTest
    {
        [TestMethod]
        public void CbFilter_SelectedIndexChanged_0andА_list()
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

            Assert.IsNotNull(adminMain.listEmployees);

            string valueTextFilter = "К";
            int countListEmployee = adminMain.listEmployees.Rows.Count;
            adminMain.cbFilter.SelectedIndex = 0;
            adminMain.textFilter.Text = valueTextFilter;
            Assert.AreNotEqual(countListEmployee, adminMain.listEmployees.Rows.Count);
            string res = adminMain.listEmployees.Rows[0].Cells[2].Value.ToString()[0].ToString();
            Assert.AreEqual(res, valueTextFilter);
        }

        [TestMethod]
        public void CbFilter_SelectedIndexChanged_1andР_list()
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

            Assert.IsNotNull(adminMain.listEmployees);

            string valueTextFilter = "М";
            int countListEmployee = adminMain.listEmployees.Rows.Count;
            adminMain.cbFilter.SelectedIndex = 1;
            adminMain.textFilter.Text = valueTextFilter;
            Assert.AreNotEqual(countListEmployee, adminMain.listEmployees.Rows.Count);
            Assert.AreEqual(adminMain.listEmployees.Rows[0].Cells[5].Value.ToString()[0].ToString(), valueTextFilter);
        }

        [TestMethod]
        public void CbSorting_SelectedIndexChanged_0_list()
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

            Assert.IsNotNull(adminMain.listEmployees);

            List<string> listBefore = new List<string>();

            foreach (DataGridViewRow row in adminMain.listEmployees.Rows)
            {
                listBefore.Add(row.Cells[2].Value.ToString());
            }

            List<string> listAfter = listBefore;
            listAfter.Sort((left, right) => left.CompareTo(right));
            Assert.AreEqual(listBefore, listAfter);
        }

        [TestMethod]
        public void CbSorting_SelectedIndexChanged_1_list()
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

            Assert.IsNotNull(adminMain.listEmployees);

            List<string> listBefore = new List<string>();

            foreach (DataGridViewRow row in adminMain.listEmployees.Rows)
            {
                listBefore.Add(row.Cells[2].Value.ToString());
            }

            List<string> listAfter = listBefore;

            adminMain.cbSorting.SelectedIndex = 1;

            listBefore.Clear();

            foreach (DataGridViewRow row in adminMain.listEmployees.Rows)
            {
                listBefore.Add(row.Cells[2].Value.ToString());
            }

            listAfter.Sort((right, leftt) => right.CompareTo(leftt));
            Assert.AreEqual(listBefore, listAfter);
        }

        [TestMethod]
        public void CbSorting_SelectedIndexChanged_2_list()
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

            Assert.IsNotNull(adminMain.listEmployees);

            List<string> listBefore = new List<string>();

            foreach (DataGridViewRow row in adminMain.listEmployees.Rows)
            {
                listBefore.Add(row.Cells[5].Value.ToString());
            }

            List<string> listAfter = listBefore;

            adminMain.cbSorting.SelectedIndex = 2;

            listBefore.Clear();

            foreach (DataGridViewRow row in adminMain.listEmployees.Rows)
            {
                listBefore.Add(row.Cells[5].Value.ToString());
            }

            listAfter.Sort((leftt, right) => leftt.CompareTo(right));
            Assert.AreEqual(listBefore, listAfter);
        }

        [TestMethod]
        public void CbSorting_SelectedIndexChanged_3_list()
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

            Assert.IsNotNull(adminMain.listEmployees);

            List<string> listBefore = new List<string>();

            foreach (DataGridViewRow row in adminMain.listEmployees.Rows)
            {
                listBefore.Add(row.Cells[5].Value.ToString());
            }

            List<string> listAfter = listBefore;

            adminMain.cbSorting.SelectedIndex = 2;

            listBefore.Clear();

            foreach (DataGridViewRow row in adminMain.listEmployees.Rows)
            {
                listBefore.Add(row.Cells[5].Value.ToString());
            }

            listAfter.Sort((right, leftt) => right.CompareTo(leftt));
            Assert.AreEqual(listBefore, listAfter);
        }

        [TestMethod]
        public void SeartchSurname_TextChanged_Б_list()
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

            Thread.Sleep(27000);

            Assert.IsNotNull(adminMain.clientList);

            string valueTextFilter = "Б";
            int countListEmployee = adminMain.clientList.Rows.Count;
            adminMain.seartchSurname.Text = valueTextFilter;

            Assert.AreNotEqual(countListEmployee, adminMain.clientList.Rows.Count);
            Assert.AreEqual(adminMain.clientList.Rows[0].Cells[1].Value.ToString()[0].ToString(), valueTextFilter);
        }

        [TestMethod]
        public void GenerateReportClick()
        {
            try
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
                adminMain.GenerateReport_Click(adminMain, new System.EventArgs());

                Assert.IsTrue(true);
            }
            catch
            {
                Assert.IsTrue(false);
            }
        }
    }
}
