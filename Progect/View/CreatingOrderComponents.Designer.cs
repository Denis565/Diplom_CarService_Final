
namespace Progect
{
    partial class CreatingOrderComponents
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(CreatingOrderComponents));
            this.refreshComponentTypeConsumable = new System.Windows.Forms.PictureBox();
            this.menuStrip4 = new System.Windows.Forms.MenuStrip();
            this.back = new System.Windows.Forms.ToolStripMenuItem();
            this.addListOrders = new System.Windows.Forms.ToolStripMenuItem();
            this.listComponentTypeConsumable = new System.Windows.Forms.DataGridView();
            this.listSelectedComponentTypeConsumable = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.refreshComponentTypeConsumable)).BeginInit();
            this.menuStrip4.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listComponentTypeConsumable)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.listSelectedComponentTypeConsumable)).BeginInit();
            this.SuspendLayout();
            // 
            // refreshComponentTypeConsumable
            // 
            this.refreshComponentTypeConsumable.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.refreshComponentTypeConsumable.Image = global::Progect.Properties.Resources.refresh;
            this.refreshComponentTypeConsumable.Location = new System.Drawing.Point(1008, 12);
            this.refreshComponentTypeConsumable.Margin = new System.Windows.Forms.Padding(4);
            this.refreshComponentTypeConsumable.Name = "refreshComponentTypeConsumable";
            this.refreshComponentTypeConsumable.Size = new System.Drawing.Size(50, 50);
            this.refreshComponentTypeConsumable.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.refreshComponentTypeConsumable.TabIndex = 38;
            this.refreshComponentTypeConsumable.TabStop = false;
            this.refreshComponentTypeConsumable.Click += new System.EventHandler(this.RefreshComponentTypeConsumable_Click);
            // 
            // menuStrip4
            // 
            this.menuStrip4.Font = new System.Drawing.Font("Segoe UI", 10.2F);
            this.menuStrip4.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menuStrip4.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.back,
            this.addListOrders});
            this.menuStrip4.Location = new System.Drawing.Point(0, 0);
            this.menuStrip4.Name = "menuStrip4";
            this.menuStrip4.Padding = new System.Windows.Forms.Padding(8, 2, 0, 2);
            this.menuStrip4.Size = new System.Drawing.Size(1069, 31);
            this.menuStrip4.TabIndex = 37;
            this.menuStrip4.Text = "menuStrip4";
            // 
            // back
            // 
            this.back.BackColor = System.Drawing.Color.Transparent;
            this.back.Image = global::Progect.Properties.Resources.exit;
            this.back.Name = "back";
            this.back.Size = new System.Drawing.Size(93, 27);
            this.back.Text = "Выход";
            this.back.Click += new System.EventHandler(this.Back_Click);
            // 
            // addListOrders
            // 
            this.addListOrders.Image = global::Progect.Properties.Resources.save_btn;
            this.addListOrders.Name = "addListOrders";
            this.addListOrders.Size = new System.Drawing.Size(237, 27);
            this.addListOrders.Text = "Внести в список заказов";
            this.addListOrders.Click += new System.EventHandler(this.AddListOrders_Click);
            // 
            // listComponentTypeConsumable
            // 
            this.listComponentTypeConsumable.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.listComponentTypeConsumable.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1;
            this.listComponentTypeConsumable.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.listComponentTypeConsumable.DefaultCellStyle = dataGridViewCellStyle2;
            this.listComponentTypeConsumable.Location = new System.Drawing.Point(12, 68);
            this.listComponentTypeConsumable.Margin = new System.Windows.Forms.Padding(4);
            this.listComponentTypeConsumable.Name = "listComponentTypeConsumable";
            this.listComponentTypeConsumable.RowHeadersWidth = 51;
            this.listComponentTypeConsumable.RowTemplate.Height = 24;
            this.listComponentTypeConsumable.Size = new System.Drawing.Size(551, 401);
            this.listComponentTypeConsumable.TabIndex = 39;
            this.listComponentTypeConsumable.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.ListComponentTypeConsumable_CellMouseDoubleClick);
            // 
            // listSelectedComponentTypeConsumable
            // 
            this.listSelectedComponentTypeConsumable.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            dataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.listSelectedComponentTypeConsumable.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle3;
            this.listSelectedComponentTypeConsumable.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle4.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            dataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.listSelectedComponentTypeConsumable.DefaultCellStyle = dataGridViewCellStyle4;
            this.listSelectedComponentTypeConsumable.Location = new System.Drawing.Point(614, 68);
            this.listSelectedComponentTypeConsumable.Margin = new System.Windows.Forms.Padding(4);
            this.listSelectedComponentTypeConsumable.Name = "listSelectedComponentTypeConsumable";
            this.listSelectedComponentTypeConsumable.RowHeadersWidth = 51;
            this.listSelectedComponentTypeConsumable.RowTemplate.Height = 24;
            this.listSelectedComponentTypeConsumable.Size = new System.Drawing.Size(443, 401);
            this.listSelectedComponentTypeConsumable.TabIndex = 40;
            this.listSelectedComponentTypeConsumable.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.ListSelectedComponentTypeConsumable_CellEndEdit);
            this.listSelectedComponentTypeConsumable.EditingControlShowing += new System.Windows.Forms.DataGridViewEditingControlShowingEventHandler(this.ListSelectedComponentTypeConsumable_EditingControlShowing);
            // 
            // CreatingOrderComponents
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1069, 472);
            this.Controls.Add(this.listSelectedComponentTypeConsumable);
            this.Controls.Add(this.listComponentTypeConsumable);
            this.Controls.Add(this.refreshComponentTypeConsumable);
            this.Controls.Add(this.menuStrip4);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MinimumSize = new System.Drawing.Size(1087, 519);
            this.Name = "CreatingOrderComponents";
            this.Text = "Создание заявки";
            ((System.ComponentModel.ISupportInitialize)(this.refreshComponentTypeConsumable)).EndInit();
            this.menuStrip4.ResumeLayout(false);
            this.menuStrip4.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.listComponentTypeConsumable)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.listSelectedComponentTypeConsumable)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox refreshComponentTypeConsumable;
        private System.Windows.Forms.MenuStrip menuStrip4;
        private System.Windows.Forms.ToolStripMenuItem back;
        private System.Windows.Forms.DataGridView listComponentTypeConsumable;
        private System.Windows.Forms.DataGridView listSelectedComponentTypeConsumable;
        private System.Windows.Forms.ToolStripMenuItem addListOrders;
    }
}