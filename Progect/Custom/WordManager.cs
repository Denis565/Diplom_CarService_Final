using System;
using System.Data;
using System.Linq;
using System.Windows.Forms;
using Xceed.Document.NET;
using Xceed.Words.NET;

namespace Progect.Custom
{
    /// <summary>
    /// Менеджер для рботы с Word
    /// </summary>
    internal class WordManager
    {
        private DocX doc;
        private double sumMaerial = 0.0;
        private double sumItemMaterial = 0.0;
        private double sumService = 0.0;

        public DataGridViewRow dataGridViewRowOrder;
        public DataGridViewRow dataGridViewRowClient;
        public DataGridView listSelectService;
        public DataGridView listSelectMaterial;
        public DataGridView listSelectCar;

        private DataRow dataTableRowOrderOutfit;

        public bool adminLoginWorker;

        /// <summary>
        /// 
        /// Создание сметы по заказ наряду
        /// </summary>
        /// <param name="fileName">Путь для сохранения word файла</param>
        /// <returns>Успешность создания сметы по заказ наряду</returns>
        public bool CreateSmeta(string fileName, string title)
        {
            try
            {
                doc = DocX.Create(fileName);

                Formatting titleFormat = new Formatting
                {
                    FontFamily = new Font("Times New Roman"),
                    Size = 14D,
                    Bold = true
                };

                Border borders = new Border
                {
                    Color = System.Drawing.Color.White
                };

                //Формирование документа
                Paragraph paragraphTitle = doc.InsertParagraph(title, false, titleFormat);
                paragraphTitle.Alignment = Alignment.left;
                paragraphTitle.AppendLine("__________________________________________________________________________________").Bold(true);

                doc.InsertTable(Heading(borders));

                Paragraph paragraphProdel = doc.InsertParagraph();
                paragraphProdel.AppendLine();

                Paragraph paragraphGlavService = doc.InsertParagraph("Перечень выполненных работ", false, new Formatting { Size = 10D, FontFamily = new Font("Times New Roman") });
                paragraphGlavService.Alignment = Alignment.left;
                doc.InsertTable(Service(borders));

                paragraphProdel = doc.InsertParagraph();
                paragraphProdel.AppendLine();

                Paragraph paragraphGlavMatrial = doc.InsertParagraph("Перечень замененных частей", false, new Formatting { Size = 10D, FontFamily = new Font("Times New Roman") });
                paragraphGlavService.Alignment = Alignment.left;
                doc.InsertTable(Material(borders));

                paragraphProdel = doc.InsertParagraph();

                DateTime dateBirth;

                if (adminLoginWorker)
                {
                    dateBirth = Convert.ToDateTime(dataGridViewRowClient.Cells[5].Value.ToString());
                }
                else
                {
                    dateBirth = Convert.ToDateTime(dataTableRowOrderOutfit[9].ToString());
                }

                DateTime dateEnrollment = Convert.ToDateTime(dataGridViewRowOrder.Cells[2].Value.ToString());
                double summingPrize = sumService + sumMaerial;

                if (dateEnrollment.Month == dateBirth.Month && dateEnrollment.Day == dateBirth.Day)
                {
                    Paragraph paragraphSale = doc.InsertParagraph($@"Скидка:", false, new Formatting { Size = 10D, FontFamily = new Font("Times New Roman") })
                    .Append("15%").Font("Times New Roman")
                    .UnderlineStyle(UnderlineStyle.singleLine)
                    .UnderlineColor(System.Drawing.Color.Black);
                    paragraphSale.Alignment = Alignment.right;
                    paragraphSale.AppendLine();

                    Paragraph paragraphNoSale = doc.InsertParagraph($@"Без скидки:", false, new Formatting { Size = 10D, FontFamily = new Font("Times New Roman") })
                     .Append($@"{Math.Round(summingPrize, 2)} .руб").Font("Times New Roman")
                    .UnderlineStyle(UnderlineStyle.singleLine)
                    .UnderlineColor(System.Drawing.Color.Black);
                    paragraphNoSale.Alignment = Alignment.right;
                    paragraphNoSale.AppendLine();

                    summingPrize = (summingPrize / 100) * 85;
                }

                paragraphProdel.AppendLine();

                Paragraph paragraphTotalAmount = doc.InsertParagraph($@"Общая стоимость:", false, new Formatting { Size = 10D, FontFamily = new Font("Times New Roman") })
                    .Append($@"{Math.Round(summingPrize, 2)} .руб").Font("Times New Roman")
                    .UnderlineStyle(UnderlineStyle.singleLine)
                    .UnderlineColor(System.Drawing.Color.Black);
                paragraphTotalAmount.Alignment = Alignment.right;

                Formatting signaturesFormat = new Formatting
                {
                    FontFamily = new Font("Times New Roman")
                };

                Paragraph paragraphSignatures = doc.InsertParagraph("", false, signaturesFormat);
                paragraphSignatures.AppendLine();
                paragraphSignatures.AppendLine();
                paragraphSignatures.AppendLine();

                paragraphSignatures.Append("_________________________                                                                         ________________________");
                paragraphSignatures.AppendLine("     подпись заказчика                                                                                                                подпись исполнителя ")
                    .Font("Times New Roman").FontSize(9D)
                    .Italic(true)
                    .Alignment = Alignment.left;

                doc.Save();
                return true;
            }
            catch
            {
                MessageBox.Show("Закройте файл Word с похожим названием.");
                return false;
            }

        }

