using System;
using System.Windows.Forms;

namespace Progect
{
    internal static class Program
    {
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        [STAThread]
        private static void Main()
        {
            try
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                Application.Run(new Loging());
            }
            catch(Exception ex) { MessageBox.Show(ex.Message); }
        }

        //Data Source=dbresoran.cjfd5gi0qfpz.us-east-1.rds.amazonaws.com;Initial Catalog=CarService;User ID=admin;Password=qwerty1234
    }
}
