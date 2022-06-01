using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс формы для изменения и добавления моделей машин в реестр
    /// </summary>
    public partial class ModelCarAddUpdate : Form
    {
        private readonly List<string> listNameModel = new List<string>();
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();
        private string initialName = null;

        /// <summary>
        /// Инициализация компонентов
        /// </summary>
        public ModelCarAddUpdate()
        {
            InitializeComponent();

            sqlManager.OpenConnection();
            sqlManager.GetList(listModel, "[dbo].[Car_Model]", "select * from [dbo].[Car_Model_List]");
            listModel.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            listModel.Columns[0].Visible = false;
            listNameModel = listModel.Rows.OfType<DataGridViewRow>()
                .Where(x => x.Cells[1].Value != null)
                .Select(dr => dr.Cells[1].Value.ToString().ToLower()).ToList();

            listModel.AllowUserToDeleteRows = false;

            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Закрытие формы
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Close_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        /// <summary>
        /// Начало редактирования реестра моделей машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListModel_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            initialName = listModel.Rows[listModel.CurrentRow.Index].Cells[1].Value.ToString();
        }

        /// <summary>
        /// Окончание редактирования реестра моделей машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListModel_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            sqlManager.OpenConnection();
            string newNameModel = listModel.Rows[e.RowIndex].Cells[1].Value.ToString().Trim();

            if (newNameModel.Length <= 0 || listNameModel.Contains(newNameModel.ToLower()) == true)
            {
                listModel.Rows[e.RowIndex].Cells[1].Value = initialName;
                if (initialName.Equals(""))
                {
                    listModel.Rows.RemoveAt(listModel.Rows.Count - 2);
                }
                return;
            }

            if (!listModel.Rows[e.RowIndex].Cells[0].Value.ToString().Equals(""))
            {
                sqlManager.PerformingProcedure(
                    new string[] { listModel.Rows[e.RowIndex].Cells[0].Value.ToString(), newNameModel },
                    "[dbo].[Car_Model_update]",
                    new string[] { "ID_Car_Model", "Name_Car_Model" }
                    );
            }
            else
            {
                object reader = sqlManager.PerformingProcedureReader(
                    new string[] { newNameModel },
                    "[dbo].[Car_Model_insert]",
                    new string[] { "Name_Car_Model" }
                    );
                listModel.Rows[e.RowIndex].Cells[0].Value = reader.ToString();
            }

            listModel.Rows[e.RowIndex].Cells[1].Value = newNameModel;
            listNameModel.Remove(initialName);
            listNameModel.Add(newNameModel);

            sqlManager.CloseConnection();
        }
    }
}
