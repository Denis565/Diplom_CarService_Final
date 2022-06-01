using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace Progect
{
    /// <summary>
    /// Класс формы для изменения и добавления марок машин в реестр
    /// </summary>
    public partial class StampCarAddUpdate : Form
    {
        private readonly List<string> listNameStamp = new List<string>();
        private readonly SQL.SQLManager sqlManager = new SQL.SQLManager();
        private string initialName = null;

        /// <summary>
        /// Инициализация компонентов 
        /// </summary>
        public StampCarAddUpdate()
        {
            InitializeComponent();
            sqlManager.OpenConnection();

            sqlManager.GetList(listStamp, "[dbo].[Car_Brand]", "select * from [dbo].[Car_Brand_List]");
            listStamp.Font = new Font("Arial", 13, GraphicsUnit.Pixel);
            listStamp.Columns[0].Visible = false;
            listNameStamp = listStamp.Rows.OfType<DataGridViewRow>()
                .Where(x => x.Cells[1].Value != null)
                .Select(dr => dr.Cells[1].Value.ToString().ToLower()).ToList();

            listStamp.AllowUserToDeleteRows = false;

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
        /// Начало редактирования списка с марками
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListStamp_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            TextBox name_text_box = (TextBox)e.Control;
            name_text_box.KeyPress += new KeyPressEventHandler(Name_text_box_KeyPress);
            initialName = listStamp.Rows[listStamp.CurrentRow.Index].Cells[1].Value.ToString();
        }

        /// <summary>
        /// Обработка нажатия на кнопки при введении наименования марки машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Name_text_box_KeyPress(object sender, KeyPressEventArgs e)
        {
            string Symbol = e.KeyChar.ToString();

            if (!Regex.Match(Symbol, @"[а-яА-Я]|[a-zA-Z]").Success && e.KeyChar != 8 && e.KeyChar != (int)Keys.Space)
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Окончание редактирования марки машины
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListStamp_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            string newNameStamp = listStamp.Rows[e.RowIndex].Cells[1].Value.ToString().Trim();

            if (newNameStamp.Length <= 0 || listNameStamp.Contains(newNameStamp.ToLower()))
            {
                listStamp.Rows[e.RowIndex].Cells[1].Value = initialName;
                if (initialName.Equals(""))
                {
                    listStamp.Rows.RemoveAt(listStamp.Rows.Count - 2);
                }
                return;
            }

            sqlManager.OpenConnection();
            if (!listStamp.Rows[e.RowIndex].Cells[0].Value.ToString().Equals(""))
            {
                sqlManager.PerformingProcedure(
                    new string[] { listStamp.Rows[e.RowIndex].Cells[0].Value.ToString(), newNameStamp },
                    "[dbo].[Car_Brand_update]",
                    new string[] { "ID_Car_Brand", "Name_Car_Brand" }
                    );
            }
            else
            {
                object reader = sqlManager.PerformingProcedureReader(
                    new string[] { newNameStamp },
                    "[dbo].[Car_Brand_insert]",
                    new string[] { "Name_Car_Brand" }
                    );
                listStamp.Rows[e.RowIndex].Cells[0].Value = reader.ToString(); ;
            }

            listStamp.Rows[e.RowIndex].Cells[1].Value = newNameStamp;
            listNameStamp.Remove(initialName);
            listNameStamp.Add(newNameStamp);

            sqlManager.CloseConnection();
        }
    }
}
