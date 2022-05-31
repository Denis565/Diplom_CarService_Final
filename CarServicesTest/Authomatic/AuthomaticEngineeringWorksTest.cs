using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Windows.Forms;

namespace CarServicesTest.Authomatic
{
    [TestClass]
    public class AuthomaticEngineeringWorksTest
    {
        [TestMethod]
        public void CbFilterOrderStatus_SelectedIndexChanged_1()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();

            string status = "Открыт";

            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 0;

            List<int> listBefore = (((DataTable)engineeringWorks.listOrder.DataSource).Rows)
                .Cast<DataRow>()
                .Where(x => x[3].ToString() == status)
                .Select(x => Convert.ToInt32(x[0].ToString())).ToList();

            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 1;

            List<int> listAfter = (((DataTable)engineeringWorks.listOrder.DataSource).Rows)
                .Cast<DataRow>()
                .Where(x => x[3].ToString() == status)
                .Select(x => Convert.ToInt32(x[0].ToString())).ToList();

            listBefore.Sort((leftt, right) => leftt.CompareTo(right));
            listBefore.Reverse();
            CollectionAssert.AreEqual(listAfter, listBefore);
        }

        [TestMethod]
        public void CbFilterOrderStatus_SelectedIndexChanged_2()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();

            string status = "Закрыт";

            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 0;

            List<int> listBefore = (((DataTable)engineeringWorks.listOrder.DataSource).Rows)
                .Cast<DataRow>()
                .Where(x => x[3].ToString() == status)
                .Select(x => Convert.ToInt32(x[0].ToString())).ToList();

            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 2;

            List<int> listAfter = (((DataTable)engineeringWorks.listOrder.DataSource).Rows)
                .Cast<DataRow>()
                .Where(x => x[3].ToString() == status)
                .Select(x => Convert.ToInt32(x[0].ToString())).ToList();

            listBefore.Sort((leftt, right) => leftt.CompareTo(right));
            listBefore.Reverse();
            CollectionAssert.AreEqual(listAfter, listBefore);
        }

        [TestMethod]
        public void CbFilterOrderStatus_SelectedIndexChanged_3()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();

            string status = "Выполняется";

            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 0;

            List<int> listBefore = (((DataTable)engineeringWorks.listOrder.DataSource).Rows)
                .Cast<DataRow>()
                .Where(x => x[3].ToString() == status)
                .Select(x => Convert.ToInt32(x[0].ToString())).ToList();


            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 3;

            List<int> listAfter = (((DataTable)engineeringWorks.listOrder.DataSource).Rows)
                .Cast<DataRow>()
                .Where(x => x[3].ToString() == status)
                .Select(x => Convert.ToInt32(x[0].ToString())).ToList();

            listBefore.Sort((leftt, right) => leftt.CompareTo(right));
            listBefore.Reverse();
            CollectionAssert.AreEqual(listAfter, listBefore);
        }

        [TestMethod]
        public void DoubleClickListMaterials()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();

            int countRowStrat = engineeringWorks.listSelectedMaterials.Rows.Count;

            engineeringWorks.ListAvailableMaterials_CellMouseDoubleClick(this,
                new DataGridViewCellMouseEventArgs(1, 1, 131, 15, new MouseEventArgs(MouseButtons.Left, 2, 131, 15, 0)));

            string item = engineeringWorks.listAvailableMaterials.Rows[1].Cells[1].Value.ToString();
            int countRowEnd = engineeringWorks.listSelectedMaterials.Rows.Count;

            bool statusAddRow = false;
            if (countRowEnd > countRowStrat)
            {
                statusAddRow = true;
            }

            bool statusAddRowCorrect = false;
            if (engineeringWorks.listSelectedMaterials.Rows[countRowEnd - 1].Cells[2].Value.ToString() == item)
            {
                statusAddRowCorrect = true;
            }

            Assert.IsTrue(statusAddRow);
            Assert.IsTrue(statusAddRowCorrect);
        }

        [TestMethod]
        public void DoubleClickListService()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();

            int countRowStrat = engineeringWorks.listSelectedServices.Rows.Count;

            engineeringWorks.ListAvailableServices_CellMouseDoubleClick(this,
                new DataGridViewCellMouseEventArgs(1, 1, 131, 15, new MouseEventArgs(MouseButtons.Left, 2, 131, 15, 0)));

            string item = engineeringWorks.listAvailableServices.Rows[1].Cells[1].Value.ToString();
            int countRowEnd = engineeringWorks.listSelectedServices.Rows.Count;

            bool statusAddRow = false;
            if (countRowEnd > countRowStrat)
            {
                statusAddRow = true;
            }

            bool statusAddRowCorrect = false;
            if (engineeringWorks.listSelectedServices.Rows[countRowEnd - 1].Cells[2].Value.ToString() == item)
            {
                statusAddRowCorrect = true;
            }

            Assert.IsTrue(statusAddRow);
            Assert.IsTrue(statusAddRowCorrect);
        }
    }
}
