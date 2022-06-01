using Progect.Custom;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Threading;
using System.Windows.Forms;


namespace Progect
{
    /// <summary>
    /// Класс формы для работы механика над машиной
    /// </summary>
    public partial class EngineeringWorks : Form
    {
        private readonly OrderGeneral orderGeneral = new OrderGeneral();
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();

        private int idWorkerLoging;
        private int idBranchLogin;

        private readonly DataTable dataService = new DataTable();
        private readonly DataTable dataMaterial = new DataTable();

        private DataTable dataTableWarehouse = new DataTable();
        private DataTable dataTableOrderLog = new DataTable();

        private readonly List<int> ListDeleteService = new List<int>();
        private readonly List<int> ListDeleteMaterial = new List<int>();
        private readonly Dictionary<int, string> ListUpdateMaterialSelect = new Dictionary<int, string>();
        private Dictionary<int, string> listListStatusId = new Dictionary<int, string>();

        private string initialQuantity;

        public int IDWorkers
        {
            set
            {
                idWorkerLoging = value;
                sqlManager.OpenConnection();
                Init();
                sqlManager.OpenConnection();
            }
        }
        public int IDBranch { set => idBranchLogin = value; }

        /// <summary>
        /// Инициализация компонентов
        /// </summary>
        public EngineeringWorks()
        {
            InitializeComponent();
        }


        /// <summary>
        /// Загрузка формы с первичными данными
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void EngineeringWorks_Load(object sender, EventArgs e)
        {
            if (listOrder.Rows.Count > 0)
            {
                listOrder.CurrentCell = listOrder.Rows[0].Cells[0];
                orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);
                orderGeneral.EnabledButtonPrint(0, listOrder, printOrderOutfit);

                DataTable dataTablListStatus = sqlManager.ReturnTable("select * from [dbo].[List_Status]");

                listListStatusId = dataTablListStatus.Rows.OfType<DataRow>()
                    .Select(o => new
                    {
                        Key = o.Field<int>("ID_List_Status"),
                        Value = o.Field<string>("Name_Status")
                    }).OrderBy(x => x.Key).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
            }
        }

        /// <summary>
        /// Печать заказ наряда
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void PrintOrderOutfit_Click(object sender, EventArgs e)
        {
            ListOrder_CellClick(this, new DataGridViewCellEventArgs(1, listOrder.CurrentRow.Index));
            string fileNameDefault = $@"Заказ наряд №{Convert.ToInt32(listOrder.Rows[listOrder.CurrentRow.Index].Cells[0].Value)} от {DateTime.Now:D}";
            saveFileDialog.FileName = fileNameDefault.Substring(0, fileNameDefault.Length - 1);
            saveFileDialog.Filter = "DOC (.doc)|*.doc|DOCX (.docx)|*.docx";
            DialogResult res = saveFileDialog.ShowDialog();
            if (res.Equals(DialogResult.OK))
            {
                string path = saveFileDialog.FileName;

                bool statusCreateSmeta = new WordManager()
                {
                    dataGridViewRowOrder = listOrder.Rows[listOrder.CurrentCell.RowIndex],
                    listSelectService = listSelectedServices,
                    listSelectMaterial = listSelectedMaterials,
                    adminLoginWorker = false
                }.CreateSmeta(path, fileNameDefault);

                if (statusCreateSmeta)
                {
                    if (printDialog.ShowDialog() == DialogResult.OK)
                    {
                        printDocument.DocumentName = path;

                        ProcessStartInfo info = new ProcessStartInfo(path)
                        {
                            Verb = "PrintTo",
                            Arguments = printDialog.PrinterSettings.PrinterName,
                            CreateNoWindow = true,
                            WindowStyle = ProcessWindowStyle.Maximized
                        };
                        Process.Start(info);
                    }
                }

                Process.Start(path);
            }
        }

        /// <summary>
        /// Обработка выбора из выпадающего спсика статуса заказ наряда для выведения в DataGridView
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CbFilterOrderStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            string cbFilterOrderStatusText = cbFilterOrderStatus.Text;

            if (cbFilterOrderStatusText == "Все")
            {
                sqlManager.GetList(listOrder, "[dbo].[Order]", $@"select * from [dbo].[Order_List_Engineers] ({idBranchLogin})");
            }
            else
            {
                sqlManager.GetList(listOrder, "[dbo].[Order]", $@"select * from [dbo].[Search_Order_View_Filter] (N'{cbFilterOrderStatusText}',{idBranchLogin})");
            }

