using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace Progect.Custom
{
    /// <summary>
    /// Класс для работы с Excel
    /// </summary>
    internal class ExcelManager
    {
        private readonly PrintDialog printDialog = new PrintDialog();

        /// <summary>
        /// Генерация отчета об остатках на складе
        /// </summary>
        /// <param name="path">Путь создания файла</param>
        /// <param name="dataTable">Набор данных с информацией об компонентах на складах</param>
        /// <returns></returns>
        public async Task GenerateReport(string path, DataTable dataTable)
        {
            await Task.Run(() =>
            {
                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

                dataTable.Columns.Remove("Номер позиции");

                using (ExcelPackage excelPackage = new ExcelPackage())
                {
                    ExcelWorksheet worksheet = excelPackage.Workbook.Worksheets.Add($@"Остатки от {DateTime.Now.ToShortDateString()}");

                    dataTable.Columns.Remove("Минимальное число");
                    dataTable.Columns.Remove("Номер компонента");

                    worksheet.Cells[1, 1].LoadFromDataTable(dataTable, true);
                    worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();

                    FrontHeaderExcel(worksheet.Cells[1, 1, 1, dataTable.Columns.Count]);
                    SettingBoundaries(worksheet.Cells[1, 1, dataTable.Rows.Count + 1, dataTable.Columns.Count]);

                    excelPackage.SaveAs(new FileInfo($@"{path}"));

                    Process.Start(path);
                }
            });
        }

        /// <summary>
        /// Создание excel файла с отработкой сотрудников
        /// </summary>
        /// <param name="dataTableAllInformWorker">DataTable с информацией по сотрудникам</param>
        /// <param name="dataTableAllService">Работы выполненые сотрудником</param>
        /// <param name="listWorkerSelected">ФИО выбранных сотрудников для анализа</param>
        /// <param name="listIdWorkerSelected">Индификаторы сотрудников</param>
        /// <param name="path">Путь сохранения excel файла</param>
        /// <returns></returns>
        public async Task CreateRosterManuFacturedWorkMaterials(
            DataTable dataTableAllInformWorker,
            DataTable dataTableAllService,
            string[] listWorkerSelected,
            int[] listIdWorkerSelected,
            string path,
            Action<string> callback
            )
        {
            try
            {
                int rowIndex = 1;

                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

                await Task.Run(() =>
                {
                    using (ExcelPackage excelPackage = new ExcelPackage())
                    {
                        DataTable dataTableServiceItem = new DataTable();
                        DataTable dataTableInformWorkerItem = new DataTable();

                        ExcelWorksheet worksheet = excelPackage.Workbook.Worksheets.Add($@"Ведомость от {DateTime.Now.ToShortDateString()}");
                        int lengthRow = listIdWorkerSelected.Length;

                        for (int i = 0; i < lengthRow; i++)
                        {
                            int idWorkerItem = listIdWorkerSelected[i];

                            try
                            {
                                if (dataTableAllInformWorker.Rows.Count > 0)
                                {
                                    dataTableInformWorkerItem = dataTableAllInformWorker.AsEnumerable()
                                                   .Where(row => row.Field<int>("Номер работника") == idWorkerItem)
                                                   .CopyToDataTable();
                                }

                                if (dataTableAllService.Rows.Count > 0)
                                {
                                    try
                                    {
                                        dataTableServiceItem = dataTableAllService.AsEnumerable()
                                                        .Where(row => row.Field<int>("Номер работника") == idWorkerItem)
                                                        .CopyToDataTable();
                                        dataTableServiceItem.Columns.Remove("Номер работника");
                                    }
                                    catch
                                    {
                                        dataTableServiceItem = new DataTable();
                                    }
                                }

                                int countRowService = dataTableServiceItem.Rows.Count;
                                int countRowAllWorker = dataTableAllInformWorker.Rows.Count;

                                int maxCountRowReader = Math.Max(countRowAllWorker, countRowService);

                                worksheet.Cells[rowIndex, 1].Value = listWorkerSelected[i].ToString();
                                worksheet.Cells[rowIndex, 1].Style.Font.Bold = true;
                                worksheet.Cells[rowIndex, 1, rowIndex, 3].Merge = true;
                                worksheet.Cells[rowIndex, 1, rowIndex, 3].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                                rowIndex += 2;

                                int rowIndexStart = rowIndex;

                                foreach (DataRow item in dataTableInformWorkerItem.Rows)
                                {
                                    worksheet.Cells[rowIndex, 1].Value = dataTableInformWorkerItem.Columns[1].ColumnName;
                                    worksheet.Cells[rowIndex, 1].Style.Font.Bold = true;
                                    worksheet.Cells[rowIndex, 2].Value = item[1].ToString() + " .шт";

                                    worksheet.Cells[rowIndex += 1, 1].Value = dataTableInformWorkerItem.Columns[2].ColumnName;
                                    worksheet.Cells[rowIndex, 1].Style.Font.Bold = true;
                                    string clockWorker = item[2].ToString();
                                    int clockWorkerInt = Convert.ToInt32(item[2].ToString());
                                    worksheet.Cells[rowIndex, 2].Value = clockWorker + " .час";

                                    double workingHoursNorm = Working_Hours_Calculation();

                                    if (clockWorkerInt > 120)
                                    {
                                        double prozent = Math.Ceiling((double)(Convert.ToDouble(clockWorkerInt) * 100.00) / workingHoursNorm);
                                        worksheet.Cells[rowIndex, 3].Value = $"Превышение отработки на {Math.Ceiling(prozent - 100)}%";
                                        worksheet.Cells[rowIndex, 1, rowIndex, 3].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                        worksheet.Cells[rowIndex, 1, rowIndex, 3].Style.Fill.BackgroundColor.SetColor(Color.LightGreen);
                                    }

                                    if (clockWorkerInt < 120)
                                    {
                                        double prozent = Math.Ceiling((double)(Convert.ToDouble(clockWorkerInt) * 100.00) / workingHoursNorm);
                                        worksheet.Cells[rowIndex, 3].Value = $"Не доработка на {Math.Ceiling(100 - prozent)}%";
                                        worksheet.Cells[rowIndex, 1, rowIndex, 3].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                        worksheet.Cells[rowIndex, 1, rowIndex, 3].Style.Fill.BackgroundColor.SetColor(Color.PaleVioletRed);
                                    }

                                    worksheet.Cells[rowIndex += 1, 1].Value = dataTableInformWorkerItem.Columns[3].ColumnName;
                                    worksheet.Cells[rowIndex, 1].Style.Font.Bold = true;
                                    worksheet.Cells[rowIndex, 2].Value = item[3].ToString() + " .шт";

                                    worksheet.Cells[rowIndex += 1, 1].Value = dataTableInformWorkerItem.Columns[4].ColumnName;
                                    worksheet.Cells[rowIndex, 1].Style.Font.Bold = true;
                                    worksheet.Cells[rowIndex, 2].Value = item[4].ToString() + " .шт";

                                    if (countRowService > 0)
                                    {
                                        worksheet.Cells[rowIndex += 1, 2].LoadFromDataTable(dataTableServiceItem, true);

                                        FrontHeaderExcel(worksheet.Cells[rowIndex, 2, rowIndex, 3]);

                                        int index = rowIndex + countRowService;
                                        for (int j = rowIndex; j <= index; j++)
                                        {
                                            worksheet.Row(j).OutlineLevel = 1;
                                        }

                                        rowIndex = index;
                                    }
                                }

                                SettingBoundaries(worksheet.Cells[rowIndexStart, 1, rowIndex, 3]);
                                worksheet.Cells[rowIndexStart, 1, rowIndex, 3].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                                if (countRowAllWorker > 0 || countRowService > 0)
                                {
                                    rowIndex += 2;
                                }
                            }
                            catch { }
                        }

                        worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();

                        FileInfo fi = new FileInfo($@"{path}");
                        excelPackage.SaveAs(fi);

                        callback(path);
                    }
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public DateTimePicker endDateAnaliz;
        public DateTimePicker startDateAnaliz;

        /// <summary>
        /// Расчет количества норм часов за периуд времени
        /// </summary>
        /// <returns></returns>
        private int Working_Hours_Calculation()
        {
            var endDate = endDateAnaliz.Value;
            var startDate = startDateAnaliz.Value;
            var nMonth2 = (double)(endDate.Subtract(startDate).TotalDays / (365.25 / 12)) + (startDate.AddDays(1).Month == startDate.Month ? 0 : 1);
            int index = 0; ;
            if (nMonth2 > 12.00 || nMonth2 == 12.00)
            {
                index = (int)(nMonth2 / 12.00);
            }

            return (int)Math.Ceiling(Math.Ceiling(nMonth2 * 160.00) - (index * 160));
        }

        /// <summary>
        /// Вывод на чечать вдомости об остатках на складах
        /// </summary>
        /// <param name="path">Путь для сохранения файла</param>
        public void PrintingExcel(string path)
        {
            DialogResult dialogResult = MessageBox.Show("Ведомость успешно создана." + "\n" + "Хотите распечатать ново созданный excel документ?", "Печать excel.", MessageBoxButtons.OKCancel, MessageBoxIcon.Information);
            if (dialogResult == DialogResult.OK)
            {
                PrintExcel(path);
            }

            Process.Start(path);
        }

        /// <summary>
        /// Границы таблиц
        /// </summary>
        /// <param name="excelRange">Выделенная область</param>
        private void SettingBoundaries(ExcelRange excelRange)
        {
            excelRange.Style.Border.Top.Style = ExcelBorderStyle.Thin;
            excelRange.Style.Border.Right.Style = ExcelBorderStyle.Thin;
            excelRange.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
            excelRange.Style.Border.Left.Style = ExcelBorderStyle.Thin;
        }

        /// <summary>
        /// Печать excel файла
        /// </summary>
        /// <param name="path"></param>
        private void PrintExcel(string path)
        {
            Excel.Application excelApp = new Excel.Application();
            Excel.Workbook wb = excelApp.Workbooks.Open(
                $@"{path}",
                Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing,
                Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing,
                Type.Missing, Type.Missing, Type.Missing, Type.Missing);
            Excel.Worksheet ws = (Excel.Worksheet)wb.Worksheets[1];
            ws.PageSetup.Orientation = Excel.XlPageOrientation.xlPortrait;
            ws.PageSetup.PaperSize = Excel.XlPaperSize.xlPaperA3;

            string activePrinter = "Microsoft Print to PDF";
            if (printDialog.ShowDialog() == DialogResult.OK)
            {
                ProcessStartInfo info = new ProcessStartInfo(path);
                activePrinter = printDialog.PrinterSettings.PrinterName;


                ws.PrintOut(
                    Type.Missing, Type.Missing, Type.Missing, Type.Missing,
                     activePrinter, Type.Missing, Type.Missing, Type.Missing);

                GC.Collect();
                GC.WaitForPendingFinalizers();
                Marshal.FinalReleaseComObject(ws);

                wb.Close(false, Type.Missing, Type.Missing);
                Marshal.FinalReleaseComObject(wb);

                excelApp.Quit();
                Marshal.FinalReleaseComObject(excelApp);
            }
        }

        /// <summary>
        /// Настройка заголовка
        /// </summary>
        /// <param name="excelRange">Диапазон ячеек заголовка</param>
        private void FrontHeaderExcel(ExcelRange excelRange)
        {
            excelRange.Style.Font.Italic = true;
            excelRange.Style.Font.Bold = true;
            excelRange.Style.Font.Color.SetColor(Color.Blue);
            excelRange.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
        }
    }
}
