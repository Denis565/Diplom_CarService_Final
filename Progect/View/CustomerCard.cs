using Progect.Custom;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс формы с основной информацией об клиенте
    /// </summary>
    public partial class CustomerCard : Form
    {
        private readonly OrderGeneral orderGeneral = new OrderGeneral();
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();

        public int idClient;
        private int idWorkerLoging;
        private int idBranchLogin;

        private string initialQuantity;

        private readonly DataTable dataService = new DataTable();
        private readonly DataTable dataMaterial = new DataTable();
        private DataGridView clientList = new DataGridView();

        private DataTable dataTableWarehouse = new DataTable();
        private DataTable dataTableOrderLog = new DataTable();

        private readonly List<int> ListDeleteService = new List<int>();
        private readonly List<int> ListDeleteMaterial = new List<int>();
        private readonly Dictionary<int, string> ListUpdateMaterialSelect = new Dictionary<int, string>();

        public int IDWorkers { set { idWorkerLoging = value; } }
        public int IDBranch { set { idBranchLogin = value; } }
        public DataGridView ClientList { set { clientList = value; } }
        public int IDClient { set { idClient = value; } }

        /// <summary>
        /// Инициализация компонентов
        /// </summary>
        public CustomerCard()
        {
            InitializeComponent();
        }


        /// <summary>
        /// Загрузка формы с первичными данными
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CustomerCard_Load(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            Init();
        }

        /// <summary>
        /// Настройка и заполнение списков
        /// </summary>
        private async void Init()
        {
            orderGeneral.DateSelected(dataService, dataMaterial, listSelectedServices, listSelectedMaterials);

            await Task.Run(() =>
            {
                clientList.Invoke(new Action<DataGridView>((dgv) =>
                {
                    sqlManager.GetList(dgv, "[dbo].[Customers_Machines]", $@"select * from [dbo].[Car_Client_View] ({idClient})");
                    listCar.DefaultCellStyle.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
                    listCar.AllowUserToAddRows = false;
                    listCar.ReadOnly = true;
                    listOrder.AllowUserToAddRows = false;
                }), listCar);

                if (listCar.Rows.Count > 0)
                {
                    listCar.CurrentCell = listCar.Rows[0].Cells[0];

                    CbFilterOrderStatus_SelectedIndexChanged_Function();
                    listOrder.Columns[0].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
                    listOrder.DefaultCellStyle.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
                    listOrder.ReadOnly = true;
                }

                if (listOrder.Rows.Count > 0)
                {
                    orderGeneral.EnabledButtonPrint(0, listOrder, printOrderOutfit);
                    int idOrder = Convert.ToInt32(listOrder.Rows[0].Cells[0].Value.ToString());
                    OrderDetailsOutput(idOrder);
                }

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
                cbTypeComponent.Items.AddRange(new string[] { "Расходники", "Индивидуальные" });
                cbTypeComponent.SelectedIndex = 0;
                cbFilterOrderStatus.SelectedIndex = 1;

                sqlManager.CloseConnection();
            });
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
        /// Обработка нажатия на список с машинами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListCar_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            sqlManager.OpenConnection();
            if (listCar.Rows.Count > 0)
            {
                CbFilterOrderStatus_SelectedIndexChanged_Function();
                orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);
                ListOrder_CellClick(this, new DataGridViewCellEventArgs(0, 0));
            }
            else
            {
                int rowsCount = listOrder.Rows.Count;
                for (int i = 0; i < rowsCount; i++)
                {
                    listOrder.Rows.Remove(listOrder.Rows[0]);
                }
            }

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия на список с заказ нарядами
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
        /// Обработка нажатия на кнопку для перехода на форму по созданию машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AddCar_Click(object sender, EventArgs e)
        {
            CarAddUpdate carAdd = new CarAddUpdate
            {
                IDClient = idClient,
                DGVListCar = listCar,
                TextFilter = cbFilterOrderStatus
            };
            carAdd.Show();
        }

        /// <summary>
        /// Обработка нажатия на кнопку для перехода на форму по изменению машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void UpdateCar_Click(object sender, EventArgs e)
        {
            CarAddUpdate carUpdate = new CarAddUpdate
            {
                IDClient = idClient,
                DGVCar = listCar,
                IsStatusUpdate = true,
                TextFilter = cbFilterOrderStatus
            };
            carUpdate.Show();
        }

        /// <summary>
        /// Обработка нажатия на кнопку для создания нового заказ наряда
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CreateOrder_Click(object sender, EventArgs e)
        {
            if (listCar.Rows.Count > 0)
            {
                sqlManager.OpenConnection();
                string vinStr = listCar.Rows[listCar.CurrentRow.Index].Cells[0].Value.ToString();

                var result = sqlManager.PerformingProcedure(new string[] { vinStr, DateTime.Now.ToShortDateString(), idBranchLogin.ToString(), idWorkerLoging.ToString() },
                    "[dbo].[Order_insert]",
                    new string[] { "VIN", "Date_Receipt", "Branch_ID", "Worker_ID" }
                   );

                if (!result)
                {
                    return;
                }

                CbFilterOrderStatus_SelectedIndexChanged_Function();
                listOrder.Columns[0].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
                orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);
                sqlManager.CloseConnection();
            }
            else
            {
                MessageBox.Show("Внесите машину клиента в реестр.");
            }
        }

        /// <summary>
        /// Печать заказ наряда
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void PrintOrderOutfit_Click(object sender, EventArgs e)
        {
            ListOrder_CellClick(this, new DataGridViewCellEventArgs(0, listOrder.CurrentRow.Index));
            string fileNameDefault = $@"Заказ наряд №{Convert.ToInt32(listOrder.Rows[listOrder.CurrentRow.Index].Cells[0].Value)} от {DateTime.Now:D}";
            saveFileDialog.FileName = fileNameDefault.Substring(0, fileNameDefault.Length - 1);
            saveFileDialog.Filter = "DOC (.doc)|*.doc|DOCX (.docx)|*.docx";
            DialogResult res = saveFileDialog.ShowDialog();
            if (res.Equals(DialogResult.OK))
            {
                var path = saveFileDialog.FileName;

                bool status = new Custom.WordManager()
                {
                    dataGridViewRowOrder = listOrder.Rows[listOrder.CurrentCell.RowIndex],
                    dataGridViewRowClient = clientList.Rows[clientList.CurrentCell.RowIndex],
                    listSelectService = listSelectedServices,
                    listSelectMaterial = listSelectedMaterials,
                    listSelectCar = listCar,
                    adminLoginWorker = true
                }.CreateSmeta(path, fileNameDefault);

                if (!status)
                {
                    return;
                }

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

                Process.Start(path);
            }
        }

        /// <summary>
        /// Удаление материала из списка для деталей заказ наряда
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
        /// Удаление выполненых работ из списка для деталей заказ наряда
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DeleteService_Click(object sender, EventArgs e)
        {
            int index = listSelectedServices.CurrentRow.Index;
            DataGridViewRow dataRow = listSelectedServices.Rows[index];

            orderGeneral.DeleteSelectService(totalCost, amountService, amountComponents, dataRow.Cells[6].Value.ToString());

            if (dataRow.Cells[1].Value.ToString() != "")
            {
                ListDeleteService.Add(Convert.ToInt32(dataRow.Cells[1].Value.ToString()));
            }

            listSelectedServices.Rows.RemoveAt(index);
        }

        /// <summary>
        /// Обработка нажатия на кнопку сохранения детелей заказ наряда. 
        /// Сохранение деталей заказ наряда.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveServiceMaterial_Click(object sender, EventArgs e)
        {
            if (listOrder.Rows.Count <= 0)
            {
                return;
            }

            sqlManager.OpenConnection();

            int indexRowOrder = listOrder.CurrentCell.RowIndex;
            string idOrder = listOrder.Rows[indexRowOrder].Cells[0].Value.ToString();

            foreach (int idServiceDelete in ListDeleteService)
            {
                sqlManager.PerformingProcedure(new string[] { idServiceDelete.ToString() }, "[dbo].[Car_Services_Provided_delete]", new string[] { "ID_Car_Services_Provided" });
            }

            foreach (int idMaerialDelete in ListDeleteMaterial)
            {
                sqlManager.PerformingProcedure(new string[] { idMaerialDelete.ToString() }, "[dbo].[Component_Order_delete]", new string[] { "ID_Component_Order" });
            }

            dataTableWarehouse = sqlManager.ReturnTable($@"select * from [dbo].[Warehouse_Component_View_FuncUpdate] ({idBranchLogin})");
            dataTableOrderLog = sqlManager.ReturnTable($@"select * from [dbo].[OrderLog_View_FunUpdate]");

            UpdateSaveChanged();
            InsertSaveChanged(idOrder);

            ListDeleteService.Clear();
            ListDeleteMaterial.Clear();
            ListUpdateMaterialSelect.Clear();

            CbTypeComponent_SelectedIndexChanged(this, new EventArgs());

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обновление списка услуг в заказ наряде
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
        /// Добавление компонентов в список к заказ наряду
        /// </summary>
        /// <param name="idOrder">Номер заказ наряда</param>
        private void InsertSaveChanged(string idOrder)
        {
            DataTable itemOrdreLog = new DataTable();
            DataTable dataTableWarehouseSearth = new DataTable();
            IEnumerable<DataRow> orderLogIdComponentList = null;

            double quantityDifference = 0.0;

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
                rowServiceItem.Cells[1].Value = reader.ToString();
            }

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
        /// Двойное нажатие на список с материалами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListAvailableMaterials_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            int indexRow = e.RowIndex;
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
        /// Обработка остоновки редактирования DataGridView
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
        /// Обработка двойного нажатия на список с услугами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListAvailableServices_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            int indexRow = e.RowIndex;
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
        /// Обрботка нажатия на кнопку клавиатуры для поиска материалов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SearchMaterial_TextChanged(object sender, EventArgs e)
        {
            (listAvailableMaterials.DataSource as DataTable).DefaultView.RowFilter = $"[{listAvailableMaterials.Columns[1].Name}] LIKE '{searchMaterial.Text}%'";
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
        /// Обработка выбора из выпадающего спсика статуса заказ наряда для выведения в DataGridView
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CbFilterOrderStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            CbFilterOrderStatus_SelectedIndexChanged_Function();
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Выбор статуса заказ наряда для фильтрациию И вывод заказ нарядов
        /// </summary>
        private void CbFilterOrderStatus_SelectedIndexChanged_Function()
        {
            string cbFilterOrderStatusText = cbFilterOrderStatus.Text;

            if (listCar.Rows.Count > 0)
            {
                int rowindexCar = listCar.CurrentCell.RowIndex;
                if (cbFilterOrderStatusText == "Все")
                {
                    sqlManager.GetList(listOrder, "[dbo].[Order]", $@"select * from [dbo].[Search_Order_Car_Admin] (N'{listCar.Rows[rowindexCar].Cells[0].Value}',{idBranchLogin})");
                }
                else
                {
                    sqlManager.GetList(listOrder, "[dbo].[Order]", $@"select * from [dbo].[Search_Order_Car_Filter_Admin] (N'{listCar.Rows[rowindexCar].Cells[0].Value}', N'{cbFilterOrderStatusText}',{idBranchLogin})");
                }

                if (listOrder.Rows.Count > 0)
                {
                    ListOrder_CellClick(this, new DataGridViewCellEventArgs(0, 0));
                    orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);
                }
            }
        }

        /// <summary>
        /// Запрет на сортировку по нажаию на заголовки в DataGridView с машинами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListCar_ColumnStateChanged(object sender, DataGridViewColumnStateChangedEventArgs e)
        {
            e.Column.SortMode = DataGridViewColumnSortMode.NotSortable;
        }

        /// <summary>
        /// Запрет на сортировку по нажаию на заголовки в DataGridView с заказ нарядами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListOrder_ColumnStateChanged(object sender, DataGridViewColumnStateChangedEventArgs e)
        {
            e.Column.SortMode = DataGridViewColumnSortMode.NotSortable;
        }

        /// <summary>
        /// Обработка нажатия на слои приложения
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ScreenLayers_SelectedIndexChanged(object sender, EventArgs e)
        {
            Thread.Sleep(1);
            if (screenLayers.SelectedTab.Text == "Заказ наряды")
            {
                orderGeneral.AnaliticStatusOrder(listOrder, cbFilterOrderStatus.Text);
                if (listOrder.Rows.Count > 0)
                {
                    orderGeneral.EnabledButtonPrint(listOrder.CurrentCell.RowIndex, listOrder, printOrderOutfit);
                }
                else
                {
                    printOrderOutfit.Enabled = false;
                }

            }
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
        private void UpdateRegistryList_Click(object sender, EventArgs e)
        {
            CbTypeComponent_SelectedIndexChanged(this, new EventArgs());
            CbServiceGroup_SelectedIndexChanged(this, new EventArgs());
        }
    }
}