            if (listOrder.RowCount > 0)
            {
                ListOrder_CellClick(this, new DataGridViewCellEventArgs(0, 0));
                orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);
            }

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия мышю на список с заказ нарядами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListOrder_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (listOrder.Rows.Count > 0)
            {
                int indexOrder;
                try
                {
                    indexOrder = e.RowIndex;

                    if (indexOrder < 0)
                    {
                        indexOrder = 0;
                    }
                }
                catch
                {
                    indexOrder = 0;
                }

                int idOrder = Convert.ToInt32(listOrder.Rows[indexOrder].Cells[0].Value.ToString());

                OrderDetailsOutput(idOrder);
                ServiceStatusAnalysis();

                ListDeleteService.Clear();
                ListDeleteMaterial.Clear();
                ListUpdateMaterialSelect.Clear();

                orderGeneral.EnabledButtonPrint(indexOrder, listOrder, printOrderOutfit);
                List<decimal> listDecimal = orderGeneral.TotalCostOrder(listSelectedMaterials, listSelectedServices);
                amountComponents.Text = listDecimal[0].ToString() + " .руб";
                amountService.Text = listDecimal[1].ToString() + " .руб";
                totalCost.Text = listDecimal[2].ToString() + " .руб";
            }
        }

        /// <summary>
        /// Отключение сортировки в списке с заказ нарядами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListOrder_ColumnStateChanged(object sender, DataGridViewColumnStateChangedEventArgs e)
        {
            e.Column.SortMode = DataGridViewColumnSortMode.NotSortable;
        }

        /// <summary>
        /// Настройка и заполнение списка заказ нарядов
        /// </summary>
        private void InitListOrder()
        {
            sqlManager.GetList(listOrder, "[dbo].[Order]", $@"select * from [dbo].[Order_List_Engineers] ({idBranchLogin})");
            listOrder.Columns[0].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listOrder.Columns[1].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listOrder.DefaultCellStyle.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            listOrder.AllowUserToAddRows = false;
            listOrder.ReadOnly = true;

            orderGeneral.DateSelected(dataService, dataMaterial, listSelectedServices, listSelectedMaterials);
        }

        /// <summary>
        /// Изменение надписи кнопки по выполнению работы
        /// </summary>
        private void ServiceStatusAnalysis()
        {
            if (listSelectedServices.Rows.Count > 0)
            {
                if (listSelectedServices.Rows[0].Cells[4].Value.ToString() == "")
                {
                    runStopService.Text = "Начать выполнение";
                }
                else
                {
                    runStopService.Text = "Закончить выполнение";
                }
            }
        }

        /// <summary>
        /// Первичная выгрузка данных с настройкой DataGridView
        /// </summary>
        private void Init()
        {
            InitListOrder();

            cbServiceGroup.Items.Add("Все");
            sqlManager.AddComboBox(cbServiceGroup, "[dbo].[Service_Group_View]", 1);
            cbServiceGroup.SelectedIndex = 0;

            sqlManager.GetList(listAvailableServices, "[dbo].[List_Services]", $@"select * from [dbo].[List_Service_View]");
            listAvailableServices.Columns[2].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listAvailableServices.Columns[3].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listAvailableServices.DefaultCellStyle.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            listAvailableServices.Columns[0].Visible = false;
            listAvailableServices.AllowUserToAddRows = false;
            listAvailableServices.ReadOnly = true;

            sqlManager.GetList(listAvailableMaterials, "[dbo].[Warehouse]", $@"select * from [dbo].[Warehouse_Component_View] ({idBranchLogin})");
            listAvailableMaterials.DefaultCellStyle.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            listAvailableMaterials.Columns[2].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listAvailableMaterials.Columns[3].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listAvailableMaterials.Columns[0].Visible = false;
            listAvailableMaterials.Columns[4].Visible = false;
            listAvailableMaterials.Columns[5].Visible = false;
            listAvailableMaterials.AllowUserToAddRows = false;
            listAvailableMaterials.ReadOnly = true;

            cbFilterOrderStatus.Items.AddRange(new string[] { "Все", "Открыт", "Закрыт", "Выполняется" });
            cbFilterOrderStatus.SelectedIndex = 1;

            cbTypeComponent.Items.AddRange(new string[] { "Расходники", "Индивидуальные" });
            cbTypeComponent.SelectedIndex = 0;

            orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);

            ServiceStatusAnalysis();
        }

        /// <summary>
        /// Выход из главной формы работника
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Back_Click(object sender, EventArgs e)
        {
            new Loging().Show();
            Close();
        }

        /// <summary>
        /// Поиск услуги в списке с услугами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SearchService_TextChanged(object sender, EventArgs e)
        {
            (listAvailableServices.DataSource as DataTable).DefaultView.RowFilter = $"[{listAvailableServices.Columns[1].Name}] LIKE '{searchService.Text}%'";
        }

        /// <summary>
        /// Удаление услуги из списка выбранных услуг
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DeleteService_Click(object sender, EventArgs e)
        {
            int index = listSelectedServices.CurrentCell.RowIndex;
            DataGridViewRow dataRow = listSelectedServices.Rows[index];

            orderGeneral.DeleteSelectService(totalCost, amountService, amountComponents, dataRow.Cells[6].Value.ToString());

            if (dataRow.Cells[1].Value.ToString() != "")
            {
                ListDeleteService.Add(Convert.ToInt32(dataRow.Cells[1].Value.ToString()));
            }

            listSelectedServices.Rows.RemoveAt(index);
        }

        /// <summary>
        /// Удаление материала из списка выбранных материалов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DeleteMaterial_Click(object sender, EventArgs e)
        {
            int index = listSelectedMaterials.CurrentRow.Index;
            DataGridViewRow dataRow = listSelectedMaterials.Rows[index];

            if (dataRow.Cells[1].Value.ToString() != "")
            {
                ListDeleteMaterial.Add(Convert.ToInt32(dataRow.Cells[1].Value.ToString()));
            }

            listSelectedMaterials.Rows.RemoveAt(index);

            orderGeneral.UpdateTotalCostAndCostComponent(totalCost, amountService, amountComponents, listSelectedMaterials);
        }

        /// <summary>
        /// Обработка нажатия на кнопку сохранения детелей заказ наряда. 
        /// Сохранение деталей заказ наряда.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveServiceMaterial_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            int countRemove = 0;
            int countUpdate = 0;
            int indexRowOrder = listOrder.CurrentCell.RowIndex;
            string idOrder = listOrder.Rows[indexRowOrder].Cells[0].Value.ToString();

            foreach (int idServiceDelete in ListDeleteService)
            {
                countRemove++;
                sqlManager.PerformingProcedure(new string[] { idServiceDelete.ToString() }, "[dbo].[Car_Services_Provided_delete]", new string[] { "ID_Car_Services_Provided" });
            }

            foreach (int idMaerialDelete in ListDeleteMaterial)
            {
                countRemove++;
                sqlManager.PerformingProcedure(new string[] { idMaerialDelete.ToString() }, "[dbo].[Component_Order_delete]", new string[] { "ID_Component_Order" });
            }

            dataTableWarehouse = sqlManager.ReturnTable($@"select * from [dbo].[Warehouse_Component_View_FuncUpdate] ({idBranchLogin})");
            dataTableOrderLog = sqlManager.ReturnTable($@"select * from [dbo].[OrderLog_View_FunUpdate]");

            UpdateSaveChanged();
            countUpdate += ListUpdateMaterialSelect.Count;
            countUpdate += InsertComponentSaveChanged(idOrder);
            countUpdate += InsertServiceSaveChanged(idOrder);

            if (countRemove > 0 || countUpdate > 0)
            {
                sqlManager.PerformingProcedure(
                    new string[] { idOrder.ToString(), idWorkerLoging.ToString() },
                    "[dbo].[Order_update_Worker]",
                    new string[] { "ID_Order", "Worker_ID" }
                );
            }

            if (countRemove > 0 && countUpdate == 0 && listOrder.Rows[indexRowOrder].Cells[3].Value.ToString() != "Закрыт")
            {
                int countComponentWin = listSelectedMaterials.Rows.OfType<DataGridViewRow>().Where(x => Convert.ToDecimal(x.Cells[4].Value.ToString()) == Convert.ToDecimal("0,00")).Count();
                int countServiceWin = listSelectedServices.Rows.OfType<DataGridViewRow>().Where(x => x.Cells[5].Value.ToString() == "").Count();

                if (countComponentWin == 0 && countServiceWin == 0)
                {
                    string idListStatus = listListStatusId.FirstOrDefault(x => x.Value == "Закрыт").Key.ToString();
                    sqlManager.PerformingProcedure(
                        new string[] { idOrder.ToString(), idListStatus },
                        "[dbo].[Order_StatusList_update]",
                        new string[] { "ID_Order", "List_Status_ID" }
                        );

                    listOrder.Rows[indexRowOrder].Cells[3].Value = "Закрыт";
                    listOrder.Rows[indexRowOrder].DefaultCellStyle.BackColor = Color.Green;
                    printOrderOutfit.Enabled = true;
                }
            }
            else
            {
                if (listOrder.Rows[indexRowOrder].Cells[3].Value.ToString() != "Выполняется" && countUpdate > 0)
                {
                    string idListStatus = listListStatusId.FirstOrDefault(x => x.Value == "Выполняется").Key.ToString();

                    sqlManager.PerformingProcedure(
                        new string[] { idOrder.ToString(), idListStatus },
                        "[dbo].[Order_StatusList_update]",
                        new string[] { "ID_Order", "List_Status_ID" }
                        );
                    listOrder.Rows[indexRowOrder].Cells[3].Value = "Выполняется";
                    listOrder.Rows[indexRowOrder].DefaultCellStyle.BackColor = Color.Yellow;
                    printOrderOutfit.Enabled = false;
                }
            }

            ListDeleteService.Clear();
            ListDeleteMaterial.Clear();
            ListUpdateMaterialSelect.Clear();
            runStopService.Enabled = true;

            sqlManager.CloseConnection();

            CbTypeComponent_SelectedIndexChanged(this, new EventArgs());

            AnaliticEnableService(new DataGridViewCellEventArgs(listSelectedServices.CurrentCell.ColumnIndex, listSelectedServices.CurrentCell.RowIndex));
        }

        /// <summary>
        /// Обновление компонентов в заказ наряде
        /// </summary>
        private void UpdateSaveChanged()
        {
            DataTable itemOrdreLog = new DataTable();
            DataTable dataTableWarehouseSearth = new DataTable();
            IEnumerable<DataRow> orderLogIdComponentList = null;

            double quantityDifference = 0.0;

            foreach (var item in ListUpdateMaterialSelect)
            {
                DataGridViewRow rowMaterial = listSelectedMaterials.Rows[item.Key];

                sqlManager.PerformingProcedure(
                            new string[] { rowMaterial.Cells[1].Value.ToString(), rowMaterial.Cells[3].Value.ToString(), idWorkerLoging.ToString(), DateTime.Now.ToShortDateString() },
                            "[dbo].[Component_Order_update]",
                            new string[] { "ID_Component_Order", "Quantity_Component", "Worker_ID", "Date_Enrollment" }
                         );

                if (rowMaterial.Cells[6].Value.ToString() == "True")
                {
                    IEnumerable<DataRow> dataTableWarehouseSearthList = dataTableWarehouse.AsEnumerable().Where(x => x.Field<string>("Наименование компонента") == rowMaterial.Cells[2].Value.ToString());

                    if (dataTableWarehouseSearthList.Any())
                    {
                        dataTableWarehouseSearth = dataTableWarehouseSearthList.CopyToDataTable();

                        quantityDifference = Convert.ToDouble(dataTableWarehouseSearth.Rows[0][2].ToString()) - Convert.ToDouble(item.Value);

                        sqlManager.PerformingProcedure(
                            new string[] { dataTableWarehouseSearth.Rows[0][0].ToString(), quantityDifference.ToString() },
                            "[dbo].[Warehouse_update_Quantity]",
                            new string[] { "ID_Warehouse", "Quantity_Warehouse" }
                            );
                    }

                    double minComponent = Convert.ToDouble(rowMaterial.Cells[5].Value.ToString());
                    if (quantityDifference < minComponent)
                    {
                        if (dataTableOrderLog.Rows.Count > 0)
                        {
                            orderLogIdComponentList = dataTableOrderLog.AsEnumerable()
                                .Where(x => x.Field<int>("Номер компонента").ToString() == rowMaterial.Cells[0].Value.ToString());

                            if (orderLogIdComponentList.Any())
                            {
                                if (orderLogIdComponentList.Count() == 0)
                                {
                                    orderGeneral.SeartchOrderLogInsertConsumables(Convert.ToInt32(minComponent * 1.25).ToString(), rowMaterial.Cells[1].Value.ToString());
                                }
                            }
                            else
                            {
                                orderGeneral.SeartchOrderLogInsertConsumables(Convert.ToInt32(minComponent * 1.25).ToString(), rowMaterial.Cells[1].Value.ToString());
                            }
                        }
                        else
                        {
                            orderGeneral.SeartchOrderLogInsertConsumables(Convert.ToInt32(minComponent * 1.25).ToString(), rowMaterial.Cells[1].Value.ToString());
                        }

                    }
                }
            }
        }

        /// <summary>
        /// Добавление новых услуг к заказ наряду
        /// </summary>
        /// <param name="idOrder"></param>
        /// <returns></returns>
        private int InsertServiceSaveChanged(string idOrder)
        {
            List<DataGridViewRow> listServiceInsert = listSelectedServices.Rows.OfType<DataGridViewRow>()
                    .Where(x => x.Cells[1].Value.ToString().Equals(""))
                    .ToList();

            foreach (DataGridViewRow rowServiceItem in listServiceInsert)
            {
                object reader = sqlManager.PerformingProcedureReader(
                        new string[] { rowServiceItem.Cells[0].Value.ToString(), idOrder, idWorkerLoging.ToString() },
                        "[Car_Services_Provided_insert]",
                        new string[] { "List_Services_ID", "Order_ID", "Worker_ID" }
                    );
                rowServiceItem.Cells[1].Value = rowServiceItem.Cells[1].Value = reader.ToString();
            }

            return listServiceInsert.Count;
        }

        /// <summary>
        /// Добавление компонентов в заказ наряд
        /// </summary>
        /// <param name="idOrder">Номер заказ наряда</param>
        /// <returns></returns>
        private int InsertComponentSaveChanged(string idOrder)
        {
            DataTable itemOrdreLog = new DataTable();
            DataTable dataTableWarehouseSearth = new DataTable();
            IEnumerable<DataRow> orderLogIdComponentList = null;

            double quantityDifference = 0.0;

            List<DataGridViewRow> listMaterialInsert = listSelectedMaterials.Rows.OfType<DataGridViewRow>()
               .Where(x => x.Cells[1].Value.ToString().Equals(""))
               .ToList();

            foreach (DataGridViewRow rowMaterialItem in listMaterialInsert)
            {
                object reader = sqlManager.PerformingProcedureReader(
                        new string[] { rowMaterialItem.Cells[0].Value.ToString(), rowMaterialItem.Cells[3].Value.ToString(), idOrder, idWorkerLoging.ToString(), DateTime.Now.ToShortDateString(), rowMaterialItem.Cells[4].Value.ToString().Replace(",", ".") },
                        "[dbo].[Component_Order_insert]",
                        new string[] { "Component_ID", "Quantity_Component", "Order_ID", "Worker_ID", "Date_Enrollment", "Price" }
                        );
                rowMaterialItem.Cells[1].Value = reader.ToString();

                if (rowMaterialItem.Cells[6].Value.ToString() == "True")
                {
                    IEnumerable<DataRow> dataTableWarehouseSearthList = dataTableWarehouse.AsEnumerable().Where(x => x.Field<string>("Наименование компонента") == rowMaterialItem.Cells[2].Value.ToString());

                    if (dataTableWarehouseSearthList.Any())
                    {
                        dataTableWarehouseSearth = dataTableWarehouseSearthList.CopyToDataTable();

                        quantityDifference = Convert.ToDouble(dataTableWarehouseSearth.Rows[0][2].ToString()) - Convert.ToDouble(rowMaterialItem.Cells[3].Value.ToString());

                        sqlManager.PerformingProcedure(
                            new string[] { dataTableWarehouseSearth.Rows[0][0].ToString(), quantityDifference.ToString() },
                            "[dbo].[Warehouse_update_Quantity]",
                            new string[] { "ID_Warehouse", "Quantity_Warehouse" }
                            );
                    }


                    double minComponent = Convert.ToDouble(rowMaterialItem.Cells[5].Value.ToString());
                    if (quantityDifference < minComponent)
                    {
                        if (dataTableOrderLog.Rows.Count > 0)
                        {
                            orderLogIdComponentList = dataTableOrderLog.AsEnumerable()
                               .Where(x => x.Field<int>("Номер компонента").ToString() == rowMaterialItem.Cells[0].Value.ToString());

                            if (orderLogIdComponentList.Any())
                            {
                                if (orderLogIdComponentList.Count() == 0)
                                {
                                    orderGeneral.SeartchOrderLogInsertConsumables(Convert.ToInt32(minComponent * 1.25).ToString(), rowMaterialItem.Cells[1].Value.ToString());
                                }
                            }
                            else
                            {
                                orderGeneral.SeartchOrderLogInsertConsumables(Convert.ToInt32(minComponent * 1.25).ToString(), rowMaterialItem.Cells[1].Value.ToString());
                            }
                        }
                        else
                        {
                            orderGeneral.SeartchOrderLogInsertConsumables(Convert.ToInt32(minComponent * 1.25).ToString(), rowMaterialItem.Cells[1].Value.ToString());
                        }
                    }
                }
                else
                {
                    orderGeneral.SeartchOrderLogInsertIndividual(rowMaterialItem.Cells[1].Value.ToString());
                }
            }

            return listMaterialInsert.Count;
        }

        /// <summary>
        /// Обработка двойного нажатия мышю на список с услугами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void ListAvailableServices_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            int indexRow = e.RowIndex;

            if (indexRow < 0)
            {
                return;
            }

            string textSearth = listAvailableServices.Rows[indexRow].Cells[1].Value.ToString();
            int countSelectSertchService = listSelectedServices.Rows.OfType<DataGridViewRow>().Where(x => x.Cells[2].Value.ToString() == textSearth).ToList().Count;

            if (countSelectSertchService == 0)
            {
                dataService.Rows.Add(
                     listAvailableServices.Rows[indexRow].Cells[0].Value.ToString(),
                     "",
                     listAvailableServices.Rows[indexRow].Cells[1].Value.ToString(),
                     listAvailableServices.Rows[indexRow].Cells[2].Value.ToString(),
                     "", "",
                     listAvailableServices.Rows[indexRow].Cells[3].Value.ToString()
                 );
                listSelectedServices.DataSource = dataService;

                decimal sumService = Convert.ToDecimal(amountService.Text.ToString().Replace(" .руб", "")) + Convert.ToDecimal(listAvailableServices.Rows[indexRow].Cells[3].Value.ToString());
                amountService.Text = sumService.ToString() + " .руб";
                totalCost.Text = (Convert.ToDecimal(amountComponents.Text.ToString().Replace(" .руб", "")) + sumService).ToString() + " .руб";
            }

            if (listSelectedServices.Rows[listSelectedServices.CurrentCell.RowIndex].Cells[1].Value.ToString() == "")
            {
                runStopService.Enabled = false;
            }
            else
            {
                runStopService.Enabled = true;
            }

        }

        /// <summary>
        /// Обработка двойного нажатия мышю на список с материалами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void ListAvailableMaterials_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            int indexRow = e.RowIndex;

            if (indexRow < 0)
            {
                return;
            }

            string textSearth = listAvailableMaterials.Rows[indexRow].Cells[1].Value.ToString();

            int countSelectSertchMaterial = listSelectedMaterials.Rows.OfType<DataGridViewRow>().Where(x => x.Cells[2].Value.ToString().Equals(textSearth)).ToList().Count;

            if (countSelectSertchMaterial == 0)
            {
                dataMaterial.Rows.Add(
                    listAvailableMaterials.Rows[indexRow].Cells[0].Value.ToString(),
                    "",
                    listAvailableMaterials.Rows[indexRow].Cells[1].Value.ToString(),
                    "1",
                    listAvailableMaterials.Rows[indexRow].Cells[3].Value.ToString(),
                    listAvailableMaterials.Rows[indexRow].Cells[4].Value.ToString(),
                    listAvailableMaterials.Rows[indexRow].Cells[5].Value.ToString()
                );
                listSelectedMaterials.DataSource = dataMaterial;

                orderGeneral.UpdateTotalCostAndCostComponent(totalCost, amountService, amountComponents, listSelectedMaterials);
            }
        }

        /// <summary>
        /// Вывод детелей заказ наряда
        /// </summary>
        /// <param name="idOrder">Номер заказ наряда</param>
        private void OrderDetailsOutput(int idOrder)
        {
            dataService.Rows.Clear();
            dataMaterial.Rows.Clear();
            DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Car_Services_Provided_Order] ({idOrder})");

            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                dataService.Rows.Add(
                    dataTable.Rows[i][0].ToString(),
                    dataTable.Rows[i][1].ToString(),
                    dataTable.Rows[i][2].ToString(),
                    dataTable.Rows[i][3].ToString(),
                    dataTable.Rows[i][4].ToString(),
                    dataTable.Rows[i][5].ToString(),
                    dataTable.Rows[i][6].ToString()
                );
            }

            listSelectedServices.DataSource = dataService;

            dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Component_Order_Order] ({idOrder})");

            for (int i = 0; i < dataTable.Rows.Count; i++)
            {

                dataMaterial.Rows.Add(
                    dataTable.Rows[i][0].ToString(),
                    dataTable.Rows[i][1].ToString(),
                    dataTable.Rows[i][2].ToString(),
                    dataTable.Rows[i][3].ToString(),
                    dataTable.Rows[i][4].ToString(),
                    dataTable.Rows[i][5].ToString(),
                    dataTable.Rows[i][6].ToString()
                );
            }
            listSelectedMaterials.DataSource = dataMaterial;

            listSelectedServices.Columns[0].Visible = false;
            listSelectedMaterials.Columns[0].Visible = false;
        }

        /// <summary>
        /// Обработка нажатия на кнопку начала и окончания работы по машине
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RunStopService_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            int indexRowOrder = listOrder.CurrentCell.RowIndex;
            int idOrder = Convert.ToInt32(listOrder.Rows[indexRowOrder].Cells[0].Value.ToString());

            sqlManager.PerformingProcedure(
                new string[] { idOrder.ToString(), idWorkerLoging.ToString() },
                "[dbo].[Order_update_Worker]",
                new string[] { "ID_Order", "Worker_ID" }
            );

            DataGridViewRow dataGridViewRow = listSelectedServices.Rows[listSelectedServices.CurrentRow.Index];
            if (dataGridViewRow.Cells[4].Value.ToString() == "")
            {
                string startDateTime = DateTime.Now.ToString();
                sqlManager.PerformingProcedure(
                    new string[] { dataGridViewRow.Cells[1].Value.ToString(), startDateTime, idOrder.ToString(), idWorkerLoging.ToString() },
                    "[dbo].[Car_Services_Provided_Start_Time_update]",
                    new string[] { "ID_Car_Services_Provided", "Start_Date", "Order_ID", "Worker_ID" }
                );
                dataGridViewRow.Cells[4].Value = startDateTime;
            }
            else
            {
                string endDateTime = DateTime.Now.ToString();

                sqlManager.PerformingProcedure(
                    new string[] { dataGridViewRow.Cells[1].Value.ToString(), endDateTime, idWorkerLoging.ToString(), idOrder.ToString() },
                    "[dbo].[Car_Services_Provided_End_Time_update]",
                    new string[] { "ID_Car_Services_Provided", "End_Date", "Worker_ID", "Order_ID" }
                    );
                dataGridViewRow.Cells[5].Value = endDateTime;
            }

            runStopService.Text = "Закончить выполнение";

            int countComponentWin = listSelectedMaterials.Rows.OfType<DataGridViewRow>().Where(x => Convert.ToDecimal(x.Cells[4].Value.ToString()) == Convert.ToDecimal("0,00")).Count();
            int countServiceWin = listSelectedServices.Rows.OfType<DataGridViewRow>().Where(x => x.Cells[5].Value.ToString() == "").Count();
            if (countComponentWin == 0 && countServiceWin == 0)
            {
                string idListStatus = listListStatusId.FirstOrDefault(x => x.Value == "Закрыт").Key.ToString();
                sqlManager.PerformingProcedure(
                    new string[] { idOrder.ToString(), idListStatus },
                    "[dbo].[Order_StatusList_update]",
                    new string[] { "ID_Order", "List_Status_ID" }
                    );

                listOrder.Rows[indexRowOrder].Cells[3].Value = "Закрыт";
                listOrder.Rows[indexRowOrder].DefaultCellStyle.BackColor = Color.Green;
                printOrderOutfit.Enabled = true;
                return;
            }

            if (listOrder.Rows[indexRowOrder].Cells[3].Value.ToString() != "Выполняется")
            {
                string idListStatus = listListStatusId.FirstOrDefault(x => x.Value == "Выполняется").Key.ToString();

                sqlManager.PerformingProcedure(
                    new string[] { idOrder.ToString(), idListStatus },
                    "[dbo].[Order_StatusList_update]",
                    new string[] { "ID_Order", "List_Status_ID" }
                    );
                listOrder.Rows[indexRowOrder].Cells[3].Value = "Выполняется";
                listOrder.Rows[indexRowOrder].DefaultCellStyle.BackColor = Color.Yellow;
                printOrderOutfit.Enabled = false;
            }

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия на список с выбранными услугами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListSelectedServices_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0)
            {
                return;
            }

            AnaliticEnableService(e);
        }

        /// <summary>
        /// Аналитика кнопки для завершения и начала работ по услуги
        /// </summary>
        /// <param name="e"></param>
        private void AnaliticEnableService(DataGridViewCellEventArgs e) {
            if (listSelectedServices.Rows[e.RowIndex].Cells[1].Value.ToString() == "")
            {
                runStopService.Enabled = false;
            }
            else
            {
                runStopService.Enabled = true;
            }

            if (listSelectedServices.Rows[e.RowIndex].Cells[4].Value.ToString() == "")
            {
                runStopService.Text = "Начать выполнение";
            }
            else
            {
                runStopService.Text = "Закончить выполнение";
            }
        }

        /// <summary>
        /// Обработка начала редактирования списка с выбраными материалами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListSelectedMaterials_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            TextBox quantity_text_box = (TextBox)e.Control;
            quantity_text_box.KeyPress += new KeyPressEventHandler(Quantity_text_box_KeyPress);
            initialQuantity = listSelectedMaterials.Rows[listSelectedMaterials.CurrentRow.Index].Cells[3].Value.ToString();
        }

        /// <summary>
        /// Обработка наджатия на кнопку в поле с колличеством используемых материалов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Quantity_text_box_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsDigit(e.KeyChar) && e.KeyChar != (char)Keys.Back)
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Обработка события окончания редактирования колличества выбраных материалов 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListSelectedMaterials_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            DataGridViewRow row = listSelectedMaterials.Rows[e.RowIndex];
            string item = row.Cells[1].Value.ToString();
            double countMatrial = Convert.ToDouble(row.Cells[3].Value.ToString());

            if (Convert.ToDouble(row.Cells[3].Value.ToString()) < 1.00)
            {
                row.Cells[3].Value = initialQuantity;
                return;
            }

            if (item != "")
            {
                var IsSearth = ListUpdateMaterialSelect.TryGetValue(e.RowIndex, out _);

                if (IsSearth)
                {
                    ListUpdateMaterialSelect.Remove(e.RowIndex);
                }

                if (Convert.ToDouble(initialQuantity) != countMatrial)
                {
                    ListUpdateMaterialSelect.Add(e.RowIndex, (Convert.ToDouble(countMatrial) - Convert.ToDouble(initialQuantity)).ToString());
                }
            }

            orderGeneral.UpdateTotalCostAndCostComponent(totalCost, amountService, amountComponents, listSelectedMaterials);
        }

        /// <summary>
        /// Выбор группы услуг с подгрузкой услуг относящихся к этой группе
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CbServiceGroup_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            string cbServiceGroupText = cbServiceGroup.Text;
            if (cbServiceGroupText == "Все")
            {
                sqlManager.GetList(listAvailableServices, "[dbo].[List_Services]", $@"select * from [dbo].[List_Service_View]");
            }
            else
            {
                sqlManager.GetList(listAvailableServices, "[dbo].[List_Services]", $@"select * from [dbo].[Search_ServiceName_ServiceGroup] (N'{cbServiceGroupText}')");
            }

            listAvailableServices.Columns[2].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listAvailableServices.Columns[3].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обрботка нажатия на кнопку клавиатуры для поиска материалов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SearchMaterial_TextChanged(object sender, EventArgs e)
        {
            (listAvailableMaterials.DataSource as DataTable).DefaultView.RowFilter = $"[{listAvailableMaterials.Columns[1].Name}] LIKE '{searchMaterial.Text}%'";
        }

        /// <summary>
        /// Обработка нажатия на картинку для обновления списка заказ нарядов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RefreshOrder_Click(object sender, EventArgs e)
        {
            CbFilterOrderStatus_SelectedIndexChanged(this, new EventArgs());
            orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);
        }

        /// <summary>
        /// Выбор группы компонентов с подгрузкой компонентов относящихся к этой группе
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CbTypeComponent_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            if (cbTypeComponent.SelectedItem.ToString() == "Расходники")
            {
                sqlManager.GetList(listAvailableMaterials, "[dbo].[Warehouse]", $@"select * from [dbo].[Warehouse_Component_View] ({idBranchLogin})");
                listAvailableMaterials.Columns[2].Visible = true;
                listAvailableMaterials.Columns[3].Visible = true;
            }
            else
            {
                sqlManager.GetList(listAvailableMaterials, "[dbo].[Component]", $@"select * from [dbo].[Warehouse_Component_List_View]");
                listAvailableMaterials.Columns[2].Visible = false;
                listAvailableMaterials.Columns[3].Visible = false;
            }

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия на кнопку обновления реестров компонентов и услуг для выбора
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void UpdateRegistryLists_Click(object sender, EventArgs e)
        {
            CbTypeComponent_SelectedIndexChanged(this, new EventArgs());
            CbServiceGroup_SelectedIndexChanged(this, new EventArgs());
        }
    }
}