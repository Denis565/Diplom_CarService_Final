
namespace Progect
{
    partial class CustomerCard
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(CustomerCard));
            this.screenLayers = new System.Windows.Forms.TabControl();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.listCar = new System.Windows.Forms.DataGridView();
            this.menuStrip3 = new System.Windows.Forms.MenuStrip();
            this.back_btn = new System.Windows.Forms.ToolStripMenuItem();
            this.addCar = new System.Windows.Forms.ToolStripMenuItem();
            this.updateCar = new System.Windows.Forms.ToolStripMenuItem();
            this.tabPage4 = new System.Windows.Forms.TabPage();
            this.menuStrip4 = new System.Windows.Forms.MenuStrip();
            this.back_order = new System.Windows.Forms.ToolStripMenuItem();
            this.createOrder = new System.Windows.Forms.ToolStripMenuItem();
            this.printOrderOutfit = new System.Windows.Forms.ToolStripMenuItem();
            this.cbFilterOrderStatus = new System.Windows.Forms.ToolStripComboBox();
            this.listOrder = new System.Windows.Forms.DataGridView();
            this.tabPage5 = new System.Windows.Forms.TabPage();
            this.labelTotalCost = new System.Windows.Forms.Label();
            this.totalCost = new System.Windows.Forms.Label();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.labelCostComponent = new System.Windows.Forms.Label();
            this.amountComponents = new System.Windows.Forms.Label();
            this.cbTypeComponent = new System.Windows.Forms.ComboBox();
            this.deleteMaterial = new System.Windows.Forms.Button();
            this.searchMaterial = new System.Windows.Forms.TextBox();
            this.listSelectedMaterials = new System.Windows.Forms.DataGridView();
            this.listAvailableMaterials = new System.Windows.Forms.DataGridView();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.labelCostService = new System.Windows.Forms.Label();
            this.amountService = new System.Windows.Forms.Label();
            this.cbServiceGroup = new System.Windows.Forms.ComboBox();
            this.deleteService = new System.Windows.Forms.Button();
            this.searchService = new System.Windows.Forms.TextBox();
            this.listSelectedServices = new System.Windows.Forms.DataGridView();
            this.listAvailableServices = new System.Windows.Forms.DataGridView();
            this.menuStrip5 = new System.Windows.Forms.MenuStrip();
            this.backOrderDetails = new System.Windows.Forms.ToolStripMenuItem();
            this.updateService = new System.Windows.Forms.ToolStripMenuItem();
            this.updateRegistryList = new System.Windows.Forms.ToolStripMenuItem();
            this.imageListIconTabPage = new System.Windows.Forms.ImageList(this.components);
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.printDialog = new System.Windows.Forms.PrintDialog();
            this.printDocument = new System.Drawing.Printing.PrintDocument();
            this.screenLayers.SuspendLayout();
            this.tabPage3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listCar)).BeginInit();
            this.menuStrip3.SuspendLayout();
            this.tabPage4.SuspendLayout();
            this.menuStrip4.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listOrder)).BeginInit();
            this.tabPage5.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listSelectedMaterials)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.listAvailableMaterials)).BeginInit();
            this.groupBox1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listSelectedServices)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.listAvailableServices)).BeginInit();
            this.menuStrip5.SuspendLayout();
            this.SuspendLayout();
            // 
            // screenLayers
            // 
            this.screenLayers.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.screenLayers.Controls.Add(this.tabPage3);
            this.screenLayers.Controls.Add(this.tabPage4);
            this.screenLayers.Controls.Add(this.tabPage5);
            this.screenLayers.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F);
            this.screenLayers.ImageList = this.imageListIconTabPage;
            this.screenLayers.Location = new System.Drawing.Point(1, 5);
            this.screenLayers.Name = "screenLayers";
            this.screenLayers.SelectedIndex = 0;
            this.screenLayers.Size = new System.Drawing.Size(1227, 571);
            this.screenLayers.TabIndex = 0;
            this.screenLayers.SelectedIndexChanged += new System.EventHandler(this.ScreenLayers_SelectedIndexChanged);
            // 
            // tabPage3
            // 
            this.tabPage3.Controls.Add(this.listCar);
            this.tabPage3.Controls.Add(this.menuStrip3);
            this.tabPage3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F);
            this.tabPage3.ImageIndex = 0;
            this.tabPage3.Location = new System.Drawing.Point(4, 32);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Size = new System.Drawing.Size(1219, 535);
            this.tabPage3.TabIndex = 0;
            this.tabPage3.Text = "Машины";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // listCar
            // 
            this.listCar.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.listCar.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.listCar.Location = new System.Drawing.Point(7, 34);
            this.listCar.Name = "listCar";
            this.listCar.RowHeadersWidth = 51;
            this.listCar.RowTemplate.Height = 24;
            this.listCar.Size = new System.Drawing.Size(1205, 493);
            this.listCar.TabIndex = 3;
            this.listCar.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.ListCar_CellClick);
            this.listCar.ColumnStateChanged += new System.Windows.Forms.DataGridViewColumnStateChangedEventHandler(this.ListCar_ColumnStateChanged);
            // 
            // menuStrip3
            // 
            this.menuStrip3.Font = new System.Drawing.Font("Segoe UI", 10.2F);
            this.menuStrip3.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menuStrip3.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.back_btn,
            this.addCar,
            this.updateCar});
            this.menuStrip3.Location = new System.Drawing.Point(0, 0);
            this.menuStrip3.Name = "menuStrip3";
            this.menuStrip3.Size = new System.Drawing.Size(1219, 31);
            this.menuStrip3.TabIndex = 2;
            this.menuStrip3.Text = "menuStrip3";
            // 
            // back_btn
            // 
            this.back_btn.BackColor = System.Drawing.Color.Transparent;
            this.back_btn.Image = global::Progect.Properties.Resources.back;
            this.back_btn.Name = "back_btn";
            this.back_btn.Size = new System.Drawing.Size(91, 27);
            this.back_btn.Text = "Назад";
            this.back_btn.Click += new System.EventHandler(this.Back_Click);
            // 
            // addCar
            // 
            this.addCar.Image = global::Progect.Properties.Resources.add;
            this.addCar.Name = "addCar";
            this.addCar.Size = new System.Drawing.Size(188, 27);
            this.addCar.Text = "Добавить машину";
            this.addCar.Click += new System.EventHandler(this.AddCar_Click);
            // 
            // updateCar
            // 
            this.updateCar.Image = global::Progect.Properties.Resources.update;
            this.updateCar.Name = "updateCar";
            this.updateCar.Size = new System.Drawing.Size(280, 27);
            this.updateCar.Text = "Изменить данные по машине";
            this.updateCar.Click += new System.EventHandler(this.UpdateCar_Click);
            // 
            // tabPage4
            // 
            this.tabPage4.Controls.Add(this.menuStrip4);
            this.tabPage4.Controls.Add(this.listOrder);
            this.tabPage4.ImageIndex = 1;
            this.tabPage4.Location = new System.Drawing.Point(4, 32);
            this.tabPage4.Name = "tabPage4";
            this.tabPage4.Size = new System.Drawing.Size(1219, 535);
            this.tabPage4.TabIndex = 1;
            this.tabPage4.Text = "Заказ наряды";
            this.tabPage4.UseVisualStyleBackColor = true;
            // 
            // menuStrip4
            // 
            this.menuStrip4.Font = new System.Drawing.Font("Segoe UI", 10.2F);
            this.menuStrip4.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menuStrip4.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.back_order,
            this.createOrder,
            this.printOrderOutfit,
            this.cbFilterOrderStatus});
            this.menuStrip4.Location = new System.Drawing.Point(0, 0);
            this.menuStrip4.Name = "menuStrip4";
            this.menuStrip4.Size = new System.Drawing.Size(1219, 35);
            this.menuStrip4.TabIndex = 5;
            this.menuStrip4.Text = "menuStrip4";
            // 
            // back_order
            // 
            this.back_order.Image = global::Progect.Properties.Resources.back;
            this.back_order.Name = "back_order";
            this.back_order.Size = new System.Drawing.Size(91, 31);
            this.back_order.Text = "Назад";
            this.back_order.Click += new System.EventHandler(this.Back_Click);
            // 
            // createOrder
            // 
            this.createOrder.Image = global::Progect.Properties.Resources.add;
            this.createOrder.Name = "createOrder";
            this.createOrder.Size = new System.Drawing.Size(206, 31);
            this.createOrder.Text = "Создать заказ наряд";
            this.createOrder.Click += new System.EventHandler(this.CreateOrder_Click);
            // 
            // printOrderOutfit
            // 
            this.printOrderOutfit.Enabled = false;
            this.printOrderOutfit.Image = global::Progect.Properties.Resources.print;
            this.printOrderOutfit.Name = "printOrderOutfit";
            this.printOrderOutfit.Size = new System.Drawing.Size(240, 31);
            this.printOrderOutfit.Text = "Распечатать заказ наряд";
            this.printOrderOutfit.Click += new System.EventHandler(this.PrintOrderOutfit_Click);
            // 
            // cbFilterOrderStatus
            // 
            this.cbFilterOrderStatus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbFilterOrderStatus.Font = new System.Drawing.Font("Segoe UI", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.cbFilterOrderStatus.Name = "cbFilterOrderStatus";
            this.cbFilterOrderStatus.Size = new System.Drawing.Size(221, 31);
            this.cbFilterOrderStatus.SelectedIndexChanged += new System.EventHandler(this.CbFilterOrderStatus_SelectedIndexChanged);
            // 
            // listOrder
            // 
            this.listOrder.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.listOrder.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.listOrder.Location = new System.Drawing.Point(6, 38);
            this.listOrder.Name = "listOrder";
            this.listOrder.RowHeadersWidth = 51;
            this.listOrder.RowTemplate.Height = 24;
            this.listOrder.Size = new System.Drawing.Size(1206, 492);
            this.listOrder.TabIndex = 4;
            this.listOrder.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.ListOrder_CellClick);
            this.listOrder.ColumnStateChanged += new System.Windows.Forms.DataGridViewColumnStateChangedEventHandler(this.ListOrder_ColumnStateChanged);
            // 
            // tabPage5
            // 
            this.tabPage5.Controls.Add(this.labelTotalCost);
            this.tabPage5.Controls.Add(this.totalCost);
            this.tabPage5.Controls.Add(this.tableLayoutPanel1);
            this.tabPage5.Controls.Add(this.menuStrip5);
            this.tabPage5.ImageIndex = 2;
            this.tabPage5.Location = new System.Drawing.Point(4, 32);
            this.tabPage5.Name = "tabPage5";
            this.tabPage5.Size = new System.Drawing.Size(1219, 535);
            this.tabPage5.TabIndex = 2;
            this.tabPage5.Text = "Детали заказ наряда";
            this.tabPage5.UseVisualStyleBackColor = true;
            // 
            // labelTotalCost
            // 
            this.labelTotalCost.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.labelTotalCost.AutoSize = true;
            this.labelTotalCost.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.labelTotalCost.ForeColor = System.Drawing.Color.OrangeRed;
            this.labelTotalCost.Location = new System.Drawing.Point(13, 506);
            this.labelTotalCost.Name = "labelTotalCost";
            this.labelTotalCost.Size = new System.Drawing.Size(170, 20);
            this.labelTotalCost.TabIndex = 11;
            this.labelTotalCost.Text = "Итоговая сумма: ";
            // 
            // totalCost
            // 
            this.totalCost.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.totalCost.AutoSize = true;
            this.totalCost.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.totalCost.ForeColor = System.Drawing.Color.OrangeRed;
            this.totalCost.Location = new System.Drawing.Point(193, 506);
            this.totalCost.Name = "totalCost";
            this.totalCost.Size = new System.Drawing.Size(61, 20);
            this.totalCost.TabIndex = 10;
            this.totalCost.Text = "0 .руб";
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Controls.Add(this.groupBox2, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.groupBox1, 0, 1);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(7, 34);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(1209, 464);
            this.tableLayoutPanel1.TabIndex = 12;
            // 
            // groupBox2
            // 
            this.groupBox2.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox2.Controls.Add(this.labelCostComponent);
            this.groupBox2.Controls.Add(this.amountComponents);
            this.groupBox2.Controls.Add(this.cbTypeComponent);
            this.groupBox2.Controls.Add(this.deleteMaterial);
            this.groupBox2.Controls.Add(this.searchMaterial);
            this.groupBox2.Controls.Add(this.listSelectedMaterials);
            this.groupBox2.Controls.Add(this.listAvailableMaterials);
            this.groupBox2.Location = new System.Drawing.Point(3, 3);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(1203, 226);
            this.groupBox2.TabIndex = 10;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Используемые материалы";
            // 
            // labelCostComponent
            // 
            this.labelCostComponent.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.labelCostComponent.AutoSize = true;
            this.labelCostComponent.ForeColor = System.Drawing.Color.ForestGreen;
            this.labelCostComponent.Location = new System.Drawing.Point(822, 197);
            this.labelCostComponent.Name = "labelCostComponent";
            this.labelCostComponent.Size = new System.Drawing.Size(219, 20);
            this.labelCostComponent.TabIndex = 9;
            this.labelCostComponent.Text = "Стоимость материалов: ";
            // 
            // amountComponents
            // 
            this.amountComponents.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.amountComponents.AutoSize = true;
            this.amountComponents.ForeColor = System.Drawing.Color.ForestGreen;
            this.amountComponents.Location = new System.Drawing.Point(1047, 197);
            this.amountComponents.Name = "amountComponents";
            this.amountComponents.Size = new System.Drawing.Size(55, 20);
            this.amountComponents.TabIndex = 8;
            this.amountComponents.Text = "0 .руб";
            // 
            // cbTypeComponent
            // 
            this.cbTypeComponent.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbTypeComponent.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F);
            this.cbTypeComponent.FormattingEnabled = true;
            this.cbTypeComponent.Location = new System.Drawing.Point(427, 26);
            this.cbTypeComponent.Name = "cbTypeComponent";
            this.cbTypeComponent.Size = new System.Drawing.Size(351, 28);
            this.cbTypeComponent.TabIndex = 7;
            this.cbTypeComponent.SelectedIndexChanged += new System.EventHandler(this.CbTypeComponent_SelectedIndexChanged);
            // 
            // deleteMaterial
            // 
            this.deleteMaterial.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.deleteMaterial.Location = new System.Drawing.Point(826, 19);
            this.deleteMaterial.Name = "deleteMaterial";
            this.deleteMaterial.Size = new System.Drawing.Size(371, 40);
            this.deleteMaterial.TabIndex = 5;
            this.deleteMaterial.Text = "Удалить материал";
            this.deleteMaterial.UseVisualStyleBackColor = true;
            this.deleteMaterial.Click += new System.EventHandler(this.DeleteMaterial_Click);
            // 
            // searchMaterial
            // 
            this.searchMaterial.Location = new System.Drawing.Point(6, 26);
            this.searchMaterial.Name = "searchMaterial";
            this.searchMaterial.Size = new System.Drawing.Size(402, 27);
            this.searchMaterial.TabIndex = 2;
            this.searchMaterial.TextChanged += new System.EventHandler(this.SearchMaterial_TextChanged);
            // 
            // listSelectedMaterials
            // 
            this.listSelectedMaterials.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.listSelectedMaterials.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.listSelectedMaterials.Location = new System.Drawing.Point(826, 76);
            this.listSelectedMaterials.Name = "listSelectedMaterials";
            this.listSelectedMaterials.RowHeadersWidth = 51;
            this.listSelectedMaterials.RowTemplate.Height = 24;
            this.listSelectedMaterials.Size = new System.Drawing.Size(371, 114);
            this.listSelectedMaterials.TabIndex = 1;
            this.listSelectedMaterials.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.ListSelectedMaterials_CellEndEdit);
            this.listSelectedMaterials.EditingControlShowing += new System.Windows.Forms.DataGridViewEditingControlShowingEventHandler(this.ListSelectedMaterials_EditingControlShowing);
            // 
            // listAvailableMaterials
            // 
            this.listAvailableMaterials.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.listAvailableMaterials.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.listAvailableMaterials.Location = new System.Drawing.Point(6, 76);
            this.listAvailableMaterials.Name = "listAvailableMaterials";
            this.listAvailableMaterials.RowHeadersWidth = 51;
            this.listAvailableMaterials.RowTemplate.Height = 24;
            this.listAvailableMaterials.Size = new System.Drawing.Size(772, 114);
            this.listAvailableMaterials.TabIndex = 0;
            this.listAvailableMaterials.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.ListAvailableMaterials_CellMouseDoubleClick);
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.labelCostService);
            this.groupBox1.Controls.Add(this.amountService);
            this.groupBox1.Controls.Add(this.cbServiceGroup);
            this.groupBox1.Controls.Add(this.deleteService);
            this.groupBox1.Controls.Add(this.searchService);
            this.groupBox1.Controls.Add(this.listSelectedServices);
            this.groupBox1.Controls.Add(this.listAvailableServices);
            this.groupBox1.Location = new System.Drawing.Point(3, 235);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(1203, 226);
            this.groupBox1.TabIndex = 9;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Услуги";
            // 
            // labelCostService
            // 
            this.labelCostService.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.labelCostService.AutoSize = true;
            this.labelCostService.ForeColor = System.Drawing.Color.Blue;
            this.labelCostService.Location = new System.Drawing.Point(822, 197);
            this.labelCostService.Name = "labelCostService";
            this.labelCostService.Size = new System.Drawing.Size(160, 20);
            this.labelCostService.TabIndex = 10;
            this.labelCostService.Text = "Стоимость услуг: ";
            // 
            // amountService
            // 
            this.amountService.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.amountService.AutoSize = true;
            this.amountService.ForeColor = System.Drawing.Color.Blue;
            this.amountService.Location = new System.Drawing.Point(986, 197);
            this.amountService.Name = "amountService";
            this.amountService.Size = new System.Drawing.Size(55, 20);
            this.amountService.TabIndex = 9;
            this.amountService.Text = "0 .руб";
            // 
            // cbServiceGroup
            // 
            this.cbServiceGroup.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbServiceGroup.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F);
            this.cbServiceGroup.FormattingEnabled = true;
            this.cbServiceGroup.Location = new System.Drawing.Point(427, 27);
            this.cbServiceGroup.Name = "cbServiceGroup";
            this.cbServiceGroup.Size = new System.Drawing.Size(351, 28);
            this.cbServiceGroup.TabIndex = 6;
            this.cbServiceGroup.SelectedIndexChanged += new System.EventHandler(this.CbServiceGroup_SelectedIndexChanged);
            // 
            // deleteService
            // 
            this.deleteService.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.deleteService.Location = new System.Drawing.Point(826, 18);
            this.deleteService.Name = "deleteService";
            this.deleteService.Size = new System.Drawing.Size(371, 40);
            this.deleteService.TabIndex = 4;
            this.deleteService.Text = "Удалить услугу";
            this.deleteService.UseVisualStyleBackColor = true;
            this.deleteService.Click += new System.EventHandler(this.DeleteService_Click);
            // 
            // searchService
            // 
            this.searchService.Location = new System.Drawing.Point(7, 26);
            this.searchService.Name = "searchService";
            this.searchService.Size = new System.Drawing.Size(401, 27);
            this.searchService.TabIndex = 3;
            this.searchService.TextChanged += new System.EventHandler(this.SearchService_TextChanged);
            // 
            // listSelectedServices
            // 
            this.listSelectedServices.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.listSelectedServices.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.listSelectedServices.Location = new System.Drawing.Point(826, 72);
            this.listSelectedServices.Name = "listSelectedServices";
            this.listSelectedServices.RowHeadersWidth = 51;
            this.listSelectedServices.RowTemplate.Height = 24;
            this.listSelectedServices.Size = new System.Drawing.Size(371, 120);
            this.listSelectedServices.TabIndex = 1;
            // 
            // listAvailableServices
            // 
            this.listAvailableServices.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.listAvailableServices.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.listAvailableServices.Location = new System.Drawing.Point(6, 72);
            this.listAvailableServices.Name = "listAvailableServices";
            this.listAvailableServices.RowHeadersWidth = 51;
            this.listAvailableServices.RowTemplate.Height = 24;
            this.listAvailableServices.Size = new System.Drawing.Size(772, 120);
            this.listAvailableServices.TabIndex = 0;
            this.listAvailableServices.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.ListAvailableServices_CellMouseDoubleClick);
            // 
            // menuStrip5
            // 
            this.menuStrip5.Font = new System.Drawing.Font("Segoe UI", 10.2F);
            this.menuStrip5.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menuStrip5.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.backOrderDetails,
            this.updateService,
            this.updateRegistryList});
            this.menuStrip5.Location = new System.Drawing.Point(0, 0);
            this.menuStrip5.Name = "menuStrip5";
            this.menuStrip5.Size = new System.Drawing.Size(1219, 31);
            this.menuStrip5.TabIndex = 11;
            this.menuStrip5.Text = "menuStrip5";
            // 
            // backOrderDetails
            // 
            this.backOrderDetails.BackColor = System.Drawing.Color.Transparent;
            this.backOrderDetails.Image = global::Progect.Properties.Resources.back;
            this.backOrderDetails.Name = "backOrderDetails";
            this.backOrderDetails.Size = new System.Drawing.Size(91, 27);
            this.backOrderDetails.Text = "Назад";
            this.backOrderDetails.Click += new System.EventHandler(this.Back_Click);
            // 
            // updateService
            // 
            this.updateService.Image = global::Progect.Properties.Resources.save_btn;
            this.updateService.Name = "updateService";
            this.updateService.Size = new System.Drawing.Size(220, 27);
            this.updateService.Text = "Сохранить изменения";
            this.updateService.Click += new System.EventHandler(this.SaveServiceMaterial_Click);
            // 
            // updateRegistryList
            // 
            this.updateRegistryList.Image = global::Progect.Properties.Resources.updateRegistryList2;
            this.updateRegistryList.Name = "updateRegistryList";
            this.updateRegistryList.Size = new System.Drawing.Size(248, 27);
            this.updateRegistryList.Text = "Обновить списки реестра";
            this.updateRegistryList.Click += new System.EventHandler(this.UpdateRegistryList_Click);
            // 
            // imageListIconTabPage
            // 
            this.imageListIconTabPage.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageListIconTabPage.ImageStream")));
            this.imageListIconTabPage.TransparentColor = System.Drawing.Color.Transparent;
            this.imageListIconTabPage.Images.SetKeyName(0, "car_image (1).ico");
            this.imageListIconTabPage.Images.SetKeyName(1, "repair-tools_image.ico");
            this.imageListIconTabPage.Images.SetKeyName(2, "free-icon-detail-image.ico");
            // 
            // printDialog
            // 
            this.printDialog.UseEXDialog = true;
            // 
            // CustomerCard
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1229, 575);
            this.Controls.Add(this.screenLayers);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(1247, 622);
            this.Name = "CustomerCard";
            this.Text = "CustomerCard";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.CustomerCard_Load);
            this.screenLayers.ResumeLayout(false);
            this.tabPage3.ResumeLayout(false);
            this.tabPage3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listCar)).EndInit();
            this.menuStrip3.ResumeLayout(false);
            this.menuStrip3.PerformLayout();
            this.tabPage4.ResumeLayout(false);
            this.tabPage4.PerformLayout();
            this.menuStrip4.ResumeLayout(false);
            this.menuStrip4.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listOrder)).EndInit();
            this.tabPage5.ResumeLayout(false);
            this.tabPage5.PerformLayout();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listSelectedMaterials)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.listAvailableMaterials)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listSelectedServices)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.listAvailableServices)).EndInit();
            this.menuStrip5.ResumeLayout(false);
            this.menuStrip5.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl screenLayers;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.TabPage tabPage4;
        private System.Windows.Forms.TabPage tabPage5;
        private System.Windows.Forms.ImageList imageListIconTabPage;
        private System.Windows.Forms.DataGridView listCar;
        private System.Windows.Forms.MenuStrip menuStrip3;
        private System.Windows.Forms.ToolStripMenuItem back_btn;
        private System.Windows.Forms.ToolStripMenuItem addCar;
        private System.Windows.Forms.ToolStripMenuItem updateCar;
        private System.Windows.Forms.MenuStrip menuStrip4;
        private System.Windows.Forms.ToolStripMenuItem back_order;
        private System.Windows.Forms.ToolStripMenuItem createOrder;
        private System.Windows.Forms.ToolStripMenuItem printOrderOutfit;
        private System.Windows.Forms.DataGridView listOrder;
        private System.Windows.Forms.MenuStrip menuStrip5;
        private System.Windows.Forms.ToolStripMenuItem backOrderDetails;
        private System.Windows.Forms.ToolStripMenuItem updateService;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button deleteMaterial;
        private System.Windows.Forms.TextBox searchMaterial;
        private System.Windows.Forms.DataGridView listSelectedMaterials;
        private System.Windows.Forms.DataGridView listAvailableMaterials;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button deleteService;
        private System.Windows.Forms.TextBox searchService;
        private System.Windows.Forms.DataGridView listSelectedServices;
        private System.Windows.Forms.DataGridView listAvailableServices;
        private System.Windows.Forms.SaveFileDialog saveFileDialog;
        private System.Windows.Forms.PrintDialog printDialog;
        private System.Drawing.Printing.PrintDocument printDocument;
        private System.Windows.Forms.ComboBox cbServiceGroup;
        private System.Windows.Forms.ToolStripComboBox cbFilterOrderStatus;
        private System.Windows.Forms.ComboBox cbTypeComponent;
        private System.Windows.Forms.ToolStripMenuItem updateRegistryList;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.Label amountComponents;
        private System.Windows.Forms.Label amountService;
        private System.Windows.Forms.Label totalCost;
        private System.Windows.Forms.Label labelCostComponent;
        private System.Windows.Forms.Label labelCostService;
        private System.Windows.Forms.Label labelTotalCost;
    }
}