using Progect.Custom;
using System;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс формы для создания заявки на закупку
    /// </summary>
    public partial class CreatingOrderComponents : Form
    {
        private string idBranchLogin;
        private string idWorker;
        public string IDBranch { set { idBranchLogin = value; } }
        public string IDWorker { set { idWorker = value; } }

        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();
        private readonly DataTable listComponentDataTable = new DataTable();
        private TextBox quantitytextboxTabPageOrderLog;
        private string initialApplication;
        private readonly OrderGeneral orderGeneral = new OrderGeneral();

        /// <summary>
        /// Инициализация компонентов
        /// </summary>
        public CreatingOrderComponents()
        {
            InitializeComponent();
            sqlManager.OpenConnection();
            Init();
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Настройка и заполнение списков
        /// </summary>
        private void Init()
        {
            sqlManager.GetList(listComponentTypeConsumable, "[dbo].[Component]", "select * from [dbo].[Component_TypeConsumable_View]");
            listComponentTypeConsumable.AllowUserToDeleteRows = false;
            listComponentTypeConsumable.ReadOnly = true;
            listComponentTypeConsumable.AllowUserToAddRows = false;
            listComponentTypeConsumable.Columns[0].Visible = false;
            listComponentTypeConsumable.Font = new Font("Arial", 13, GraphicsUnit.Pixel);

            listComponentDataTable.Columns.Add(new DataColumn("Номер компонента", typeof(string)));
            listComponentDataTable.Columns.Add(new DataColumn("Наименование материала", typeof(string)));
            listComponentDataTable.Columns.Add(new DataColumn("Колличество", typeof(string)));

            listSelectedComponentTypeConsumable.DataSource = listComponentDataTable;
            listSelectedComponentTypeConsumable.AllowUserToAddRows = false;
            listSelectedComponentTypeConsumable.Columns[1].ReadOnly = true;
            listSelectedComponentTypeConsumable.Columns[0].Visible = false;
            listSelectedComponentTypeConsumable.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            listSelectedComponentTypeConsumable.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            listSelectedComponentTypeConsumable.Columns[2].AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
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
        /// Обновление списка с расходными компонентами
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RefreshComponentTypeConsumable_Click(object sender, EventArgs e)
        {
            sqlManager.OpenConnection();
            sqlManager.GetList(listComponentTypeConsumable, "[dbo].[Component]", "select * from [dbo].[Component_TypeConsumable_View]");
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Обработка нажатия на кнопки при введение количества
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
        /// Окончание работы с редактированием выбранных элементов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListSelectedComponentTypeConsumable_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (!string.IsNullOrEmpty(listSelectedComponentTypeConsumable.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString()))
            {
                string textInput = listSelectedComponentTypeConsumable.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString();

                if (textInput == initialApplication)
                {
                    return;
                }

                if (Convert.ToDouble(listSelectedComponentTypeConsumable.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString()) < 1)
                {
                    listSelectedComponentTypeConsumable.Rows[e.RowIndex].Cells[e.ColumnIndex].Value = initialApplication;
                }
            }
            else
            {
                listSelectedComponentTypeConsumable.Rows[e.RowIndex].Cells[e.ColumnIndex].Value = initialApplication;
            }
        }

        /// <summary>
        /// Начало работы с редактированием выбранных элементов
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListSelectedComponentTypeConsumable_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            quantitytextboxTabPageOrderLog = (TextBox)e.Control;
            quantitytextboxTabPageOrderLog.KeyPress -= new KeyPressEventHandler(QuantityDecimalOrdreLog_KeyPress);
            quantitytextboxTabPageOrderLog.KeyPress += new KeyPressEventHandler(QuantityDecimalOrdreLog_KeyPress);
            initialApplication = listSelectedComponentTypeConsumable.Rows[listSelectedComponentTypeConsumable.CurrentRow.Index].Cells[2].Value.ToString();
        }

        /// <summary>
        /// Обработка двойного нажатия на компоненты в списке с расходными компонентами для выбора
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListComponentTypeConsumable_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            int countSelectSertchMaterial = 0;
            int indexRow = listComponentTypeConsumable.CurrentCell.RowIndex;

            string textSearth = listComponentTypeConsumable.Rows[indexRow].Cells[1].Value.ToString();

            countSelectSertchMaterial = listSelectedComponentTypeConsumable.Rows.OfType<DataGridViewRow>()
                    .Where(x => x.Cells[0].Value != null)
                    .Where(x => x.Cells[1].Value.ToString().Equals(textSearth)).ToList().Count;
            if (countSelectSertchMaterial == 0)
            {
                listComponentDataTable.Rows.Add(
                    listComponentTypeConsumable.Rows[indexRow].Cells[0].Value.ToString(),
                    listComponentTypeConsumable.Rows[indexRow].Cells[1].Value.ToString(),
                    "1"
                );
                listSelectedComponentTypeConsumable.DataSource = listComponentDataTable;
            }
        }

        /// <summary>
        /// Добавление заявки в журнал заявкок
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AddListOrders_Click(object sender, EventArgs e)
        {
            listSelectedComponentTypeConsumable.EndEdit();
            int count = listSelectedComponentTypeConsumable.Rows.OfType<DataGridViewRow>()
                .Where(x => x.Cells[0].Value != null)
                .Where(x => Convert.ToDouble(x.Cells[2].Value.ToString()).Equals(0.00)).Count();

            if (count > 0)
            {
                MessageBox.Show("Задайте количество для заявки.");
            }
            else
            {
                sqlManager.OpenConnection();
                foreach (DataGridViewRow rowComponent in listSelectedComponentTypeConsumable.Rows)
                {
                    orderGeneral.InsertApplication(rowComponent.Cells[0].Value.ToString(), idBranchLogin, idWorker, rowComponent.Cells[2].Value.ToString());
                }
                listComponentDataTable.Clear();
                listSelectedComponentTypeConsumable.DataSource = listComponentDataTable;
            }
            sqlManager.CloseConnection();
        }
    }
}
