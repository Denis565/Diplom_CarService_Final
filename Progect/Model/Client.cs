using System.ComponentModel.DataAnnotations;

namespace Progect.Model
{
    /// <summary>
    /// Модель клиента
    /// </summary>
    public class Client
    {
        public int ID_Client { get; set; }

        [Required(ErrorMessage = "Поле с фамилией не должно оставаться пустым.")]
        public string Surname { get; set; }

        [Required(ErrorMessage = "Поле с именем не должно оставаться пустым.")]
        public string Name { get; set; }

        public string Middle_Name { get; set; }

        [MinLength(17, ErrorMessage = "Задайте номер телефона полностью.")]
        [MaxLength(17, ErrorMessage = "Задайте номер телефона полностью.")]
        public string Phone { get; set; }
        public string Date_Birth { get; set; }
    }
}
