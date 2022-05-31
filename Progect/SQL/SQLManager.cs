using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Windows.Forms;

namespace Progect.SQL
{
    /// <summary>
    /// Менеджер для работы с SQl Server
    /// </summary>
    public class SQLManager
    {
        public SqlConnection conection = new SqlConnection($@"{ConfigurationManager.ConnectionStrings["CarServiceConnectionString"].ConnectionString}");
        public SqlDataAdapter dataAdapter;
        private DataSet dataSet;

        /// <summary>
        /// Открытие соединения
        /// </summary>
        public void OpenConnection()
        {
            if (conection.State == ConnectionState.Closed)
            {
                conection.Open();
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = conection;
                    command.CommandText = String.Format("set language Russian;");
                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Закрытие соединения
        /// </summary>
        public void CloseConnection()
        {
            if (conection.State == ConnectionState.Open)
            {
                conection.Close();
            }
        }

        /// <summary>
        /// Получение таблице по запросу
        /// </summary>
        /// <param name="sqlRequest">Запрос серверу</param>
        /// <returns>Таблица выданная после выполнения запоса</returns>
        public DataTable ReturnTable(string sqlRequest)
        {
            try
            {
                dataAdapter = new SqlDataAdapter($@"{sqlRequest}", conection);
                DataTable table = new DataTable();
                dataAdapter.Fill(table);
                return table;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message + $" {sqlRequest}");
                return new DataTable();
            }
        }

        /// <summary>
        /// Добавление значений в ComboBox
        /// </summary>
        /// <param name="comboBox">В какой выпадающий список занаосить</param>
        /// <param name="table">Таблица</param>
        /// <param name="columnNumber">Колонка котрую надо заносить в выпаающий список</param>
        public void AddComboBox(ComboBox comboBox, string table, int columnNumber)
        {
            DataTable dataTable = ReturnTable($@"select * from {table}");
            comboBox.Items.AddRange(dataTable.Rows.OfType<DataRow>().Select(dr => dr[columnNumber].ToString()).ToArray());
        }

        /// <summary>
        /// Вывод полученных данных после запроса в DataGridView
        /// </summary>
        /// <param name="dataGridView">В какой DataGridView заносить</param>
        /// <param name="table">Таблица</param>
        /// <param name="performance">Текст запроса</param>
        public bool GetList(DataGridView dataGridView, string table, string performance)
        {
            try
            {
                dataAdapter = new SqlDataAdapter(performance, conection);
                dataSet = new DataSet();
                dataAdapter.Fill(dataSet, table);
                /*
                if (dataGridView.InvokeRequired)
                {
                    dataGridView.Invoke(new Action<DataTable>((dt) => dataGridView.DataSource = dt), dataSet.Tables[table]);
                }
                else {
                    dataGridView.DataSource = dataSet.Tables[table];
                }*/
                dataGridView.DataSource = dataSet.Tables[table];
                dataGridView.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
                return true;
            }
            catch (Exception ex)
            {
                conection.Close();
                MessageBox.Show(ex.Message + " DataGridView");
                return false;
            }
        }

        /// <summary>
        /// Выполнение хранимой процедуры с возвратом таблицы
        /// </summary>
        /// <param name="value">Значения для параметров хранимой процедуры</param>
        /// <param name="nameFunction">Наименование хранимой процедуры</param>
        /// <param name="parameters">Параметры для хранимой процедуры</param>
        /// <returns>Успешность выполнения хранимой процедуры</returns>
        public object PerformingProcedureReader(string[] value, string nameFunction, string[] parameters)
        {
            using (SqlCommand cmd = new SqlCommand($@"{nameFunction}", conection))
            {
                try
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    for (int i = 0; i < parameters.Length; i++)
                    {
                        cmd.Parameters.Add(parameters[i], SqlDbType.VarChar).Value = value[i];
                    }
                    object reader = cmd.ExecuteScalar();
                    return reader;
                }
                catch (Exception e)
                {
                    MessageBox.Show(e.Message);
                    conection.Close();
                    return null;
                }
            }
        }

        /// <summary>
        /// Выполнение хранимой процедуры без возращаемого значения
        /// </summary>
        /// <param name="value">Значения для параметров хранимой процедуры</param>
        /// <param name="nameFunction">Наименование хранимой процедуры</param>
        /// <param name="parameters">Параметры для хранимой процедуры</param>
        /// <returns>Успешность выполнения хранимой процедуры</returns>
        public bool PerformingProcedure(string[] value, string nameFunction, string[] parameters)
        {
            using (SqlCommand cmd = new SqlCommand($@"{nameFunction}", conection))
            {
                try
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    for (int i = 0; i < parameters.Length; i++)
                    {
                        cmd.Parameters.Add(parameters[i], SqlDbType.VarChar).Value = value[i];
                    }
                    OpenConnection();
                    cmd.ExecuteNonQuery();
                    return true;
                }
                catch (Exception e)
                {
                    MessageBox.Show(e.Message);
                    conection.Close();
                    return false;
                }
            }
        }

        /// <summary>
        /// Выполнение хранимой процедуры с возвращение DataTable
        /// </summary>
        /// <param name="value">Значения для параметров хранимой процедуры</param>
        /// <param name="nameFunction">Наименование хранимой процедуры</param>
        /// <param name="parameters">Параметры для хранимой процедуры</param>
        /// <returns></returns>
        public DataTable PerformingProcedureReturnDataTable(string[] value, string nameFunction, string[] parameters)
        {
            DataTable dataTable = new DataTable();
            using (SqlCommand cmd = new SqlCommand($@"{nameFunction}", conection))
            {
                try
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    for (int i = 0; i < parameters.Length; i++)
                    {
                        cmd.Parameters.Add(parameters[i], SqlDbType.VarChar).Value = value[i];
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        try
                        {
                            da.Fill(dataTable);
                            return dataTable;
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show(ex.Message);
                            return null;
                        }
                    }
                }
                catch (Exception e)
                {
                    MessageBox.Show(e.Message);
                    conection.Close();
                    return dataTable;
                }
            }
        }
    }
}
