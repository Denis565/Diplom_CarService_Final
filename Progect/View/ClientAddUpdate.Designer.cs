
namespace Progect
{
    partial class ClientAddUpdate
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
            this.label5 = new System.Windows.Forms.Label();
            this.dateBirth = new System.Windows.Forms.DateTimePicker();
            this.label4 = new System.Windows.Forms.Label();
            this.patronymic = new System.Windows.Forms.TextBox();
            this.surname = new System.Windows.Forms.TextBox();
            this.name = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.save = new System.Windows.Forms.Button();
            this.bake = new System.Windows.Forms.Button();
            this.phone = new System.Windows.Forms.MaskedTextBox();
            this.errorProvider = new System.Windows.Forms.ErrorProvider(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.SuspendLayout();
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label5.Location = new System.Drawing.Point(28, 216);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(141, 20);
            this.label5.TabIndex = 30;
            this.label5.Text = "Дата рождения";
            // 
            // dateBirth
            // 
            this.dateBirth.CalendarFont = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.dateBirth.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.dateBirth.Location = new System.Drawing.Point(176, 216);
            this.dateBirth.Name = "dateBirth";
            this.dateBirth.Size = new System.Drawing.Size(479, 27);
            this.dateBirth.TabIndex = 29;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label4.Location = new System.Drawing.Point(14, 173);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(155, 20);
            this.label4.TabIndex = 27;
            this.label4.Text = "Номер телефона";
            // 
            // patronymic
            // 
            this.patronymic.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.patronymic.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.patronymic.Location = new System.Drawing.Point(174, 117);
            this.patronymic.MaxLength = 50;
            this.patronymic.MinimumSize = new System.Drawing.Size(4, 20);
            this.patronymic.Name = "patronymic";
            this.patronymic.Size = new System.Drawing.Size(481, 30);
            this.patronymic.TabIndex = 26;
            this.patronymic.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Patronymic_KeyPress);
            // 
            // surname
            // 
            this.surname.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.surname.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.surname.Location = new System.Drawing.Point(176, 30);
            this.surname.MaxLength = 50;
            this.surname.MinimumSize = new System.Drawing.Size(4, 20);
            this.surname.Name = "surname";
            this.surname.Size = new System.Drawing.Size(479, 30);
            this.surname.TabIndex = 25;
            this.surname.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Surname_KeyPress);
            // 
            // name
            // 
            this.name.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.name.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.name.Location = new System.Drawing.Point(175, 76);
            this.name.MaxLength = 50;
            this.name.MinimumSize = new System.Drawing.Size(4, 20);
            this.name.Name = "name";
            this.name.Size = new System.Drawing.Size(480, 30);
            this.name.TabIndex = 24;
            this.name.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Name_KeyPress);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label3.Location = new System.Drawing.Point(78, 124);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(91, 20);
            this.label3.TabIndex = 23;
            this.label3.Text = "Отчество";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label2.Location = new System.Drawing.Point(82, 37);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(87, 20);
            this.label2.TabIndex = 22;
            this.label2.Text = "Фамилия";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(127, 83);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(42, 20);
            this.label1.TabIndex = 21;
            this.label1.Text = "Имя";
            // 
            // save
            // 
            this.save.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.save.Location = new System.Drawing.Point(32, 334);
            this.save.Name = "save";
            this.save.Size = new System.Drawing.Size(203, 49);
            this.save.TabIndex = 1;
            this.save.Text = "Сохранить";
            this.save.UseVisualStyleBackColor = true;
            this.save.Click += new System.EventHandler(this.Save_Click);
            // 
            // bake
            // 
            this.bake.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.bake.Location = new System.Drawing.Point(452, 334);
            this.bake.Name = "bake";
            this.bake.Size = new System.Drawing.Size(203, 49);
            this.bake.TabIndex = 2;
            this.bake.Text = "Отмена";
            this.bake.UseVisualStyleBackColor = true;
            this.bake.Click += new System.EventHandler(this.Bake_Click);
            // 
            // phone
            // 
            this.phone.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.phone.Location = new System.Drawing.Point(174, 166);
            this.phone.Mask = "+9 (999) 000-0000";
            this.phone.Name = "phone";
            this.phone.Size = new System.Drawing.Size(481, 30);
            this.phone.TabIndex = 31;
            // 
            // errorProvider
            // 
            this.errorProvider.ContainerControl = this;
            // 
            // ClientAddUpdate
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.PaleTurquoise;
            this.ClientSize = new System.Drawing.Size(714, 407);
            this.Controls.Add(this.phone);
            this.Controls.Add(this.bake);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.surname);
            this.Controls.Add(this.save);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.dateBirth);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.name);
            this.Controls.Add(this.patronymic);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.MaximumSize = new System.Drawing.Size(714, 407);
            this.MinimumSize = new System.Drawing.Size(714, 407);
            this.Name = "ClientAddUpdate";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "EngineeringWorksAdd";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ClientAddUpdate_FormClosing);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label5;
        public System.Windows.Forms.DateTimePicker dateBirth;
        private System.Windows.Forms.Label label4;
        public System.Windows.Forms.TextBox patronymic;
        public System.Windows.Forms.TextBox surname;
        public System.Windows.Forms.TextBox name;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button save;
        private System.Windows.Forms.Button bake;
        public System.Windows.Forms.MaskedTextBox phone;
        private System.Windows.Forms.ErrorProvider errorProvider;
    }
}