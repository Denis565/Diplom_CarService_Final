using System.Security.Cryptography;
using System.Text;

namespace Progect.Hash
{
    /// <summary>
    /// Класс для хэширования
    /// </summary>
    internal class MD5Class
    {
        /// <summary>
        /// Хеширование строки в MD5
        /// </summary>
        /// <param name="input">Строка для хэширования</param>
        /// <returns>Хэшированая строка</returns>
        public string GetHash(string input)
        {
            MD5 md5Hasher = MD5.Create();
            byte[] data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(input));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            return sBuilder.ToString();
        }
    }
}
