using Progect.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Progect.Custom
{
    /// <summary>
    /// Класс с наиболее часто используемыми методами для работы с заказ нарядами
    /// </summary>
    public class OrderGeneral
    {
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();
        /// <summary>
        /// Создание шаблона для кастомного DataGridView
        /// </summary>
        /// <param name="dataService">DataTable услуг</param>
        /// <param name="dataMaterial">DataTable материалов</param>
        /// <param name="listSelectedServices">DataGridView услуг</param>
        /// <param name="listSelectedMaterials">DataGridView выбранных материалов</param>
        public void DateSelected(DataTable dataService, DataTable dataMaterial, DataGridView listSelectedServices, DataGridView listSelectedMaterials)
        {
            dataService.Columns.Add(new DataColumn("Номер сервиса", typeof(string)));
            dataService.Columns.Add(new DataColumn("Номер в заказ наряде", typeof(string)));
            dataService.Columns.Add(new DataColumn("Наименование услуги", typeof(string)));
            dataService.Columns.Add(new DataColumn("Норма-часа", typeof(string)));
            dataService.Columns.Add(new DataColumn("Дата начала", typeof(string)));
            dataService.Columns.Add(new DataColumn("Дата завершения", typeof(string)));
            dataService.Columns.Add(new DataColumn("Стоисмость в руб", typeof(string)));
            listSelectedServices.DataSource = dataService;
            listSelectedServices.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            listSelectedServices.Columns[4].AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            listSelectedServices.Columns[5].AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            listSelectedServices.Columns[6].AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;

            dataMaterial.Columns.Add(new DataColumn("Номер компонента", typeof(string)));
            dataMaterial.Columns.Add(new DataColumn("Номер компонента в списке с израсходуемыми компонентами", typeof(string)));
            dataMaterial.Columns.Add(new DataColumn("Наименование материала", typeof(string)));
            dataMaterial.Columns.Add(new DataColumn("Количество", typeof(string)));
            dataMaterial.Columns.Add(new DataColumn("Стоимость в руб", typeof(string)));
            dataMaterial.Columns.Add(new DataColumn("Минимальное количесто", typeof(string)));
            dataMaterial.Columns.Add(new DataColumn("Тип расходник", typeof(string)));
            listSelectedMaterials.DataSource = dataMaterial;
            listSelectedMaterials.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            listSelectedMaterials.Columns[3].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;
            listSelectedMaterials.Columns[4].AutoSizeMode = DataGridViewAutoSizeColumnMode.DisplayedCells;

            listSelectedServices.AllowUserToAddRows = false;
            listSelectedServices.ReadOnly = true;
            listSelectedServices.Columns[0].Visible = false;
            listSelectedServices.Columns[1].Visible = false;
            listSelectedServices.Columns[3].Visible = false;

            listSelectedMaterials.AllowUserToAddRows = false;
            listSelectedMaterials.Columns[0].Visible = false;
            listSelectedMaterials.Columns[1].Visible = false;
            listSelectedMaterials.Columns[5].Visible = false;
            listSelectedMaterials.Columns[6].Visible = false;
            listSelectedMaterials.Columns[2].ReadOnly = true;
            listSelectedMaterials.Columns[5].ReadOnly = true;
        }

        /// <summary>
        /// Анализ цвета в зависемости от от статуса заказ наряда
        /// </summary>
        /// <param name="status">Наименование статуса</param>
        /// <returns></returns>
        public Color AnaliticStatusOrder(string status)
        {
            switch (status)
            {
                case "Открыт":
                    return Color.Red;
                case "Закрыт":
                    return Color.Green;
                case "Выполняется":
                    return Color.Yellow;
                default: return Color.White;
            }
        }

        /// <summary>
        /// Аналитика заказ наряда
        /// </summary>
        /// <returns></returns>
        public async void AnaliticStatusOrder(DataGridView dataGridView, string cbFilterText, int indexAnaliticValue = 3)
        {
            await Task.Run(() =>
            {
                Color color = AnaliticStatusOrder(cbFilterText);
                if (color == Color.White)
                {
                    foreach (DataGridViewRow row in dataGridView.Rows)
                    {
                        switch (row.Cells[indexAnaliticValue].Value.ToString())
                        {
                            case "Открыт":
                                row.DefaultCellStyle.BackColor = Color.Red;
                                break;

                            case "Закрыт":
                                row.DefaultCellStyle.BackColor = Color.Green;
                                break;

                            case "Выполняется":
                                row.DefaultCellStyle.BackColor = Color.Yellow;
                                break;
                        }
                    }
                }
                else
                {
                    dataGridView.DefaultCellStyle.BackColor = color;
                }
            });
        }

        /// <summary>
        /// Подсчет стоимостей по заказ наряду
        /// </summary>
        /// <param name="dgvComponent"></param>
        /// <param name="dgvService"></param>
        /// <returns></returns>
        public List<decimal> TotalCostOrder(DataGridView dgvComponent, DataGridView dgvService)
        {
            decimal costComponent = decimal.Parse("0,0");
            decimal costService = decimal.Parse("0,0");

            if (dgvComponent.Rows.Count > 0)
            {
                costComponent = ((DataTable)dgvComponent.DataSource).AsEnumerable().Sum(x => (decimal.Parse(x[4].ToString()) * decimal.Parse(x[3].ToString())));
            }
            if (dgvService.Rows.Count > 0)
            {
                costService = ((DataTable)dgvService.DataSource).AsEnumerable().Sum(x => decimal.Parse(x[6].ToString()));
            }

            return new List<decimal>() { costComponent, costService, costComponent + costService };
        }

        /// <summary>
        /// Обновление значений стоимостей в итоге и в материалах
        /// </summary>
        /// <param name="totalCost">Label итоговой стоимости </param>
        /// <param name="amountService">Label итоговой сттоимости по услугам</param>
        /// <param name="amountComponent">Label итоговой стоимости по материалам</param>
        /// <param name="listSelectedMaterials">DataGridView выбранных материалов</param>
        public void UpdateTotalCostAndCostComponent(Label totalCost, Label amountService, Label amountComponent, DataGridView listSelectedMaterials)
        {
            decimal sumComponent = ((DataTable)listSelectedMaterials.DataSource).AsEnumerable().Sum(x => (decimal.Parse(x[4].ToString()) * decimal.Parse(x[3].ToString())));
            amountComponent.Text = sumComponent.ToString() + " .руб";
            decimal sumService = Convert.ToDecimal(amountService.Text.ToString().Replace(" .руб", ""));
            totalCost.Text = (sumComponent + sumService).ToString() + " .руб";
        }

        /// <summary>
        /// Обновление итоговой стоимости и услуг при удаление услуги
        /// </summary>
        /// <param name="totalCost">Label итоговой стоимости </param>
        /// <param name="amountService">Label итоговой сттоимости по услугам</param>
        /// <param name="amountComponents">Label итоговой стоимости по материалам</param>
        /// <param name="deleteItem">Стоимость элемента для удаления</param>
        public void DeleteSelectService(Label totalCost, Label amountService, Label amountComponents, string deleteItem)
        {
            decimal sumService = Convert.ToDecimal(amountService.Text.ToString().Replace(" .руб", "")) - Convert.ToDecimal(deleteItem);
            amountService.Text = sumService.ToString() + " .руб";
            totalCost.Text = (sumService + Convert.ToDecimal(amountComponents.Text.ToString().Replace(" .руб", ""))).ToString() + " .руб";
        }

        /// <summary>
        /// Работа с марками и моделями машин
        /// </summary>
        /// <param name="comboBoxStampCar">Выпадающий список марок</param>
        /// <param name="comboBoxModelCar">Выпадающий список моделей</param>
        /// <param name="dataGridView">Список с сопоставленными марками и моделями</param>
        /// <param name="callback">Метод для передачи значений</param>
        public void MatchingMachines(DataGridViewComboBoxColumn comboBoxStampCar, DataGridViewComboBoxColumn comboBoxModelCar, DataGridView dataGridView, Action<List<CarStamp>, List<CarModel>> callback)
        {
            comboBoxStampCar.DataSource = null;
            comboBoxModelCar.DataSource = null;

            DataTable dataTableStampCar = sqlManager.ReturnTable("select * from [dbo].[Car_Brand_List]");
            DataTable dataTableModelCar = sqlManager.ReturnTable("select * from [dbo].[Car_Model_List]");

            List<CarStamp> listStampCar = new List<CarStamp>();
            List<CarModel> listModelCar = new List<CarModel>();

            comboBoxStampCar.Items.AddRange(
                dataTableStampCar
                    .Rows.Cast<DataRow>()
                    .Select(col => col[1].ToString())
                    .ToArray());

            ((DataGridViewComboBoxColumn)dataGridView.Columns[comboBoxStampCar.Name]).DataSource = comboBoxStampCar.Items;

            comboBoxModelCar.Items.AddRange(
                dataTableModelCar
                .Rows.Cast<DataRow>()
                .Select(col => col[1].ToString())
                .ToArray());

            ((DataGridViewComboBoxColumn)dataGridView.Columns[comboBoxModelCar.Name]).DataSource = comboBoxModelCar.Items;

            sqlManager.GetList(dataGridView, "[dbo].[Brand_Model_Compliance]", "select * from [dbo].[BrandModelCompliance_List]");

            listStampCar.AddRange(
                dataTableStampCar.Rows.OfType<DataRow>().Select(col => new CarStamp
                {
                    ID = Convert.ToInt32(col[0].ToString()),
                    Name_Stemp_Car = col[1].ToString()
                }).ToArray()
            );

            listModelCar.AddRange(
                dataTableModelCar.Rows.OfType<DataRow>().Select(col => new CarModel
                {
                    ID = Convert.ToInt32(col[0].ToString()),
                    Name_Model_Car = col[1].ToString()
                }).ToArray()
            );

            callback(listStampCar, listModelCar);
        }

        /// <summary>
        /// Метод определяющий возможность взаимодействовать с кнопкой направления на печать заказ наряда
        /// </summary>
        /// <param name="indexOrder">Индекс строки с заказ нарядами</param>
        /// <param name="listOrder">Список с заказ нарядами</param>
        /// <param name="printOrderOutfit">Кнопка для печати</param>
        public bool EnabledButtonPrint(int indexOrder, DataGridView listOrder, ToolStripMenuItem printOrderOutfit)
        {
            if (listOrder.Rows[indexOrder].Cells[3].Value.ToString() == "Закрыт")
            {
                printOrderOutfit.Enabled = true;
                return true;
            }

            printOrderOutfit.Enabled = false;
            return false;
        }

        /// <summary>
        /// Метод добавления записи в журнал заказов
        /// </summary>
        /// <param name="difference">Колличество компонента</param>
        /// <param name="component_order_id">Номер компонента из списка компонентов с заказ нарядом</param>
        public bool SeartchOrderLogInsertConsumables(string difference, string component_order_id)
        {
            return sqlManager.PerformingProcedure(
                new string[] { component_order_id, difference },
                "[dbo].[OrderLog_insert_Consumables]",
                new string[] { "Component_Order_ID", "Quantity_Component" }
            );
        }

        /// <summary>
        /// Добавление в журнал заказов новой заявки с индивидуальным компонентом
        /// </summary>
        /// <param name="component_order_id">Номер компонента из списка компонентов с заказ нарядом</param>
        public bool SeartchOrderLogInsertIndividual(string component_order_id)
        {
            return sqlManager.PerformingProcedure(
                new string[] { component_order_id },
                "[dbo].[OrderLog_insert_Individual]",
                new string[] { "Component_Order_ID" }
            );
        }

        /// <summary>
        /// Добавление заявки в список с заявками
        /// </summary>
        /// <param name="componentId">Номер компонента</param>
        /// <param name="idBranch">Номер филиала</param>
        /// <param name="idWorker">Номер работника создавшего заявку</param>
        /// <param name="quantityComponent">Колличество компонента для заявки</param>
        public bool InsertApplication(string componentId, string idBranch, string idWorker, string quantityComponent)
        {
            return sqlManager.PerformingProcedure(
                new string[] { componentId, idBranch, idWorker, DateTime.Now.ToShortDateString(), quantityComponent },
                "[dbo].[Application_insert]",
                new string[] { "Component_ID", "Branch_ID", "Worker_ID", "Date_Creation", "Quantity_Component" }
            );
        }
    }
}
