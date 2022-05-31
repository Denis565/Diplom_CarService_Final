using Progect.Custom;
using Progect.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;
using TableDependency.SqlClient;
using TableDependency.SqlClient.Base.Enums;
using TableDependency.SqlClient.Base.EventArgs;

namespace Progect
{
    /// <summary>
    /// Класс главной формы для админестратора зала
    /// </summary>
    public partial class AdminMain : Form
    {
        private static readonly SQL.SQLManager sqlManager = new SQL.SQLManager();
        private readonly OrderGeneral orderGeneral = new OrderGeneral();
        private SqlTableDependency<Order_Log> orderLogTableDependency;
        private bool statusMessage = false;

        private TextBox quantitytextboxTabPageService;
        private TextBox quantitytextboxTabPageOrderLog;
        private TextBox quantitytextboxTabPageComponent;

        public readonly string stringConnectionDB = $@"{ConfigurationManager.ConnectionStrings["CarServiceConnectionString"].ConnectionString}";
        private readonly DataGridViewComboBoxColumn comboBoxStampCar = new DataGridViewComboBoxColumn();
        private readonly DataGridViewComboBoxColumn comboBoxModelCar = new DataGridViewComboBoxColumn();
        private readonly DataGridViewComboBoxColumn comboBoxListStatus = new DataGridViewComboBoxColumn();
        private readonly DataGridViewComboBoxColumn comboBoxListServiceGroup = new DataGridViewComboBoxColumn();
        private Dictionary<int, string> listListStatusId = new Dictionary<int, string>();

        private readonly List<int> listEditRowIndexBrandModelCompliance = new List<int>();
        private readonly List<int> listEditRowIndexService = new List<int>();
        private readonly List<int> listEditRowIndexComponent = new List<int>();
        private readonly List<int> listEditRowIndexOrderLog = new List<int>();

        private List<string> listSelectedModelCar = new List<string>();

        private List<CarStamp> listStampCar = new List<CarStamp>();
        private List<CarModel> listModelCar = new List<CarModel>();
        private readonly List<Service_Group> ListGroupService = new List<Service_Group>();

        private readonly DataTable listStatusOrderLog = new DataTable();
        private readonly DataTable listServiceDataTable = new DataTable();

        private int idrowSelectedDGVWorker;
        private int idEmployeeSelected;
        private int idWorkerSelected;
        public int idBranchLogin;
        public int idWorkerLoging;

        private int indexCurrentCellService = 0;
        private int indexCurrentCellOrderLog = 0;
        private int indexCurrentCellComponent = 0;

        private string listIdComponentOrderLog = "";

        public string loginPerson;
        private string selectedItemComboBoxFilter;
        private string initialNameModelCar;
        private string initialService;
        private string initialOrderLog;
        private string initialComponent;

        private Service_Group initialServiceGroup = new Service_Group { };

        public int CbFilterValue { set { cbFilter.SelectedIndex = value; } }
        public int CBSortingValue
        {
            set
            {
                sqlManager.OpenConnection();

                Init();
                cbSorting.SelectedIndex = value;
            }
        }
        public string TextFilterValue { set { textFilter.Text = value; } }
        public int IDWorkers { set { idWorkerLoging = value; } }
        public int IDBranch { set { idBranchLogin = value; } }
        public string LoginPerson { set { loginPerson = value; } }

        /// <summary>
        /// Инициализация компонентов
        /// </summary>
        public AdminMain()
        {
            InitializeComponent();
            StartOrderLogTableDependency();
        }

        /// <summary>
        /// Загрузка главной формы админестратора
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private async void AdminMain_Load(object sender, EventArgs e)
        {
            await Task.Run(() =>
            {
                InitListOrderLog();
                InitDataGridTabPage();
                InitListModelStampCar();
                InitListServiceAndServiceGroup();
                InitComponent();
                dgvWarehouse.ReadOnly = true;

                var dataTableOrderLog = listOrderLog.Rows.OfType<DataGridViewRow>()
                .Where(x => (x.Cells[1].Value != null && x.Cells[4].Value.ToString() == "Открыт"))
                .Select(dr => dr.Cells[1].Value.ToString())
                .Distinct().ToList();

                if (dataTableOrderLog.Count > 0)
                {
                    string res = string.Join(", ", dataTableOrderLog.Select(x => x));

                    if (dataTableOrderLog.Count > 1)
                    {
                        MessageBox.Show($@"{res} требуют отклика");
                    }
                    else
                    {
                        MessageBox.Show($@"{res} требует отклика ");
                    }
                }

                sqlManager.CloseConnection();
            });
        }

        /// <summary>
        /// Фильтрация элементов журнала заказов по статусу
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void FilterStatusOrderLog_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            string nameFilterStatusOrdreLog = filterStatusOrderLog.Text;

            if (nameFilterStatusOrdreLog == "Все")
            {
                sqlManager.GetList(listOrderLog, "[dbo].[Order_Log]", "select * from [dbo].[Order_Log_View]");
                return;
            }

            if (nameFilterStatusOrdreLog == "Все кроме закрытых")
            {
                sqlManager.GetList(listOrderLog, "[dbo].[Order_Log]", $@"select * from [dbo].[Order_Log_View_Filter_Alter]");
            }
            else
            {
                sqlManager.GetList(listOrderLog, "[dbo].[Order_Log]", $@"select * from [dbo].[Order_Log_View_FilterFunction] (N'{nameFilterStatusOrdreLog}')");
            }
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Настройка и вывод списков склада и клиента
        /// </summary>
        private void InitDataGridTabPage()
        {
            filterStatusOrderLog.Items.AddRange(new string[] { "Все", "Все кроме закрытых", "Открыт" });
            filterStatusOrderLog.SelectedIndex = 1;
            listOrderLog.DefaultCellStyle.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            listOrderLog.AllowUserToAddRows = false;
            listOrderLog.Columns[1].ReadOnly = true;
            listOrderLog.Columns[1].AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            listOrderLog.Columns[0].Visible = false;
            listOrderLog.Columns[5].Visible = false;
            listOrderLog.Columns[6].Visible = false;
            listOrderLog.Columns[7].Visible = false;
            listOrderLog.Columns[8].Visible = false;
            listOrderLog.Columns[9].Visible = false;
            listOrderLog.Columns[10].Visible = false;


            sqlManager.GetList(dgvWarehouse, "[dbo].[Warehouse]", $@"select * from [dbo].[Warehouse_View] ({idBranchLogin})");
            dgvWarehouse.Columns[0].Visible = false;
            dgvWarehouse.Columns[4].Visible = false;
            dgvWarehouse.Columns[5].Visible = false;
            dgvWarehouse.AllowUserToAddRows = false;

            sqlManager.GetList(clientList, "[dbo].[Client]", "select * from [dbo].[Client_View]");
            clientList.Columns[0].Visible = false;
            clientList.DefaultCellStyle.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            clientList.AllowUserToAddRows = false;
            clientList.ReadOnly = true;
        }

        /// <summary>
        /// Первичный вывод данных
        /// </summary>
        private void Init()
        {
            listEmployees.DefaultCellStyle.Font = new Font("Tahoma", 9);
            listEmployees.AllowUserToAddRows = false;

            sqlManager.GetList(listEmployees, "[dbo].[Worker]", $@"select * from [dbo].[Worker_View] (N'{loginPerson}',{idBranchLogin})");
            listEmployees.Columns[7].Visible = false;
            listEmployees.Columns["Номер сотрудника"].Visible = false;
            listEmployees.Columns["Номер работника"].Visible = false;
            listEmployees.ReadOnly = true;
            listEmployees.Columns[8].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;

            cbSorting.Items.AddRange(new string[] { "По фамилии А-Я", "По фамилии Я-А", "По должности А-Я", "По должности Я-А" });
            cbFilter.Items.AddRange(new string[] { "Фамилия начинаеться на", "Должность начинаеться на" });

            cbSorting.SelectedIndex = 0;
            cbFilter.SelectedIndex = 0;

            DateTime dateMin = DateTime.ParseExact("01.01.1900", "dd.MM.yyyy", System.Globalization.CultureInfo.InvariantCulture);
            DateTime dateNow = DateTime.Now;
            startDateAnaliz.Value = dateNow;
            startDateAnaliz.MaxDate = dateNow.Date.AddDays(-1);
            startDateAnaliz.MinDate = dateMin;

            endDateAnaliz.Value = dateNow;
            endDateAnaliz.MaxDate = dateNow;
            endDateAnaliz.MinDate = dateMin;
        }

        /// <summary>
        /// Настройка и вывод списка компонентов
        /// </summary>
        private void InitComponent()
        {
            sqlManager.GetList(listComponent, "[dbo].[Component]", "select * from [dbo].[Component_View]");
            listComponent.Columns[0].Visible = false;
            listComponent.AllowUserToDeleteRows = false;
            listComponent.Columns[2].AutoSizeMode = DataGridViewAutoSizeColumnMode.ColumnHeader;
            listComponent.Columns[3].AutoSizeMode = DataGridViewAutoSizeColumnMode.ColumnHeader;
        }

