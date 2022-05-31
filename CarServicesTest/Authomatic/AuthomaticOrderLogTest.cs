using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect;
using Progect.Custom;
using System.Windows.Forms;

namespace CarServicesTest.Authomatic
{
    [TestClass]
    public class AuthomaticOrderLogTest
    {
        private readonly OrderGeneral orderGeneral = new OrderGeneral();

        [TestMethod]
        public void EnabledButtonPrint_Closed_true()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();
            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 2;

            bool executionStatus = orderGeneral.EnabledButtonPrint(0, engineeringWorks.listOrder, new ToolStripMenuItem());
            Assert.IsTrue(executionStatus);
        }

        [TestMethod]
        public void EnabledButtonPrint_IsProgress_false()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();
            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 3;

            bool executionStatus = orderGeneral.EnabledButtonPrint(0, engineeringWorks.listOrder, new ToolStripMenuItem());
            Assert.IsFalse(executionStatus);
        }

        [TestMethod]
        public void EnabledButtonPrint_IsOpen_false_Error()
        {
            EngineeringWorks engineeringWorks = new EngineeringWorks
            {
                IDBranch = 1,
                IDWorkers = 5
            };
            engineeringWorks.Show();
            engineeringWorks.cbFilterOrderStatus.SelectedIndex = 1;

            bool executionStatus = orderGeneral.EnabledButtonPrint(0, engineeringWorks.listOrder, new ToolStripMenuItem());
            Assert.IsTrue(executionStatus);
        }
    }
}
