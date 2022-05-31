
namespace Progect
{
    partial class EmployeeAddUpdate
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(EmployeeAddUpdate));
            this.save = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.post = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.loginLable = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.name = new System.Windows.Forms.TextBox();
            this.surname = new System.Windows.Forms.TextBox();
            this.patronymic = new System.Windows.Forms.TextBox();
            this.login = new System.Windows.Forms.TextBox();
            this.password = new System.Windows.Forms.TextBox();
            this.menu = new System.Windows.Forms.MenuStrip();
            this.back = new System.Windows.Forms.ToolStripMenuItem();
            this.label5 = new System.Windows.Forms.Label();
            this.branch = new System.Windows.Forms.ComboBox();
            this.menu.SuspendLayout();
            this.SuspendLayout();
            // 
            // save
            // 
            this.save.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.save.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.save.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.save.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.save.Location = new System.Drawing.Point(16, 441);
            this.save.Margin = new System.Windows.Forms.Padding(3, 3, 3, 7);
            this.save.Name = "save";
            this.save.Size = new System.Drawing.Size(747, 38);
            this.save.TabIndex = 1;
            this.save.Text = "Сохранить";
            this.save.UseVisualStyleBackColor = false;
            this.save.Click += new System.EventHandler(this.Save_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(73, 120);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(42, 20);
            this.label1.TabIndex = 8;
            this.label1.Text = "Имя";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label2.Location = new System.Drawing.Point(28, 74);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(87, 20);
            this.label2.TabIndex = 9;
            this.label2.Text = "Фамилия";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label3.Location = new System.Drawing.Point(24, 168);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(91, 20);
            this.label3.TabIndex = 10;
            this.label3.Text = "Отчество";
            // 
            // post
            // 
            this.post.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.post.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.post.FormattingEnabled = true;
            this.post.Location = new System.Drawing.Point(123, 211);
            this.post.Name = "post";
            this.post.Size = new System.Drawing.Size(640, 33);
            this.post.TabIndex = 7;
            this.post.SelectedIndexChanged += new System.EventHandler(this.Post_SelectedIndexChanged);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label4.Location = new System.Drawing.Point(12, 221);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(103, 20);
            this.label4.TabIndex = 11;
            this.label4.Text = "Должность";
            // 
            // loginLable
            // 
            this.loginLable.AutoSize = true;
            this.loginLable.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.loginLable.Location = new System.Drawing.Point(54, 269);
            this.loginLable.Name = "loginLable";
            this.loginLable.Size = new System.Drawing.Size(59, 20);
            this.loginLable.TabIndex = 15;
            this.loginLable.Text = "Логин";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label7.Location = new System.Drawing.Point(41, 317);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(72, 20);
            this.label7.TabIndex = 17;
            this.label7.Text = "Пароль";
            // 
            // name
            // 
            this.name.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.name.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.name.Location = new System.Drawing.Point(124, 113);
            this.name.MaxLength = 50;
            this.name.MinimumSize = new System.Drawing.Size(4, 20);
            this.name.Name = "name";
            this.name.Size = new System.Drawing.Size(641, 30);
            this.name.TabIndex = 18;
            this.name.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Name_KeyPress);
            // 
            // surname
            // 
            this.surname.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.surname.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.surname.Location = new System.Drawing.Point(124, 67);
            this.surname.MaxLength = 50;
            this.surname.MinimumSize = new System.Drawing.Size(4, 20);
            this.surname.Name = "surname";
            this.surname.Size = new System.Drawing.Size(641, 30);
            this.surname.TabIndex = 19;
            this.surname.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Surname_KeyPress);
            // 
            // patronymic
            // 
            this.patronymic.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.patronymic.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.patronymic.Location = new System.Drawing.Point(123, 161);
            this.patronymic.MaxLength = 50;
            this.patronymic.MinimumSize = new System.Drawing.Size(4, 20);
            this.patronymic.Name = "patronymic";
            this.patronymic.Size = new System.Drawing.Size(641, 30);
            this.patronymic.TabIndex = 20;
            this.patronymic.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Patronymic_KeyPress);
            // 
            // login
            // 
            this.login.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.login.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.login.Location = new System.Drawing.Point(124, 262);
            this.login.MaxLength = 50;
            this.login.MinimumSize = new System.Drawing.Size(4, 20);
            this.login.Name = "login";
            this.login.Size = new System.Drawing.Size(640, 30);
            this.login.TabIndex = 21;
            // 
            // password
            // 
            this.password.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.password.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.password.Location = new System.Drawing.Point(124, 310);
            this.password.MaxLength = 50;
            this.password.MinimumSize = new System.Drawing.Size(4, 20);
            this.password.Name = "password";
            this.password.Size = new System.Drawing.Size(639, 30);
            this.password.TabIndex = 22;
            // 
            // menu
            // 
            this.menu.BackColor = System.Drawing.Color.PaleTurquoise;
            this.menu.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.back});
            this.menu.Location = new System.Drawing.Point(0, 0);
            this.menu.Name = "menu";
            this.menu.Size = new System.Drawing.Size(790, 31);
            this.menu.TabIndex = 42;
            this.menu.Text = "menuStrip1";
            // 
            // back
            // 
            this.back.BackColor = System.Drawing.Color.Transparent;
            this.back.Font = new System.Drawing.Font("Segoe UI", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.back.Image = global::Progect.Properties.Resources.back;
            this.back.Name = "back";
            this.back.Size = new System.Drawing.Size(91, 27);
            this.back.Text = "Назад";
            this.back.Click += new System.EventHandler(this.Back_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label5.Location = new System.Drawing.Point(38, 363);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(75, 20);
            this.label5.TabIndex = 44;
            this.label5.Text = "Филиал";
            // 
            // branch
            // 
            this.branch.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.branch.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.branch.FormattingEnabled = true;
            this.branch.Location = new System.Drawing.Point(123, 356);
            this.branch.Name = "branch";
            this.branch.Size = new System.Drawing.Size(640, 33);
            this.branch.TabIndex = 43;
            this.branch.SelectedIndexChanged += new System.EventHandler(this.Branch_SelectedIndexChanged);
            // 
            // EmployeeAddUpdate
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.PaleTurquoise;
            this.ClientSize = new System.Drawing.Size(790, 507);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.branch);
            this.Controls.Add(this.menu);
            this.Controls.Add(this.password);
            this.Controls.Add(this.login);
            this.Controls.Add(this.patronymic);
            this.Controls.Add(this.surname);
            this.Controls.Add(this.name);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.loginLable);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.post);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.save);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximumSize = new System.Drawing.Size(808, 554);
            this.MinimumSize = new System.Drawing.Size(808, 554);
            this.Name = "EmployeeAddUpdate";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Форма добавления и изменения работника";
            this.menu.ResumeLayout(false);
            this.menu.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Button save;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        public System.Windows.Forms.ComboBox post;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label loginLable;
        private System.Windows.Forms.Label label7;
        public System.Windows.Forms.TextBox name;
        public System.Windows.Forms.TextBox surname;
        public System.Windows.Forms.TextBox patronymic;
        public System.Windows.Forms.TextBox login;
        public System.Windows.Forms.TextBox password;
        private System.Windows.Forms.MenuStrip menu;
        private System.Windows.Forms.ToolStripMenuItem back;
        private System.Windows.Forms.Label label5;
        public System.Windows.Forms.ComboBox branch;
    }
}