        /// <summary>
        /// Настройка и вывод списка группы услуг и услуг
        /// </summary>
        private void InitListServiceAndServiceGroup()
        {
            sqlManager.GetList(listGroupService, "[dbo].[Service_Group]", "select * from [dbo].[Service_Group_View]");

            listGroupService.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);

            comboBoxListServiceGroup.HeaderText = "Группа услуг";
            comboBoxListServiceGroup.Name = "serviceGroup";
            comboBoxListServiceGroup.DataPropertyName = "Группа услуг";
            comboBoxListServiceGroup.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);

            AddRangeComboBoxServiceGroup();

            listServiceDataTable.Columns.Add(new DataColumn("Номер услуги", typeof(string)));
            listServiceDataTable.Columns.Add(new DataColumn("Наименование услуги", typeof(string)));
            listServiceDataTable.Columns.Add(new DataColumn("Нормо-час", typeof(string)));
            listServiceDataTable.Columns.Add(new DataColumn("Стоимость", typeof(string)));
            listServiceDataTable.Columns.Add(new DataColumn("Номер группы услуги", typeof(string)));
            listService.DataSource = listServiceDataTable;
            listService.Columns.Add(comboBoxListServiceGroup);

            sqlManager.GetList(listService, "[dbo].[List_Servce]", "select * from [dbo].[List_Service_View_Guide]");
            listService.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);

            listGroupService.AllowUserToDeleteRows = false;
            listService.AllowUserToDeleteRows = false;

            listGroupService.Columns[0].Visible = false;
            listService.Columns[0].Visible = false;
            listService.Columns[4].Visible = false;

            listService.Columns[2].AutoSizeMode = DataGridViewAutoSizeColumnMode.ColumnHeader;
            listService.Columns[3].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
        }

        /// <summary>
        /// Настройка и вывод списка журнала заказов
        /// </summary>
        private void InitListOrderLog()
        {
            comboBoxListStatus.HeaderText = "Статус";
            comboBoxListStatus.Name = "statusOrderLog";
            comboBoxListStatus.DataPropertyName = "Статус";
            comboBoxListStatus.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);
            listOrderLog.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);

            listStatusOrderLog.Columns.Add(new DataColumn("Номер в журнале заказов", typeof(string)));
            listStatusOrderLog.Columns.Add(new DataColumn("Наименование материала", typeof(string)));
            listStatusOrderLog.Columns.Add(new DataColumn("Количество", typeof(string)));
            listStatusOrderLog.Columns.Add(new DataColumn("Стоимость за еденицу", typeof(string)));
            listOrderLog.DataSource = listStatusOrderLog;

            listOrderLog.Columns.Add(comboBoxListStatus);

            DataTable dataTablListStatus = sqlManager.ReturnTable("select * from [dbo].[List_Status]");

            comboBoxListStatus.Items.AddRange(
                 dataTablListStatus.Rows.Cast<DataRow>()
                    .Where(col => col[1].ToString() != "Не доступен")
                    .OrderBy(x => x[0].ToString())
                    .Select(col => col[1].ToString()).ToArray()
                    );

            listListStatusId =
                dataTablListStatus.Rows.OfType<DataRow>()
                .Where(col => col[1].ToString() != "Не доступен")
                .Select(o => new
                {
                    Key = o.Field<int>("ID_List_Status"),
                    Value = o.Field<string>("Name_Status")
                }).OrderBy(x => x.Key).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

        }

        /// <summary>
        /// Настройка и вывод списка соответствия марки и модели авто
        /// </summary>
        private void InitListModelStampCar()
        {
            comboBoxStampCar.HeaderText = "Название марки";
            comboBoxStampCar.Name = "nameStamp";
            comboBoxStampCar.DataPropertyName = "Название марки";
            comboBoxStampCar.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);
            listBrandModelCompliance.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);
            listBrandModelCompliance.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            listBrandModelCompliance.Columns.Add(comboBoxStampCar);

            comboBoxModelCar.HeaderText = "Название модели";
            comboBoxModelCar.Name = "nameModel";
            comboBoxModelCar.DataPropertyName = "Название модели";
            comboBoxModelCar.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);
            listBrandModelCompliance.DefaultCellStyle.Font = new Font("Arial", 15, GraphicsUnit.Pixel);
            listBrandModelCompliance.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            listBrandModelCompliance.Columns.Add(comboBoxModelCar);

            orderGeneral.MatchingMachines(comboBoxStampCar, comboBoxModelCar, listBrandModelCompliance, AddListStampModel);

            listBrandModelCompliance.Columns[2].Visible = false;
            listBrandModelCompliance.Columns[3].Visible = false;
            listBrandModelCompliance.Columns[4].Visible = false;
        }

        /// <summary>
        ///  Обработка нажатия на кнопку обновления списка компонентов на складе
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RefreshListWarehouse_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            sqlManager.GetList(dgvWarehouse, "[dbo].[Warehouse]", $@"select * from [dbo].[Warehouse_View] ({idBranchLogin})");
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия на кнопку обновления списка журнала заказов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RefreshListOrdreLog_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            FilterStatusOrderLog_SelectedIndexChanged(this, new EventArgs());
            listEditRowIndexOrderLog.Clear();
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Начало редактирования списка компонентов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListComponent_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            indexCurrentCellComponent = listComponent.CurrentCell.ColumnIndex;
            if (indexCurrentCellComponent != 3)
            {
                quantitytextboxTabPageComponent = (TextBox)e.Control;
                quantitytextboxTabPageComponent.KeyPress -= new KeyPressEventHandler(QuantityInt_KeyPress);

                if (indexCurrentCellComponent == 1)
                {
                    initialComponent = listComponent.Rows[listComponent.CurrentRow.Index].Cells[indexCurrentCellComponent].Value.ToString();
                }

                if (indexCurrentCellComponent == 2)
                {
                    quantitytextboxTabPageComponent.KeyPress += new KeyPressEventHandler(QuantityInt_KeyPress);
                }
            }
        }

        /// <summary>
        /// Обработка нажатия кнопок при вводе количества компонентов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void QuantityInt_KeyPress(object sender, KeyPressEventArgs e)
        {
            char number = e.KeyChar;
            if (!Char.IsDigit(number) && number != 8)
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Окончание редактирования списка компонентов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListComponent_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (indexCurrentCellComponent == 1)
            {
                int count = listComponent.Rows.OfType<DataGridViewRow>()
                    .Where(x => x.Cells[1].Value != null)
                    .Where(x => x.Cells[1].Value.ToString().ToLower() == listComponent.Rows[e.RowIndex].Cells[1].Value.ToString().ToLower()).ToList().Count;

                if (count > 1)
                {
                    listComponent.Rows[e.RowIndex].Cells[indexCurrentCellComponent].Value = initialComponent;
                    if (initialComponent.Equals(""))
                    {
                        listComponent.Rows.RemoveAt(listComponent.Rows.Count - 2);
                    }
                    return;
                }
            }

            string CountMin = listComponent.Rows[e.RowIndex].Cells[indexCurrentCellComponent].Value.ToString();

            if (indexCurrentCellComponent == 2 && !CountMin.Equals(""))
            {
                if (Convert.ToInt32(listComponent.Rows[e.RowIndex].Cells[indexCurrentCellComponent].Value.ToString()) < 10)
                {
                    listComponent.Rows[e.RowIndex].Cells[indexCurrentCellComponent].Value = "10";
                }
            }

            if (!listEditRowIndexComponent.Contains(e.RowIndex) && !listComponent.Rows[e.RowIndex].Cells[0].Value.ToString().Equals(""))
            {
                listEditRowIndexComponent.Add(e.RowIndex);
            }
        }

        /// <summary>
        /// Сохранение изменений в реестре компонентов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveUpadateListComponent_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            try
            {
                listComponent.EndEdit();

                List<DataGridViewRow> dataGridViewUpdates = listComponent.Rows.OfType<DataGridViewRow>()
                    .Where(xy => xy.Cells[0].Value != null && xy.Cells[1].Value != null && xy.Cells[2].Value != null && xy.Cells[3].Value != null)
                    .Where(x =>
                        (!x.Cells[0].Value.ToString().Equals("") &&
                        ((x.Cells[3].Value.ToString().Equals("False") && (x.Cells[1].Value.ToString().Equals("") || !x.Cells[2].Value.ToString().Equals(""))) ||
                        (x.Cells[3].Value.ToString().Equals("True") && (x.Cells[1].Value.ToString().Equals("") || x.Cells[2].Value.ToString().Equals("")))
                        ))).ToList();

                List<DataGridViewRow> dataGridViewInserSelect = listComponent.Rows.OfType<DataGridViewRow>()
                     .Where(xy => xy.Cells[0].Value != null && xy.Cells[1].Value != null && xy.Cells[2].Value != null && xy.Cells[3].Value != null)
                     .Where(x => x.Cells[0].Value.ToString().Equals(""))
                     .Where(x => !x.Cells[1].Value.ToString().Equals("") || !x.Cells[2].Value.ToString().Equals("") || !x.Cells[3].Value.ToString().Equals(""))
                     .ToList();

                List<DataGridViewRow> dgvNoYesTypeСonsumable = dataGridViewInserSelect.OfType<DataGridViewRow>()
                    .Where(x =>
                    !x.Cells[1].Value.ToString().Equals("") &&
                    ((x.Cells[2].Value.ToString().Equals("") && (x.Cells[3].Value.ToString().Equals("False") || x.Cells[3].Value.ToString().Equals(""))) ||
                    ((!x.Cells[2].Value.ToString().Equals("") && x.Cells[3].Value.ToString().Equals("True")))))
                    .OrderBy(x => x.Index).Select(x => x).ToList();

                if (dataGridViewUpdates.Count == 0 && dataGridViewInserSelect.Count == dgvNoYesTypeСonsumable.Count)
                {

                    UpdateTableComponent();
                    InsertTableComponent(ref dgvNoYesTypeСonsumable);
                    listEditRowIndexComponent.Clear();
                }
                else
                {
                    MessageBox.Show("Для сохранения данных необходимо заполнение поля наименования компонента, а также если выбран тип расходный материал, то минимальное количество должно быть заполнено. Если тип не расходный материал, то минимальное количество не задаться.");
                }
            }
            catch
            {
                MessageBox.Show("Нажмите на пустую ячейку после чего повторите нажатие на кнопку сохранения.");
            }
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Добавление компонентов
        /// </summary>
        /// <param name="insertDGVR">Список для добавления компонетов</param>
        private void InsertTableComponent(ref List<DataGridViewRow> insertDGVR)
        {
            object reader;
            foreach (DataGridViewRow dataRowInsert in insertDGVR)
            {

                if (dataRowInsert.Cells[3].Value.ToString() == "False" || dataRowInsert.Cells[3].Value.ToString() == "")
                {
                    reader = sqlManager.PerformingProcedureReader(
                        new string[] { dataRowInsert.Cells[1].Value.ToString(), "0" },
                        "[dbo].[ComponentNoTypeConsumabl_insert]",
                        new string[] { "Name_Component", "Type_Сonsumable" }
                    );
                }
                else
                {
                    reader = sqlManager.PerformingProcedureReader(
                       new string[] { dataRowInsert.Cells[1].Value.ToString(), dataRowInsert.Cells[2].Value.ToString(), "1" },
                       "[dbo].[Component_insert]",
                       new string[] { "Name_Component", "Minimum_Quantity", "Type_Сonsumable" }
                   );
                }
                dataRowInsert.Cells[0].Value = reader.ToString();
            }
        }

        /// <summary>
        /// Обновление компонентов
        /// </summary>
        private void UpdateTableComponent()
        {
            foreach (int index in listEditRowIndexComponent)
            {
                DataGridViewRow dataRowUpdate = listComponent.Rows[index];

                if (dataRowUpdate.Cells[3].Value.ToString() == "False")
                {
                    sqlManager.PerformingProcedure(
                        new string[] { dataRowUpdate.Cells[0].Value.ToString(), dataRowUpdate.Cells[1].Value.ToString(), "0" },
                        "[dbo].[ComponentNoTypeConsumable_update]",
                        new string[] { "ID_Component", "Name_Component", "Type_Сonsumable" }
                    );
                }
                else
                {
                    sqlManager.PerformingProcedure(
                        new string[] { dataRowUpdate.Cells[0].Value.ToString(), dataRowUpdate.Cells[1].Value.ToString(), dataRowUpdate.Cells[2].Value.ToString(), "1" },
                        "[dbo].[Component_update]",
                        new string[] { "ID_Component", "Name_Component", "Minimum_Quantity", "Type_Сonsumable" }
                    );
                }
            }
        }

        /// <summary>
        /// Обработка нажатия для обнавления списка компонентов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RefreshListComponent_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            sqlManager.GetList(listComponent, "[dbo].[Component]", "select * from [dbo].[Component_View]");
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия на выпадающий список групп услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListService_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                DataGridViewCell cell = listService.Rows[e.RowIndex].Cells[e.ColumnIndex];
                if (cell is DataGridViewComboBoxCell)
                {
                    listService.BeginEdit(false);
                    (listService.EditingControl as DataGridViewComboBoxEditingControl).DroppedDown = true;
                }
            }
            catch { }
        }

        /// <summary>
        /// Обработка нажатия на выпадающий список с моделями и марками машин
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListBrandModelCompliance_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                DataGridViewCell cell = listBrandModelCompliance.Rows[e.RowIndex].Cells[e.ColumnIndex];
                if (cell is DataGridViewComboBoxCell)
                {
                    listBrandModelCompliance.BeginEdit(false);
                    (listBrandModelCompliance.EditingControl as DataGridViewComboBoxEditingControl).DroppedDown = true;
                }
            }
            catch { }
        }

        /// <summary>
        /// Обработка нажатия для обнавления списка услуг и групп услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RefreshListGroupServiceAndService_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            ListGroupService.Clear();
            comboBoxListServiceGroup.DataSource = null;

            sqlManager.GetList(listGroupService, "[dbo].[Service_Group]", "select * from [dbo].[Service_Group_View]");
            AddRangeComboBoxServiceGroup();

            ((DataGridViewComboBoxColumn)listService.Columns[comboBoxListServiceGroup.Name]).DataSource = comboBoxListServiceGroup.Items;

            sqlManager.GetList(listService, "[dbo].[List_Servce]", "select * from [dbo].[List_Service_View_Guide]");

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Чтение данных группы услуг
        /// </summary>
        private void AddRangeComboBoxServiceGroup()
        {
            var list = listGroupService.Rows.OfType<DataGridViewRow>()
                .Where(x => x.Cells[1].Value != null);

            if (list.Any())
            {
                ListGroupService.AddRange(
                list.Select(row => new Service_Group
                {
                    ID = Convert.ToInt32(row.Cells[0].Value.ToString()),
                    NameGroupService = row.Cells[1].Value.ToString()
                })
               );
                comboBoxListServiceGroup.Items.Clear();
                comboBoxListServiceGroup.Items.AddRange(ListGroupService.Select(x => x.NameGroupService).ToArray());
            }
        }

        /// <summary>
        /// Начало редактирования списка групп услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListGroupService_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            if (listService.Rows.Count > 0)
            {
                if (listService.CurrentCell.ColumnIndex == 5)
                {
                    listService.CurrentCell = listService.Rows[listService.CurrentRow.Index].Cells[1];
                }
            }
            string idServiceGroup = listGroupService.Rows[listGroupService.CurrentRow.Index].Cells[0].Value.ToString();
            if (idServiceGroup == "")
            {
                idServiceGroup = "0";
            }

            if (listService.CurrentCell.ColumnIndex == 5)
            {
                listService.BeginEdit(true);
            }

            initialServiceGroup = new Service_Group
            {
                ID = Convert.ToInt32(idServiceGroup),
                NameGroupService = listGroupService.Rows[listGroupService.CurrentRow.Index].Cells[1].Value.ToString()
            };
        }

        /// <summary>
        /// Окончание редактирования списка групп услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListGroupService_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            sqlManager.OpenConnection();
            string newNameGroupService = listGroupService.Rows[e.RowIndex].Cells[1].Value.ToString().Trim();
            string result = null;

            if (newNameGroupService.Length <= 0 || ListGroupService.Any(c => c.NameGroupService.ToLower() == newNameGroupService.ToLower()) == true)
            {
                listGroupService.Rows[e.RowIndex].Cells[1].Value = initialServiceGroup.NameGroupService;
                if (initialServiceGroup.NameGroupService.Equals(""))
                {
                    listGroupService.Rows.RemoveAt(listGroupService.Rows.Count - 2);
                }
                return;
            }

            if (!listGroupService.Rows[e.RowIndex].Cells[0].Value.ToString().Equals(""))
            {
                sqlManager.PerformingProcedure(
                    new string[] { listGroupService.Rows[e.RowIndex].Cells[0].Value.ToString(), newNameGroupService },
                    "[dbo].[Service_Group_update]",
                    new string[] { "ID_Service_Group", "Name_Group_Service" }
                    );

                Service_Group service_Group = ListGroupService.Single(x => x.ID == initialServiceGroup.ID);

                comboBoxListServiceGroup.Items[comboBoxListServiceGroup.Items.IndexOf(service_Group.NameGroupService)] = newNameGroupService;
                service_Group.NameGroupService = newNameGroupService;
                ((DataGridViewComboBoxColumn)listService.Columns[comboBoxListServiceGroup.Name]).DataSource = comboBoxListServiceGroup.Items;
                sqlManager.GetList(listService, "[dbo].[List_Servce]", "select * from [dbo].[List_Service_View_Guide]");
            }
            else
            {
                object reader = sqlManager.PerformingProcedureReader(
                    new string[] { newNameGroupService },
                    "[dbo].[Service_Group_insert]",
                    new string[] { "Name_Group_Service" }
                    );
                listGroupService.Rows[e.RowIndex].Cells[0].Value = reader.ToString();
                ListGroupService.Add(new Service_Group { ID = Convert.ToInt32(result), NameGroupService = newNameGroupService });
                comboBoxListServiceGroup.Items.Add(newNameGroupService);
                ((DataGridViewComboBoxColumn)listService.Columns[comboBoxListServiceGroup.Name]).DataSource = comboBoxListServiceGroup.Items;
            }

            listGroupService.Rows[e.RowIndex].Cells[1].Value = newNameGroupService;
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Начало редактирования списка услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListService_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            indexCurrentCellService = listService.CurrentCell.ColumnIndex;
            if (indexCurrentCellService != 5)
            {
                quantitytextboxTabPageService = (TextBox)e.Control;
                quantitytextboxTabPageService.KeyPress -= new KeyPressEventHandler(QuantityName_KeyPress);
                quantitytextboxTabPageService.KeyPress -= new KeyPressEventHandler(QuantityDecimal_KeyPress);

                if (indexCurrentCellService == 1)
                {
                    quantitytextboxTabPageService.KeyPress += new KeyPressEventHandler(QuantityName_KeyPress);
                    initialService = listService.Rows[listService.CurrentRow.Index].Cells[indexCurrentCellService].Value.ToString();
                }

                if (indexCurrentCellService == 2 || indexCurrentCellService == 3)
                {
                    quantitytextboxTabPageService.KeyPress += new KeyPressEventHandler(QuantityDecimal_KeyPress);
                }
            }
        }

        /// <summary>
        /// Обработка нажатия на кнопки при введении наименования услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void QuantityName_KeyPress(object sender, KeyPressEventArgs e)
        {
            string Symbol = e.KeyChar.ToString();

            if (!Regex.Match(Symbol, @"[а-яА-Я]|[a-zA-Z]").Success && e.KeyChar != 8 && e.KeyChar != 32)
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Обработка нажатия на кнопки при введении стоимости услуги
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void QuantityDecimal_KeyPress(object sender, KeyPressEventArgs e)
        {
            char keyChar = e.KeyChar;
            string text = quantitytextboxTabPageService.Text;
            if ((!Char.IsDigit(keyChar) && keyChar != 8 && keyChar != 44) || (keyChar == 44 && text.Length < 1) || (keyChar == 44 && text.Contains(",")))
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Окончание редактирования списка услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListService_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (indexCurrentCellService == 1)
            {
                int count = listService.Rows.OfType<DataGridViewRow>()
                    .Where(x => x.Cells[1].Value != null)
                    .Where(x => x.Cells[1].Value.ToString().ToLower() == listService.Rows[e.RowIndex].Cells[1].Value.ToString().ToLower()).ToList().Count;

                if (count > 1)
                {
                    listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value = initialService;

                    if (initialService.Equals(""))
                    {
                        listService.Rows.RemoveAt(listService.Rows.Count - 2);
                    }
                    return;
                }
            }

            if (indexCurrentCellService == 3 && !String.IsNullOrEmpty(listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value.ToString()))
            {
                if (Convert.ToDouble(listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value.ToString()) < 100.00)
                {
                    listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value = "100,00";
                }

                if (!listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value.ToString().Contains(","))
                {
                    listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value = listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value.ToString() + ",00";
                }
            }

            if (indexCurrentCellService == 2 && !string.IsNullOrEmpty(listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value.ToString()))
            {
                if (Convert.ToDouble(listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value.ToString()) < 0.30)
                {
                    listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value = "0,20";
                }
            }

            if (indexCurrentCellService == 5)
            {
                string nameServiceGroupSelect = listService.Rows[e.RowIndex].Cells[indexCurrentCellService].Value.ToString();
                int idService = ListGroupService.Where(x => x.NameGroupService == nameServiceGroupSelect).Select(x => x.ID).FirstOrDefault();
                listService.Rows[e.RowIndex].Cells[4].Value = idService.ToString();
            }

            if (!listEditRowIndexService.Contains(e.RowIndex) && !string.IsNullOrEmpty(listService.Rows[e.RowIndex].Cells[0].Value.ToString()))
            {
                listEditRowIndexService.Add(e.RowIndex);
            }

        }

        /// <summary>
        /// Сохранение изменений списка услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveListService_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            try
            {
                listService.EndEdit();

                var dataGridViewInserSelect = listService.Rows.OfType<DataGridViewRow>()
                    .Where(x => (x.Cells[0].Value != null && x.Cells[1].Value != null && x.Cells[2].Value != null
                            && x.Cells[3].Value != null && x.Cells[4].Value != null && x.Cells[5].Value != null))
                    .Where(x => x.Cells[0].Value.ToString().Equals(""))
                    .Where(x => !x.Cells[1].Value.ToString().Equals("") || !x.Cells[2].Value.ToString().Equals("") || !x.Cells[3].Value.ToString().Equals("") ||
                    !x.Cells[4].Value.ToString().Equals("") || !x.Cells[5].Value.ToString().Equals("")).ToList();

                var dataGridViewRowsInsert = dataGridViewInserSelect.OfType<DataGridViewRow>()
                    .Where(x => (!x.Cells[1].Value.ToString().Equals("") && !x.Cells[2].Value.ToString().Equals("")
                    && !x.Cells[3].Value.ToString().Equals("") && !x.Cells[4].Value.ToString().Equals("") && !x.Cells[5].Value.ToString().Equals(""))).ToList();

                int countDataGridViewInserSelect = dataGridViewInserSelect.Count;
                int countDataGridViewRowsInsert = dataGridViewRowsInsert.Count;
                if (countDataGridViewInserSelect != countDataGridViewRowsInsert)
                {
                    MessageBox.Show("Для добавления необходимо заполнить все ячейки.");
                    return;
                }

                foreach (DataGridViewRow row in dataGridViewRowsInsert)
                {
                    object reader = sqlManager.PerformingProcedureReader(
                             new string[] {
                            row.Cells[1].Value.ToString() ,
                            row.Cells[2].Value.ToString().Replace(",",".") ,
                            row.Cells[3].Value.ToString().Replace(",","."),
                            row.Cells[4].Value.ToString() },
                             "[dbo].[List_Service_insert]",
                             new string[] { "Name_Services", "Norm_Hour", "Price", "Service_Group_ID" });
                    row.Cells[0].Value = reader.ToString();
                }

                foreach (int index in listEditRowIndexService)
                {

                    DataGridViewRow row = listService.Rows[index];

                    sqlManager.PerformingProcedure(
                        new string[] {
                            row.Cells[0].Value.ToString(),
                            row.Cells[1].Value.ToString() ,
                            row.Cells[2].Value.ToString().Replace(",",".") ,
                            row.Cells[3].Value.ToString().Replace(",","."),
                            row.Cells[4].Value.ToString() },
                        "[dbo].[List_Service_update]",
                        new string[] { "ID_List_Services", "Name_Services", "Norm_Hour", "Price", "Service_Group_ID" });
                }

                listEditRowIndexService.Clear();
            }
            catch
            {
                MessageBox.Show("Нажмите на пустую ячейку после чего повторите нажатие на кнопку сохранения.");
            }

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Сохранение
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveChangesStampModelCar_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            listBrandModelCompliance.EndEdit();

            int count = listEditRowIndexBrandModelCompliance
                .Where(x => listBrandModelCompliance.Rows[x].Cells[0].Value != null)
                .Where(x => listBrandModelCompliance.Rows[x].Cells[3].Value.ToString().Equals("") ||
                            listBrandModelCompliance.Rows[x].Cells[4].Value.ToString().Equals("")).Count();

            if (count > 0)
            {
                MessageBox.Show("Дозаполните марку и модель если такие не имеються.");
                sqlManager.CloseConnection();
                return;
            }

            foreach (int index in listEditRowIndexBrandModelCompliance)
            {
                DataGridViewRow ItemlistBrandModelCompliance = listBrandModelCompliance.Rows[index];

                if (listBrandModelCompliance.Rows[index].Cells[2].Value.ToString().Equals(""))
                {
                    object reader = sqlManager.PerformingProcedureReader(
                        new string[] {
                        ItemlistBrandModelCompliance.Cells[3].Value.ToString(),
                        ItemlistBrandModelCompliance.Cells[4].Value.ToString()
                        },
                        "[dbo].[BrandModelCompliance_insert]",
                        new string[] { "Car_Brand_ID", "Car_Model_ID" }
                    );
                    listBrandModelCompliance.Rows[index].Cells[2].Value = reader.ToString();
                }
                else
                {
                    sqlManager.PerformingProcedure(
                        new string[] {
                        ItemlistBrandModelCompliance.Cells[2].Value.ToString(),
                        ItemlistBrandModelCompliance.Cells[3].Value.ToString(),
                        ItemlistBrandModelCompliance.Cells[4].Value.ToString()
                        },
                        "[dbo].[BrandModelCompliance_update]",
                        new string[] { "ID_Brand_Model_Compliance", "Car_Brand_ID", "Car_Model_ID" }
                    );
                }


            }

            listEditRowIndexBrandModelCompliance.Clear();
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Начало редактирования соответствия модели и марки машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListBrandModelCompliance_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            if (listStampCar != null || listModelCar != null)
            {
                initialNameModelCar = listBrandModelCompliance.Rows[listBrandModelCompliance.CurrentRow.Index].Cells[1].Value.ToString();
            }
        }

        /// <summary>
        /// Окончание редактирования соответствия модели и марки машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListBrandModelCompliance_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (e.ColumnIndex == 1)
                {
                    string nameSelectedModel = listBrandModelCompliance.Rows[e.RowIndex].Cells[1].Value.ToString().Trim();
                    List<int> indexOfArray = listSelectedModelCar
                        .Select((s, i) => new { i, s })
                        .Where(t => t.s == nameSelectedModel)
                        .Select(t => t.i).ToList();

                    foreach (int indexArray in indexOfArray)
                    {
                        if (listBrandModelCompliance.Rows[e.RowIndex].Cells[0].Value.ToString() == listBrandModelCompliance.Rows[indexArray].Cells[0].Value.ToString())
                        {
                            listBrandModelCompliance.Rows[e.RowIndex].Cells[1].Value = initialNameModelCar;
                            return;
                        }
                    }

                    listSelectedModelCar.Remove(initialNameModelCar);
                    if (!listSelectedModelCar.Contains(nameSelectedModel))
                    {
                        listSelectedModelCar.Add(nameSelectedModel);
                    }

                    CarModel carModel = listModelCar.Where(u => u.Name_Model_Car == nameSelectedModel).FirstOrDefault();

                    if (carModel != null)
                    {
                        listBrandModelCompliance.Rows[e.RowIndex].Cells[4].Value = carModel.ID;
                    }
                }
                else
                {
                    string nameSelectedStemp = listBrandModelCompliance.Rows[e.RowIndex].Cells[0].Value.ToString().Trim();
                    CarStamp carStemp = listStampCar.Where(u => u.Name_Stemp_Car == nameSelectedStemp).FirstOrDefault();
                    if (carStemp != null)
                    {
                        listBrandModelCompliance.Rows[e.RowIndex].Cells[3].Value = carStemp.ID;
                    }
                }

                if (!listEditRowIndexBrandModelCompliance.Contains(e.RowIndex))
                {
                    listEditRowIndexBrandModelCompliance.Add(e.RowIndex);
                }
            }
            catch { }
        }

        /// <summary>
        /// Обработка закрытия главной формы админестратора зала
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AdminMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            try
            {
                StopOrderLogTableDependency();
            }
            catch (Exception ex) { MessageBox.Show(ex.ToString()); }
        }

        /// <summary>
        /// Начало маниторинга таблицы журнала заказов в базе данных
        /// </summary>
        private async void StartOrderLogTableDependency()
        {
            await Task.Run(() =>
            {
                try
                {
                    orderLogTableDependency = new SqlTableDependency<Order_Log>(stringConnectionDB);
                    orderLogTableDependency.OnChanged += OrderLogTableDependencyChanged;
                    orderLogTableDependency.OnError += OrderLogTableDependencyOnError;
                    orderLogTableDependency.Start();
                }
                catch (Exception ex)
                {
                    ThreadSafe(() => MessageBox.Show(ex.ToString()));
                }
            });
        }

        /// <summary>
        /// Остановка мониторнига таблицы журнала заказов в базе данных
        /// </summary>
        private void StopOrderLogTableDependency()
        {
            try
            {
                if (orderLogTableDependency != null)
                {
                    orderLogTableDependency.Stop();
                }
            }
            catch (Exception ex) { ThreadSafe(() => MessageBox.Show(ex.ToString())); }
        }

        /// <summary>
        /// Вывод ошибок в мониторинге таблицы журнал заказов в базе данных
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void OrderLogTableDependencyOnError(object sender, ErrorEventArgs e)
        {
            ThreadSafe(() => MessageBox.Show(e.Error.Message));
        }

        /// <summary>
        /// Обработка изменений таблицы журнал заказов в базе данных
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void OrderLogTableDependencyChanged(object sender, RecordChangedEventArgs<Order_Log> e)
        {

            try
            {
                Order_Log changedEntity = e.Entity;
                ChangeType type = e.ChangeType;

                if (type.Equals(ChangeType.Insert) && changedEntity.List_Status_ID == 1 && changedEntity.Component_Order_ID > 0)
                {
                    if (changedEntity.Component_Order_ID <= 0)
                    {
                        return;
                    }

                    listIdComponentOrderLog += changedEntity.Component_Order_ID.ToString() + ";";

                    if (!statusMessage)
                    {
                        statusMessage = true;

                        ThreadSafe(() =>
                        {
                            timer.Start();
                            timer.Interval = 10000;
                            timer.Enabled = true;
                            timer.Tick += Timer_Tick;
                        });
                    }
                }
            }
            catch (Exception ex) { MessageBox.Show(ex.ToString()); }

        }

        /// <summary>
        /// Засекание времени канала получения результатов изменения таблицы журнала заказов в базе данных
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Timer_Tick(object sender, EventArgs e)
        {
            timer.Stop();
            statusMessage = false;
            DataTable dataTableTypeYes = sqlManager.ReturnTable($@"select * from [dbo].[Search_Component_Type] (N'{listIdComponentOrderLog.Trim(';')}')");
            DataTable dataTableTypeNo = sqlManager.ReturnTable($@"select * from [dbo].[Search_Component_TypeNo] (N'{listIdComponentOrderLog.Trim(';')}')");
            string listIdComponentsYes = string.Join(", ", dataTableTypeYes.Rows.OfType<DataRow>().Select(o => o[0].ToString()));
            if (dataTableTypeYes.Rows.Count > 1)
            {
                ThreadSafe(() => MessageBox.Show($@"{listIdComponentsYes} достигли минимума."));
            }
            if (dataTableTypeYes.Rows.Count == 1)
            {
                ThreadSafe(() => MessageBox.Show($@"{listIdComponentsYes} достиг минимума. "));
            }

            if (dataTableTypeNo.Rows.Count > 0)
            {
                ThreadSafe(() => MessageBox.Show($@"Добавлены новые индивидуальные компоненты."));
            }

            listIdComponentOrderLog = "";
        }

        /// <summary>
        /// Обработка действий в потоке где было оно созданно
        /// </summary>
        /// <param name="method">Метод</param>
        public void ThreadSafe(MethodInvoker method)
        {
            try
            {
                if (InvokeRequired)
                {
                    Invoke(method);
                }
                else
                {
                    method();
                }
            }
            catch (ObjectDisposedException) { }
        }

        /// <summary>
        /// Обработка обновления списка сопоставленных марок и моделей
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        private void RefreshListCar_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            orderGeneral.MatchingMachines(comboBoxStampCar, comboBoxModelCar, listBrandModelCompliance, AddListStampModel);
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Внесение данных в списк с моделям и марками машин
        /// </summary>
        /// <param name="listStampCar">Список марок машин</param>
        /// <param name="listModelCar">Список моделей машин</param>
        private void AddListStampModel(List<CarStamp> listStampCar, List<CarModel> listModelCar)
        {
            listSelectedModelCar = listBrandModelCompliance.Rows.OfType<DataGridViewRow>()
                .Where(x => x.Cells[1].Value != null)
                .Select(dr => dr.Cells[1].Value.ToString())
                .ToList();

            this.listStampCar = listStampCar;
            this.listModelCar = listModelCar;
        }

        /// <summary>
        /// Кнопка из под админестратора зала
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Exit_Click(object sender, EventArgs e)
        {
            Loging loging = new Loging();
            loging.Show();
            this.Hide();
            this.Close();
        }

        /// <summary>
        /// кнопка удаления работника
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DeleteEmployeePost_Click(object sender, EventArgs e)
        {
            ValueDataGrid();
            sqlManager.OpenConnection();
            sqlManager.PerformingProcedure(
                 new string[] { idWorkerSelected.ToString() },
                 "[dbo].[Worker_delete]",
                 new string[] { "ID_Worker" }
                 );
            sqlManager.CloseConnection();
            listEmployees.Rows.RemoveAt(idrowSelectedDGVWorker);
        }

        /// <summary>
        /// Кнопка удаления сотрудника
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DeleteEmployee_Click(object sender, EventArgs e)
        {
            ValueDataGrid();
            sqlManager.OpenConnection();
            sqlManager.PerformingProcedure(
                     new string[] { idEmployeeSelected.ToString() },
                     "[dbo].[Employee_delete]",
                     new string[] { "ID_Employee" }
                 );
            sqlManager.CloseConnection();

            for (int i = listEmployees.RowCount; i > 0; i--)
            {
                if (Convert.ToInt32(listEmployees.Rows[i - 1].Cells[0].Value) == idEmployeeSelected)
                {
                    listEmployees.Rows.RemoveAt(i - 1);
                }
            }
        }

        /// <summary>
        /// Кнопка для перехода в форму по созданию или изменению списка работников
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AddEmployee_Click(object sender, EventArgs e)
        {
            EmployeeAddUpdate employeeAddUpdate = new EmployeeAddUpdate(this)
            { 
                BranchLogin = idBranchLogin,
                LoginPerson = loginPerson
            };
            employeeAddUpdate.Show();
        }

        /// <summary>
        /// Получение индификаторов сотрудника и работника
        /// </summary>
        private void ValueDataGrid()
        {
            idrowSelectedDGVWorker = listEmployees.CurrentRow.Index;
            idEmployeeSelected = Convert.ToInt32(listEmployees.Rows[idrowSelectedDGVWorker].Cells[0].Value);
            idWorkerSelected = Convert.ToInt32(listEmployees.Rows[idrowSelectedDGVWorker].Cells[1].Value);
        }

        /// <summary>
        /// Обработка выбора элемента из выпадающего списка для сортировки
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CbSorting_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (cbSorting.Text)
            {
                case "По фамилии А-Я":
                    listEmployees.Sort(listEmployees.Columns["Фамилия"], ListSortDirection.Ascending);
                    break;

                case "По фамилии Я-А":
                    listEmployees.Sort(listEmployees.Columns["Фамилия"], ListSortDirection.Descending);
                    break;

                case "По должности А-Я":
                    listEmployees.Sort(listEmployees.Columns["Должность"], ListSortDirection.Ascending);
                    break;

                case "По должности Я-А":
                    listEmployees.Sort(listEmployees.Columns["Должность"], ListSortDirection.Descending);
                    break;
            }
        }

        /// <summary>
        /// Обработка выбора элемента из выпадающего списка для фильтрации 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CbFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (cbFilter.Text)
            {
                case "Фамилия начинаеться на":
                    selectedItemComboBoxFilter = "Фамилия";
                    break;

                case "Должность начинаеться на":
                    selectedItemComboBoxFilter = "Должность";
                    break;

                default:
                    break;
            }
        }

        /// <summary>
        /// Запрет на нажатие заголовков в DataGridView
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListEmployees_ColumnStateChanged(object sender, DataGridViewColumnStateChangedEventArgs e)
        {
            e.Column.SortMode = DataGridViewColumnSortMode.NotSortable;
        }

        /// <summary>
        /// Обработка появления сиволов в поле для ввода значений фильтрации
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TextFilter_TextChanged(object sender, EventArgs e)
        {
            (listEmployees.DataSource as DataTable).DefaultView.RowFilter = $"{selectedItemComboBoxFilter} LIKE '{textFilter.Text}%'";
        }

        /// <summary>
        /// Двойное нажатие на DataGridView со списком сотрудников
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListEmployees_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0)
            {
                return;
            }

            DataGridViewRow row = listEmployees.Rows[e.RowIndex];
            EmployeeAddUpdate employeeAddUpdate = new EmployeeAddUpdate(this)
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
                BranchLogin = idBranchLogin,
                LoginPerson = loginPerson,
                IsStatusUpdate = true
            };
            employeeAddUpdate.Show();
        }

        /// <summary>
        /// Открытие формы для добавления клиента
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AddClient_Click(object sender, EventArgs e)
        {
            ClientAddUpdate clientAddUpdate = new ClientAddUpdate
            {
                DGVMain = clientList
            };
            clientAddUpdate.Show();
        }

        /// <summary>
        /// Открытие формы для изменения клиента
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Update_client_Click(object sender, EventArgs e)
        {
            ClientAddUpdate clientAddUpdate = new ClientAddUpdate
            {
                DGVClient = clientList,
                IsStatusUpdate = true
            };

            clientAddUpdate.Show();
        }

        /// <summary>
        /// Обработка появления сиволов в поле для ввода значений фильтрации по фамиилии клиентов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SeartchSurname_TextChanged(object sender, EventArgs e)
        {
            (clientList.DataSource as DataTable).DefaultView.RowFilter = $"Фамилия LIKE '{seartchSurname.Text}%'";
        }

        /// <summary>
        /// Обработка двойного нажатия на клиента для перехода в его форму
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ClientList_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0)
            {
                return;
            }
            CustomerCard customerCard = new CustomerCard
            {
                IDWorkers = idWorkerLoging,
                IDBranch = idBranchLogin,
                IDClient = Convert.ToInt32(clientList.Rows[e.RowIndex].Cells[0].Value.ToString()),
                ClientList = clientList
            };
            customerCard.Text = $@"{clientList.Rows[e.RowIndex].Cells[1].Value} {clientList.Rows[e.RowIndex].Cells[2].Value} {clientList.Rows[e.RowIndex].Cells[3].Value}";
            customerCard.Show();
        }

        /// <summary>
        /// Выбор значения начала анализа
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void StartDateAnaliz_ValueChanged(object sender, EventArgs e)
        {
            endDateAnaliz.MinDate = startDateAnaliz.Value;
        }

        /// <summary>
        /// Нажатие на кнопку для создания excel файла с отработкой сотрудников
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private async void CreateStatement_Click(object sender, EventArgs e)
        {
            IEnumerable<DataGridViewRow> selectedRows = listEmployees.SelectedRows.Cast<DataGridViewRow>();

            if (selectedRows.Count() > 0)
            {
                string listIdWorkerStr = string.Join(";", selectedRows.Select(o => o.Cells[1].Value.ToString()));
                string[] listWorkerSelected = selectedRows.Select(o => $@"{o.Cells[2].Value} {o.Cells[3].Value} {o.Cells[4].Value} - {o.Cells[5].Value}").ToArray();
                int[] listIdWorkerSelected = selectedRows.Select(o => Convert.ToInt32(o.Cells[1].Value.ToString())).ToArray();

                string startDateValue = startDateAnaliz.Value.ToShortDateString();
                string endDateValue = endDateAnaliz.Value.ToShortDateString();

                sqlManager.OpenConnection();
                DataTable dataTableAllInformWorker = sqlManager.PerformingProcedureReturnDataTable(
                        new string[] { startDateValue, endDateValue, listIdWorkerStr },
                        "[dbo].[Analiz_Worker]",
                        new string[] { "startDate", "endDate", "idWorker", }
                    );

                DataTable dataTableAllService = sqlManager.PerformingProcedureReturnDataTable(
                        new string[] { startDateValue, endDateValue, listIdWorkerStr },
                        "[dbo].[Analiz_RosterWorkService]",
                        new string[] { "startDate", "endDate", "idWorker", }
                    );
                sqlManager.CloseConnection();

                if (dataTableAllService.Rows.Count > 0 || dataTableAllInformWorker.Rows.Count > 0)
                {
                    saveFileDialog.FileName = $@"Ведомость от {DateTime.Now.ToShortDateString()} анализ {startDateValue} - {endDateValue}";
                    saveFileDialog.Filter = "XLSX (.xlsx)|*.xlsx|XLS (.xls)|*.xls|XLAM (.xlam)|*.xlam|CV (.cv)|*.cv";
                    DialogResult res = saveFileDialog.ShowDialog();
                    if (res.Equals(DialogResult.OK))
                    {
                        Custom.ExcelManager excel = new Custom.ExcelManager() { endDateAnaliz = endDateAnaliz, startDateAnaliz = startDateAnaliz };
                        await excel.CreateRosterManuFacturedWorkMaterials(
                            dataTableAllInformWorker, dataTableAllService,
                            listWorkerSelected, listIdWorkerSelected, saveFileDialog.FileName, excel.PrintingExcel
                        );
                    }
                }
                else
                {
                    MessageBox.Show("По выбранным сотрудникам нет данных.");
                }
            }
            else
            {
                MessageBox.Show("Необходимо выбрать всю строку с клиентом.");
            }
        }

        /// <summary>
        /// Обработка нажатия для обнавления списка сотрудников
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void RefreshWorkerList_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            sqlManager.GetList(listEmployees, "[dbo].[Worker]", $@"select * from [dbo].[Worker_View] (N'{loginPerson}',{idBranchLogin})");
            CbSorting_SelectedIndexChanged(this, new EventArgs());
            TextFilter_TextChanged(this, new EventArgs());
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия для обнавления списка клиентов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RefreshClient_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            sqlManager.GetList(clientList, "[dbo].[Client]", "select * from [dbo].[Client_View]");
            SeartchSurname_TextChanged(this, new EventArgs());
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Списание компонентов со склада
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void WriteOffGoods_Click(object sender, EventArgs e)
        {
            DataTable dataTableOrderLog = sqlManager.ReturnTable($@"select * from [dbo].[OrderLog_View_FunUpdate]");
            IEnumerable<DataGridViewRow> selectedRows = dgvWarehouse.SelectedRows.Cast<DataGridViewRow>();
            string amountDebitedText = countWriteOffComponent.Text;
            string message = "";
            string messageInform = "";
            int messageInformCount = 0;

            if (selectedRows.Count() > 0)
            {

                sqlManager.OpenConnection();

                if (amountDebitedText != "")
                {
                    foreach (DataGridViewRow row in selectedRows)
                    {
                        int idWarehouse = Convert.ToInt32(row.Cells[0].Value);

                        decimal amountDebitedFloat = Convert.ToDecimal(amountDebitedText);
                        decimal cellFloat = Convert.ToDecimal(row.Cells[2].Value.ToString());
                        string result = (cellFloat - amountDebitedFloat).ToString();

                        if (amountDebitedFloat > cellFloat)
                        {
                            message += $@"Нельзя списать {row.Cells[1].Value} больше чем есть на складе." + "\n";
                        }
                        else
                        {
                            sqlManager.PerformingProcedure(
                                new string[] { dgvWarehouse.Rows[row.Index].Cells[0].Value.ToString(), result.Replace(",", ".") },
                                "[dbo].[Warehouse_update_Quantity]",
                                new string[] { "ID_Warehouse", "Quantity_Warehouse" }
                            );

                            double minimum = Convert.ToDouble(row.Cells[4].Value.ToString());
                            if (Convert.ToDouble(result) < minimum)
                            {
                                messageInform += row.Cells[1].Value.ToString() + ",";
                                messageInformCount++;
                                InsertApplication(dataTableOrderLog, row.Cells[5].Value.ToString(), Convert.ToInt32(minimum * 1.25).ToString());
                            }

                            if (float.Parse(result) % 1 == 0)
                            {
                                result += ",00";
                            }

                            row.Cells[2].Value = result;
                        }
                    }
                }
                else
                {
                    foreach (DataGridViewRow row in selectedRows)
                    {
                        InsertApplication(dataTableOrderLog, row.Cells[5].Value.ToString(), Convert.ToInt32(Convert.ToDouble(row.Cells[4].Value.ToString()) * 1.25).ToString());
                        row.Cells[2].Value = "0";
                        sqlManager.PerformingProcedure(
                                new string[] { dgvWarehouse.Rows[row.Index].Cells[0].Value.ToString(), "0.0" },
                                "[dbo].[Warehouse_update_Quantity]",
                                new string[] { "ID_Warehouse", "Quantity_Warehouse" }
                            );

                        messageInform += row.Cells[1].Value.ToString() + ",";
                        messageInformCount++;
                    }
                }

                if (message != "")
                {
                    MessageBox.Show(message);
                }

                if (messageInform != "")
                {
                    if (messageInformCount > 1)
                    {
                        MessageBox.Show(messageInform.TrimEnd(',', ' ') + " достигли минимума.");
                    }
                    else
                    {
                        MessageBox.Show(messageInform.TrimEnd(',', ' ') + " достиг минимума.");
                    }
                }

                sqlManager.CloseConnection();
            }
            else
            {
                MessageBox.Show("Для того чтобы списать товар выделете всю строку. Для этого нажмите на левую часть таблицы.");
            }
        }

        /// <summary>
        /// Добавление заявки в список с заявкми
        /// </summary>
        /// <param name="dataTableOrderLog">Набор данных из журнала заказов</param>
        /// <param name="idComponent">Номер компонентов</param>
        /// <param name="quantityComponent">Количество компонентов</param>
        private void InsertApplication(DataTable dataTableOrderLog, string idComponent, string quantityComponent)
        {
            sqlManager.OpenConnection();
            if (dataTableOrderLog.Rows.Count > 0)
            {
                IEnumerable<DataRow> orderLogIdComponentList = dataTableOrderLog.AsEnumerable()
                    .Where(x => x.Field<int>("Номер компонента").ToString() == idComponent);

                if (orderLogIdComponentList.Any())
                {
                    if (orderLogIdComponentList.Count() == 0)
                    {
                        orderGeneral.InsertApplication(idComponent, idBranchLogin.ToString(), idWorkerLoging.ToString(), quantityComponent);
                    }
                }
                else
                {
                    orderGeneral.InsertApplication(idComponent, idBranchLogin.ToString(), idWorkerLoging.ToString(), quantityComponent);
                }
            }
            else
            {
                orderGeneral.InsertApplication(idComponent, idBranchLogin.ToString(), idWorkerLoging.ToString(), quantityComponent);
            }

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажаий кнопок в поле с колличетвом для списания
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CountWriteOffComponent_KeyPress(object sender, KeyPressEventArgs e)
        {
            char keyChar = e.KeyChar;
            string text = countWriteOffComponent.Text;
            if ((!Char.IsDigit(keyChar) && keyChar != 8 && keyChar != 44) || (keyChar == 44 && text.Length < 1) || (keyChar == 44 && text.Contains(",")))
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Обработка нажатия на кнопку для создания ведомости об остатках на складах
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public async void GenerateReport_Click(object sender, EventArgs e)
        {
            saveFileDialog.FileName = $@"Остатки склада от {DateTime.Now.ToShortDateString()}";
            saveFileDialog.Filter = "XLSX (.xlsx)|*.xlsx|XLS (.xls)|*.xls|XLAM (.xlam)|*.xlam|CV (.cv)|*.cv";
            DialogResult res = saveFileDialog.ShowDialog();
            if (res.Equals(DialogResult.OK))
            {
                DataTable dataTableWarehouse = (dgvWarehouse.DataSource as DataTable).Copy();
                await new ExcelManager().GenerateReport(saveFileDialog.FileName, dataTableWarehouse);
            }
        }

        /// <summary>
        /// Обработка кнопки для перехода на форму добавления и изменения марок машин
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AddStampCar_Click(object sender, EventArgs e)
        {
            new StampCarAddUpdate().Show();
        }

        /// <summary>
        /// Обработка кнопки для перехода на форму добавления и изменения моделей машин
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AddModelCar_Click(object sender, EventArgs e)
        {
            new ModelCarAddUpdate().Show();
        }

        /// <summary>
        /// Начало редактиования списка журнала заазов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListOrderLog_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            indexCurrentCellOrderLog = listOrderLog.CurrentCell.ColumnIndex;
            if (indexCurrentCellOrderLog != 4)
            {
                quantitytextboxTabPageOrderLog = (TextBox)e.Control;
                quantitytextboxTabPageOrderLog.KeyPress -= new KeyPressEventHandler(QuantityDecimalOrdreLog_KeyPress);
                quantitytextboxTabPageOrderLog.KeyPress += new KeyPressEventHandler(QuantityDecimalOrdreLog_KeyPress);

                if (indexCurrentCellOrderLog == 2)
                {
                    if (listOrderLog.Rows[listOrderLog.CurrentRow.Index].Cells[6].Value.ToString() == "False")
                    {
                        listOrderLog.CurrentCell = listOrderLog.Rows[listOrderLog.CurrentRow.Index].Cells[1];
                        listOrderLog.CurrentCell = listOrderLog.Rows[listOrderLog.CurrentRow.Index].Cells[indexCurrentCellOrderLog];
                    }
                    else
                    {
                        initialOrderLog = listOrderLog.Rows[listOrderLog.CurrentRow.Index].Cells[indexCurrentCellOrderLog].Value.ToString();
                    }
                }
            }
            else
            {
                initialOrderLog = listOrderLog.Rows[listOrderLog.CurrentRow.Index].Cells[indexCurrentCellOrderLog].Value.ToString();
            }
        }

        /// <summary>
        /// Обработка нажатия на кнопки в поле для введения количества компонентов в журнале заказов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void QuantityDecimalOrdreLog_KeyPress(object sender, KeyPressEventArgs e)
        {
            char keyChar = e.KeyChar;
            string text = quantitytextboxTabPageOrderLog.Text;
            if ((!Char.IsDigit(keyChar) && keyChar != 8 && keyChar != 44) || (keyChar == 44 && text.Length < 1) || (keyChar == 44 && text.Contains(",")))
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Оконание редактирования списка журнала заказов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListOrderLog_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (!string.IsNullOrEmpty(listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString()))
            {
                string textInput = listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString();

                if (textInput == initialOrderLog)
                {
                    return;
                }
            }

            if (indexCurrentCellOrderLog == 3)
            {
                if (!string.IsNullOrEmpty(listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString()))
                {
                    string textInput = listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString();
                    if (Convert.ToDouble(textInput) < 10.00)
                    {
                        listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value = "10";
                    }

                    if (!textInput.Contains(","))
                    {
                        listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value = textInput + ",00";
                    }
                }
                else
                {
                    listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value = "10";
                }
            }

            if (indexCurrentCellOrderLog == 2)
            {
                if (!string.IsNullOrEmpty(listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString()))
                {
                    if (Convert.ToDouble(listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString()) < 1)
                    {
                        listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value = initialOrderLog;
                    }
                }
                else
                {
                    listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex].Value = initialOrderLog;
                }
            }

            if (indexCurrentCellOrderLog == 4)
            {
                string idListStatus = listListStatusId.FirstOrDefault(x => x.Value == listOrderLog.Rows[e.RowIndex].Cells[indexCurrentCellOrderLog].Value.ToString()).Key.ToString();
                listOrderLog.Rows[e.RowIndex].Cells[indexCurrentCellOrderLog + 1].Value = idListStatus;
            }

            if (!listEditRowIndexOrderLog.Contains(e.RowIndex) && !listOrderLog.Rows[e.RowIndex].Cells[0].Value.ToString().Equals(""))
            {
                listEditRowIndexOrderLog.Add(e.RowIndex);
            }
        }

        /// <summary>
        /// Обработка нажатия на выпадающий список со статусами в журнале заказов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListOrderLog_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                DataGridViewCell cell = listOrderLog.Rows[e.RowIndex].Cells[e.ColumnIndex];
                if (cell is DataGridViewComboBoxCell)
                {
                    listOrderLog.BeginEdit(false);
                    (listOrderLog.EditingControl as DataGridViewComboBoxEditingControl).DroppedDown = true;
                }
            }
            catch { }
        }

        /// <summary>
        /// Сохранение изменений в журнале заказов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveListUpdateOrderLog_Click(object sender, EventArgs e)
        {
            listOrderLog.EndEdit();
            int count = listEditRowIndexOrderLog.Where(x => (
                 Convert.ToDouble(listOrderLog.Rows[x].Cells[3].Value.ToString()).Equals(0.00) &&
                 listOrderLog.Rows[x].Cells[4].Value.ToString() == "Закрыт"
                 )).Count();

            if (count > 0 || listEditRowIndexOrderLog.Count() == 0)
            {
                MessageBox.Show("Задайте цену для измененных элементов журналов заказов.");
            }
            else
            {
                sqlManager.OpenConnection();
                UpdateListOrderLog();
                RefreshListOrdreLog_Click(this, new EventArgs());
                sqlManager.CloseConnection();
            }
        }

        /// <summary>
        /// Обновление элементов в журнале заказов
        /// </summary>
        private void UpdateListOrderLog()
        {
            DataTable dataTableWarehouse = sqlManager.ReturnTable($@"select * from [dbo].[Warehouse_Component_View_FuncUpdate] ({idBranchLogin})");

            foreach (int indexRowOrderLog in listEditRowIndexOrderLog)
            {
                DataGridViewRow row = listOrderLog.Rows[indexRowOrderLog];

                if (row.Cells[6].Value.ToString() == "True") //Расходники
                {
                    sqlManager.PerformingProcedure(
                        new string[] { row.Cells[0].Value.ToString(), row.Cells[2].Value.ToString(), row.Cells[3].Value.ToString().Replace(",", "."), row.Cells[5].Value.ToString() },
                        "[dbo].[OrderLog_update_Consumables]",
                        new string[] { "ID_Order_Log", "Quantity_Warehouse", "Price", "List_Status_ID" }
                        );

                    if (row.Cells[4].Value.ToString() == "Закрыт")
                    {
                        string price = ((Convert.ToDecimal(row.Cells[3].Value.ToString()) * 120) / 100).ToString().Replace(",", ".");

                        IEnumerable<DataRow> dataTableWarehouseSearthList = dataTableWarehouse.AsEnumerable().Where(x => x[1].ToString() == row.Cells[1].Value.ToString());

                        if (dataTableWarehouseSearthList.Any())
                        {
                            if (dataTableWarehouseSearthList.Count() <= 0)
                            {
                                sqlManager.PerformingProcedure(
                                    new string[] { row.Cells[7].Value.ToString(), row.Cells[2].Value.ToString(), price, idBranchLogin.ToString() },
                                    "[dbo].[Warehouse_insert]",
                                    new string[] { "Component_ID", "Quantity_Warehouse", "Price", "Branch_ID" }
                                );
                            }
                            else
                            {
                                foreach (DataRow itemWarehouse in dataTableWarehouseSearthList)
                                {
                                    double quantityWarehouse = Convert.ToDouble(row.Cells[2].Value.ToString()) + Convert.ToDouble(itemWarehouse[2].ToString());
                                    sqlManager.PerformingProcedure(
                                       new string[] { itemWarehouse[0].ToString(), quantityWarehouse.ToString(), price },
                                       "[dbo].[Warehouse_update_Price_Quantity]",
                                       new string[] { "ID_Warehouse", "Quantity_Warehouse", "Price" }
                                   );
                                }
                            }
                        }
                        else
                        {
                            sqlManager.PerformingProcedure(
                                    new string[] { row.Cells[7].Value.ToString(), row.Cells[2].Value.ToString(), price, idBranchLogin.ToString() },
                                    "[dbo].[Warehouse_insert]",
                                    new string[] { "Component_ID", "Quantity_Warehouse", "Price", "Branch_ID" }
                                );
                        }
                    }
                }
                else
                {
                    sqlManager.PerformingProcedure(
                        new string[] { row.Cells[0].Value.ToString(), row.Cells[3].Value.ToString().Replace(",", "."), row.Cells[5].Value.ToString() },
                        "[dbo].[OrderLog_update_Individual]",
                        new string[] { "ID_Order_Log", "Price", "List_Status_ID" }
                        );

                    if (row.Cells[4].Value.ToString() == "Закрыт")
                    {

                        string price = ((Convert.ToDecimal(row.Cells[3].Value.ToString()) * 120) / 100).ToString().Replace(",", ".");

                        sqlManager.PerformingProcedure(
                            new string[] { row.Cells[8].Value.ToString(), price },
                            "[dbo].[Component_Order_update_Price]",
                            new string[] { "ID_Component_Order", "Price" }
                        );
                    }
                }
            }
        }

        /// <summary>
        /// Обработка нажатия на кнопку для открытия формы для создания заявки
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CreatePurchaseRequest_Click(object sender, EventArgs e)
        {
            new CreatingOrderComponents()
            {
                IDBranch = idBranchLogin.ToString(),
                IDWorker = idWorkerLoging.ToString()
            }.Show();
        }

        /// <summary>
        /// Удаление элемента из журнала заказов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DeleteItemOrderLog_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            string idListStatusOpen;
            DataGridViewRow itemOrdreLog = listOrderLog.Rows[listOrderLog.CurrentCell.RowIndex];

            if (itemOrdreLog.Cells[10].Value.ToString() == "Application")
            {
                bool status = sqlManager.PerformingProcedure(
                    new string[] { itemOrdreLog.Cells[8].Value.ToString() },
                    "[dbo].[Application_delete]",
                    new string[] { "ID_Application" }
                );

                if (status)
                {
                    listOrderLog.Rows.Remove(itemOrdreLog);
                }
            }
            else
            {
                string idListStatusWin = listListStatusId.FirstOrDefault(x => x.Value == "Закрыт").Key.ToString();

                if (itemOrdreLog.Cells[9].Value.ToString() == "Админестратор точки")
                {
                    idListStatusOpen = listListStatusId.FirstOrDefault(x => x.Value == "Открыт").Key.ToString();
                }
                else
                {
                    idListStatusOpen = listListStatusId.FirstOrDefault(x => x.Value == "Выполняется").Key.ToString();
                }

                sqlManager.PerformingProcedure(
                    new string[] { itemOrdreLog.Cells[8].Value.ToString(), itemOrdreLog.Cells[5].Value.ToString(), idListStatusOpen },
                    "[dbo].[Component_Order_delete_OrdreLog]",
                    new string[] { "ID_Component_Order", "List_Status_ID_OrderLog", "List_Status_ID_Order" }
                 );
            }

            sqlManager.CloseConnection();
        }
    }
}
