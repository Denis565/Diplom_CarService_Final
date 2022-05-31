using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect.Model;
using Progect.SQL;
using System;
using System.Data;
using System.Threading;
using System.Windows.Forms;
using TableDependency.SqlClient;
using TableDependency.SqlClient.Base.Enums;

namespace CarServicesTest.UnitTest
{
    [TestClass]
    public class SQLManagerTest
    {
        private readonly SQLManager sqlManager = new SQLManager();
        public SqlTableDependency<Order_Log> people_table_dependency;
        private readonly string connection_string_people = @"Data Source=LAPTOP-TSGG5DA6\BALAEVDENES;Initial Catalog=CarService6;User ID=sa;Password=1234";

        /// <summary>
        /// Тестирование открытия подключения
        /// </summary>
        [TestMethod]
        public void OpenConnection_StateOpen()
        {
            sqlManager.OpenConnection();
            Assert.AreEqual(sqlManager.conection.State, ConnectionState.Open);
        }

        /// <summary>
        /// Тестирование закрытия подключения
        /// </summary>
        [TestMethod]
        public void OpenConnection_StateClose()
        {
            sqlManager.CloseConnection();
            Assert.AreEqual(sqlManager.conection.State, ConnectionState.Closed);
        }

        /// <summary>
        /// Тестирование возрата таблицы с соответствием марки и модели машин
        /// </summary>
        [TestMethod]
        public void ReturnTable_SearchCarBrandModelandBMWandM5_119()
        {
            DataTable dataTable = sqlManager.ReturnTable($@"select * from [dbo].[Search_Car_Brand_Model] ('BMW','M5')");
            int idBrandModelCompliance = Convert.ToInt32(dataTable.Rows[0][0].ToString());
            Assert.AreEqual(idBrandModelCompliance, 119);
        }

        /// <summary>
        /// Тестирование добавления в выпадающий список брендов машин
        /// </summary>
        [TestMethod]
        public void AddComboBox_CarBrandViewandbrandand0_89()
        {
            ComboBox brand = new ComboBox();
            sqlManager.AddComboBox(brand, "[dbo].[Car_Brand_View]", 0);
            Assert.AreNotEqual(brand.Items.Count, 0);
        }

        /// <summary>
        /// Тестирование заполнения DataGridView
        /// </summary>
        [TestMethod]
        public void GetList_ClientViewandclientandClientandClientView_true()
        {
            DataGridView client = new DataGridView();
            bool result = sqlManager.GetList(client, "[dbo].[Client]", "select * from [dbo].[Client_View]");
            Assert.AreEqual(result, true);
            Assert.AreNotEqual(client.RowCount, -1);
        }

        /// <summary>
        /// Тестирование метода для добавления данных с возвратом одной переменной
        /// </summary>
        [TestMethod]
        public void PerformingProcedureReader_CarServicesProvidedinsertand1and1_NotNull()
        {
            sqlManager.OpenConnection();
            object reader = sqlManager.PerformingProcedureReader(
                        new string[] { "1", "1", "2" },
                        "[Car_Services_Provided_insert]",
                        new string[] { "List_Services_ID", "Order_ID", "Worker_ID" }
                    );
            string result = reader.ToString();
            Assert.AreNotEqual(result, null);
            sqlManager.CloseConnection();
        }

        /// <summary>
        /// Тестирование метода без возврата переменной
        /// </summary>
        [TestMethod]
        public void PerformingProcedure_CustomersMachinesinsertandGFU65F56JDandF122JH197and2019and20000and1and1_NotNull()
        {
            DateTime now = DateTime.Now;
            string index = (now.Year + now.Month + now.Day + now.Minute + now.Second + now.Millisecond).ToString();
            bool result = sqlManager.PerformingProcedure
            (
                new string[] { $@"HDULGGFFGGFYH {index}", "F122JH197", "2019", "20000", "1", "1" },
                "[dbo].[Customers_Machines_insert]",
                new string[] { "VIN", "Registration_Mark", "Year_Release", "Mileage", "Brand_Model_Compliance_ID", "Client_ID" }
            );
            Assert.AreEqual(result, true);
        }

        [TestMethod]
        public void PerformingProcedureReturnDataTable_NotNull()
        {
            sqlManager.OpenConnection();
            DataTable dataTableAllInformWorker = sqlManager.PerformingProcedureReturnDataTable(
                    new string[] { "20.03.1999", "20.05.2022", "1;2;3;4" },
                    "[dbo].[Analiz_Worker]",
                    new string[] { "startDate", "endDate", "idWorker", }
                );
            sqlManager.CloseConnection();
            Assert.AreNotEqual(dataTableAllInformWorker, null);
        }

        /// <summary>
        /// Тестирование отслеживания изменений в таблицы базы данных Order_Log
        /// </summary>
        [TestMethod]
        public void AbleDependencyOrderLog()
        {
            int changesReceived = 0;
            ChangeType type = ChangeType.None;

            people_table_dependency = new SqlTableDependency<Order_Log>(connection_string_people);
            people_table_dependency.OnChanged += (o, e) =>
            {
                changesReceived++;
                type = e.ChangeType;
            };
            people_table_dependency.Start();

            bool executionStatus = sqlManager.PerformingProcedure(
                new string[] { "230" },
                "[dbo].[OrderLog_insert_Individual]",
                new string[] { "Component_Order_ID" }
            );

            Thread.Sleep(1000);

            Assert.IsTrue(executionStatus);
            Assert.AreEqual(1, changesReceived);
            Assert.AreEqual(ChangeType.Insert, type);
        }

    }
}
