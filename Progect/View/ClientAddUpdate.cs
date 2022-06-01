using Progect.Model;
using System;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс формы для создания и изменения информации о клиенте
    /// </summary>
    public partial class ClientAddUpdate : Form
    {
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();
        private bool status_update;

        private DataGridViewRow dataGridViewRowClient;
        private DataGridView gridView;
        public DataGridView DGVMain
        {
            set
            {
                gridView = value;
                dataGridViewRowClient = gridView.Rows[gridView.CurrentRow.Index];
            }
        }
        public DataGridView DGVClient
        {
            set
            {
                gridView = value;
                dataGridViewRowClient = gridView.Rows[gridView.CurrentRow.Index];
                surname.Text = dataGridViewRowClient.Cells[1].Value.ToString();
                name.Text = dataGridViewRowClient.Cells[2].Value.ToString();
                patronymic.Text = dataGridViewRowClient.Cells[3].Value.ToString();
                phone.Text = dataGridViewRowClient.Cells[4].Value.ToString();
                dateBirth.Value = Convert.ToDateTime(dataGridViewRowClient.Cells[5].Value.ToString());
            }
        }
        public bool IsStatusUpdate { set { status_update = value; } }

        /// <summary>
        /// Инициализация компонентов с первичной настройкой
        /// </summary>
        public ClientAddUpdate()
        {
            InitializeComponent();

            dateBirth.MaxDate = DateTime.Now.AddYears(-18);
            dateBirth.MinDate = DateTime.ParseExact("01.01.1900", "dd.MM.yyyy", System.Globalization.CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Обработка нажатия на кнопку сохранения значений
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void Save_Click(object sender, EventArgs e)
        {
            Client client = new Client
            {
                ID_Client = Convert.ToInt32(dataGridViewRowClient.Cells[0].Value.ToString()),
                Surname = surname.Text,
                Name = name.Text,
                Middle_Name = patronymic.Text,
                Phone = phone.Text,
                Date_Birth = dateBirth.Value.ToShortDateString()
            };

            try
            {
                new Custom.ModelDataValidation().Validation(client);
                sqlManager.OpenConnection();
                if (status_update)
                {
                    sqlManager.PerformingProcedure
                    (
                        new string[] { client.ID_Client.ToString(), client.Surname, client.Name, client.Middle_Name, client.Phone, client.Date_Birth },
                                "[dbo].[Client_update]",
                        new string[] { "ID_Client", "Surname", "Name", "Middle_Name", "Phone", "Date_Birth" }
                    );
                }
                else
                {
                    sqlManager.PerformingProcedure
                    (
                        new string[] { client.Surname, client.Name, client.Middle_Name, client.Phone, client.Date_Birth },
                                "[dbo].[Client_insert]",
                        new string[] { "Surname", "Name", "Middle_Name", "Phone", "Date_Birth" }
                    );
                }

                sqlManager.GetList(gridView, "[dbo].[Client]", "select * from [dbo].[Client_View]");

                sqlManager.CloseConnection();
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        /// <summary>
        /// Закрытие формы
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Back_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        /// <summary>
        /// Обработка нажатия кнопки в поле с фамилией клиента
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Surname_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.Match(e.KeyChar.ToString(), @"[а-яА-Я]|[a-zA-Z]").Success && e.KeyChar != 8)
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Обработка нажатия кнопки в поле с именем клиента
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Name_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.Match(e.KeyChar.ToString(), @"[а-яА-Я]|[a-zA-Z]").Success && e.KeyChar != 8)
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Обработка нажатия кнопки в поле с отчеством клиента
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Patronymic_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.Match(e.KeyChar.ToString(), @"[а-яА-Я]|[a-zA-Z]").Success && e.KeyChar != 8)
            {
                e.Handled = true;
            }
        }
    }
}
