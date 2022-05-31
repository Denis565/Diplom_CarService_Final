using System;
using System.Data;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс формы для создания и изменения работников
    /// </summary>
    public partial class EmployeeAddUpdate : Form
    {
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();
        private int idPost;
        private int idBranch;
        private int idBranchLogin;
        private int idEmployee;
        private int idWorker;

        public string passwordSelectPerson;
        public string loginPerson;

        private bool isStatusUpdate;

        private readonly AdminMain adminMainForms;

        public int IDWorker { set { idWorker = value; } }
        public int IDEmployee { set { idEmployee = value; } }
        public int BranchLogin { set { idBranchLogin = value; } }
        public bool IsStatusUpdate { set { isStatusUpdate = value; } }
        public string Names { set { name.Text = value; } }
        public string Surname { set { surname.Text = value; } }
        public string Patronymic { set { patronymic.Text = value; } }
        public string BranchItem { set { branch.SelectedItem = value; } }
        public string PostItem { set { post.SelectedItem = value; } }
        public string Login { set { login.Text = value; } }
        public string Password { set { passwordSelectPerson = value; } }
        public string LoginPerson { set { loginPerson = value; } }

        /// <summary>
        /// Инициализация компонентов с первичным выбором данных
        /// </summary>
        public EmployeeAddUpdate(AdminMain adminMainForm)
        {
            InitializeComponent();
            sqlManager.AddComboBox(post, "[dbo].[Information_Post]", 0);
            sqlManager.AddComboBox(branch, "[dbo].[Information_Branch]", 0);
            post.SelectedIndex = 0;
            branch.SelectedIndex = 0;
            adminMainForms = adminMainForm;
        }

        /// <summary>
        /// Переход на главную форму админестратора с закрытием текущей формы
        /// </summary>
        private void Transition_Admin()
        {
            sqlManager.GetList(adminMainForms.listEmployees, "[dbo].[Worker]", $@"select * from [dbo].[Worker_View] (N'{loginPerson}',{idBranchLogin})");
            int indexFilter = adminMainForms.cbFilter.SelectedIndex;
            int indexSorting = adminMainForms.cbSorting.SelectedIndex;
            string textFilter = adminMainForms.textFilter.Text;
            adminMainForms.cbFilter.SelectedIndex = -1;
            adminMainForms.cbSorting.SelectedIndex = -1;
            adminMainForms.textFilter.Text = "";

            adminMainForms.cbFilter.SelectedIndex = indexFilter;
            adminMainForms.cbSorting.SelectedIndex = indexSorting;
            adminMainForms.textFilter.Text = textFilter;
            this.Hide();
            this.Close();
        }

        /// <summary>
        /// Обработка нажатия на кнопку для перехода назад в главную форму админестратора
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Back_Click(object sender, EventArgs e)
        {
            Transition_Admin();
        }

        /// <summary>
        /// Обработка выбора должности
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Post_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Post](N'{post.Text}')");
            if (dataTable.Rows.Count > 0)
            {
                idPost = Convert.ToInt32(dataTable.Rows[0][0]);
            }
        }

        /// <summary>
        /// Обработка нажатия на кнопку сохранения данных сотрудника
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Save_Click(object sender, EventArgs e)
        {
            SaveBtn_Click();
        }

        /// <summary>
        /// Метод сохранения данных сотрудника
        /// </summary>
        /// <returns>Успешность добавления или изменения сотрудника</returns>
        public bool SaveBtn_Click()
        {
            bool notNullPassword = true;

            if (!isStatusUpdate && password.Text.Replace(" ", "").Trim() == "")
            {
                notNullPassword = false;
            }

            if (name.Text.Replace(" ", "").Trim() != "" && surname.Text.Replace(" ", "").Trim() != "" && login.Text.Replace(" ", "").Trim() != "" && notNullPassword)
            {
                DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Login_Worker](N'{login.Text}')");
                if (dataTable.Rows.Count > 0 && idWorker != Convert.ToInt32(dataTable.Rows[0][0].ToString()))
                {
                    MessageBox.Show("Пользователь с таким логином уже существует.");
                }
                else
                {
                    if (!isStatusUpdate)
                    {
                        if (login.Text.Length < 6 || password.Text.Length < 6)
                        {
                            MessageBox.Show("Логин и пароль должны быть не менее 6 символов.");
                            return false;
                        }
                    }
                    else
                    {
                        if (login.Text.Length < 6 || (password.Text.Length < 6 && password.Text.Length > 0))
                        {
                            MessageBox.Show("Логин и пароль должны быть не менее 6 символов.");
                            return false;
                        }
                    }

                    sqlManager.OpenConnection();
                    if (!isStatusUpdate)
                    {

                        string branchText = branch.Text.Trim(' ');

                        if (branch.FindString(branchText) < 0)
                        {
                            sqlManager.PerformingProcedure
                            (
                                 new string[] { branchText },
                                       "[dbo].[Branch_insert]",
                                 new string[] { "Address" }
                            );

                            branch.Items.Add(branchText);
                            branch.SelectedItem = branchText;
                        }
                        Create_Work();
                        sqlManager.CloseConnection();
                        return true;
                    }
                    else
                    {

                        if (password.Text.Replace(" ", "").Trim() != "")
                        {
                            passwordSelectPerson = new Hash.MD5Class().GetHash(password.Text);
                        }

                        string branchText = branch.Text.Trim(' ');

                        if (branch.FindString(branchText) < 0)
                        {
                            sqlManager.PerformingProcedure
                            (
                                 new string[] { branchText },
                                       "[dbo].[Branch_insert]",
                                 new string[] { "Address" }
                            );
                            branch.Items.Add(branchText);
                            branch.SelectedItem = branchText;
                        }


                        bool statusCreateEmployee = sqlManager.PerformingProcedure
                        (
                          new string[] { idEmployee.ToString(), surname.Text, name.Text, patronymic.Text },
                                "[dbo].[Employee_update]",
                          new string[] { "ID_Employee", "Surname", "Name_Employee", "Patronymic" }
                        );

                        bool statusCreateWorker = sqlManager.PerformingProcedure
                        (
                          new string[] { idWorker.ToString(), idEmployee.ToString(), idPost.ToString(), login.Text, passwordSelectPerson, idBranch.ToString() },
                                "[dbo].[Worker_update]",
                          new string[] { "ID_Worker", "Employee_ID", "Post_ID", "Login", "Password", "Branch_ID" }
                        );

                        if (!statusCreateEmployee || !statusCreateWorker)
                        {
                            sqlManager.CloseConnection();
                            return false;
                        }

                        Transition_Admin();
                        sqlManager.CloseConnection();
                        return true;
                    }
                }
            }
            else
            {
                MessageBox.Show("Все поля должны быть заполнены.Поле отчество не обязательно для заполнения.");
            }
            sqlManager.CloseConnection();
            return false;
        }

        /// <summary>
        /// Функция создание работника
        /// </summary>
        private void Create_Work()
        {
            DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Employee](N'{surname.Text}.{name.Text}.{patronymic.Text}')");
            if (dataTable.Rows.Count > 0)
            {
                idEmployee = Convert.ToInt32(dataTable.Rows[0][0]);

                sqlManager.PerformingProcedure
                (
                  new string[] { idEmployee.ToString(), idPost.ToString(), login.Text, new Hash.MD5Class().GetHash(password.Text), idBranch.ToString() },
                        "[dbo].[Worker_insert]",
                  new string[] { "Employee_ID", "Post_ID", "Login", "Password", "Branch_ID" }
                );

                ClearInformation();
            }
            else
            {
                sqlManager.PerformingProcedure
                (
                    new string[] { surname.Text, name.Text, patronymic.Text },
                    "[dbo].[Employee_insert]",
                    new string[] { "Surname", "Name_Employee", "Patronymic" }
                );

                Create_Work();
            }
        }

        /// <summary>
        /// Очистка полей
        /// </summary>
        private void ClearInformation()
        {
            name.Text = "";
            surname.Text = "";
            patronymic.Text = "";
            login.Text = "";
            password.Text = "";
        }

        /// <summary>
        /// Обработка выбора адресса работы
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Branch_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Branch](N'{branch.Text}')");
            if (dataTable.Rows.Count > 0)
            {
                idBranch = Convert.ToInt32(dataTable.Rows[0][0]);
            }
        }

        /// <summary>
        /// Обработка нажатия на клавиши в поле с фамилией
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Surname_KeyPress(object sender, KeyPressEventArgs e)
        {
            NewKeyPress(e);
        }

        /// <summary>
        /// Обработка нажатия на клавиши в поле с именем
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Name_KeyPress(object sender, KeyPressEventArgs e)
        {
            NewKeyPress(e);
        }

        /// <summary>
        /// Обработка нажатия на клавиши в поле с отчеством
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Patronymic_KeyPress(object sender, KeyPressEventArgs e)
        {
            NewKeyPress(e);
        }

        /// <summary>
        /// Проверка чтобы вводились только буквы
        /// </summary>
        /// <param name="e"></param>
        private void NewKeyPress(KeyPressEventArgs e)
        {
            string Symbol = e.KeyChar.ToString();

            if (!Regex.Match(Symbol, @"[а-яА-Я]|[a-zA-Z]").Success && e.KeyChar != 8)
            {
                e.Handled = true;
            }
        }
    }
}
