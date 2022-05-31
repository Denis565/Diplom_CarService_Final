using System;
using System.Data;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс стартовой формы приложения для авторизации
    /// </summary>
    public partial class Loging : Form
    {
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();

        /// <summary>
        /// Инициализация компонентов спервичной настройкой
        /// </summary>
        public Loging()
        {
            InitializeComponent();

            title.Parent = panel1;
            title.BackColor = System.Drawing.Color.Transparent;

            panel1.Parent = pictureBox1;
            panel1.BackColor = System.Drawing.Color.Transparent;

            panel1.Top = this.ClientSize.Height / 2 - panel1.Height / 2;
        }

        /// <summary>
        /// Обработка нажатия на кнопку закрытия приложения
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Exit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        /// <summary>
        /// Обработка нажатия на копку для авторизации в системе
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void Enter_Click(object sender, EventArgs e)
        {
            EnterBtn_Click();
        }

        /// <summary>
        /// Выполнение авторизации в системе
        /// </summary>
        /// <returns>Статус выполнения авторизации</returns>
        public bool EnterBtn_Click()
        {
            if (login.Text == "" || password.Text == "")
            {
                MessageBox.Show("Все поля должны быть заполнены.");
            }
            else
            {
                if (login.Text.Length < 6 || password.Text.Length < 6)
                {
                    MessageBox.Show("Логин и пароль должны быть не менее 6 символов.");
                }
                else
                {
                    DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Autarization](N'{login.Text}',N'{new Hash.MD5Class().GetHash(password.Text)}')");
                    if (dataTable.Rows.Count > 0)
                    {
                        string role = dataTable.Rows[0][2].ToString();
                        int idworker = Convert.ToInt32(dataTable.Rows[0][4]);
                        int idBranche = Convert.ToInt32(dataTable.Rows[0][5]);
                        switch (role)
                        {
                            case "Админестратор точки":
                                AdminMain adminMain = new AdminMain()
                                {
                                    LoginPerson = dataTable.Rows[0][0].ToString(),
                                    IDBranch = idBranche,
                                    IDWorkers = idworker,
                                    CBSortingValue = 0,
                                    CbFilterValue = 0,
                                    TextFilterValue = ""
                                };
                                adminMain.Show();
                                this.Hide();
                                return true;
                            case "Механик":
                                EngineeringWorks engineeringWorks = new EngineeringWorks
                                {
                                    IDBranch = idBranche,
                                    IDWorkers = idworker
                                };
                                engineeringWorks.Text = dataTable.Rows[0][3].ToString();
                                engineeringWorks.Show();
                                this.Hide();
                                return true;
                        }
                    }
                    else
                    {
                        MessageBox.Show("Авторизация не пройдена.");
                    }
                }
            }
            return false;
        }
    }
}