        /// <summary>
        /// Разметка вырхней части сметы по заказ наряду
        /// </summary>
        /// <param name="borders">Границы</param>
        /// <param name="indexOrderRow">Номер строки в списке с заказ нрядами</param>
        /// <returns>Возрашение таблицы</returns>
        private Table Heading(Border borders)
        {
            Table tableInvormMain = doc.AddTable(7, 2);
            tableInvormMain.Alignment = Alignment.left;
            tableInvormMain.Rows[0].Cells[0].Paragraphs.First().Append("Исполнитель:").Font("Times New Roman").Alignment = Alignment.right;
            tableInvormMain.Rows[1].Cells[0].Paragraphs.First().Append("Заказчик:").Font("Times New Roman").Alignment = Alignment.right;
            tableInvormMain.Rows[2].Cells[0].Paragraphs.First().Append("Модель Марка:").Font("Times New Roman").Alignment = Alignment.right;
            tableInvormMain.Rows[3].Cells[0].Paragraphs.First().Append("Гос №:").Font("Times New Roman").Alignment = Alignment.right;
            tableInvormMain.Rows[4].Cells[0].Paragraphs.First().Append("Год выпуска:").Font("Times New Roman").Alignment = Alignment.right;
            tableInvormMain.Rows[5].Cells[0].Paragraphs.First().Append("VIN:").Font("Times New Roman").Alignment = Alignment.right;
            tableInvormMain.Rows[6].Cells[0].Paragraphs.First().Append("Пробег:").Font("Times New Roman").Alignment = Alignment.right;

            tableInvormMain.SetBorder(TableBorderType.Top, borders);
            tableInvormMain.SetBorder(TableBorderType.Bottom, borders);
            tableInvormMain.SetBorder(TableBorderType.Left, borders);
            tableInvormMain.SetBorder(TableBorderType.Right, borders);
            tableInvormMain.SetBorder(TableBorderType.InsideH, borders);
            tableInvormMain.SetBorder(TableBorderType.InsideV, borders);

            tableInvormMain.Rows[0].Cells[1].Paragraphs.First().Append("ООО. Автосервис Груп").Bold(true).Font("Times New Roman");

            if (adminLoginWorker)
            {
                DataGridViewRow dataGridViewRowCar;
                try
                {
                    dataGridViewRowCar = listSelectCar.Rows[listSelectCar.CurrentRow.Index];
                }
                catch
                {
                    dataGridViewRowCar = listSelectCar.Rows[0];
                }

                tableInvormMain.Rows[1].Cells[1].Paragraphs.First().Append($@"{dataGridViewRowClient.Cells[1].Value} {dataGridViewRowClient.Cells[2].Value} {dataGridViewRowClient.Cells[3].Value}.").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[2].Cells[1].Paragraphs.First().Append($@"{dataGridViewRowCar.Cells[2].Value} {dataGridViewRowCar.Cells[3].Value}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[3].Cells[1].Paragraphs.First().Append($@"{dataGridViewRowCar.Cells[1].Value}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[4].Cells[1].Paragraphs.First().Append($@"{dataGridViewRowCar.Cells[4].Value}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[5].Cells[1].Paragraphs.First().Append($@"{dataGridViewRowCar.Cells[0].Value}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[6].Cells[1].Paragraphs.First().Append($@"{dataGridViewRowCar.Cells[5].Value.ToString().Replace(" ", "")}").Bold(true).Font("Times New Roman");
            }
            else
            {
                DataTable dataTable = new SQL.SQLManager().ReturnTable($@"select * from [dbo].[OrderOutfit_Information]({Convert.ToInt32(dataGridViewRowOrder.Cells[0].Value)})");
                dataTableRowOrderOutfit = dataTable.Rows[0];
                tableInvormMain.Rows[1].Cells[1].Paragraphs.First().Append($@"{dataTableRowOrderOutfit[0]} {dataTableRowOrderOutfit[1]} {dataTableRowOrderOutfit[2]}.").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[2].Cells[1].Paragraphs.First().Append($@"{dataTableRowOrderOutfit[3]} {dataTableRowOrderOutfit[4]}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[3].Cells[1].Paragraphs.First().Append($@"{dataTableRowOrderOutfit[5]}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[4].Cells[1].Paragraphs.First().Append($@"{dataTableRowOrderOutfit[6]}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[5].Cells[1].Paragraphs.First().Append($@"{dataTableRowOrderOutfit[7]}").Bold(true).Font("Times New Roman");
                tableInvormMain.Rows[6].Cells[1].Paragraphs.First().Append($@"{dataTableRowOrderOutfit[8]} км").Bold(true).Font("Times New Roman");
            }
            tableInvormMain.AutoFit = AutoFit.Contents;

            doc.InsertParagraph().Append("");

            return tableInvormMain;
        }

        /// <summary>
        /// Создание таблицы с материалами
        /// </summary>
        /// <param name="borders">Границы</param>
        /// <returns>Возрашение таблицы</returns>
        private Table Material(Border borders)
        {
            Table tableMaterila = doc.AddTable(listSelectMaterial.Rows.Count + 2, 6);
            tableMaterila.Alignment = Alignment.center;

            tableMaterila.Rows[0].Cells[0].Paragraphs.First().Append("№").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableMaterila.Rows[0].Cells[1].Paragraphs.First().Append("Код").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableMaterila.Rows[0].Cells[2].Paragraphs.First().Append("Наименование").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableMaterila.Rows[0].Cells[3].Paragraphs.First().Append("Количество").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableMaterila.Rows[0].Cells[4].Paragraphs.First().Append("Цена").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableMaterila.Rows[0].Cells[5].Paragraphs.First().Append("Сумма").Bold(true).Font("Times New Roman").Alignment = Alignment.center;

            int j = 1;
            foreach (DataGridViewRow row in listSelectMaterial.Rows)
            {

                float count = float.Parse(row.Cells[3].Value.ToString());
                float price = float.Parse(row.Cells[4].Value.ToString());
                sumItemMaterial = count * price;
                sumMaerial += sumItemMaterial;

                tableMaterila.Rows[row.Index + 1].Cells[0].Paragraphs.First().Append(j.ToString()).Font("Times New Roman").Alignment = Alignment.center;
                tableMaterila.Rows[row.Index + 1].Cells[2].Width = 1;

                tableMaterila.Rows[row.Index + 1].Cells[1].Paragraphs.First().Append(row.Cells[0].Value.ToString()).Font("Times New Roman").Alignment = Alignment.center;
                tableMaterila.Rows[row.Index + 1].Cells[2].Width = 1;

                tableMaterila.Rows[row.Index + 1].Cells[2].Paragraphs.First().Append(row.Cells[2].Value.ToString()).Font("Times New Roman");
                tableMaterila.Rows[row.Index + 1].Cells[2].Width = 700;

                tableMaterila.Rows[row.Index + 1].Cells[3].Paragraphs.First().Append(count.ToString()).Font("Times New Roman").Alignment = Alignment.right;
                tableMaterila.Rows[row.Index + 1].Cells[3].Width = 20;

                tableMaterila.Rows[row.Index + 1].Cells[4].Paragraphs.First().Append(price.ToString()).Font("Times New Roman").Alignment = Alignment.right;
                tableMaterila.Rows[row.Index + 1].Cells[4].Width = 20;

                tableMaterila.Rows[row.Index + 1].Cells[5].Paragraphs.First().Append(sumItemMaterial.ToString()).Font("Times New Roman").Alignment = Alignment.right;
                tableMaterila.Rows[row.Index + 1].Cells[5].Width = 20;

                j++;
            }
            tableMaterila.Rows[listSelectMaterial.RowCount + 1].Cells[4].Paragraphs.First().Append("Итого: ").Font("Times New Roman").Alignment = Alignment.right;
            tableMaterila.Rows[listSelectMaterial.RowCount + 1].Cells[5].Paragraphs.First().Append(Math.Round(sumMaerial, 2).ToString()).Font("Times New Roman").Alignment = Alignment.right;
            tableMaterila.Rows[listSelectMaterial.RowCount + 1].Cells[4].Paragraphs.First().Bold(true).Font("Times New Roman");
            tableMaterila.Rows[listSelectMaterial.RowCount + 1].Cells[5].Paragraphs.First().Bold(true).Font("Times New Roman");
            tableMaterila.Rows[listSelectMaterial.RowCount + 1].MergeCells(0, 3);

            tableMaterila.Rows[listSelectMaterial.RowCount + 1].Cells[0].SetBorder(TableCellBorderType.Bottom, borders);
            tableMaterila.Rows[listSelectMaterial.RowCount + 1].Cells[0].SetBorder(TableCellBorderType.Left, borders);
            tableMaterila.Rows[listSelectMaterial.RowCount + 1].Cells[0].SetBorder(TableCellBorderType.Right, borders);

            return tableMaterila;
        }

        /// <summary>
        /// Сздание таблицы с названием работ 
        /// </summary>
        /// <param name="borders">Границы</param>
        /// <returns>Возрашение таблицы</returns>
        private Table Service(Border borders)
        {
            Table tableService = doc.AddTable(listSelectService.Rows.Count + 2, 5);
            tableService.Alignment = Alignment.center;
            tableService.AutoFit = AutoFit.Contents;
            tableService.Rows[0].Cells[0].Paragraphs.First().Append("№").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableService.Rows[0].Cells[1].Paragraphs.First().Append("Работа").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableService.Rows[0].Cells[2].Paragraphs.First().Append("Наименование").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableService.Rows[0].Cells[3].Paragraphs.First().Append("Н/ч").Bold(true).Font("Times New Roman").Alignment = Alignment.center;
            tableService.Rows[0].Cells[4].Paragraphs.First().Append("Сумма").Bold(true).Font("Times New Roman").Alignment = Alignment.center;

            int i = 1;
            foreach (DataGridViewRow row in listSelectService.Rows)
            {
                float normHourse = float.Parse(row.Cells[3].Value.ToString());
                float price = float.Parse(row.Cells[6].Value.ToString());

                sumService += price;

                tableService.Rows[row.Index + 1].Cells[0].Paragraphs.First().Append(i.ToString()).Font("Times New Roman").Alignment = Alignment.center;
                tableService.Rows[row.Index + 1].Cells[0].Width = 1;

                tableService.Rows[row.Index + 1].Cells[1].Paragraphs.First().Append(row.Cells[0].Value.ToString()).Font("Times New Roman").Alignment = Alignment.center;
                tableService.Rows[row.Index + 1].Cells[1].Width = 1;

                tableService.Rows[row.Index + 1].Cells[2].Paragraphs.First().Append(row.Cells[2].Value.ToString()).Font("Times New Roman");
                tableService.Rows[row.Index + 1].Cells[2].Width = 700;

                tableService.Rows[row.Index + 1].Cells[3].Paragraphs.First().Append(normHourse.ToString()).Font("Times New Roman").Alignment = Alignment.right;
                tableService.Rows[row.Index + 1].Cells[3].Width = 20;

                tableService.Rows[row.Index + 1].Cells[4].Paragraphs.First().Append(Math.Round(price, 2).ToString()).Font("Times New Roman").Alignment = Alignment.right;
                tableService.Rows[row.Index + 1].Cells[4].Width = 20;

                i++;
            }

            tableService.Rows[listSelectService.RowCount + 1].Cells[3].Paragraphs.First().Append("Итого: ").Font("Times New Roman");
            tableService.Rows[listSelectService.RowCount + 1].Cells[4].Paragraphs.First().Append(Math.Round(sumService, 2).ToString()).Font("Times New Roman").Alignment = Alignment.right;
            tableService.Rows[listSelectService.RowCount + 1].Cells[3].Paragraphs.First().Bold(true).Font("Times New Roman");
            tableService.Rows[listSelectService.RowCount + 1].Cells[4].Paragraphs.First().Bold(true).Font("Times New Roman");
            tableService.Rows[listSelectService.RowCount + 1].MergeCells(0, 2);

            tableService.Rows[listSelectService.RowCount + 1].Cells[0].SetBorder(TableCellBorderType.Bottom, borders);
            tableService.Rows[listSelectService.RowCount + 1].Cells[0].SetBorder(TableCellBorderType.Left, borders);
            tableService.Rows[listSelectService.RowCount + 1].Cells[0].SetBorder(TableCellBorderType.Right, borders);

            return tableService;
        }
    }
}
