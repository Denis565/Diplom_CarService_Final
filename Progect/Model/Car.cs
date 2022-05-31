using System.ComponentModel.DataAnnotations;

namespace Progect.Model
{
    /// <summary>
    /// Модель машины клиента
    /// </summary>
    public class Car
    {
        [Required(ErrorMessage = "Необходимо заполнить VIN номер.")]
        [MinLength(17, ErrorMessage = "Колличество символов в VIN 17 символов.")]
        public string VIN { get; set; }

        [MinLength(9, ErrorMessage = "Государственный номер состоит из 9 цифр.")]
        public string Registration_Mark { get; set; }
        public string Year_Release { get; set; }

        [Required(ErrorMessage = "Необходимо заполнить пробег.")]
        [Range(1, 1000000, ErrorMessage = "Минимальный пробег 1.")]
        public int Mileage { get; set; }
        public int Brand_Model_Compliance_ID { get; set; }
        public int Client_ID { get; set; }
    }
}
