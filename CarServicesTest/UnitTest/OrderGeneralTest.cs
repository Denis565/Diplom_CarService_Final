using Microsoft.VisualStudio.TestTools.UnitTesting;
using Progect.Custom;
using Progect.Model;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Windows.Forms;

namespace CarServicesTest.UnitTest
{
    [TestClass]
    public class OrderGeneralTest
    {
        private readonly OrderGeneral orderGeneral = new OrderGeneral();

        [TestMethod]
        public void ColorOrderLog_IsOpen_Red()
        {
            Color color = orderGeneral.AnaliticStatusOrder("Открыт");
            Assert.AreEqual(color, Color.Red);
        }

        [TestMethod]
        public void ColorOrderLog_Unopened_Green()
        {
            Color color = orderGeneral.AnaliticStatusOrder("Закрыт");
            Assert.AreEqual(color, Color.Green);
        }

        [TestMethod]
        public void ColorOrderLog_InProgres_Yellow()
        {
            Color color = orderGeneral.AnaliticStatusOrder("Выполняется");
            Assert.AreEqual(color, Color.Yellow);
        }

        [TestMethod]
        public void ColorOrderLog_All_White()
        {
            Color color = orderGeneral.AnaliticStatusOrder("Все");
            Assert.AreEqual(color, Color.White);
        }

        [TestMethod]
        public void DateSelected_NotNull()
        {
            DataTable dataTableService = new DataTable();
            DataTable dataTableMaterial = new DataTable();
            DataGridView listService = new DataGridView();
            DataGridView listMaterial = new DataGridView();
            orderGeneral.DateSelected(dataTableService, dataTableMaterial, listService, listMaterial);

            Assert.AreEqual(listService.Columns.Count, 7);
            Assert.AreEqual(listMaterial.Columns.Count, 7);
        }

        [TestMethod]
        public void MatchingMachines_ListModel()
        {
            DataGridView listBrandModelCompliance = new DataGridView();

            DataGridViewComboBoxColumn comboBoxStampCar = new DataGridViewComboBoxColumn();
            DataGridViewComboBoxColumn comboBoxModelCar = new DataGridViewComboBoxColumn();
            DataGridViewComboBoxColumn comboBoxListStatus = new DataGridViewComboBoxColumn();
            DataGridViewComboBoxColumn comboBoxListServiceGroup = new DataGridViewComboBoxColumn();
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
        }

        private void AddListStampModel(List<CarStamp> listStampCar, List<CarModel> listModelCar)
        {
            Assert.AreNotEqual(listStampCar.Count, 0);
            Assert.AreNotEqual(listModelCar.Count, 0);
        }

        [TestMethod]
        public void SeartchOrderLogInsertConsumables_true()
        {
            bool executionStatus = orderGeneral.SeartchOrderLogInsertConsumables("2", "2");
            Assert.IsTrue(executionStatus);
        }

        [TestMethod]
        public void SeartchOrderLogInsertIndividual_true()
        {
            bool executionStatus = orderGeneral.SeartchOrderLogInsertIndividual("2");
            Assert.IsTrue(executionStatus);
        }

        [TestMethod]
        public void InsertApplication_true()
        {
            bool executionStatus = orderGeneral.InsertApplication("2", "1", "32", "10");
            Assert.IsTrue(executionStatus);
        }
    }
}
