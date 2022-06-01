using Progect.Model;
using System;
using System.Data;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс формы для создания и изменения машины
    /// </summary>
    public partial class CarAddUpdate : Form
    {
        private int idBrandModelCompliance;
        private int idClient;

        private bool status_update;

        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();

        private ToolStripComboBox cbFilter;

        private DataGridViewRow dataGridViewRowCar;
        private DataGridView gridViewListCar;

        private Car carStart;

        public int IDClient { set { idClient = value; } }
        public DataGridView DGVCar
        {
            set
            {
                gridViewListCar = value;
                dataGridViewRowCar = gridViewListCar.Rows[gridViewListCar.CurrentRow.Index];
                vinNumber.Text = dataGridViewRowCar.Cells[0].Value.ToString();
                registrationMark.Text = dataGridViewRowCar.Cells[1].Value.ToString().Replace(" ", "");
                brand.SelectedItem = dataGridViewRowCar.Cells[2].Value.ToString();
                model.SelectedItem = dataGridViewRowCar.Cells[3].Value.ToString();
                yearRelease.SelectedItem = dataGridViewRowCar.Cells[4].Value.ToString();
                mileage.Text = dataGridViewRowCar.Cells[5].Value.ToString().Replace("км", "").Replace(" ", "");

                carStart = new Car()
                {
                    VIN = vinNumber.Text,
                    Registration_Mark = registrationMark.Text,
                    Year_Release = yearRelease.Text,
                    Mileage = Convert.ToInt32(mileage.Text),
                    Brand_Model_Compliance_ID = idBrandModelCompliance,
                    Client_ID = idClient
                };
            }
        }
        public DataGridView DGVListCar { set { gridViewListCar = value; } }
        public bool IsStatusUpdate { set { status_update = value; } }
        public ToolStripComboBox TextFilter { set { cbFilter = value; } }

        /// <summary>
        /// Инициализация компонентов
        /// </summary>
        public CarAddUpdate()
        {
            InitializeComponent();
            AddYear();
            sqlManager.AddComboBox(brand, "[dbo].[Car_Brand_View]", 0);
            brand.SelectedIndex = 0;
        }

        /// <summary>
        /// Добавление годов в выпадающий список
        /// </summary>
        /// <returns></returns>
        private async void AddYear()
        {
            await Task.Run(() =>
            {
                int yearNow = DateTime.Now.Year;

                for (int i = yearNow; i >= 1950; i--)
                {
                    yearRelease.Items.Add(i.ToString());
                }

                yearRelease.SelectedIndex = 0;
            });
        }

        /// <summary>
        /// Обработка нажатия кнопки в поле с вин номером
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void VinNumber_KeyPress(object sender, KeyPressEventArgs e)
        {
            char number = e.KeyChar;
            if (number == (Char)Keys.Back)
            {
                return;
            }

            if (char.IsDigit(number) || char.IsLetter(number))
            {
                e.KeyChar = char.ToUpper(number);
                return;
            }
            e.Handled = true;
        }

        /// <summary>
        /// Обработка нажатия кнопки в поле с регистрационным номером
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RegistrationMark_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == ' ')
            {
                e.Handled = true;
            }

            e.KeyChar = char.ToUpper(e.KeyChar);
        }

        /// <summary>
        /// Обработка нажатия кнопки в поле с пробегом
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Mileage_KeyPress(object sender, KeyPressEventArgs e)
        {
            char number = e.KeyChar;
            if (!Char.IsDigit(number) && number != 8 || e.KeyChar == ' ')
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Выбор марки машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Brand_SelectedIndexChanged(object sender, EventArgs e)
        {
            model.Items.Clear();
            sqlManager.AddComboBox(model, $@"[dbo].[Car_Model_View] (N'{brand.Text}')", 0);
            model.SelectedIndex = 0;
        }

        /// <summary>
        /// Закрытие формы добавления и изменения машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Back_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        /// <summary>
        /// Обработка нажатия на кнопку сохранения значений
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Save_Click(object sender, EventArgs e)
        {
            bool status = true;
            Car car = new Car()
            {
                VIN = vinNumber.Text,
                Registration_Mark = registrationMark.Text,
                Year_Release = yearRelease.Text,
                Mileage = mileage.Text.Equals("") ? 0 : Convert.ToInt32(mileage.Text),
                Brand_Model_Compliance_ID = idBrandModelCompliance,
                Client_ID = idClient
            };

            try
            {
                new Custom.ModelDataValidation().Validation(car);

                DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Car_Client] (N'{vinNumber.Text}',{idClient})");

                if (dataTable.Rows.Count > 0)
                {
                    if (dataTable.Rows[0][0].ToString() == "Yes")
                    {
                        if ((!status_update && dataTable.Rows.Count == 1) || (status_update && car.VIN != carStart.VIN))
                        {
                            MessageBox.Show("У вас уже есть автомобиль с таким VIN.");
                            status = false;
                        }
                    }

                    if (dataTable.Rows[0][0].ToString() == "No")
                    {
                        status = Verefication(dataTable, car);

                        if (status && status_update)
                        {
                            sqlManager.PerformingProcedure(
                                new string[] { carStart.VIN.ToString() },
                                "[dbo].[Customers_Machines_delete]",
                                new string[] { "VIN" }
                                );
                        }
                    }

                    if (status && dataTable.Rows[0][0].ToString() == "Yes")
                    {
                        UpdateCar(car);
                    }
                }
                else
                {
                    sqlManager.OpenConnection();

                    if (status_update)
                    {
                        UpdateCar(car);
                    }
                    else
                    {
                        sqlManager.PerformingProcedure
                        (
                            new string[] { car.VIN, car.Registration_Mark, car.Year_Release, car.Mileage.ToString(), car.Brand_Model_Compliance_ID.ToString(), car.Client_ID.ToString() },
                            "[dbo].[Customers_Machines_insert]",
                            new string[] { "VIN", "Registration_Mark", "Year_Release", "Mileage", "Brand_Model_Compliance_ID", "Client_ID" }
                        );
                    }
                }

                if (!status)
                {
                    this.Close();
                    return;
                }

                int index = cbFilter.SelectedIndex;
                cbFilter.SelectedIndex = index;
                sqlManager.GetList(gridViewListCar, "[dbo].[Customers_Machines]", $@"select * from [dbo].[Car_Client_View] ({idClient})");

                sqlManager.CloseConnection();
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private bool Verefication(DataTable dataTable, Car car)
        {
            DialogResult dialogResult = MessageBox.Show($@"В системе уже есть такой вин у владельца " + "\n" +
                            $@"{dataTable.Rows[0][1]} номер телефона {dataTable.Rows[0][2]}. Вы точно изменить данные авто?", "Вопрос", MessageBoxButtons.YesNo);
            if (dialogResult == DialogResult.Yes)
            {
                sqlManager.PerformingProcedure
                (
                    new string[] { car.VIN, car.Registration_Mark, car.Year_Release, car.Mileage.ToString(), car.Brand_Model_Compliance_ID.ToString(), car.Client_ID.ToString() },
                    "[dbo].[Customers_Machines_update]",
                    new string[] { "VIN", "Registration_Mark", "Year_Release", "Mileage", "Brand_Model_Compliance_ID", "Client_ID" }
                );
                return true;
            }
            return false;
        }

        private void UpdateCar(Car car)
        {
            if (car.VIN != carStart.VIN)
            {
                sqlManager.PerformingProcedure
                (
                    new string[] { carStart.VIN, car.VIN, car.Registration_Mark, car.Year_Release, car.Mileage.ToString(), car.Brand_Model_Compliance_ID.ToString(), car.Client_ID.ToString() },
                    "[dbo].[Customers_Machines_update_VIN]",
                    new string[] { "VIN", "VIN_New", "Registration_Mark", "Year_Release", "Mileage", "Brand_Model_Compliance_ID", "Client_ID" }
                );
            }
            else
            {
                sqlManager.PerformingProcedure
                (
                    new string[] { car.VIN, car.Registration_Mark, car.Year_Release, car.Mileage.ToString(), car.Brand_Model_Compliance_ID.ToString(), car.Client_ID.ToString() },
                    "[dbo].[Customers_Machines_update]",
                    new string[] { "VIN", "Registration_Mark", "Year_Release", "Mileage", "Brand_Model_Compliance_ID", "Client_ID" }
                );
            }
        }

        /// <summary>
        /// Выбор модели машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Model_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Car_Brand_Model] (N'{brand.Text}',N'{model.Text}')");
            if (dataTable.Rows.Count > 0)
            {
                idBrandModelCompliance = Convert.ToInt32(dataTable.Rows[0][0]);
            }
        }

        /// <summary>
        /// Обработка нажатия на поле для регистрационного номера
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RegistrationMark_MouseClick(object sender, MouseEventArgs e)
        {
            registrationMark.SelectionStart = registrationMark.Text.Length;
        }
    }
}
