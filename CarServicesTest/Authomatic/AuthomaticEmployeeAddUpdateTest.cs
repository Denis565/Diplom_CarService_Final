using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect;
using System;
using System.Threading;
using System.Windows.Forms;

namespace CarServicesTest.Authomatic
{
    [TestClass]
    public class AuthomaticEmployeeAddUpdateTest
    {
        [TestMethod]
        public void AddBtn_Click()
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

            EmployeeAddUpdate employeeAddUpdate = new EmployeeAddUpdate(adminMain);
            employeeAddUpdate.Show();

            DateTime now = DateTime.Now;
            string index = (now.Year + now.Month + now.Day + now.Minute + now.Second + now.Millisecond).ToString();

            employeeAddUpdate.name.Text = "Денис";
            employeeAddUpdate.surname.Text = "Купатов";
            employeeAddUpdate.patronymic.Text = "Ильич";
            employeeAddUpdate.post.SelectedIndex = 1;
            employeeAddUpdate.login.Text = $@"administrator {index}";
            employeeAddUpdate.password.Text = $@"denAdmin332 {index}";
            employeeAddUpdate.branch.SelectedIndex = 1;

            bool result = employeeAddUpdate.SaveBtn_Click();

            Assert.AreEqual(result, true);
        }

        [TestMethod]
        public void UpdateBtn_Click()
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

            DataGridViewRow row = adminMain.listEmployees.Rows[1];
            EmployeeAddUpdate employeeAddUpdate = new EmployeeAddUpdate(adminMain)
            {
                Names = row.Cells[3].Value.ToString(),
                Surname = row.Cells[2].Value.ToString(),
                Patronymic = row.Cells[4].Value.ToString(),
                BranchItem = row.Cells[8].Value.ToString(),
                PostItem = row.Cells[5].Value.ToString(),
                Login = row.Cells[6].Value.ToString(),
                Password = row.Cells[7].Value.ToString(),
                IDEmployee = Convert.ToInt32(row.Cells[0].Value),
                IDWorker = Convert.ToInt32(row.Cells[1].Value),
                BranchLogin = 1,
                LoginPerson = "admin2",
                IsStatusUpdate = true
            };

            employeeAddUpdate.Show();

            employeeAddUpdate.Show();
            employeeAddUpdate.name.Text = "Ильин";
            employeeAddUpdate.patronymic.Text = "Михайлович";

            bool result = employeeAddUpdate.SaveBtn_Click();

            Assert.AreEqual(result, true);
        }
    }
}
