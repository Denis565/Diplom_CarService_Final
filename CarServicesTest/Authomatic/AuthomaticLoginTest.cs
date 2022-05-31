using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect;

namespace CarServicesTest.Authomatic
{
    [TestClass]
    public class AuthomaticLoginTest
    {
        [TestMethod]
        public void Enter_admin2andadmin2_Success()
        {
            Loging loging = new Loging();
            loging.Show();
            loging.password.Text = "admin2";
            loging.login.Text = "admin2";

            bool result = loging.EnterBtn_Click();
            Assert.AreEqual(result, true);
        }

        [TestMethod]
        public void Enter_kadandnull_Error()
        {
            Loging loging = new Loging();
            loging.Show();
            loging.password.Text = "kad";
            loging.login.Text = "";

            bool result = loging.EnterBtn_Click();
            Assert.AreEqual(result, true);
        }
    }
}
