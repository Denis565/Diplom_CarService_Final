
namespace Progect
{
    partial class CarAddUpdate
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(CarAddUpdate));
            this.vinNumber = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label = new System.Windows.Forms.Label();
            this.yearRelease = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.mileage = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.brand = new System.Windows.Forms.ComboBox();
            this.label5 = new System.Windows.Forms.Label();
            this.model = new System.Windows.Forms.ComboBox();
            this.registrationMark = new System.Windows.Forms.MaskedTextBox();
            this.menu = new System.Windows.Forms.MenuStrip();
            this.close = new System.Windows.Forms.ToolStripMenuItem();
            this.save = new System.Windows.Forms.Button();
            this.menu.SuspendLayout();
            this.SuspendLayout();
            // 
            // vinNumber
            // 
            this.vinNumber.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.vinNumber.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.vinNumber.Location = new System.Drawing.Point(134, 50);
            this.vinNumber.MaxLength = 17;
            this.vinNumber.MinimumSize = new System.Drawing.Size(4, 20);
            this.vinNumber.Name = "vinNumber";
            this.vinNumber.Size = new System.Drawing.Size(312, 30);
            this.vinNumber.TabIndex = 27;
            this.vinNumber.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.VinNumber_KeyPress);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label2.Location = new System.Drawing.Point(89, 55);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(36, 20);
            this.label2.TabIndex = 26;
            this.label2.Text = "VIN";
            // 
            // label
            // 
            this.label.AutoSize = true;
            this.label.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label.Location = new System.Drawing.Point(38, 99);
            this.label.Name = "label";
            this.label.Size = new System.Drawing.Size(90, 20);
            this.label.TabIndex = 28;
            this.label.Text = "Госномер";
            // 
            // yearRelease
            // 
            this.yearRelease.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.yearRelease.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.yearRelease.FormattingEnabled = true;
            this.yearRelease.Location = new System.Drawing.Point(134, 229);
            this.yearRelease.Name = "yearRelease";
            this.yearRelease.Size = new System.Drawing.Size(488, 33);
            this.yearRelease.TabIndex = 30;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(11, 236);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(114, 20);
            this.label1.TabIndex = 31;
            this.label1.Text = "Год выпуска";
            // 
            // mileage
            // 
            this.mileage.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mileage.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.mileage.Location = new System.Drawing.Point(134, 276);
            this.mileage.MaxLength = 10000000;
            this.mileage.MinimumSize = new System.Drawing.Size(4, 20);
            this.mileage.Name = "mileage";
            this.mileage.Size = new System.Drawing.Size(488, 30);
            this.mileage.TabIndex = 33;
            this.mileage.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Mileage_KeyPress);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label3.Location = new System.Drawing.Point(55, 283);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(70, 20);
            this.label3.TabIndex = 32;
            this.label3.Text = "Пробег";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label4.Location = new System.Drawing.Point(63, 144);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(62, 20);
            this.label4.TabIndex = 35;
            this.label4.Text = "Марка";
            // 
            // brand
            // 
            this.brand.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.brand.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.brand.FormattingEnabled = true;
            this.brand.Location = new System.Drawing.Point(134, 137);
            this.brand.Name = "brand";
            this.brand.Size = new System.Drawing.Size(488, 33);
            this.brand.TabIndex = 34;
            this.brand.SelectedIndexChanged += new System.EventHandler(this.Brand_SelectedIndexChanged);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label5.Location = new System.Drawing.Point(50, 190);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(75, 20);
            this.label5.TabIndex = 37;
            this.label5.Text = "Модель";
            // 
            // model
            // 
            this.model.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.model.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.model.FormattingEnabled = true;
            this.model.Location = new System.Drawing.Point(134, 183);
            this.model.Name = "model";
            this.model.Size = new System.Drawing.Size(488, 33);
            this.model.TabIndex = 36;
            this.model.SelectedIndexChanged += new System.EventHandler(this.Model_SelectedIndexChanged);
            // 
            // registrationMark
            // 
            this.registrationMark.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.registrationMark.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.registrationMark.Location = new System.Drawing.Point(134, 94);
            this.registrationMark.Mask = "L000LL000";
            this.registrationMark.Name = "registrationMark";
            this.registrationMark.Size = new System.Drawing.Size(313, 30);
            this.registrationMark.TabIndex = 41;
            this.registrationMark.MouseClick += new System.Windows.Forms.MouseEventHandler(this.RegistrationMark_MouseClick);
            this.registrationMark.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.RegistrationMark_KeyPress);
            // 
            // menu
            // 
            this.menu.BackColor = System.Drawing.Color.PaleTurquoise;
            this.menu.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.close});
            this.menu.Location = new System.Drawing.Point(0, 0);
            this.menu.Name = "menu";
            this.menu.Size = new System.Drawing.Size(633, 31);
            this.menu.TabIndex = 44;
            this.menu.Text = "menuStrip1";
            // 
            // close
            // 
            this.close.BackColor = System.Drawing.Color.Transparent;
            this.close.Font = new System.Drawing.Font("Segoe UI", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.close.Image = global::Progect.Properties.Resources.exit;
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(108, 27);
            this.close.Text = "Закрыть";
            this.close.Click += new System.EventHandler(this.Close_Click);
            // 
            // save
            // 
            this.save.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.save.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.save.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.save.Location = new System.Drawing.Point(13, 336);
            this.save.Name = "save";
            this.save.Size = new System.Drawing.Size(609, 38);
            this.save.TabIndex = 45;
            this.save.Text = "Сохранить";
            this.save.UseVisualStyleBackColor = false;
            this.save.Click += new System.EventHandler(this.Save_Click);
            // 
            // CarAddUpdate
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.PaleTurquoise;
            this.ClientSize = new System.Drawing.Size(633, 384);
            this.Controls.Add(this.save);
            this.Controls.Add(this.menu);
            this.Controls.Add(this.registrationMark);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.model);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.brand);
            this.Controls.Add(this.mileage);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.yearRelease);
            this.Controls.Add(this.label);
            this.Controls.Add(this.vinNumber);
            this.Controls.Add(this.label2);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "CarAddUpdate";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Форма добавления и изменения машины";
            this.menu.ResumeLayout(false);
            this.menu.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox vinNumber;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label;
        private System.Windows.Forms.TextBox mileage;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox yearRelease;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.ComboBox model;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox brand;
        private System.Windows.Forms.MaskedTextBox registrationMark;
        private System.Windows.Forms.MenuStrip menu;
        private System.Windows.Forms.ToolStripMenuItem close;
        private System.Windows.Forms.Button save;
    }
}