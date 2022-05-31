using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Progect.Custom
{
    /// <summary>
    /// Класс валидации данных
    /// </summary>
    public class ModelDataValidation
    {
        /// <summary>
        /// Метод определяющий валидность модели
        /// </summary>
        /// <param name="model">Модель для валидации</param>
        public void Validation(object model)
        {
            StringBuilder errorMessage = new StringBuilder();
            List<ValidationResult> results = new List<ValidationResult>();
            ValidationContext context = new ValidationContext(model);
            bool isValidation = Validator.TryValidateObject(model, context, results, true);

            if (!isValidation)
            {
                foreach (var item in results)
                {
                    errorMessage.AppendLine(item.ErrorMessage);
                }

                throw new Exception(errorMessage.ToString());
            }
        }
    }
}
